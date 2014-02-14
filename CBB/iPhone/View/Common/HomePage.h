//
//  HomePage.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-12.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePage : UIViewController
@property(nonatomic,assign)NSInteger businessType;
@property(nonatomic,retain)NSMutableDictionary *appClientData;
@property(nonatomic,retain)NSMutableDictionary *doneClientData;
@end
