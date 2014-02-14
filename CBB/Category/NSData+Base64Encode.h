//
//  NSData+Base64Encode.h
//  CBB
//
//  Created by 卡宝宝 on 13-10-9.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64Encode)
+ (id)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64Encoding;
@end
