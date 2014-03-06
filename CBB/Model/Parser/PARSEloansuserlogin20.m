//
//  PARSEloansuserlogin20.m
//  CBB
//
//  Created by 卡宝宝 on 14-3-6.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "PARSEloansuserlogin20.h"

@implementation PARSEloansuserlogin20
-(id)parser:(GDataXMLElement *)aElement
{
    GDataXMLNode *info = [[aElement nodesForXPath:@"//info" error:nil] objectAtIndex:0];
    [self.parseredDic setObject:info.stringValue forKey:@"result"];
    return self.parseredDic;
}
@end
