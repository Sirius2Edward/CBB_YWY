//
//  Request_API.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-7.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "Request_API.h"
#import "SVProgressHUD.h"
#import "DataModel.h"

@implementation Request_API
{
    HTTP_Request *req;
}

+(Request_API *)shareInstance
{
    static Request_API *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Request_API alloc] init];
    });
    return instance;
}

-(id)init
{
    if (self = [super init]) {
        req = [[HTTP_Request alloc] init];
    }
    return self;
}

-(void)setDelegate:(id)delegate
{
    [self cancel];
    req.delegate = delegate;
}

-(void)cancel
{
    [req.queue cancelAllOperations];
}
#pragma mark - 业务员注册
//信用卡业务员注册
-(void)registerCardWithDic:(NSDictionary *)aDic
{
    [SVProgressHUD showWithMaskType:4];
    req.connectEnd = @selector(regEnd:);
    [req httpRequestWithAPI:REGISTER TypeID:1 Dictionary:aDic];
}
//贷款业务员注册
-(void)registerLoanWithDic:(NSDictionary *)aDic
{
    [SVProgressHUD showWithMaskType:4];
    req.connectEnd = @selector(regEnd:);
    [req httpRequestWithAPI:REGISTER TypeID:3 Dictionary:aDic];
}

//可申请的银行
-(void)registerValidatedBank
{
    req.connectEnd = @selector(getBank:);
    [req httpRequestWithAPI:REGISTER TypeID:2 Dictionary:nil];
}

#pragma mark - 贷款业务员
//贷款业务员登录
-(void)loanLoginWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(loginEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:1 Dictionary:aDic];
}

//贷款新客户申请表
-(void)loanNewClientsWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(newLoanClientEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:18 Dictionary:aDic];
}

//贷款单个客户申请表
-(void)loanClientInfoWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(loanNewDetail:);
    [req httpRequestWithAPI:LoanYWY TypeID:3 Dictionary:aDic];
}

//贷款购买客户申请表
-(void)loanBuyApplicationWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(buyClient:);
    [req httpRequestWithAPI:LoanYWY TypeID:4 Dictionary:aDic];
}

//已购买的客户申请表
-(void)loanBuyersInfoWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(doneLoanClientEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:5 Dictionary:aDic];
}

//贷款已购买单个客户申请表详细
-(void)loanBuyerDetailWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(loanBoughtDetail:);
    [req httpRequestWithAPI:LoanYWY TypeID:6 Dictionary:aDic];
}

//贷款充值记录
-(void)loanPayRecordWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(payRecordEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:7 Dictionary:aDic];
}

//贷款充值记录删除
-(void)loanDeletePayWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(delPayEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:8 Dictionary:aDic];
}

//修改密码
-(void)loanPasswordModifyWithDic:(NSDictionary *)aDic
{
    [SVProgressHUD showWithMaskType:4];
    req.connectEnd = nil;
    [req httpRequestWithAPI:LoanYWY TypeID:9 Dictionary:aDic];
}

//基本资料修改
-(void)loanInfoModifyWithDic:(NSDictionary *)aDic
{
    [SVProgressHUD showWithMaskType:4];
    req.connectEnd = nil;
    [req httpRequestWithAPI:LoanYWY TypeID:10 Dictionary:aDic];
}

//贷款删除客户
-(void)loanDeleteClientWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(delClient:);
    [req httpRequestWithAPI:LoanYWY TypeID:14 Dictionary:aDic];
}

//贷款密码找回
-(void)loanPasswordBackWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(connectEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:16 Dictionary:aDic];
}

//贷款申请省市
-(void)loanGetCity
{
    req.connectEnd = @selector(getCitys:);
    [req httpRequestWithAPI:LoanREG TypeID:1 Dictionary:nil];
}
//数据统计
-(void)loanStatisticWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(statisticEnd:);
    [req httpRequestWithURL:SeveletURL API:@"DkServlet" TypeID:1 Dictionary:aDic];
}

//用户咨询
-(void)loanAdvisorWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(advisorEnd:);
    [req httpRequestWithURL:SeveletURL API:@"LoanslyServlet" TypeID:1 Dictionary:aDic];
}

//已回复咨询
-(void)loanRepliedAdvisorWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(advisorEnd:);
    [req httpRequestWithURL:SeveletURL API:@"LoanslyReServlet" TypeID:1 Dictionary:aDic];
}

//删除咨询
-(void)loanDelAdvisorWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(delAdvEnd:);
    [req httpRequestWithURL:SeveletURL API:@"DeleteLoanslyServlet" TypeID:1 Dictionary:aDic];
}

//回复未回复咨询
-(void)loanFirstReplyWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(replyEnd:);
    [req httpRequestWithURL:SeveletURL API:@"ReplyLoanslyServlet" TypeID:1 Dictionary:aDic];
}

//回复已回复咨询
-(void)loanAgainReplyWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(replyEnd:);
    [req httpRequestWithURL:SeveletURL API:@"AgainReplyLoanslyServlet" TypeID:1 Dictionary:aDic];
}

