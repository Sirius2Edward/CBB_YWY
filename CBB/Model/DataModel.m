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
@synthesize orderid;
@synthesize LL;
@synthesize Rt;
@synthesize worktype;
@synthesize loanmoney;
@synthesize adddate;
@synthesize Xing;
@synthesize yearmonth;
@synthesize buynum;
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