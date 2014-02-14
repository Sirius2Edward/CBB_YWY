//
//  PARSEloansuserlogin16.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-21.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEloansuserlogin16.h"

@implementation PARSEloansuserlogin16
-(id)parser:(GDataXMLElement *)aElement
{
    GDataXMLNode *info = [[aElement nodesForXPath:@"//info" error:nil] objectAtIndex:0];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:info.stringValue delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [alert show];
    
    NSArray *arr = [aElement nodesForXPath:@"//code" error:nil];
    if (arr.count) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        GDataXMLNode *code = [arr objectAtIndex:0];
        [mDic setObject:code.stringValue forKey:code.name];
        GDataXMLNode *newpwd = [[aElement nodesForXPath:@"//newpwd" error:nil] objectAtIndex:0];
        [mDic setObject:newpwd.stringValue forKey:newpwd.name];
        [self.parseredDic setObject:mDic forKey:@"result"];
    }
    return self.parseredDic;
}
@end
