//
//  ViewController.m
//  BabyBluetoothDemo
//
//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "ViewController.h"

//screen width and height
#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height

@interface ViewController (){
//    UITableView *tableView;
    NSMutableArray *peripherals;
    BabyBluetooth *baby;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化table init table
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    //初始化BabyBluetooth 蓝牙库
    [self pregnancy];
    //初始化其他数据 init other
    peripherals = [[NSMutableArray alloc]init];
    //开始扫描设备
    [self performSelector:@selector(scanPeripheral) withObject:nil afterDelay:2];

    //测试方法
//    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(testInsertRow) userInfo:nil repeats:YES];
}

#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置 BabyBluetooth init and config
-(void)pregnancy{
    //初始化BabyBluetooth， BabyBluetooth init
    baby = [[BabyBluetooth alloc]init];
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        [weakSelf insertTableView:peripheral];
    }];
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        //设置连接成功的block
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    
    [baby setBlockOndDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
        //找到cell并修改detaisText
        for (int i=0;i<peripherals.count;i++) {
            UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell.textLabel.text == peripheral.name) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d个service",peripheral.services.count];
            }
        }
        
    }];
    
    
//#warning 设置长连接，测试设备特殊设置
//    //开启长连接
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"39E1FA06-84A8-11E2-AFBA-0002A5D5C51B"]] ) {
//        int i = 1;
//        NSData *data = [NSData dataWithBytes: &@(1) length: 1];
//        [_testPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
//    }
    
    //设置查找设备的过滤器
    [baby setDiscoverPeripheralsFilter:^BOOL(NSString *peripheralsFilter) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralsFilter.length >1) {
            return YES;
        }
        return NO;
    }];
}

//扫描设备,读取服务
-(void)scanPeripheral{
    
//    baby.scanForPeripherals().begin(); //扫描设备
    
    //扫描设备 然后读取服务,然后读取characteristics名称和值和属性
    baby.scanForPeripherals().then.connectToPeripheral()
    .then.discoverServices().then.discoverCharacteristics().begin();
}

//点击table row连接制定设备
-(void)selectRowForConnectPeripheral:(CBPeripheral *)peripheral{
    baby.connectToPeripheral(peripheral).discoverServices().discoverCharacteristics().begin(10).stop();
    
}

//读取服务
-(void)fetchServices{

    
}
//读取RSSI



#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral{
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
    [indexPaths addObject:indexPath];
    [peripherals addObject:peripheral];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    NSLog(@"insertDevice done!");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -table委托 table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return peripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //peripheral名称 peripheral name
    cell.textLabel.text = peripheral.name;
    //信号和服务
    cell.detailTextLabel.text = @"读取中...";
    //次线程读取RSSI和服务数量
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
