//
//  PARSEXYKServlet1.m
//  CBB
//
//  Created by 卡宝宝 on 14-2-20.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "PARSEXYKServlet1.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"


@implementation PARSEXYKServlet1
@synthesize parseredDic;
@synthesize parserString;

-(id)initWithStr:(NSString *)aStr
{
    if (self = [super init])
    {
        self.parserString = aStr;
        self.parseredDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(id)superParser
{
//    NSLog(@"------Parse JSON--------------------");
//    NSLog(@"str = %@",self.parserString);
    
    if (nil == self.parserString) {
        [SVProgressHUD showErrorWithStatus:@"获取不到统计数据！" duration:1.5f];
        return nil;
    }
    NSArray *arr = [self.parserString objectFromJSONString];
//    NSLog(@"Arr = %@",arr);
    NSDictionary *dic = [arr objectAtIndex:0];
//    NSLog(@"Dic = %@",dic);
    
    [self.parseredDic setObject:dic forKey:@"result"];
    return self.parseredDic;
}
@end
