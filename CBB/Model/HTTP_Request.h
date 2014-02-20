//
//  HTTP_Request.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-6.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"

@interface HTTP_Request : NSObject
{
    NSMutableString *url;
    NSString *CBB;
    NSString *KEY;
}

#define STATE (1)   // 0为测试，1为正式
@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)ASINetworkQueue *queue;  //网络请求队列
@property(nonatomic,retain)NSDictionary *response;  //响应结果字段
@property(nonatomic,assign)SEL connectEnd;          //请求完成时执行函数
@property(nonatomic,assign)SEL connectFailded;      //请求失败时执行函数
-(void)httpRequestWithAPI:(NSString *)api TypeID:(NSInteger)typeID Dictionary:(NSDictionary *)aDic;
-(void)httpRequestWithURL:(NSString *)aUrl API:(NSString *)api TypeID:(NSInteger)typeID Dictionary:(NSDictionary *)aDic;
-(void)postSOAPwithAPI:(NSString *)api File:(NSString *)file Method:(NSString *)method xmlNS:(NSString *)xmlns Params:(NSArray *)params;
@end
