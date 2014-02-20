//
//  PARSEXYKServlet1.h
//  CBB
//
//  Created by 卡宝宝 on 14-2-20.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PARSEXYKServlet1 : NSObject
@property(nonatomic,retain) NSString *parserString;
@property(nonatomic,retain) NSMutableDictionary *parseredDic;

-(id)initWithStr:(NSString *)aStr;
-(id)superParser;
@end
