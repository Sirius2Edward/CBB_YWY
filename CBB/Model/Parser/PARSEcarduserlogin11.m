//
//  PARSEcarduserlogin11.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-20.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEcarduserlogin11.h"

@implementation PARSEcarduserlogin11
-(id)parser:(GDataXMLElement *)aElement
{
    NSArray *itemsArr = [aElement nodesForXPath:@"//Item" error:nil];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    for (GDataXMLElement *element in itemsArr) {
        NSString *key = nil;
        NSString *value = nil;
        for (GDataXMLNode *node in element.attributes) {
            if ([node.name isEqualToString:@"ID"]) {
                value = node.stringValue;
            }
            else {
                key = node.stringValue;
            }
        }
        [mDic setObject:value forKey:key];
    }
    [self.parseredDic setObject:mDic forKey:@"QL"];
    return self.parseredDic;
}
@end
