//
//  ClientDetail.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-16.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "ClientDetail.h"
#import "DataModel.h"
#import "Request_API.h"
#import "CustomLabel.h"
#import "LoanClientTable.h"
#import "CardClientTable.h"

@implementation ClientDetail
@synthesize scrollView;
@synthesize detailInfo;
- (void)loadView
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    //返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backBarButton.frame = CGRectMake(0, 0, 51, 33);
    [backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    self.title = @"查看详情";
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-66)];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    [self.view addSubview:self.scrollView];
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

#pragma mark -
@implementation NewCardClientDetail
@synthesize cell;
@synthesize uid;
- (void)loadView
{
    [super loadView];
    //购买按钮
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setBackgroundImage:[UIImage imageNamed:@"right_btn.png"] forState:0];
    [barButton setTitle:@"购买" forState:0];
    barButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    [barButton sizeToFit];
    [barButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    NSArray *keys = [NSArray arrayWithObjects:@"Orderid",@"CardName",@"RadBankA",@"cbodata",@"pingfengs",@"years",@"usersex",
                     @"RadEdu",@"RadHomeA",@"txtWordkE",@"DropScore",@"txtWordkF",@"hukou",@"RadCar",@"DropWorkA",@"DropWorkC",
                     @"bhcx",@"RadWorkD",@"DropWorkB",@"RadBankB",@"email", nil];
    CGRect rect;
    CGFloat y = 10;

    for (int i = 0; i < keys.count; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSArray *textArr = nil;
        if ([key isEqualToString:@"cbodata"] || [key isEqualToString:@"RadHomeA"]) {
            NSString *text = [self.detailInfo objectForKey:key];
            textArr = [NSArray arrayWithObjects:[text substringToIndex:4],[text substringFromIndex:5], nil];
        }
        else {
            textArr = [[self.detailInfo objectForKey:key] componentsSeparatedByString:@":"];
        }
        DetailLabel *label = [[DetailLabel alloc] init];
        label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
        label.contentStr = [textArr objectAtIndex:1];
        if (i == 0) {
            label.backgroundImage = [UIImage imageNamed:@"detail1.png"];
            rect = CGRectMake(7, y, 306, 42);
            y += 42;
        }
        else if (i == keys.count-1) {
            label.backgroundImage = [UIImage imageNamed:@"x_6.png"];
            rect = CGRectMake(7, y, 306, 40);
        }
        else {
            UIImage *img = [UIImage imageNamed:@"detail3.png"];
            label.backgroundImage = img;
            CGSize size = [[textArr objectAtIndex:1] sizeWithFont:[UIFont systemFontOfSize:14]];
            if ([[textArr objectAtIndex:0] length] > 6 || size.width > 200) {
                rect = CGRectMake(7, y, 306, 50);
                y += 50;
            }
            else {
                rect = CGRectMake(7, y, 306, 33);
                y += 33;
            }
        }
        label.frame = rect;
        [self.scrollView addSubview:label];
    }
    self.scrollView.contentSize = CGSizeMake(320, y+50);
}

//购买
-(void)buyAction
{
    [self.cell performSelector:@selector(buyAction) withObject:nil];
}
@end

