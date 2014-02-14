//
//  SingleSelectControl.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-8.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleSelectControl : UIView
- (id)initWithArray:(NSArray *)array;
@property(nonatomic,retain)NSArray *selectArray;
@property(nonatomic,assign)NSInteger selectIndex;
@end
