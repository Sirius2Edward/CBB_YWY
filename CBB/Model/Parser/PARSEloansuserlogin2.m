//
//  PARSEloansuserlogin2.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-14.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEloansuserlogin2.h"

@implementation PARSEloansuserlogin2
-(id)parser:(GDataXMLElement *)aElement
{
    NSArray *itemsArr = [aElement nodesForXPath:@"//Item" error:nil];
    NSMutableArray *mArr = [NSMutableArray array];
    for (GDataXMLNode *node in itemsArr) {
        LoanClient *client = [[LoanClient alloc] init];
        for (GDataXMLElement *element in node.children) {
            [client setValue:element.stringValue forKey:element.name];
        }
        [mArr addObject:client];
    }
    [self.parseredDic setObject:mArr forKey:@"UL"];
    return self.parseredDic;
}
@end
