//
//  DataModel.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-6.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@end

@interface UserInfo : DataModel
@property(nonatomic,retain)NSString *ID;                    //业务员用户ID
@property(nonatomic,retain)NSString *username;              //登陆账号
@property(nonatomic,retain)NSString *password;              //登陆密码
@property(nonatomic,retain)NSMutableDictionary *userInfo;   //用户基本资料
+(UserInfo *)shareInstance;//静态方法，使用单例
-(void)clearInfo;//清除数据
@end

#pragma mark - 
//属性字段与网络接口返回的XML结点字段一致
//贷款新客户表
@interface LoanClient : DataModel
@property(nonatomic,retain)NSString *ID;
@property(nonatomic,retain)NSString *orderid;
@property(nonatomic,retain)NSString *LL;
@property(nonatomic,retain)NSString *worktype;
@property(nonatomic,retain)NSString *yearmonth;
@property(nonatomic,retain)NSString *Rt;
@property(nonatomic,retain)NSString *loanmoney;
@property(nonatomic,retain)NSString *adddate;
@property(nonatomic,retain)NSString *Xing;
@property(nonatomic,retain)NSString *buynum;
@property(nonatomic,retain)NSString *usersex;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *worksf;
@property(nonatomic,retain)NSString *mobile;
@property(nonatomic,retain)NSString *loans_dyw;
@property(nonatomic,retain)NSString *monthIncome;
@property(nonatomic,retain)NSString *mon_date;
@property(nonatomic,retain)NSString *address;
@end

//贷款用户咨询表
@interface Advisor : DataModel
@property(nonatomic,retain)NSString *ID;
@property(nonatomic,retain)NSString *loansID;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *uname;
@property(nonatomic,retain)NSString *addDate;
@property(nonatomic,retain)NSString *reDate;
@property(nonatomic,retain)NSString *see;
@property(nonatomic,retain)NSString *resee;
@property(nonatomic,retain)NSArray  *replyList;
@end
//咨询回复
@interface Reply : DataModel
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *date;
@end

//信用卡新客户表
@interface CardClient : DataModel
@property(nonatomic,retain)NSString *ID;
@property(nonatomic,retain)NSString *orderid;
@property(nonatomic,retain)NSString *CardName;
@property(nonatomic,retain)NSString *Address;
@property(nonatomic,retain)NSString *Date;
@property(nonatomic,retain)NSString *Xing;
@property(nonatomic,retain)NSString *LL;
@property(nonatomic,retain)NSString *zt;
@end

//充值记录表
@interface PayRecord : DataModel
@property(nonatomic,retain)NSString *ID;
@property(nonatomic,retain)NSString *orderid;
@property(nonatomic,retain)NSString *money;
@property(nonatomic,retain)NSString *jifen;
@property(nonatomic,retain)NSString *ptype;
@property(nonatomic,retain)NSString *paydate;
@property(nonatomic,retain)NSString *successdate;
@end
