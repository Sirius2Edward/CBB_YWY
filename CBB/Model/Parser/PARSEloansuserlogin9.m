//
//  PARSEloansuserlogin9.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-26.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEloansuserlogin9.h"
#import "SVProgressHUD.h"
@implementation PARSEloansuserlogin9
-(id)parser:(GDataXMLElement *)aElement
{
    GDataXMLNode *info = [[aElement nodesForXPath:@"//info" error:nil] objectAtIndex:0];
    [SVProgressHUD showSuccessWithStatus:info.stringValue duration:1.0f];
    [self.parseredDic setObject:info.stringValue forKey:@"result"];
    return self.parseredDic;
}
@end
