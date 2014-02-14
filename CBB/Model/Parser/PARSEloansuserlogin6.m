//
//  PARSEloansuserlogin6.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-14.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEloansuserlogin6.h"

@implementation PARSEloansuserlogin6
-(id)parser:(GDataXMLElement *)aElement
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    GDataXMLElement *detail = [[aElement nodesForXPath:@"//UserInfo" error:nil] objectAtIndex:0];
    for (GDataXMLElement *e in detail.children) {
        [mDic setObject:e.stringValue forKey:e.name];
    }
    [self.parseredDic setObject:mDic forKey:@"result"];
    return self.parseredDic;
}
@end
