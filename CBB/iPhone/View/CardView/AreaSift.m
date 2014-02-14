//
//  AreaSift.m
//  CBB
//
//  Created by 卡宝宝 on 13-9-2.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "AreaSift.h"
#import "Request_API.h"
#import "UIColor+TitleColor.h"

@interface AreaSift ()
{
    Request_API *req;
    NSDictionary *areaList;
    NSMutableArray *selectedAreas;
}
@end

@implementation AreaSift
@synthesize areaList;
-(id)init
{
    if (self = [super init]) {
        req = [Request_API shareInstance];
        req.delegate = self;
        selectedAreas = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"区域筛选";
    NSArray *areas = [self.areaList allKeys];
    CGFloat y = 0;
    for (int i = 0; i< areas.count+1; i++) {
        y = 20 + i/2*50;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15+i%2*150, y, 140, 41);
        btn.tag = 4100+i;
        [btn setBackgroundImage:[UIImage imageNamed:@"area_1.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"area_2.png"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"area_2.png"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setTitleColor:[UIColor titleColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(sift:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitle:@"选择全部" forState:0];
        }
        else {
            [btn setTitle:[areas objectAtIndex:i-1] forState:UIControlStateNormal];
        }
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(320, y+70);
}

-(void)sift:(UIButton *)sender
{
    if (sender.tag - 4100 == 0) {//全选
        if (sender.selected) {
            for (int i = 0; i < self.areaList.count+1; i++) {
                UIButton *btn = (UIButton *)[self.scrollView viewWithTag:i+4100];
                btn.selected = NO;
            }
            [selectedAreas removeAllObjects];
        }
        else {
            for (int i = 0; i < self.areaList.count+1; i++) {
                UIButton *btn = (UIButton *)[self.scrollView viewWithTag:i+4100];
                btn.selected = YES;
            }
            [selectedAreas setArray:[self.areaList allKeys]];            
        }
    }
    else {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [selectedAreas addObject:[sender titleForState:0]];
        }
        else {
            [selectedAreas removeObject:[sender titleForState:0]];
            UIButton *btn = (UIButton *)[self.scrollView viewWithTag:4100];
            btn.selected = NO;
        }
    }
}

-(void)submit
{
//    NSLog(@"%@",selectedAreas);
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSString *str in selectedAreas) {
        [mArr addObject:[NSString stringWithFormat:@"%@#%@",[self.areaList objectForKey:str],str]];
    }
    NSString *para = [mArr componentsJoinedByString:@","];
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         userInfo.ID,@"id",
                         para,@"qy",nil];
    req.delegate = self;
    [req cardAreaSelectWithDic:dic];
}

-(void)areaCommitEnd:(NSDictionary *)mDic
{
    NSString *result = [[mDic objectForKey:@"PARSEcarduserlogin12"] objectForKey:@"result"];
    if (!result) {
        return;
    }
    [self popAction];
}
@end
