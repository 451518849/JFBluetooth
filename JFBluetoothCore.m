//
//  JFBluetoothCore.m
//  iOSExample
//
//  Created by 小发工作室 on 2017/8/17.
//  Copyright © 2017年 lixing123.com. All rights reserved.
//

#import "JFBluetoothCore.h"

#import "JFMacro.h"
#import "NSString+Decimal.h"
#import "JFBluetoothModel.h"
#import "JFBluetoothDataModel.h"

static JFBluetoothCore *_singleInstance = nil;

@interface JFBluetoothCore ()

@property (nonatomic, copy  ) NSString               *historyDataString;

@property (nonatomic, assign) CiBluetoothServiceType dataType;

@property (nonatomic, copy  ) NSString               *deviceId;

@property (nonatomic, assign) BOOL                   repeated;

@property (nonatomic, assign) BOOL                   isConnected;

@end

@implementation JFBluetoothCore

#pragma mark -Public

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleInstance = [self new];
    });
    return _singleInstance;
}

- (void)scanAllBluetoothDevicesWithDelay:(NSTimeInterval)delay
                                repeated:(BOOL)repeated
                         completedBlock:(BluetoothScanCompletedBlock _Nullable )bluetoothScanCompletedBlock{

    self.bluetoothScanCompletedBlock = bluetoothScanCompletedBlock;
    _repeated                        = repeated;
    
    [[CiBluetoothManager shareManager] scanAllBluetoothsWithDelegate:self delay:delay];
}

- (void)connectBluetoothWithBluetoothName:(NSString *_Nullable)name
                                  success:(BluetoothConnectSuccess _Nonnull)success
                                  failure:(BluetoothConnectFailed _Nonnull )failure {
    
    [[CiBluetoothManager shareManager] startConnectBluetoothWithDeviceName:name
                                                                   success:success
                                                                   failure:failure];
}


- (void)startBluetoothServicesWithBluetoothName:(NSString *_Nullable)name
                                       DeviceID:(NSString *_Nonnull)deviceId
                                          param:(NSString *_Nullable)param
                                    serviceType:(CiBluetoothServiceType)type
                                        success:(BluetoothServeredSuccess _Nonnull)success
                                        failure:(BluetoothServeredFailed _Nonnull )failure{
    
    self.bluetoothUpdateValueBlock = success;

    
    NSString *serviceType = @"";
    
    switch (type) {
        
        case CiBluetoothGetPowerServiceType:
            serviceType = JFBattery;
            break;
         
        case CiBluetoothClearFlashServiceType:
            serviceType = JFClearFlash;

            break;
        
        case CiBluetoothSetReservedWordServiceType:
            
          //  serviceType = [NSString stringWithFormat:JFSetReservedWord, [param decimalToHexIsWirte:YES]];
            serviceType = [NSString stringWithFormat:JFSetReservedWord, param];
            break;
            
        case CiBluetoothGetReservedWordServiceType:
            serviceType = JFReservedWord;

            break;
        case CiBluetoothSetTimeIntervalServiceType:
            
            serviceType = [NSString stringWithFormat:JFSetTimeInterval, [param decimalToHexIsWirte:YES]];
            break;
            
        case CiBluetoothGetTimeIntervalServiceType:
            serviceType = JFTimeInterval;
            break;
            
        case CiBluetoothSetSensorCountServiceType:
            
            serviceType = [NSString stringWithFormat:JFSetSensorCount, [param decimalToHexIsWirte:YES]];
            break;
            
        case CiBluetoothGetSensorCountServiceType:
            serviceType = JFSensorCount;
            
            break;
        case CiBluetoothSetRealTimeServiceType:
            serviceType = JFSetTime;
            break;
            
        case CiBluetoothGetRealTimeServiceType:
            serviceType = JFTime;
            break;
            
        case CiBluetoothGetRealDataServiceType:
            
            _dataType   = CiBluetoothGetRealDataServiceType;
            
            serviceType = [NSString stringWithFormat:JFRealData,[deviceId decimalToHexIsWirte:NO]];

            break;
        case CiBluetoothGetHistoryDataServiceType:
            
            _dataType   = CiBluetoothGetHistoryDataServiceType;
            _deviceId   = deviceId;

            serviceType = [NSString stringWithFormat:JFHistoryData,[deviceId decimalToHexIsWirte:NO]];

            break;
            
        default:
            
            self.bluetoothUpdateValueBlock(CiBluetoothErrorResultType, serviceType);
            return;
            
            break;
    }
    
    [[CiBluetoothManager shareManager] startBluetoothServicesWithDeviceName:name
                                                                      param:serviceType
                                                                    success:success
                                                                    failure:failure];
    
}

