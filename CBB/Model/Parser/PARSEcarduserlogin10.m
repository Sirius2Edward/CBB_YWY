//
//  PARSEcarduserlogin10.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-23.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEcarduserlogin10.h"

@implementation PARSEcarduserlogin10
-(id)parser:(GDataXMLElement *)aElement
{
    GDataXMLNode *info = [[aElement nodesForXPath:@"//info" error:nil] objectAtIndex:0];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:info.stringValue delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
    return self.parseredDic;
}
@end
