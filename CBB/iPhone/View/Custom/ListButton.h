//
//  ListButton.h
//  ListButton
//
//  Created by 卡宝宝 on 13-8-20.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListDelegate <NSObject>
-(void)changeTitleAndSift:(NSString *)title;
@end

@interface ListButton : UIControl
@property(nonatomic,retain)NSString *title;
@end

@interface ListView : UIImageView
@property(nonatomic,assign)id<ListDelegate> delegate;
@property(nonatomic,assign)BOOL isShow;
- (id)initWithStat:(NSArray *)stats;
-(void)showList;
-(void)closeList;
@end