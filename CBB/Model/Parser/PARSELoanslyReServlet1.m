//
//  PARSELoanslyReServlet1.m
//  CBB
//
//  Created by 卡宝宝 on 14-2-26.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "PARSELoanslyReServlet1.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"
#import "DataModel.h"

@implementation PARSELoanslyReServlet1
-(id)superParser
{
    if (nil == self.parserString) {
        [SVProgressHUD showErrorWithStatus:@"获取不到统计数据！" duration:0.789f];
        return nil;
    }
    NSArray *arr = [self.parserString objectFromJSONString];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *d in arr) {
        Advisor *adv = [Advisor new];
        adv.ID      = [d objectForKey:@"id"];
        adv.loansID = [d objectForKey:@"loansid"];
        adv.content = [[d objectForKey:@"lycontent"] stringByRemovingPercentEncoding];
        adv.uname   = [[d objectForKey:@"uname"] stringByRemovingPercentEncoding];
        adv.addDate = [d objectForKey:@"adddate"];
        adv.reDate  = [d objectForKey:@"redate"];
        adv.see     = [d objectForKey:@"see"];
        adv.resee   = [d objectForKey:@"resee"];
        NSMutableArray *replies = [NSMutableArray array];
        for (NSDictionary *re in [d objectForKey:@"list"]) {
            Reply *reply = [Reply new];
            reply.content = [[re objectForKey:@"content"] stringByRemovingPercentEncoding];
            reply.date = [re objectForKey:@"date"];
            [replies addObject:reply];
        }
        adv.replyList= replies;
        [mArr addObject:adv];
    }
    if (arr.count) {
        [self.parseredDic setObject:mArr forKey:@"list"];
        NSString *pageTotal = [[arr objectAtIndex:0] objectForKey:@"pageTotal"];
        [self.parseredDic setObject:pageTotal forKey:@"pageTotal"];
    }
    return self.parseredDic;
}
@end
