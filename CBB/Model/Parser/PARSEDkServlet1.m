//
//  DKServelet1.m
//  CBB
//
//  Created by 卡宝宝 on 14-2-25.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "PARSEDkServlet1.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"

@implementation PARSEDkServlet1
-(id)superParser
{
    if (nil == self.parserString) {
        [SVProgressHUD showErrorWithStatus:@"获取不到统计数据！" duration:0.789f];
        return nil;
    }
    NSArray *arr = [self.parserString objectFromJSONString];
    NSDictionary *dic = [arr objectAtIndex:0];
    
    [self.parseredDic setObject:dic forKey:@"result"];
    return self.parseredDic;
}
@end
