//
//  ViewController.swift
//  BluetoothStubOnOSX
//
//  Created by ZTELiuyw on 15/9/30.
//  Copyright © 2015年 liuyanwei. All rights reserved.
//

import Cocoa
import CoreBluetooth



class ViewController: NSViewController,CBPeripheralManagerDelegate{

//MARK:- static parameter

    let localNameKey =  "BabyBluetoothStubOnOSX";
    let ServiceUUID =  "FFF0";
    let notiyCharacteristicUUID =  "FFF1";
    let readCharacteristicUUID =  "FFF2";
    let readwriteCharacteristicUUID =  "FFE3";
    
    var peripheralManager:CBPeripheralManager!
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    //publish service and characteristic
    func publishService(){
        
        let notiyCharacteristic = CBMutableCharacteristic(type: CBUUID(string: notiyCharacteristicUUID), properties:  [CBCharacteristicProperties.Notify], value: nil, permissions: CBAttributePermissions.Readable)
        let readCharacteristic = CBMutableCharacteristic(type: CBUUID(string: readCharacteristicUUID), properties:  [CBCharacteristicProperties.Read], value: nil, permissions: CBAttributePermissions.Readable)
        let writeCharacteristic = CBMutableCharacteristic(type: CBUUID(string: readwriteCharacteristicUUID), properties:  [CBCharacteristicProperties.Write,CBCharacteristicProperties.Read], value: nil, permissions: [CBAttributePermissions.Readable,CBAttributePermissions.Writeable])
        
        //设置description
        let descriptionStringType = CBUUID(string: CBUUIDCharacteristicUserDescriptionString)
        let description1 = CBMutableDescriptor(type: descriptionStringType, value: "canNotifyCharacteristic")
        let description2 = CBMutableDescriptor(type: descriptionStringType, value: "canReadCharacteristic")
        let description3 = CBMutableDescriptor(type: descriptionStringType, value: "canWriteAndWirteCharacteristic")
        notiyCharacteristic.descriptors = [description1];
        readCharacteristic.descriptors = [description2];
        writeCharacteristic.descriptors = [description3];
        
        //设置service
        let service:CBMutableService =  CBMutableService(type: CBUUID(string: ServiceUUID), primary: true)
        service.characteristics = [notiyCharacteristic,readCharacteristic,writeCharacteristic]
        peripheralManager.addService(service);
        
    }
    //发送数据，发送当前时间的秒数
    func sendData(t:NSTimer)->Bool{
        let characteristic = t.userInfo as!  CBMutableCharacteristic;
        let dft = NSDateFormatter();
        dft.dateFormat = "ss";
        NSLog("%@",dft.stringFromDate(NSDate()))
        
        //执行回应Central通知数据
        return peripheralManager.updateValue(dft.stringFromDate(NSDate()).dataUsingEncoding(NSUTF8StringEncoding)!, forCharacteristic: characteristic, onSubscribedCentrals: nil)
    }

    //MARK:- CBPeripheralManagerDelegate
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        switch peripheral.state{
        case CBPeripheralManagerState.PoweredOn:
            NSLog("power on")
            publishService();
        case CBPeripheralManagerState.PoweredOff:
            NSLog("power off")
        default:break;
        }
    }
    
    
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        peripheralManager.startAdvertising(
            [
                CBAdvertisementDataServiceUUIDsKey : [CBUUID(string: ServiceUUID)]
                ,CBAdvertisementDataLocalNameKey : localNameKey
            ]
        )
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        NSLog("in peripheralManagerDidStartAdvertisiong");
    }
    
    //订阅characteristics
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
        NSLog("订阅了 %@的数据",characteristic.UUID)
        //每秒执行一次给主设备发送一个当前时间的秒数
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:"sendData:" , userInfo: characteristic, repeats: true)
    }
    
    
    //取消订阅characteristics
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic) {
        NSLog("取消订阅 %@的数据",characteristic.UUID)
        //取消回应
        timer.invalidate()
    }
   
    
    //读characteristics请求
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
        NSLog("didReceiveReadRequest")
        //判断是否有读数据的权限
        if(request.characteristic.properties.contains(CBCharacteristicProperties.Read))
        {
            request.value = request.characteristic.value;
            peripheral .respondToRequest(request, withResult: CBATTError.Success);
        }
        else{
            peripheral .respondToRequest(request, withResult: CBATTError.ReadNotPermitted);
        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveWriteRequests requests: [CBATTRequest]) {
        NSLog("didReceiveWriteRequests")
        let request:CBATTRequest = requests[0];
        
        //判断是否有写数据的权限
        if (request.characteristic.properties.contains(CBCharacteristicProperties.Write)) {
            //需要转换成CBMutableCharacteristic对象才能进行写值
            let c:CBMutableCharacteristic = request.characteristic as! CBMutableCharacteristic
            c.value = request.value;
            peripheral .respondToRequest(request, withResult: CBATTError.Success);
        }else{
             peripheral .respondToRequest(request, withResult: CBATTError.ReadNotPermitted);
        }
    }
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
            NSLog("peripheralManagerIsReadyToUpdateSubscribers")
    }
}

