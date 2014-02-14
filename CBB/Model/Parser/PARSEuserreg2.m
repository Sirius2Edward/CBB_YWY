//
//  PARSEuserreg2.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-15.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEuserreg2.h"

@implementation PARSEuserreg2
-(id)parser:(GDataXMLElement *)aElement
{
    NSArray *banks = [aElement nodesForXPath:@"//Item" error:nil];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    for (GDataXMLElement *e in banks) {
        NSString *key = nil;
        NSString *value = nil;
        for (GDataXMLNode *node in e.attributes) {
            if ([node.name isEqualToString:@"BankID"]) {
                value = node.stringValue;
            }
            if ([node.name isEqualToString:@"Bankname"]) {
                key = node.stringValue;
            }        
        }
        [mDic setObject:value forKey:key];        
    }
    [self.parseredDic setValue:mDic forKey:@"banks"];
    return self.parseredDic;
}
@end
