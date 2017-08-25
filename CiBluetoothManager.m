//
//  CiBluetoothManager.m
//  iOSExample
//
//  Created by 小发工作室 on 2017/8/16.
//  Copyright © 2017年 lixing123.com. All rights reserved.
//

#import "CiBluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CiBluetoothManager+Tool.h"

static CiBluetoothManager *_shareInstance = nil;

@interface CiBluetoothManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *connectedPeripheral;
@property (nonatomic, strong) CBCharacteristic *connectedCharacteristic;
@property (nonatomic, strong) NSMutableArray   *scanedPeripherals;

@property (nonatomic, assign) NSTimeInterval   connectDelay;

@property (nonatomic, assign) BOOL             isConnected;


@end

@implementation CiBluetoothManager


#pragma mark -Public

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shareInstance = [self new];
        
    });
    return _shareInstance;
}

- (NSMutableArray *)sensorArr {
    if (_sensorArr == nil) {
        _sensorArr = [NSMutableArray array];
    }
    return _sensorArr;
}

- (NSMutableArray *)scanedPeripherals {
    if (_scanedPeripherals == nil) {
        _scanedPeripherals = [NSMutableArray array];
    }
    return _scanedPeripherals;
}

- (void)scanAllBluetoothsWithDelegate:(id <CiBluetoothProtocol>)delegate delay:(NSTimeInterval)delay{
    
    
    if (delegate == nil) {
        NSLog(@"delegate is null,please check it out");
        return;
    }
    _connectDelay       = delay;
    _delegate           = delegate;
    _centralManager     = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

}

- (void)startConnectBluetoothWithDeviceName:(NSString *_Nullable)name
                                    success:(BluetoothConnectSuccess _Nullable )bluetoothConnectSuccess
                                    failure:(BluetoothConnectFailed _Nullable )bluetoothConnectFailed{
    
    _isConnected = NO;

    for (CBPeripheral *scanPeripheral in self.scanedPeripherals) {
        
        if ([scanPeripheral.name isEqualToString:name]) {
            
            _connectedPeripheral = scanPeripheral;
            
            break;
        }
    }
    
    if (_connectedPeripheral && (_connectedPeripheral.state == CBPeripheralStateDisconnected || _connectedPeripheral.state == CBPeripheralStateDisconnecting ||_connectedPeripheral.state == CBPeripheralStateConnecting)) {
        
        NSLog(@"bluetooth is ready to  connect");
        
        self.bluetoothName           = name;
        self.bluetoothConnectSuccess = bluetoothConnectSuccess;
        self.bluetoothConnectFailed  = bluetoothConnectFailed;
        
        [self.centralManager connectPeripheral:_connectedPeripheral options:nil];

    }
    else if (_connectedPeripheral.state == CBPeripheralStateConnected )
    {
        bluetoothConnectSuccess(@"已连接");
    }
    else
    {
        bluetoothConnectFailed(@"连接失败，设备或被其他人连接");

    }

}

- (void)startBluetoothServicesWithDeviceName:(NSString *)name
                                       param:(NSString *)param
                                     success:(BluetoothServeredSuccess _Nullable )bluetoothServeredSuccess
                                     failure:(BluetoothServeredFailed _Nullable )bluetoothServeredFailed{
    

    if (_connectedPeripheral.state == CBPeripheralStateConnected) {
        
        self.bluetoothServeredSuccess = bluetoothServeredSuccess;
        self.bluetoothServeredFailed  = bluetoothServeredFailed;

        _orderValue = param;

        if (!_connectedCharacteristic) {
            

        //[_connectedPeripheral discoverServices:nil];

        }
        else
        {
            
            [self peripheralWirteValue:param connectedCharacteristic:_connectedCharacteristic];
        }
        
    }
    else {
        NSLog(@"bluetooth dont connect, please chectout");
        
        bluetoothServeredFailed(CiBluetoothErrorResultType, @"写入失败");
    }
    
}


- (void)disconnectBluetooth {
    
    if (_connectedPeripheral) {
        
        [_centralManager cancelPeripheralConnection:_connectedPeripheral];
        
    }
    
    
}

