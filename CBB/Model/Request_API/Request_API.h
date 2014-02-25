//
//  Request_API.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-7.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTP_Request.h"

#define LoanYWY @"loansuserlogin.asp"
#define CardYWY @"carduserlogin.asp"
#define REGISTER @"userreg.asp"
#define LoanREG @"loansreg.asp"
#define CardREG @"regcard.asp"

@interface Request_API : NSObject

@property(nonatomic,assign)id delegate;

+(Request_API *)shareInstance;                              //请求接口单例
-(void)cancel;

//业务员注册
-(void)registerCardWithDic:(NSDictionary *)aDic;            //信用卡业务员注册
-(void)registerLoanWithDic:(NSDictionary *)aDic;            //贷款业务员注册
-(void)registerValidatedBank;                               //可申请的银行

//贷款业务员
-(void)loanLoginWithDic:(NSDictionary *)aDic;               //贷款业务员登录
-(void)loanNewClientsWithDic:(NSDictionary *)aDic;          //贷款新客户申请表
-(void)loanClientInfoWithDic:(NSDictionary *)aDic;          //贷款单个客户申请表
-(void)loanBuyApplicationWithDic:(NSDictionary *)aDic;      //贷款购买客户申请表
-(void)loanBuyersInfoWithDic:(NSDictionary *)aDic;          //已购买的客户申请表
-(void)loanBuyerDetailWithDic:(NSDictionary *)aDic;         //贷款已购买单个客户申请表详细
-(void)loanPayRecordWithDic:(NSDictionary *)aDic;           //贷款充值记录
-(void)loanDeletePayWithDic:(NSDictionary *)aDic;           //贷款充值记录删除
-(void)loanPasswordModifyWithDic:(NSDictionary *)aDic;      //修改密码
-(void)loanInfoModifyWithDic:(NSDictionary *)aDic;          //基本资料修改
-(void)loanDeleteClientWithDic:(NSDictionary *)aDic;        //贷款删除客户
-(void)loanPasswordBackWithDic:(NSDictionary *)aDic;        //找回密码
-(void)loanGetCity;                                         //贷款申请省市
-(void)loanStatisticWithDic:(NSDictionary *)aDic;               //数据统计
-(void)loanAdvisorWithDic:(NSDictionary *)aDic;                 //用户咨询

//信用卡业务员
-(void)cardLoginWithDic:(NSDictionary *)aDic;               //信用卡业务员登录
-(void)cardNewClientsWithDic:(NSDictionary *)aDic;          //信用卡新客户申请表
-(void)cardClientInfoWithDic:(NSDictionary *)aDic;          //信用卡单个客户申请表
-(void)cardBuyApplicationWithDic:(NSDictionary *)aDic;      //信用卡购买客户申请表
-(void)cardBuyersInfoWithDic:(NSDictionary *)aDic;          //已购买的客户申请表
-(void)cardBuyerDetailWithDic:(NSDictionary *)aDic;         //信用卡已购买单个客户申请表详细
-(void)cardPayRecordWithDic:(NSDictionary *)aDic;           //信用卡充值记录
-(void)cardDeletePayWithDic:(NSDictionary *)aDic;           //信用卡充值记录删除
-(void)cardPasswordModifyWithDic:(NSDictionary *)aDic;      //修改密码
-(void)cardInfoModifyWithDic:(NSDictionary *)aDic;          //基本资料修改
-(void)cardAreaSelectWithDic:(NSDictionary *)aDic;          //区域选择提交
-(void)cardAreaListWithDic:(NSDictionary *)aDic;            //业务员城市区域列表
-(void)cardDeleteClientWithDic:(NSDictionary *)aDic;        //信用卡删除客户
-(void)cardZTChangeWithDic:(NSDictionary *)aDic;            //已购买客户状态值修改
-(void)cardPasswordBackWithDic:(NSDictionary *)aDic;        //找回密码
-(void)cardStatisticWithDic:(NSDictionary *)aDic;               //数据统计

-(void)uploadImageWithParams:(NSArray *)paras;             //上传图片
@end
