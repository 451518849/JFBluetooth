//
//  CiBluetoothManager+Tool.h
//  iOSExample
//
//  Created by 小发工作室 on 2017/8/17.
//  Copyright © 2017年 lixing123.com. All rights reserved.
//

#import "CiBluetoothManager.h"

@interface CiBluetoothManager (Tool)

- (NSString *)convertDataToHexStr:(NSData *)data;

- (NSData *)convertHexStrToData:(NSString *)str ;

@end
