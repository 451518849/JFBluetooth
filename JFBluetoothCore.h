//
//  JFBluetoothCore.h
//  iOSExample
//
//  Created by 小发工作室 on 2017/8/17.
//  Copyright © 2017年 lixing123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CiBluetoothManager.h"
#import "CiBluetoothManager+Tool.h"

typedef void(^BluetoothScanCompletedBlock)(NSArray * _Nullable devices);

/*
 * 脊峰项目蓝牙入口文件
 */
@interface JFBluetoothCore : NSObject<CiBluetoothProtocol>

@property (nonatomic, strong, nonnull) BluetoothServeredSuccess     bluetoothUpdateValueBlock;

@property (nonatomic, strong, nonnull) BluetoothScanCompletedBlock  bluetoothScanCompletedBlock;

+ (instancetype _Nonnull )shareInstance;

/* @param delay 扫描时长
 * @param bluetoothScanCompletedBlock block返回所有设备
 *
 */
- (void)scanAllBluetoothDevicesWithDelay:(NSTimeInterval)delay
                                repeated:(BOOL)repeated
                         completedBlock:(BluetoothScanCompletedBlock _Nullable )bluetoothScanCompletedBlock;

/* @param name 连接的设备名称
 * @param success BluetoothConnectSuccess 连接成功后回调
 * @param failure BluetoothConnectFailed 连接失败后回调
 */
- (void)connectBluetoothWithBluetoothName:(NSString *_Nullable)name
                                  success:(BluetoothConnectSuccess _Nonnull)success
                                  failure:(BluetoothConnectFailed _Nonnull )failure;

/* @param name 蓝牙名称，不写置nil，标示搜索设备
 * @param deviceId  设备个数 （十进制）
 * @param param 设置时间或者设备个数的值（8位十进制）12345678，不传值置@""
 * @param type 需要的服务类型 CiBluetoothServiceType
 * @param success 返回 value （value有可能整形字符串或者JFBluetoothModel数据或者JFBluetoothModel模型，根据传入的type区分）
 * @param failure 连接失败
 */

- (void)startBluetoothServicesWithBluetoothName:(NSString *_Nullable)name
                                       DeviceID:(NSString *_Nonnull)deviceId
                                          param:(NSString *_Nullable)param
                                    serviceType:(CiBluetoothServiceType)type
                                        success:(BluetoothServeredSuccess _Nonnull)success
                                        failure:(BluetoothServeredFailed _Nonnull )failure;
/*
 * 断开当前连接设备
 */
- (void)disconnectBluetoothDevice;

/*
 * 停止扫描
 */
- (void)stopScanBluetoothDevices;

@end
