//
//  PARSEServiceFileUploadImage.m
//  CBB
//
//  Created by 卡宝宝 on 13-9-26.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PARSEServiceFileUploadImage.h"
#import "SVProgressHUD.h"
@implementation PARSEServiceFileUploadImage
-(id)parser:(GDataXMLElement *)aElement
{
    if ([aElement.stringValue isEqualToString:@"true"]) {
        [SVProgressHUD showSuccessWithStatus:@"上传成功！" duration:1.5f];
    }
    return nil;
}
@end
