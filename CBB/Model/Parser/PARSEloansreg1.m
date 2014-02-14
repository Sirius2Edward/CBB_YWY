//
//  PARSEloansreg1.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-22.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEloansreg1.h"

@implementation PARSEloansreg1
-(id)parser:(GDataXMLElement *)aElement
{
    GDataXMLNode *info = [[aElement nodesForXPath:@"//Sheng" error:nil] objectAtIndex:0];
    NSArray *infoArr = info.children;
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    for (int i = 0;i < infoArr.count/2; i++) {
        GDataXMLElement *sheng = [infoArr objectAtIndex:i*2];
        GDataXMLElement *citys = [infoArr objectAtIndex:i*2 +1];
        
        
        NSString *sName = nil;
        NSString *sID = nil;
        for (GDataXMLNode *node in sheng.attributes) {
            if ([node.name isEqualToString:@"ShengId"]) {
                sID = node.stringValue;
            }
            if ([node.name isEqualToString:@"ShengName"]) {
                sName = node.stringValue;
            }
        }
        
        NSMutableDictionary *citysDic = [NSMutableDictionary dictionary];
        for (GDataXMLElement *e in citys.children) {
            NSString *key = nil;
            NSString *value = nil;
            for (GDataXMLNode *city in e.attributes) {
                if ([city.name isEqualToString:@"CityId"]) {
                    value = city.stringValue;
                }
                if ([city.name isEqualToString:@"CityName"]) {
                    key = city.stringValue;
                }
            }
            [citysDic setObject:value forKey:key];
        }
        [mDic setObject:[NSArray arrayWithObjects:sID,citysDic, nil] forKey:sName];
     }
    [self.parseredDic setValue:mDic forKey:@"citys"];
    return self.parseredDic;
}
@end