//第一次购买
-(void)loanUpdateFirstBuy
{
    UserInfo *userinfo = [UserInfo shareInstance];
    req.connectEnd = @selector(firstBuyEnd:);
    [req httpRequestWithURL:SeveletURL API:@"DkUpdateServlet" TypeID:1 Dictionary:@{@"username":userinfo.username,@"password":userinfo.password}];
}

//对我店铺申请表
-(void)loanForMyShopWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(forMeClientEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:17 Dictionary:aDic];
}

//对我产品申请表
-(void)loanForMyProductWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(forMeClientEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:19 Dictionary:aDic];
}

//购买对我申请的表单
-(void)loanBuyForMeFormWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(buyEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:20 Dictionary:aDic];
}

//删除对我申请的表单
-(void)loanDeleteForMeFormWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(deleteEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:21 Dictionary:aDic];
}

//已购买客户状态值修改
-(void)loanZTChangeWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(ztChangeEnd:);
    [req httpRequestWithAPI:LoanYWY TypeID:15 Dictionary:aDic];
}

#pragma mark - 信用卡业务员
//信用卡业务员登录
-(void)cardLoginWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(loginEnd:);
    [req httpRequestWithAPI:CardYWY TypeID:1 Dictionary:aDic];
}

//信用卡新客户申请表
-(void)cardNewClientsWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(newCardClientEnd:);
    [req httpRequestWithAPI:CardYWY TypeID:2 Dictionary:aDic];
}

//信用卡单个客户申请表
-(void)cardClientInfoWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(cardNewDetail:);
    [req httpRequestWithAPI:CardYWY TypeID:3 Dictionary:aDic];
}

//信用卡购买客户申请表
-(void)cardBuyApplicationWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(buyClient:);
    [req httpRequestWithAPI:CardYWY TypeID:4 Dictionary:aDic];
}

//已购买的客户申请表
-(void)cardBuyersInfoWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(doneCardClientEnd:);
    [req httpRequestWithAPI:CardYWY TypeID:5 Dictionary:aDic];
}

//信用卡已购买单个客户申请表详细
-(void)cardBuyerDetailWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(cardBoughtDetail:);
    [req httpRequestWithAPI:CardYWY TypeID:6 Dictionary:aDic];
}

//信用卡充值记录
-(void)cardPayRecordWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(payRecordEnd:);
    [req httpRequestWithAPI:CardYWY TypeID:7 Dictionary:aDic];
}

//信用卡充值记录删除
-(void)cardDeletePayWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(delPayEnd:);
    [req httpRequestWithAPI:CardYWY TypeID:8 Dictionary:aDic];
}

//修改密码
-(void)cardPasswordModifyWithDic:(NSDictionary *)aDic
{
    [SVProgressHUD showWithMaskType:4];
    req.connectEnd = nil;
    [req httpRequestWithAPI:CardYWY TypeID:9 Dictionary:aDic];
}

//基本资料修改
-(void)cardInfoModifyWithDic:(NSDictionary *)aDic
{
    [SVProgressHUD showWithMaskType:4];
    req.connectEnd = nil;
    [req httpRequestWithAPI:CardYWY TypeID:10 Dictionary:aDic];
}

//城市区域列表
-(void)cardAreaListWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(areaListEnd:);
    [req httpRequestWithAPI:CardYWY TypeID:11 Dictionary:aDic];
}

//区域选择提交参数
-(void)cardAreaSelectWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(areaCommitEnd:);
    [req httpRequestWithAPI:CardYWY TypeID:12 Dictionary:aDic];
}

//信用卡删除客户
-(void)cardDeleteClientWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(delClient:);
    [req httpRequestWithAPI:CardYWY TypeID:14 Dictionary:aDic];
}

//已购买客户状态值修改
-(void)cardZTChangeWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(ztChangeEnd:);
    [req httpRequestWithAPI:CardYWY TypeID:15 Dictionary:aDic];
}

//信用卡找回密码
-(void)cardPasswordBackWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(connectEnd:);
    [req httpRequestWithAPI:CardYWY TypeID:16 Dictionary:aDic];
}

//信用卡业务员 业务量数据统计
-(void)cardStatisticWithDic:(NSDictionary *)aDic
{
    req.connectEnd = @selector(statisticEnd:);
    [req httpRequestWithURL:SeveletURL API:@"XYKServlet" TypeID:1 Dictionary:aDic];
}

//第一次购买
-(void)cardUpdateFirstBuy
{
    UserInfo *userinfo = [UserInfo shareInstance];
    req.connectEnd = @selector(firstBuyEnd:);
    [req httpRequestWithURL:SeveletURL API:@"XYKUpdateServlet" TypeID:1 Dictionary:@{@"username":userinfo.username,@"password":userinfo.password}];
}
#pragma mark -
//上传图片
-(void)uploadImageWithParams:(NSArray *)paras
{
    req.connectEnd = @selector(uploadEnd:);
    [req postSOAPwithAPI:@"http://upload.cardbaobao.com/" File:@"Service" Method:@"FileUploadImage" xmlNS:@"http://tempuri.org/" Params:paras];
}
@end
