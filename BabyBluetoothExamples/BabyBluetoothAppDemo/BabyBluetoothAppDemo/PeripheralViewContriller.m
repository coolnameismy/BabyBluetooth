//
//  PeripheralViewContriller.m
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/4.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "PeripheralViewContriller.h"

#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height
#define channelOnPeropheralView @"peripheralView"

@interface PeripheralViewContriller ()

@end

@implementation PeripheralViewContriller{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    self.services = [[NSMutableArray alloc]init];
    [self babyDelegate];

    //开始扫描设备
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    [SVProgressHUD showInfoWithStatus:@"准备连接设备"];
    //导航右侧菜单
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navRightBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [navRightBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [navRightBtn.titleLabel setTextColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
    [navRightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];

                                      
}
//导航右侧按钮点击
-(void)navRightBtnClick:(id)sender{
    NSLog(@"navRightBtnClick");
//    [self.tableView reloadData];
    [self readPlantAssistantData];
}

//退出时断开连接
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}


//babyDelegate
-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;

    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调

    [baby setBlockOnConnectedOnChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesOnChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            [weakSelf insertSectionToTableView:s];
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsOnChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        [weakSelf insertRowToTableView:service];
       
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicOnChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicOnChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsOnChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
}
-(void)loadData{
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}

#warning 测试数据
//个性化，读取设备养护数据
-(void)readPlantAssistantData{
    //写入当前系统时间
    
    CBCharacteristic *currentTime = [BabyToy findCharacteristicFormServices:self.services UUIDString:@"FFA8"];
    
    if (currentTime) {
        NSMutableData *data = [NSMutableData data];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy/MM/dd/hh/mm"];
        NSArray *dateArray = [[df stringFromDate:[NSDate date]] componentsSeparatedByString:@"/"];
        for (NSString *item in dateArray) {
            int intItem = [item intValue];
            if (intItem > 1000) {
                int hPart = intItem/100;
                int lPart = intItem%2000;
                [data appendData:[NSData dataWithBytes:&hPart length:1]];
                [data appendData:[NSData dataWithBytes:&lPart length:1]];
            }
            else{
                [data appendData:[NSData dataWithBytes:&intItem length:1]];
            }
            
        }

        [self.currPeripheral writeValue:data forCharacteristic:currentTime type:CBCharacteristicWriteWithResponse];
    }

    //读取当前RecordStartTime（FFA2）RecordPeriod(FFAB) CurrentTime(FFA8)，ReadID（FFA4），ReadOT(FFA5)
    
    //设置ReadID,ReadOT
    
    //TransferStatus(FFA9) 写1
    CBCharacteristic *transferStatus = [BabyToy findCharacteristicFormServices:self.services UUIDString:@"FFA9"];

    if (transferStatus) {
        int i = 1;
        NSData *value = [NSData dataWithBytes:&i length:sizeof(i)];
        [self.currPeripheral writeValue:value forCharacteristic:transferStatus type:CBCharacteristicWriteWithResponse];
    }
    //订阅RecordBuf(FFA1)数据
    CBCharacteristic *recordBuf =  [BabyToy findCharacteristicFormServices:self.services UUIDString:@"FFA1"];

    if (recordBuf) {
        [self.currPeripheral setNotifyValue:YES forCharacteristic:recordBuf];
    }

}



#pragma mark -插入table数据
-(void)insertSectionToTableView:(CBService *)service{
    NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    PeripheralInfo *info = [[PeripheralInfo alloc]init];
    [info setServiceUUID:service.UUID];
    [self.services addObject:info];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.services.count-1];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
    
-(void)insertRowToTableView:(CBService *)service{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    int sect = -1;
    for (int i=0;i<self.services.count;i++) {
        PeripheralInfo *info = [self.services objectAtIndex:i];
        if (info.serviceUUID == service.UUID) {
            sect = i;
        }
    }
    if (sect != -1) {
        PeripheralInfo *info =[self.services objectAtIndex:sect];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sect];
            [indexPaths addObject:indexPath];
            NSLog(@"add indexpath in row:%d, sect:%d",row,sect);
        }
        PeripheralInfo *curInfo =[self.services objectAtIndex:sect];
        NSLog(@"%@",curInfo.characteristics);
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }

    
}


#pragma mark -Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.services.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PeripheralInfo *info = [self.services objectAtIndex:section];
    return [info.characteristics count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBCharacteristic *characteristic = [[[self.services objectAtIndex:indexPath.section] characteristics]objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"characteristicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@",characteristic.UUID];
    cell.detailTextLabel.text = characteristic.description;
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    PeripheralInfo *info = [self.services objectAtIndex:section];
    title.text = [NSString stringWithFormat:@"%@", info.serviceUUID];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor darkGrayColor]];
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CharacteristicViewController *vc = [[CharacteristicViewController alloc]init];
    vc.currPeripheral = self.currPeripheral;
    vc.characteristic =[[[self.services objectAtIndex:indexPath.section] characteristics]objectAtIndex:indexPath.row];
    vc->baby = baby;
    [self.navigationController pushViewController:vc animated:YES];
}


 
@end
