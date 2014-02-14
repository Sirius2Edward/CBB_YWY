//
//  CustomLabel.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-12.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel
@property(nonatomic,retain)UIImage *backgroundImage;
@property(nonatomic,assign)UIEdgeInsets insets;
@end

@interface TouchLabel : UILabel
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end

@interface KeyWordLabel : UILabel
-(void)setText:(NSString *)text WithFont:(UIFont *)font AndColor:(UIColor *)color;//设置文本及字体颜色
-(void)setKeywordLight:(NSString *)keyword WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor;//设置关键字位置及字体颜色
@end

@interface DetailLabel : UIView
@property(nonatomic,retain)NSString *titleStr;
@property(nonatomic,retain)NSString *contentStr;
@property(nonatomic,retain)UIImage *backgroundImage;
@end