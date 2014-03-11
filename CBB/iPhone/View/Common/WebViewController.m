//
//  WebViewController.m
//  CBB
//
//  Created by 卡宝宝 on 14-2-19.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView *webView;
}
@end

@implementation WebViewController
@synthesize url;
- (void)loadView
{
    [super loadView];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif
    
    //返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backBarButton.frame = CGRectMake(0, 0, 51, 33);
    [backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGRect rect = self.view.frame;
    rect.size.height -= 64;
    webView = [[UIWebView alloc] initWithFrame:rect];
    webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    [self.view addSubview:webView];
    
    if (!self.url) {
        url = @"http://3g.cardbaobao.com";
    }
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
