//
//  CharacteristicViewController.m
//  BabyBluetoothDemo
//
//  Created by ZTELiuyw on 15/8/7.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "CharacteristicViewController.h"

@interface CharacteristicViewController (){

}

@end

#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height
#define isIOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define navHeight ( isIOS7 ? 64 : 44)  //导航栏高度


@implementation CharacteristicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //初始化数据
    sect = [NSMutableArray arrayWithObjects:@"read value",@"write value",@"desc",@"properties", nil];
    readValueArray = [[NSMutableArray alloc]init];
    //配置ble委托
    [self babyDelegate];
    //读取服务
    baby.fetchCharacteristicDetails(self.currPeripheral,self.characteristic);
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
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        [weakSelf insertRowToTableView:characteristics];
        
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"CharacteristicViewController Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
}

-(void)insertRowToTableView:(CBCharacteristic *)characteristics{
    [self->readValueArray addObject:[NSString stringWithFormat:@"%@",characteristics.value]];
    NSMutableArray *indexPahts = [[NSMutableArray alloc]init];
    NSIndexPath *indexPaht = [NSIndexPath indexPathForRow:self->readValueArray.count-1 inSection:0];
    [indexPahts addObject:indexPaht];
    [self.tableView insertRowsAtIndexPaths:indexPahts withRowAnimation:UITableViewRowAnimationAutomatic];
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
            return 1;
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
            cell.textLabel.text = @"read value";
            cell.detailTextLabel.text = @"read value detailstext";
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
            cell.textLabel.text = @"desc";
        }
            break;
        case 3:
            //properties
        {
            cell.textLabel.text = @"properties";
        }

            break;
        default:
            return 0 ;break;
    }

    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    title.text = [sect objectAtIndex:section];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor darkGrayColor]];
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