- (void)disconnectBluetoothDevice {
    
    [[CiBluetoothManager shareManager] disconnectBluetooth];

}

- (void)stopScanBluetoothDevices {
    
    [[CiBluetoothManager shareManager] stopBluetoothScan];

}


#pragma mark -CiBluetoothProtocol

- (void)updateDataFromBluetooth:(NSData *)data {
    
    if (data == nil || data.length == 0) {
        
        NSLog(@"update vlaue is nil ");
        
        self.bluetoothUpdateValueBlock(CiBluetoothNullResultType, @"");
        
        return;
        
    }
    else
    {
        NSLog(@"%@", data);
    }
    
    [self handleBluetoothUpdateData:data];
}

- (void)scanForBluetoothDevices:(NSMutableArray *)devices {
    
    if (self.bluetoothScanCompletedBlock) {
        
        self.bluetoothScanCompletedBlock(devices);
    }
    
}

- (void)didCompetedScanOnceBluetoothDevices {
    
    if (!_repeated) {
        [self stopScanBluetoothDevices];
    }
    
}


#pragma mark -Private

- (void)handleBluetoothUpdateData:(NSData *)data {
    
    NSString *hexString    = [[CiBluetoothManager shareManager] convertDataToHexStr:data];
    NSString *binaryString = [hexString hexToBinary];
    
    if (_dataType == CiBluetoothGetHistoryDataServiceType) {
        
        [self handleHistoryUpdataDataWith:binaryString];

    }
    else {
        [self handleRealTimeUpdataDataWith:binaryString];

    }
    
}

#pragma mark -Handle Real Time Data

- (void)handleRealTimeUpdataDataWith:(NSString *)dataString {
    
    NSString *subString = [dataString substringWithRange:NSMakeRange(0, 8)];
    
    if ([subString isEqualToString:@"11111110"]) {
        
        NSString *codeString = [dataString substringWithRange:NSMakeRange(16, 8)];
        
        if ([codeString isEqualToString:@"00001001"]) {
            
            NSString *type = [dataString substringWithRange:NSMakeRange(24, 8)];
            
            CiBluetoothServiceType serviceType;
            
            if ([type isEqualToString:@"00000001"]) {
                
                serviceType = CiBluetoothGetTimeIntervalServiceType;
                
            }
            else if ([type isEqualToString:@"00000010"]) {
                
                serviceType = CiBluetoothGetSensorCountServiceType;
                
            }
            else if ([type isEqualToString:@"00000011"]) {
                
                serviceType = CiBluetoothGetRealTimeServiceType;
                
            }
            else if ([type isEqualToString:@"00000100"]) {
                
                serviceType = CiBluetoothGetPowerServiceType;
                
            }
            else if ([type isEqualToString:@"00000111"]) {
                
                serviceType = CiBluetoothGetReservedWordServiceType;
            }
            else {
                
                serviceType = CiBluetoothServiceErrorType;
            }
            
            NSString *binarySubString = [dataString substringWithRange:NSMakeRange(40, 32)];
            
            NSString *subNum;
            
            if (serviceType == CiBluetoothGetReservedWordServiceType) {
                
                subNum = [binarySubString binaryToHex];
            }
            else
            {
                subNum = [binarySubString binaryToDecimal];
            }
            
            self.bluetoothUpdateValueBlock(CiBluetoothSuccessResultType,subNum);
            
        }
        else if ([codeString isEqualToString:@"00000111"]) {
            
            //设置命令
            self.bluetoothUpdateValueBlock(CiBluetoothSuccessResultType,@"保留字设置成功!");

        }
        else if ([codeString isEqualToString:@"00000101"]){
            
            
            NSInteger decimal        = [[[dataString substringWithRange:NSMakeRange(32, 8)] binaryToDecimal] integerValue];
            
            NSInteger count          = (decimal - 4) / 5;

            NSMutableArray *dataList = [self handleDataModelWithData:dataString count:count];

            JFBluetoothModel *model  = [self handelModelWithDataList:dataList dataString:dataString];
            
            self.bluetoothUpdateValueBlock(CiBluetoothSuccessResultType, model);
        }
    }
    
}


