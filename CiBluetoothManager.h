//
//  CiBluetoothManager.h
//  iOSExample
//
//  Created by 小发工作室 on 2017/8/16.
//  Copyright © 2017年 lixing123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define dispatch_main_async_safe(block)\
if([NSThread isMainThread]){\
    block();\
}\
else{\
    dispatch_async(dispatch_get_main_queue(), block);\
}\

typedef NS_ENUM(NSInteger, CiBluetoothServiceType) {
    
    //请求超时
    CiBluetoothTimeOutServiceType = -2,
    
    CiBluetoothServiceErrorType = -1,
    
    // 读取电量
    CiBluetoothGetPowerServiceType = 1 << 1,
    
    //清除flash数据
    CiBluetoothClearFlashServiceType = 1 << 2,
    
    // 设置保留字
    CiBluetoothSetReservedWordServiceType = 1 << 3 ,

    //读取保留字段
    CiBluetoothGetReservedWordServiceType = 1 << 4 ,
    
    // 设置时间间隔 timeInterval格式 时间戳格式
    CiBluetoothSetTimeIntervalServiceType = 1 << 5,

    //获取时间间隔
    CiBluetoothGetTimeIntervalServiceType = 1 << 6,
    
    //设置传感器数目
    CiBluetoothSetSensorCountServiceType = 1 << 7,
    
    //获取传感器数目
    CiBluetoothGetSensorCountServiceType = 1 << 8,

    //设置时间
    CiBluetoothSetRealTimeServiceType = 1 << 9,
    
    //读取时间
    CiBluetoothGetRealTimeServiceType = 1 << 10,

    //获取实时数据
    CiBluetoothGetRealDataServiceType = 1 << 11,
    
    //获取历史数据
    CiBluetoothGetHistoryDataServiceType = 1 << 12,

};

typedef NS_ENUM(NSInteger, CiBluetoothResultType) {
    
    CiBluetoothErrorResultType = -2,
    
    CiBluetoothNullResultType,
    
    CiBluetoothSuccessResultType = 1,
    
};


@protocol CiBluetoothProtocol <NSObject>

@required


- (void)updateDataFromBluetooth:(NSData *_Nullable)data;

- (void)scanForBluetoothDevices:(NSMutableArray *_Nullable)devices;

- (void)didCompetedScanOnceBluetoothDevices;

@optional

- (void)bluetoothConnectSuccess;

- (void)bluetoothConnectFailed;



@end
typedef void(^BluetoothConnectSuccess)(id _Nullable info);
typedef void(^BluetoothConnectFailed)(id  _Nullable info);

typedef void(^BluetoothServeredSuccess)(CiBluetoothResultType type,id _Nullable value);
typedef void(^BluetoothServeredFailed)(CiBluetoothResultType type,id _Nullable value);

@interface CiBluetoothManager : NSObject

@property (nonatomic, weak , nullable ) id <CiBluetoothProtocol> delegate;

@property (nonatomic, copy, nullable  ) NSString                 *bluetoothName;

@property (nonatomic, copy , nullable ) NSString                 *orderValue;

@property (nonatomic, strong, nullable) NSMutableArray           *sensorArr;

@property (nonatomic, strong , nonnull) BluetoothConnectSuccess  bluetoothConnectSuccess;

@property (nonatomic, strong , nonnull) BluetoothConnectFailed   bluetoothConnectFailed;

@property (nonatomic, strong , nonnull) BluetoothServeredSuccess bluetoothServeredSuccess;

@property (nonatomic, strong , nonnull) BluetoothServeredFailed  bluetoothServeredFailed;

+ (instancetype _Nullable )shareManager;

- (void)scanAllBluetoothsWithDelegate:(id <CiBluetoothProtocol> _Nonnull)delegate delay:(NSTimeInterval)delay;

- (void)startConnectBluetoothWithDeviceName:(NSString *_Nullable)name
                                    success:(BluetoothConnectSuccess _Nullable )bluetoothConnectSuccess
                                    failure:(BluetoothConnectFailed _Nullable )bluetoothConnectFailed;

- (void)startBluetoothServicesWithDeviceName:(NSString *_Nonnull)name
                                       param:(NSString *_Nonnull)param
                                     success:(BluetoothServeredSuccess _Nullable )bluetoothServeredSuccess
                                     failure:(BluetoothServeredFailed _Nullable )bluetoothServeredFailed;
- (void)disconnectBluetooth;

- (void)stopBluetoothScan;

@end
