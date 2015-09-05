//
//  CharacteristicViewController.m
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/7.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "CharacteristicViewController.h"
#import "SVProgressHUD.h"

@interface CharacteristicViewController (){

}

@end

#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height
#define isIOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define navHeight ( isIOS7 ? 64 : 44)  //导航栏高度
#define channelOnCharacteristicView @"CharacteristicView"


@implementation CharacteristicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //初始化数据
    sect = [NSMutableArray arrayWithObjects:@"read value",@"write value",@"desc",@"properties", nil];
    readValueArray = [[NSMutableArray alloc]init];
    descriptors = [[NSMutableArray alloc]init];
    //配置ble委托
    [self babyDelegate];
    //读取服务
    baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic);
   
}


-(void)createUI{
    //headerView
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight, width, 100)];
    [headerView setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:headerView];
    
    NSArray *array = [NSArray arrayWithObjects:self.currPeripheral.name,[NSString stringWithFormat:@"%@", self.characteristic.UUID],self.characteristic.UUID.UUIDString, nil];

    for (int i=0;i<array.count;i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30*i, width, 30)];
        [lab setText:array[i]];
        [lab setBackgroundColor:[UIColor whiteColor]];
        [lab setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        [headerView addSubview:lab];
    }

    //tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, array.count*30+navHeight, width, height-navHeight-array.count*30)];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)babyDelegate{

    __weak typeof(self)weakSelf = self;
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicOnChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        [weakSelf insertReadValues:characteristics];
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicOnChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
//        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
//            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
            [weakSelf insertDescriptor:d];
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsOnChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        for (int i =0 ; i<descriptors.count; i++) {
            if (descriptors[i]==descriptor) {
                UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
//                NSString *valueStr = [[NSString alloc]initWithData:descriptor.value encoding:NSUTF8StringEncoding];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",descriptor.value];
            }
        }
        NSLog(@"CharacteristicViewController Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
}

