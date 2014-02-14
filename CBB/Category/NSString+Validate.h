//
//  NSString+Validate.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-9.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)

//+(NSString *)myPhoneNumber;//获取本机号码
-(BOOL)isEmailAddress;//邮箱地址规范验证
-(BOOL)isMobileNumber;//手机号码验证
-(BOOL)isAreaNumber;//区号验证
-(BOOL)isTelNumber;//电话号码验证
-(BOOL)isBranchNumber;//分机号验证
-(BOOL)isPhoneNumber;//完整电话号码验证
-(BOOL)isQQNumber;//QQ号码验证
-(NSString *)getIDfromDic:(NSDictionary *)aDic WithTypeName:(NSString *)name;//从字典中获得ID
-(NSArray *)getStateAndCityID:(NSDictionary *)cityDic;//获得省市ID
-(NSString *)getCityID:(NSDictionary *)cityDic;//获得城市ID
@end
