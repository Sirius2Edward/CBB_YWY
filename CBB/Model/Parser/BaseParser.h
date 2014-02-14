//
//  BaseParser.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-7.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "DataModel.h"
@interface BaseParser : NSObject
{
    NSString *_parserString;
    NSMutableDictionary *_parseredDic;
}

@property(nonatomic,retain) NSString *parserString;
@property(nonatomic,retain) NSMutableDictionary *parseredDic;

-(id)initWithStr:(NSString *)aStr;
-(id)superParser;
-(id)parser:(GDataXMLElement *)aElement;
@end