#pragma mark -
@implementation DoneCardClientDetail
- (void)loadView
{
    [super loadView];
    NSArray *keys = [NSArray arrayWithObjects: @"Orderid",@"txtName",@"years",@"usersex",@"RadEdu",@"pingfengs",@"mobile",@"tel",
                    @"email",@"hukou",@"CardName",@"RadBankA",@"RadBankB",@"bhcx",@"RadHomeA",@"txtWordkE",@"txtWordkF",
                     @"RadWorkD",@"DropWorkA",@"DropWorkB",@"DropWorkC",@"DropScore",@"RadCar",@"cbodata", nil];
    
    CGRect rect;
    CGFloat y = 10;
    
    for (int i = 0; i < keys.count; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSArray *textArr = nil;
        if ([key isEqualToString:@"cbodata"] || [key isEqualToString:@"RadHomeA"]) {
            NSString *text = [self.detailInfo objectForKey:key];
            textArr = [NSArray arrayWithObjects:[text substringToIndex:4],[text substringFromIndex:5], nil];
        }
        else {
            textArr = [[self.detailInfo objectForKey:key] componentsSeparatedByString:@":"];
        }
        DetailLabel *label = [[DetailLabel alloc] init];
        label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
        label.contentStr = [textArr objectAtIndex:1];
        if (i == 0) {
            label.backgroundImage = [UIImage imageNamed:@"detail1.png"];
            rect = CGRectMake(7, y, 306, 42);
            y += 42;
        }
        else if (i == keys.count-1) {
            label.backgroundImage = [UIImage imageNamed:@"x_6.png"];
            rect = CGRectMake(7, y, 306, 40);
        }
        else {
            UIImage *img = [UIImage imageNamed:@"detail3.png"];
            label.backgroundImage = img;
            CGSize size = [[textArr objectAtIndex:1] sizeWithFont:[UIFont systemFontOfSize:14]];
            if ([[textArr objectAtIndex:0] length] > 6 || size.width > 200) {
                rect = CGRectMake(7, y, 306, 50);
                y += 50;
            }
            else {
                rect = CGRectMake(7, y, 306, 33);
                y += 33;
            }
        }
        label.frame = rect;
        [self.scrollView addSubview:label];
    }
    self.scrollView.contentSize = CGSizeMake(320, y + 50);
}
@end
#pragma mark -
@implementation NewLoanClientDetail
@synthesize cell;
@synthesize uid;
- (void)loadView
{
    [super loadView];
    //购买按钮    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setBackgroundImage:[UIImage imageNamed:@"right_btn.png"] forState:0];
    [barButton setTitle:@"购买" forState:0];
    barButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    [barButton sizeToFit];
    [barButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    NSArray *keys = [NSArray arrayWithObjects: @"Orderid",@"truename",@"yearmonth",@"usersex",@"RadBankA",
                     @"worktype",@"pdy",@"loanmoney",@"loansrt",@"house",@"cards",@"monthincome",@"moneyin",
                     @"mobile",@"email",@"buylist",@"contact", nil];
    
    CGRect rect;
    CGFloat y = 10;
    
    for (int i = 0; i < keys.count; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSArray *textArr = nil;
        if ([key isEqualToString:@"loansrt"]) {
            textArr = [NSArray arrayWithObjects:@"贷款用途",[self.detailInfo objectForKey:key], nil];
        }
        else if ([key isEqualToString:@"buylist"]) {
            NSString *text = [self.detailInfo objectForKey:key];
            textArr = [NSArray arrayWithObjects:[text substringToIndex:4],[text substringFromIndex:5], nil];
        }
        else {
            textArr = [[self.detailInfo objectForKey:key] componentsSeparatedByString:@":"];
        }
        DetailLabel *label = [[DetailLabel alloc] init];
        if (i == 0) {
            label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
            label.contentStr = [textArr objectAtIndex:1];
            label.backgroundImage = [UIImage imageNamed:@"detail1.png"];
            rect = CGRectMake(7, y, 306, 42);
            y += 42;
        }
        else if (i == keys.count-2) {
            NSArray *buylist = [[textArr objectAtIndex:1] componentsSeparatedByString:@";"];
            if (!buylist.count) {
                label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
                label.contentStr = @"无";
            }
            else {
                for (int j = 0; j < buylist.count - 1; j++) {
                    DetailLabel *buyLabel = [[DetailLabel alloc] init];
                    if (j == 0) {
                        buyLabel.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
                    }
                    else {
                        buyLabel.titleStr = @"";
                    }
                    buyLabel.contentStr = [buylist objectAtIndex:j];
                    buyLabel.backgroundImage = [UIImage imageNamed:@"detail2.png"];
                    rect = CGRectMake(7, y, 306, 20);
                    y += 20;
                    buyLabel.frame = rect;
                    [self.scrollView addSubview:buyLabel];
                }
            }
        }
        else if (i == keys.count-1) {
            label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
            label.contentStr = [textArr objectAtIndex:1];
            label.backgroundImage = [UIImage imageNamed:@"x_6.png"];
            rect = CGRectMake(7, y, 306, 49);
            y += 50;
        }
        else {
            label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
            label.contentStr = [textArr objectAtIndex:1];
            UIImage *img = [UIImage imageNamed:@"detail3.png"];
            label.backgroundImage = img;
            CGSize size = [[textArr objectAtIndex:1] sizeWithFont:[UIFont systemFontOfSize:14]];
            if ([[textArr objectAtIndex:0] length] > 6 || size.width > 200) {
                rect = CGRectMake(7, y, 306, 50);
                y += 50;
            }
            else {
                rect = CGRectMake(7, y, 306, 33);
                y += 33;
            }
        }
        label.frame = rect;
        [self.scrollView addSubview:label];
    }
    self.scrollView.contentSize = CGSizeMake(320, y );
}

//购买
-(void)buyAction
{
    [self.cell performSelector:@selector(buyAction) withObject:nil];
}
@end

#pragma mark -
@implementation DoneLoanClientDetail
- (void)loadView
{
    [super loadView];
    NSArray *keys = [NSArray arrayWithObjects:@"Orderid",@"truename",@"yearmonth",@"RadBankA",
                     @"workaddress",@"worktype",@"pdy",@"loanmoney",@"loansrt",@"house",@"cards",
                     @"monthincome",@"moneyin",@"mobile",@"email",@"buylist",@"contact", nil];
    
    CGRect rect;
    CGFloat y = 10;    
    for (int i = 0; i < keys.count; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSArray *textArr = nil;
        if ([key isEqualToString:@"loansrt"]) {
            textArr = [NSArray arrayWithObjects:@"贷款用途",[self.detailInfo objectForKey:key], nil];
        }
        else if ([key isEqualToString:@"buylist"]) {
            NSString *text = [self.detailInfo objectForKey:key];
            textArr = [NSArray arrayWithObjects:[text substringToIndex:4],[text substringFromIndex:5], nil];
        }
        else {
            textArr = [[self.detailInfo objectForKey:key] componentsSeparatedByString:@":"];
        }
        DetailLabel *label = [[DetailLabel alloc] init];
        if (i == 0) {
            label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
            label.contentStr = [textArr objectAtIndex:1];
            label.backgroundImage = [UIImage imageNamed:@"detail1.png"];
            rect = CGRectMake(7, y, 306, 42);
            y += 42;
        }
        else if (i == keys.count-2) {
            NSArray *buylist = [[textArr objectAtIndex:1] componentsSeparatedByString:@"；"];
            if (!buylist.count) {
                label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
                label.contentStr = @"无";
            }
            else {
                for (int j = 0; j < buylist.count - 1; j++) {
                    DetailLabel *buyLabel = [[DetailLabel alloc] init];
                    if (j == 0) {
                        buyLabel.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
                    }
                    else {
                        buyLabel.titleStr = @"";
                    }
                    buyLabel.contentStr = [buylist objectAtIndex:j];
                    buyLabel.backgroundImage = [UIImage imageNamed:@"detail2.png"];
                    rect = CGRectMake(7, y, 306, 20);
                    y += 20;
                    buyLabel.frame = rect;
                    [self.scrollView addSubview:buyLabel];
                }
            }
        }
        else if (i == keys.count-1) {
            label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
            label.contentStr = [textArr objectAtIndex:1];
            label.backgroundImage = [UIImage imageNamed:@"x_6.png"];
            rect = CGRectMake(7, y, 306, 49);
            y += 50;
        }
        else {
            label.titleStr = [NSString stringWithFormat:@"%@:",[textArr objectAtIndex:0]];
            label.contentStr = [textArr objectAtIndex:1];
            UIImage *img = [UIImage imageNamed:@"detail3.png"];
            label.backgroundImage = img;
            CGSize size = [[textArr objectAtIndex:1] sizeWithFont:[UIFont systemFontOfSize:14]];
            if ([[textArr objectAtIndex:0] length] > 6 || size.width > 200) {
                rect = CGRectMake(7, y, 306, 50);
                y += 50;
            }
            else {
                rect = CGRectMake(7, y, 306, 33);
                y += 33;
            }
        }
        label.frame = rect;
        [self.scrollView addSubview:label];
    }
    self.scrollView.contentSize = CGSizeMake(320, y );
}
@end