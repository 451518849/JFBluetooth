//
//  JFBluetoothModel.h
//  iOSExample
//
//  Created by 小发工作室 on 2017/8/17.
//  Copyright © 2017年 lixing123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFBluetoothModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, copy  ) NSString       *time;

@property (nonatomic, copy  ) NSString       *deviceName;

@end