#pragma mark -CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
            
        case CBManagerStateUnknown:
            NSLog(@"bluetooth is Unknow !");
            break;
            
        case CBManagerStateResetting:
            NSLog(@"bluetooth is Resetting !");

            break;
            
        case CBManagerStateUnsupported:
            NSLog(@"bluetooth is Unsupported !");

            break;
            
        case CBManagerStateUnauthorized:
            NSLog(@"bluetooth is Unauthorized !");

            break;
            
        case CBManagerStatePoweredOff:
            NSLog(@"bluetooth is PoweredOff !");

            break;
            
        case CBManagerStatePoweredOn:
            NSLog(@"bluetooth is PoweredOn !");
            
            [self filterBluetoothScanWithServices:nil options:nil];
            
            break;
            
        default:
            break;
    }
    
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"device :%@", peripheral);

    
    if (![self.scanedPeripherals containsObject:peripheral]) {
        
        @synchronized (self.scanedPeripherals) {
            
            [self.scanedPeripherals addObject:peripheral];
            
            
        }

    }
    
    //不重复添加蓝牙名称
    if (peripheral.name) {
        
        if (![self.sensorArr containsObject:peripheral.name]) {
            
            @synchronized (self.sensorArr) {
                
                [self.sensorArr addObject:peripheral.name];
                
                
            }
            
            
        }
        
        
    }
    
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"bluetooth connection is success");
    
    [self stopBluetoothScan];

    if (_isConnected == NO) {
        
        _isConnected = YES;
        _connectedPeripheral = peripheral;
        
        if (self.bluetoothConnectSuccess) {
            
            dispatch_main_async_safe(^{
                
                self.bluetoothConnectSuccess(peripheral.name);
                
            })
        }
    }
    

    
    if ([self.delegate conformsToProtocol:@protocol(CiBluetoothProtocol)]) {
        
        if ([self.delegate respondsToSelector:@selector(bluetoothConnectSuccess)]) {
            [self.delegate bluetoothConnectSuccess];
        }
    }
    // allow to connect and filter devices , if is nil , all devices will be allowed to connect
    [self filterDeviceWithCBUUIDs:nil];
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    _isConnected = NO;
    
    [self stopBluetoothScan];
    
    if (self.bluetoothConnectFailed) {
        
        self.bluetoothConnectFailed(peripheral.name);
    }
    
    if ([self.delegate conformsToProtocol:@protocol(CiBluetoothProtocol)]) {
        
        if ([self.delegate respondsToSelector:@selector(bluetoothConnectFailed)]) {
            [self.delegate bluetoothConnectFailed];
        }
    }
    
    NSLog(@"bluetooth connection is FAILED");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    NSLog(@"bluetooth connection disconnected");
    
    _connectedPeripheral     = nil;
    _connectedCharacteristic = nil;
    _orderValue = @"";
    _isConnected = NO;
    
    if (self.bluetoothConnectFailed) {
        
        self.bluetoothConnectFailed(@"连接失败！");
    }
    
}

#pragma mark -CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"services discoveryed error");
    }
    else
    {
        
        if ([peripheral.name isEqualToString:self.bluetoothName]) {
            
            for (CBService *service in _connectedPeripheral.services) {
                
                //service UUID FFF0
                [_connectedPeripheral discoverCharacteristics:nil forService:service];
                
            }
        }
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"Characteristics discoveryed error");
    }
    else {
        
        for (CBCharacteristic *characteristic in service.characteristics) {
            
            _connectedCharacteristic = characteristic;
        
            //characteristic UUID FFF1
            [_connectedPeripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            [self peripheralWirteValue:_orderValue connectedCharacteristic:characteristic];
        }
        
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"the value of Characteristic update error");
    }
    else {
        
        _connectedCharacteristic = characteristic;
        
        if ([self.delegate conformsToProtocol:@protocol(CiBluetoothProtocol)]) {
            
            dispatch_main_async_safe(^{
                
                // read data from device
                [self.delegate updateDataFromBluetooth:_connectedCharacteristic.value];
            });
            
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"Characteristic write error");
    }
    else
    {
        NSLog(@"write Characteristic:%@", characteristic);
        
      //  [peripheral readValueForCharacteristic:characteristic];
    }
}
#pragma mark -Private

- (void)filterBluetoothScanWithServices:(NSMutableArray *)services
                                options:(NSDictionary *)options {
    
    
    [self openBluetoothWithTimer:_connectDelay];
    
    [self.centralManager scanForPeripheralsWithServices:services options:options];
    
}

- (void)filterDeviceWithCBUUIDs:(NSMutableArray *)cbuuids {
    
    _connectedPeripheral.delegate = self;
    
    [_connectedPeripheral discoverServices:nil];
}

- (void)peripheralWirteValue:(NSString *)value connectedCharacteristic:(CBCharacteristic *)connectedCharacteristic{
    
    NSData *valueData = [self convertHexStrToData:value];

    if (valueData == nil || valueData.length == 0) {
        return;
    }
    
    if (connectedCharacteristic == nil) {
        
        return;
    }
    
    [_connectedPeripheral writeValue:valueData
                   forCharacteristic:connectedCharacteristic
                                type:CBCharacteristicWriteWithResponse];

}

- (void)openBluetoothWithTimer:(NSTimeInterval)delay {
    
    if (delay <= 0.0) {
        
        return;
    }
    
    //定时器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"-------延时执行--------");
        
        [self connectTimeout];
    });
    
}

- (void)connectTimeout{
    
    [self stopBluetoothScan];

    //返回蓝牙列表数组
    dispatch_main_async_safe(^{
        
        if ([self.delegate respondsToSelector:@selector(scanForBluetoothDevices:)]) {
            
            [self.delegate scanForBluetoothDevices:self.sensorArr];
            

        }
        
        
        if ([self.delegate respondsToSelector:@selector(didCompetedScanOnceBluetoothDevices)]) {
            [self.delegate didCompetedScanOnceBluetoothDevices];
        }
        
        
    })

    NSLog(@"scan time out");

}

- (void)stopBluetoothScan {

    [_centralManager stopScan];
    
    
}


@end























