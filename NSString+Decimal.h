//
//  NSString+Decimal.h
//  iOSExample
//
//  Created by 小发工作室 on 2017/8/17.
//  Copyright © 2017年 lixing123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Decimal)

- (NSString *)binaryToDecimal;

- (NSString *)decimalToBinary;

- (NSString *)hexToBinary;

- (NSString *)binaryToHex;

- (NSString *)decimalToHexIsWirte:(BOOL)isWrite;

@end
