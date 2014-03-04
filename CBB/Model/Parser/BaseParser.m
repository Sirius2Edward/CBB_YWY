//
//  BaseParser.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-7.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "BaseParser.h"

@implementation BaseParser
@synthesize parserString = _parserString;
@synthesize parseredDic = _parseredDic;

-(id)initWithStr:(NSString *)aStr
{
    if (self = [super init])
    {
        self.parserString = aStr;
        self.parseredDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(id)superParser
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:self.parserString options:0 error:nil];
    
    GDataXMLElement *root = doc.rootElement;
    
    if ([root.name isEqualToString:@"ReturnInfo"])
    {
        NSArray *statusArr = [root nodesForXPath:@"//zt" error:nil];
        GDataXMLNode *status = [statusArr objectAtIndex:0];
        //错误提示
        if (!status.stringValue.integerValue) {
            GDataXMLNode *errorInfo = [[root nodesForXPath:@"//info" error:nil] objectAtIndex:0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorInfo.stringValue delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
            return nil;
        }
        else {
//            GDataXMLNode *successInfo = [[root nodesForXPath:@"//info" error:nil] objectAtIndex:0];
//            NSLog(@"\n\nInfo  ===== %@",successInfo.stringValue);
        }
    }
    
    //表单页数
    NSArray *pageArr = [root nodesForXPath:@"//Pages/Items" error:nil];
    if (!pageArr.count)
    {
        pageArr = [root nodesForXPath:@"//Pages/Item" error:nil];
        
    }
    if (pageArr.count) {
        GDataXMLElement *pageInfo = [pageArr objectAtIndex:0];
        for (GDataXMLNode *node in pageInfo.attributes) {
            [self.parseredDic setObject:node.stringValue forKey:node.name];
        }
    }

    return [self parser:root];
}

// 虚函数
-(id)parser:(GDataXMLElement *)aElement
{
    return nil;
}

@end
