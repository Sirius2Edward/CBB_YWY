//
//  PARSEcarduserlogin4.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-14.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEcarduserlogin4.h"

@implementation PARSEcarduserlogin4
-(id)parser:(GDataXMLElement *)aElement
{
    GDataXMLNode *info = [[aElement nodesForXPath:@"//info" error:nil] objectAtIndex:0];
    [self.parseredDic setObject:info.stringValue forKey:@"result"];
    return self.parseredDic;
}
@end
