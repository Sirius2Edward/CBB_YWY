//
//  LoanHomeController.m
//  CBB
//
//  Created by 卡宝宝 on 14-2-17.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "LoanHomeController.h"

@interface LoanHomeController ()
@end

@implementation LoanHomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1961];
    UIImage *img = imgView.image;
    imgView.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