#pragma mark -Handle History Data

- (void)handleHistoryUpdataDataWith:(NSString *)dataString {
    
    NSString *hisoryCharacterString = @"1111111000000000000000110000000000000000";
    
    _historyDataString = [_historyDataString stringByAppendingString:dataString];
    
    NSString *subString = [_historyDataString substringWithRange:NSMakeRange(dataString.length - 6 * 8, 40)];
    //判断历史数据是否结束，根据结尾位判断
    if ([subString isEqualToString:hisoryCharacterString]) {
        
        NSMutableArray *dataList = [self handleDataModelWithHistoryData:_historyDataString];
        
        self.bluetoothUpdateValueBlock(CiBluetoothSuccessResultType, dataList);
        
        _historyDataString = nil;
    }
    
    
}

- (NSMutableArray *)handleDataModelWithHistoryData:(NSString *) dataString {
    
    NSInteger unitLength = (10 + [_deviceId intValue] * 5) * 8;
    
    NSInteger count = (dataString.length - 48) / unitLength;
    
    NSMutableArray *modelList = [NSMutableArray array];
    
    for (int i = 0; i < count; i ++) {
        
        NSString *bodyString = [dataString substringWithRange:NSMakeRange(i * unitLength, unitLength)];
        NSString *codeString = [bodyString substringWithRange:NSMakeRange(0, 8)];
        
        if ([codeString isEqualToString:@"11111110"]) {
            
            NSString *subString = [bodyString substringWithRange:NSMakeRange(16, 8)];
            
            if ([subString isEqualToString:@"00000011"]) {

                NSInteger dataLength     = [[[bodyString substringWithRange:NSMakeRange(32, 8)] binaryToDecimal] integerValue];
                NSInteger count          = (dataLength -4) / 5;

                NSMutableArray *dataList = [self handleDataModelWithData:bodyString count:count];

                JFBluetoothModel *model  = [self handelModelWithDataList:dataList dataString:bodyString];
                
                [modelList addObject:model];
            }
        }
    }
    
    return modelList;
}

#pragma mark common handle

- (NSMutableArray *)handleDataModelWithData:(NSString *) dataString count:(NSInteger)count{
    
    
    NSMutableArray *modelList = [NSMutableArray array];
    
    for (int i = 1; i <= count; i++) {
        
        NSInteger channelState = [[dataString substringWithRange:NSMakeRange(i * 40, 4)] integerValue];
        
        if (channelState == 0) {
            
            JFBluetoothDataModel *model = [JFBluetoothDataModel new];
            
            model.channel       = [[dataString substringWithRange:NSMakeRange(i * 40 + 4, 4)] binaryToDecimal];
            model.pressure      = [[dataString substringWithRange:NSMakeRange(i * 40 + 8, 24)] binaryToDecimal];
            model.pressureState = [[dataString substringWithRange:NSMakeRange(i * 40 + 32, 8)] binaryToDecimal];
            
            [modelList addObject:model];
        }
    }
    
    return modelList;
}

- (JFBluetoothModel *)handelModelWithDataList:(NSMutableArray *)dataList dataString:(NSString *)dataString{
    
    JFBluetoothModel *model  = [JFBluetoothModel new];
    
    model.dataList           = [dataList copy];
    
    model.time = [[dataString substringWithRange:NSMakeRange(dataString.length - 40,
                                                             32)] binaryToDecimal];
    
    return model;
}

@end





















