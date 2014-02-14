//
//  PARSEloansuserlogin7.m
//  CBB
//
//  Created by 卡宝宝 on 13-9-10.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEloansuserlogin7.h"

@implementation PARSEloansuserlogin7
-(id)parser:(GDataXMLElement *)aElement
{
    NSArray *itemsArr = [aElement nodesForXPath:@"//Pay/Item" error:nil];
    NSMutableArray *mArr = [NSMutableArray array];
    for (GDataXMLElement *element in itemsArr) {
        PayRecord *item = [[PayRecord alloc] init];
        for (GDataXMLNode *node in element.attributes) {
            [item setValue:node.stringValue forKey:node.name];
        }
        [mArr addObject:item];
    }
    [self.parseredDic setObject:mArr forKey:@"UL"];
    return self.parseredDic;
}
@end