//插入描述
-(void)insertDescriptor:(CBDescriptor *)descriptor{
    [self->descriptors addObject:descriptor];
    NSMutableArray *indexPahts = [[NSMutableArray alloc]init];
    NSIndexPath *indexPaht = [NSIndexPath indexPathForRow:self->descriptors.count-1 inSection:2];
    [indexPahts addObject:indexPaht];
    [self.tableView insertRowsAtIndexPaths:indexPahts withRowAnimation:UITableViewRowAnimationAutomatic];
}
//插入读取的值
-(void)insertReadValues:(CBCharacteristic *)characteristics{
    [self->readValueArray addObject:[NSString stringWithFormat:@"%@",characteristics.value]];
    NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self->readValueArray.count-1 inSection:0];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self->readValueArray.count-1 inSection:0];
    [indexPaths addObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

//写一个值
-(void)writeValue{
//    int i = 1;
    Byte b = 0X01;
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}
//订阅一个值
-(void)setNotifiy:(id)sender{
    
    __weak typeof(self)weakSelf = self;
    UIButton *btn = sender;
    if(self.currPeripheral.state != CBPeripheralStateConnected){
        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    if (self.characteristic.properties & CBCharacteristicPropertyNotify ||  self.characteristic.properties & CBCharacteristicPropertyIndicate){
        
        if(self.characteristic.isNotifying){
            [baby cancelNotify:self.currPeripheral characteristic:self.characteristic];
            [btn setTitle:@"通知" forState:UIControlStateNormal];
        }else{
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
            [btn setTitle:@"取消通知" forState:UIControlStateNormal];
            [baby notify:self.currPeripheral
          characteristic:self.characteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                NSLog(@"notify block");
//                NSLog(@"new value %@",characteristics.value);
                [self insertReadValues:characteristics];
            }];
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
        return;
    }
    
}

#pragma mark -Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return sect.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            //read value
            return readValueArray.count;
            break;
        case 1:
            //write value
            return 1;
            break;
        case 2:
            //desc
            return descriptors.count;
            break;
        case 3:
            //properties
            return 1;
            break;
        default:
            return 0 ;break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString *cellIdentifier = @"characteristicDetailsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            //read value
        {
            cell.textLabel.text = [readValueArray objectAtIndex:indexPath.row];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            cell.detailTextLabel.text = [formatter stringFromDate:[NSDate date]];
//            cell.textLabel.text = [readValueArray valueForKey:@"value"];
//            cell.detailTextLabel.text = [readValueArray valueForKey:@"stamp"];
        }
            break;
        case 1:
            //write value
        {
            cell.textLabel.text = @"write a new value";
            
        }
            break;
        case 2:
        //desc
        {
            CBDescriptor *descriptor = [descriptors objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",descriptor.UUID];

        }
            break;
        case 3:
            //properties
        {
//            CBCharacteristicPropertyBroadcast												= 0x01,
//            CBCharacteristicPropertyRead													= 0x02,
//            CBCharacteristicPropertyWriteWithoutResponse									= 0x04,
//            CBCharacteristicPropertyWrite													= 0x08,
//            CBCharacteristicPropertyNotify													= 0x10,
//            CBCharacteristicPropertyIndicate												= 0x20,
//            CBCharacteristicPropertyAuthenticatedSignedWrites								= 0x40,
//            CBCharacteristicPropertyExtendedProperties										= 0x80,
//            CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)		= 0x100,
//            CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)	= 0x200
            
            CBCharacteristicProperties p = self.characteristic.properties;
            cell.textLabel.text = @"";
            
            if (p & CBCharacteristicPropertyBroadcast) {
                cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" | Broadcast"];
            }
            if (p & CBCharacteristicPropertyRead) {
                cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" | Read"];
            }
            if (p & CBCharacteristicPropertyWriteWithoutResponse) {
                cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" | WriteWithoutResponse"];
            }
            if (p & CBCharacteristicPropertyWrite) {
                cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" | Write"];
            }
            if (p & CBCharacteristicPropertyNotify) {
                cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" | Notify"];
            }
            if (p & CBCharacteristicPropertyIndicate) {
                cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" | Indicate"];
            }
            if (p & CBCharacteristicPropertyAuthenticatedSignedWrites) {
                cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" | AuthenticatedSignedWrites"];
            }
            if (p & CBCharacteristicPropertyExtendedProperties) {
                cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" | ExtendedProperties"];
            }
            
        }
            default:
            break;
    }

    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:
            //write value
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
            [view setBackgroundColor:[UIColor darkGrayColor]];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
            title.text = [sect objectAtIndex:section];
            [title setTextColor:[UIColor whiteColor]];
            [view addSubview:title];
            UIButton *setNotifiyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [setNotifiyBtn setFrame:CGRectMake(100, 0, 100, 30)];
            [setNotifiyBtn setTitle:self.characteristic.isNotifying?@"取消通知":@"通知" forState:UIControlStateNormal];
            [setNotifiyBtn setBackgroundColor:[UIColor darkGrayColor]];
            [setNotifiyBtn addTarget:self action:@selector(setNotifiy:) forControlEvents:UIControlEventTouchUpInside];
            //恢复状态
            if(self.characteristic.isNotifying){
                [baby notify:self.currPeripheral characteristic:self.characteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                    NSLog(@"resume notify block");
                    [self insertReadValues:characteristics];
                }];
            }
            
            [view addSubview:setNotifiyBtn];
            UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [writeBtn setFrame:CGRectMake(200, 0, 100, 30)];
            [writeBtn setTitle:@"写(0x01)" forState:UIControlStateNormal];
            [writeBtn setBackgroundColor:[UIColor darkGrayColor]];
            [writeBtn addTarget:self action:@selector(writeValue) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:writeBtn];
            return view;
        }
            break;
        default:
        {
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
            title.text = [sect objectAtIndex:section];
            [title setTextColor:[UIColor whiteColor]];
            [title setBackgroundColor:[UIColor darkGrayColor]];
            return title;
        }
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
