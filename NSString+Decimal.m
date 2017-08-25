//
//  NSString+Decimal.m
//  iOSExample
//
//  Created by 小发工作室 on 2017/8/17.
//  Copyright © 2017年 lixing123.com. All rights reserved.
//

#import "NSString+Decimal.h"

@implementation NSString (Decimal)

- (NSString *)binaryToDecimal
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < self.length; i ++)
    {
        temp = [[self substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, self.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    
    return result;
}

//  十进制转二进制
- (NSString *)decimalToBinary
{
    int num = [self intValue];
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    
    for (int i = (int)(prepare.length - 1); i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}

- (NSString *)decimalToHexIsWirte:(BOOL)isWrite {
    
    NSString *hex = @"";
    NSString *letter;
    
    NSInteger decimal = [self integerValue];
    NSInteger number;
    
    for (int i = 0; i<9; i++) {
        
        number  = decimal % 16;
        decimal = decimal / 16;
        
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                
                if ([self integerValue] < 16) {
                    
                    letter = [NSString stringWithFormat:@"0%ld", number];

                }
                else
                {
                    letter = [NSString stringWithFormat:@"%ld", number];
                }
        }
        
        hex = [letter stringByAppendingString:hex];
        
        if (decimal == 0) {
            
            break;
        }
    }
    
    if (isWrite) {
        
        NSInteger length = hex.length;
        
        for (int i = 0; i < 8 - length; i ++ ) {
            
            hex = [@"0" stringByAppendingString:hex];
        }
        
    }
    
    return hex;
    
    
}

- (NSString *)hexToBinary{
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i < [self length]; i++) {
        
        NSString *key = [self substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}

- (NSString *)binaryToHex{
    
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    NSString *str = self;
    
    if (self.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - self.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        str = [mStr stringByAppendingString:self];
    }
    NSString *hex = @"";
    
    for (int i=0; i<self.length; i+=4) {
        
        NSString *key = [str substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex;
}

@end
