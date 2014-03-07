//
//  DataModel.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-6.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@end

@implementation UserInfo
@synthesize ID;
@synthesize username;
@synthesize password;
@synthesize userInfo;
+(UserInfo *)shareInstance
{
    static UserInfo *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfo alloc] init];
    });
    return instance;
}
-(void)clearInfo
{
    self.ID = nil;
    self.username = nil;
    self.password = nil;
    self.userInfo = nil;
}
@end

@implementation LoanClient
@synthesize ID;
@synthesize Rt;
@synthesize loanmoney;
@synthesize adddate;
@synthesize Xing;
@synthesize buynum;
@synthesize usersex;
@synthesize username;
@synthesize worksf;
@synthesize mobile;
@synthesize loans_dyw;
@synthesize monthIncome;
@synthesize mon_date;
@synthesize address;
@synthesize LL;
@synthesize orderid;
@synthesize worktype;
@synthesize yearmonth;
@synthesize zt;
@end

@implementation Advisor
@synthesize ID;
@synthesize loansID;
@synthesize content;
@synthesize uname;
@synthesize addDate;
@synthesize reDate;
@synthesize see;
@synthesize resee;
@synthesize replyList;
@end

@implementation Reply
@synthesize content;
@synthesize date;
@end

@implementation CardClient
@synthesize ID;
@synthesize orderid;
@synthesize CardName;
@synthesize Address;
@synthesize Date;
@synthesize Xing;
@synthesize LL;
@synthesize zt;
@end

@implementation PayRecord
@synthesize ID;
@synthesize orderid;
@synthesize money;
@synthesize jifen;
@synthesize ptype;
@synthesize paydate;
@synthesize successdate;
@end

@implementation CAnnotation
@synthesize streetAddress;
@synthesize status;
@synthesize coordinate;
-(NSString *)title
{
    return self.streetAddress;
}
-(NSString *)subtitle
{
    NSMutableString *ret=[NSMutableString stringWithString:@"跟进状态："];
    if (status)
        [ret appendString:status];
    return ret;
}
@end