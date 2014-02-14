//
//  PARSEuserlogin.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-16.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEuserlogin.h"

@implementation PARSEuserlogin
-(id)parser:(GDataXMLElement *)aElement
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    UserInfo *info = [UserInfo shareInstance];
    for (GDataXMLElement *e in aElement.children) {
        if ([e.name isEqualToString:@"id"]) {
            info.ID = e.stringValue;
        }
        else if ([e.name isEqualToString:@"user"]) {
            info.username = e.stringValue;
        }
        else {
            [mDic setObject:e.stringValue forKey:e.name];
        }
    }
    [self.parseredDic setValue:mDic forKey:@"result"];
    return self.parseredDic;
}
@end
