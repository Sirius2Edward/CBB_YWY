//
//  CardRegister.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-22.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "CardRegister.h"
#import "SingleSelectControl.h"
#import "HomePage.h"
#import "SVProgressHUD.h"

@interface CardRegister ()
{
    SingleSelectControl *sex;
    CustomPicker *picker;
    CustomTextField *activeText;
    NSDictionary *banks;
    NSDictionary *jobs;
}
@property(nonatomic,retain)NSDictionary *citys;
@end

@implementation CardRegister
@synthesize citys;
- (id)init
{
    self = [super init];
    if (self) {
        self.req = [Request_API shareInstance];
        self.req.delegate = self;
        jobs = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"业务代表（一线销售）",@""
                ,@"业务组长（管理5-30人）",@"",@"业务经理（管理30人以上）", @"",@"其他管理层",nil];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
        
    self.scrollView.contentSize = CGSizeMake(320, 1130);
    
    [self setTitle:@"信用卡业务员注册"];

    UIImage *listBoxDownImage = [UIImage imageNamed:@"box1_down.png"];
    UIImage *listBoxOutImage = [UIImage imageNamed:@"box1_out.png"];
    
    UIImage *boxDownImage = [UIImage imageNamed:@"box2_down.png"];
    UIImage *boxOutImage = [UIImage imageNamed:@"box2_out.png"];
    
    NSArray *placeHoldersArr = [NSArray arrayWithObjects:@"请输入您的邮箱帐号",@"请输入您的密码",@"确认密码",@"请选择银行",@"请选择城市",
                                @"请输入您的公司名称",@"请选择职务",@"请输入公司地址",@"请输入您的真实姓名",@"区号",@"电话号码",
                                @"分机号",@"请输入您的工作证号",@"请输入您的手机",@"您的QQ号（选填）",
                                @"推荐人姓名（选填）",@"选择推荐人所在银行（选填）",@"选择推荐人所在城市（选填）", nil];
    
    for (int i = 0; i < 18; i++) {
        CustomTextField *textField = [CustomTextField new];
        textField.tag = 1000+i;
        textField.tField.placeholder = [placeHoldersArr objectAtIndex:i];
        textField.tField.text = @"";
        if (i == 3 || i == 4 || i == 6 || i == 16 || i == 17) {
            textField.textOutImage = listBoxOutImage;
            textField.textDownImage = listBoxDownImage;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(265, 0, 40, 41);
            [textField addSubview:btn];
            if (i == 3 || i == 16 ) {
                [btn addTarget:self action:@selector(listBank:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ( i == 4  || i == 17) {
                [btn addTarget:self action:@selector(listCity:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                [btn addTarget:self action:@selector(listJobs:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else {
            textField.textDownImage = boxDownImage;
            textField.textOutImage = boxOutImage;
            if (i == 0) {
                textField.tField.keyboardType = UIKeyboardTypeEmailAddress;
            }
            else if (i == 1 || i == 2) {
                textField.tField.secureTextEntry = YES;
                textField.maxLength = 15;
            }
            else if (i > 8 && i < 15) {
                textField.tField.keyboardType = UIKeyboardTypeNumberPad;
                if (i == 9) {
                    textField.maxLength = 4;
                }
                else if (i == 10) {
                    textField.maxLength = 8;
                }
                else if (i == 11) {
                    textField.maxLength = 6;
                }
                else if (i == 13) {
                    textField.maxLength = 11;
                }
                else if (i == 14) {
                    textField.maxLength = 13;
                }
            }
        }
        [self.scrollView addSubview:textField];
    }
    
    sex = [[SingleSelectControl alloc] initWithArray:[NSArray arrayWithObjects:@"男",@"女", nil]];
    sex.frame = CGRectMake( 60, 563, 200, 40);
    [self.scrollView addSubview:sex];
    
    NSArray *tipsArr = [NSArray arrayWithObjects:@"与总行合作的银行暂不开放注册：招行、广发、兴业、中信",
                        @"包含营销中心、分行等机构的详细名称",@"需填写真实姓名，并需和工作证姓名一致",@"分机号没有可不写", nil];
    for (int i = 0; i < 4; i++) {
        CustomLabel *tip = [CustomLabel new];
        tip.textColor = [UIColor titleColor];
        tip.tag = 1500 + i;
        tip.text = [tipsArr objectAtIndex:i];
        [self.scrollView addSubview:tip];
        if (i)  tip.backgroundImage = [UIImage imageNamed:@"box4.png"];
        else    tip.backgroundImage = [UIImage imageNamed:@"box3.png"];
        
    }
    UIImageView *tips = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt01.png"]];
    tips.frame = CGRectMake(20, 980, 269.5, 120);
    [self.scrollView addSubview:tips];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutViews];
}

- (void)layoutViews
{
    for (int i = 0; i < 4; i++) {
        CustomLabel *tip = (CustomLabel *)[self.view viewWithTag:i+1500];
        tip.insets = UIEdgeInsetsMake(10, 10, 5, 10);
        switch (i) {
            case 0:
                tip.frame = CGRectMake(7.5f, 195, 305, 60);
                break;
            case 1:
                tip.frame = CGRectMake(7.5f, 347, 305, 40);
                break;
            case 2:
                tip.frame = CGRectMake(7.5f, 525, 305, 40);
                break;
            case 3:
                tip.frame = CGRectMake(7.5f, 646, 305, 40);
            default:
                break;
        }
    }
    
    CGRect rect;
    rect.size = CGSizeMake(305, 41);
    CGFloat x = 7.5f;
    CGFloat y = 15.0f;
    for (int i = 0; i < 18; i++) {
        CustomTextField *textField = (CustomTextField *)[self.view viewWithTag:i+1000];
        rect.origin = CGPointMake(x, y);
        textField.frame = rect;
        textField.leftOffset = 10;
        if (i == 3 || i == 4 || i == 6 || i == 16 || i == 17) {
            textField.rightOffset = 40;
        }
        
        if (i > 8 && i < 12) {
            if (i == 9) {
                x += 85;
                rect.size = CGSizeMake(125, 41);
            }
            else if (i == 10) {
                x += 130;
                rect.size = CGSizeMake(90, 41);
            }
            else {
                x = 7.5f;
                y += 45 + 41;
                rect.size = CGSizeMake(305, 41);
            }
        }
        else
        {
            y += 41;
            if (i == 3) {
                y += 65;
            }
            else if (i == 5)
            {
                y += 45;
            }
            else if (i == 8)
            {
                y += 80;
                rect.size = CGSizeMake(80, 41);
            }
            else
            {
                y += 5;
            }
        }
    }
}

//弹出银行列表
-(void)listBank:(UIButton *)sender
{
    CustomTextField *textField = (CustomTextField *)[sender superview];
    activeText = textField;
    if (!banks) {
        [self.req registerValidatedBank];
    }
    else
    {
        [self showPicker:banks Keys:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvinceList" ofType:@"plist"]]];
    }
    [self.view endEditing:YES];
}

-(void)getBank:(id)mDic
{
    banks = [[mDic objectForKey:@"userreg2"] objectForKey:@"banks"];
    [self showPicker:banks Keys:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvinceList" ofType:@"plist"]]];
}

//弹出职务列表
-(void)listJobs:(UIButton *)sender
{
    CustomTextField *textField = (CustomTextField *)[sender superview];
    activeText = textField;
    [self showPicker:jobs Keys:nil];
    [self.view endEditing:YES];
}

-(void)showPicker:(NSDictionary *)data Keys:(NSArray *)keys
{
    if (picker) {
        [picker removeFromSuperview];
    }
    picker = [[CustomPicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, 320, 260)];
    picker.data = data;
    if (keys) {
        picker.keysInOrder = keys;
    }
    picker.components = 1;
    picker.delegate = self;
    [picker showPickerInView:self.view];
}

//弹出省市列表
-(void)listCity:(UIButton *)sender
{
    CustomTextField *textField = (CustomTextField *)[sender superview];
    activeText = textField;
    
    if (!self.citys) {
        [self.req loanGetCity];
    }
    else
    {
        [self showCityPicker];
    }
    [self.view endEditing:YES];
}

-(void)getCitys:(NSDictionary *)aDic
{
    self.citys = [[aDic objectForKey:@"loansreg1"] objectForKey:@"citys"];
    if (picker) {
        [self showCityPicker];
    }
}

-(void)showCityPicker
{
    if (picker) {
        [picker removeFromSuperview];
    }
    picker = [[CustomPicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, 320, 260)];
    picker.data = self.citys;
    picker.components = 2;
    picker.delegate = self;
    [picker showPickerInView:self.view];
}

//注册提交
-(void)submit
{
    NSArray *keyArr = [NSArray arrayWithObjects:@"signup_uid",@"PWDS",@"PWD",@"bank1",
                       @"shi",@"mem_company",@"Mem_Remark",@"mem_addr",@"mem_name",
                       @"tel1",@"tel2",@"tel3",@"workid",@"signup_mobile",
                       @"QQ",@"upuser",@"bank2",@"Card_city1", nil];
    
    NSArray *alertMessages = [NSArray arrayWithObjects:@"城市不能为空！",@"公司名称不能为空！",@"职务不能为空！",
                              @"公司地址不能为空！",@"真实姓名不能为空！",@"工作证号不能为空！",nil];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSString *password = nil;
    for (int i = 0; i < 18; i++) {
        CustomTextField *textField = (CustomTextField *)[self.view viewWithTag:i+1000];
        if (i == 0) {
            if (![textField.tField.text isEmailAddress]) {
                return;
            }
            [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
        }
        else if (i == 1)
        {
            if (textField.tField.text.length < 6) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"密码不能少于6位！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"重新输入"
                                                      otherButtonTitles: nil];
                [alert show];
                return;
            }
            password = textField.tField.text;
        }
        else if (i == 2)
        {
            if (![textField.tField.text isEqualToString:password]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"密码不一致"
                                                               delegate:nil
                                                      cancelButtonTitle:@"重新输入"
                                                      otherButtonTitles: nil];
                [alert show];
                return;
            }
            [mDic setObject:password forKey:[keyArr objectAtIndex:i]];
        }
        else if (i == 3)
        {
            NSString *bankID = [textField.tField.text getIDfromDic:banks WithTypeName:@"银行"];
            if (!bankID) {
                return;
            }
            [mDic setObject:bankID forKey:[keyArr objectAtIndex:i]];
        }
        else if (i == 4) {
            NSString *cityID = [textField.tField.text getCityID:self.citys];
            if (!cityID) {
                return;
            }
            [mDic setObject:cityID forKey:[keyArr objectAtIndex:i]];
        }
        else if (i == 9)
        {
            if (![textField.tField.text isAreaNumber]) {
                return;
            }
            else {
                [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
            }
        }
        else if (i == 10)
        {
            if (![textField.tField.text isTelNumber]) {
                return;
            }
            else {
                [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
            }
        }
        else if (i == 13)
        {
            if (![textField.tField.text isMobileNumber]) {
                return;
            }
            else {
                //合法非本机手机号码 需短信验证
            }
            [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
        }
        else if ( i == 11 || i > 13)//选填的参数
        {
            if (![textField.tField.text isEqualToString:@""]) {
                if (i == 11 && ![textField.tField.text isBranchNumber]) {
                    return;
                }
                else if (i == 16) {
                    NSString *bankID = [textField.tField.text getIDfromDic:banks WithTypeName:@"推荐人所在银行"];
                    if (!bankID) {
                        return;
                    }
                    [mDic setObject:bankID forKey:[keyArr objectAtIndex:i]];
                }
                else if (i == 17) {
                    NSString *cityID = [textField.tField.text getCityID:self.citys];
                    if (!cityID) {
                        return;
                    }
                    [mDic setObject:cityID forKey:[keyArr objectAtIndex:i]];
                }
                else {
                    [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
                }
            }
        }
        else
        {
            if ([textField.tField.text isEqualToString:@""]) {
                int k ;
                if (i == 12) {
                    k = i-7;
                } else {
                    k = i-4;
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[alertMessages objectAtIndex:k]
                                                               delegate:nil
                                                      cancelButtonTitle:@"重新输入"
                                                      otherButtonTitles: nil];
                [alert show];
                return;
            }
            else
            {
                [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
            }
        }
    }
    [mDic setObject:[NSString stringWithFormat:@"%d",sex.selectIndex+1] forKey:@"Mem_Sex"];
    
//    for (NSString *key in [mDic allKeys]) {
//        NSLog(@"%@ -- %@",key ,[mDic objectForKey:key]);
//    }
    [self.req registerCardWithDic:mDic];
}

-(void)confirmAction:(NSString *)value WithInfo:(NSDictionary *)info
{
    activeText.tField.text = value;
    activeText = nil;
}

-(void)selectAction:(NSString *)value
{
    activeText.tField.text = value;
}

-(void)regEnd:(NSDictionary *)aDic
{
    if (![aDic objectForKey:@"userreg1"]) {
        return;
    }
    CustomTextField *userField = (CustomTextField *)[self.view viewWithTag:1000];
    CustomTextField *pwdField = (CustomTextField *)[self.view viewWithTag:1002];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userField.tField.text,@"username",
                         pwdField.tField.text,@"password",nil];
    [self.req cardLoginWithDic:dic];
}

-(void)loginEnd:(id)aDic
{
    NSMutableDictionary *dic = [[aDic objectForKey:@"userlogin"] objectForKey:@"result"];
    if (dic.count) {
        CustomTextField *pwdField = (CustomTextField *)[self.view viewWithTag:1002];
        [[UserInfo shareInstance] setPassword:pwdField.tField.text];
        HomePage *homepage = [[HomePage alloc] init];
        homepage.businessType = 0;
        UserInfo *loginInfo = [UserInfo shareInstance];
        loginInfo.userInfo = dic;
        [[NSUserDefaults standardUserDefaults] setObject:loginInfo.username forKey:@"CBB_USER"];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:homepage] animated:YES];
    }
}
@end