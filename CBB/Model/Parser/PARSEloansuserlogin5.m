//
//  PARSEloansuserlogin5.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-14.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEloansuserlogin5.h"

@implementation PARSEloansuserlogin5
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
    
    NSArray *ztArr = [aElement nodesForXPath:@"//zts/zt" error:nil];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    for (GDataXMLElement *e in ztArr) {
        NSString *key = nil;
        NSString *value = nil;
        for (GDataXMLNode *node in e.attributes) {
            if ([node.name isEqualToString:@"value"]) {
                value = node.stringValue;
            }
            if ([node.name isEqualToString:@"name"]) {
                key = node.stringValue;
            }
        }
        [mDic setObject:value forKey:key];
    }
    [self.parseredDic setValue:mDic forKey:@"ZTS"];
    return self.parseredDic;
}
@end
