//
//  ListButton.m
//  ListButton
//
//  Created by 卡宝宝 on 13-8-20.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "ListButton.h"

@implementation ListButton
{
    UILabel *titleLabel;
    UIImageView *triangle;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.93;
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"已购买客户";        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.shadowColor = [UIColor grayColor];
        titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:titleLabel];
        
        CGSize size = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}];
        triangle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle.png"]];
        titleLabel.frame = CGRectMake(0, 0, 141, 44);
        triangle.frame = CGRectMake(75.5+size.width/2, 20, 11.5, 8);
        [self addSubview:triangle];
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}];
    titleLabel.text = title;
    triangle.frame = CGRectMake(75.5+size.width/2, 20, 11.5, 8);
}

-(NSString *)title
{
    return titleLabel.text;
}

@end

@implementation ListView
{
    UIButton *selectButton;
    UIView *content;
}
@synthesize delegate;
@synthesize isShow;
- (id)initWithStat:(NSArray *)stats
{
    self = [super init];
    if (self) {
        self.image = [UIImage imageNamed:@"xyk_tab01.png"];
        self.userInteractionEnabled = YES;
        
        content = [[UIView alloc] init];
        [self addSubview:content];
        content.hidden = YES;
        
        CGFloat y = 0;
        for (int i = 0; i < stats.count; i++) {
            y = 7 + i*27;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"xyk_tab02.png"] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"xyk_tab02.png"] forState:UIControlStateHighlighted];
            btn.tag = 1300 + i;
            [btn setTitle:[stats objectAtIndex:i] forState:0];
            [btn setTitleColor:[UIColor blackColor] forState:0];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.titleLabel.textColor = [UIColor blackColor];
            btn.frame = CGRectMake(12, y, 124, 29);
            [btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
            [content addSubview:btn];
        }
        content.frame = CGRectMake(0, 0, 148, y+30);
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

-(void)showList
{
    [UIView animateWithDuration:0.23 animations:^{
        self.frame = CGRectMake(90, 0, 148, 230);
        self.alpha = 0.9;
    } completion:^(BOOL finished) {
        content.hidden = NO;
    }];
    self.isShow = YES;
}

-(void)selectItem:(UIButton *)sender
{
    selectButton.selected = NO;
    selectButton = sender;
    selectButton.selected = YES;
//    关闭ListView
    [self closeList];
//    设置title
    [self.delegate changeTitleAndSift:[sender titleForState:0]];
}

-(void)closeList
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(90, 0, 148, 0);
        self.alpha = 0;
    } completion:nil];
    content.hidden = YES;
    self.isShow = NO;
}

@end
