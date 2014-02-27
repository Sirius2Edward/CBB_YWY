//
//  PARSEDeleteLoanslyServlet1.m
//  CBB
//
//  Created by 卡宝宝 on 14-2-27.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "PARSEDeleteLoanslyServlet1.h"
#import "SVProgressHUD.h"

@implementation PARSEDeleteLoanslyServlet1
-(id)superParser
{
    if (nil == self.parserString) {
        [SVProgressHUD showErrorWithStatus:@"获取不到统计数据！" duration:0.789f];
        return nil;
    }
    if ([self.parserString isEqualToString:@"SUCCESS"]) {
        
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"删除咨询失败！" duration:0.789f];
        return nil;
    }
    return self.parseredDic;
}

@end
