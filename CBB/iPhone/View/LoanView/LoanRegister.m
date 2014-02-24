//
//  LoanRegister.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-22.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "LoanRegister.h"
#import "SingleSelectControl.h"
#import "HomePage.h"
#import "SVProgressHUD.h"

@interface LoanRegister ()
{
    SingleSelectControl *sex;
    CustomPicker *picker;
    CustomTextField *activeText;
}
@end

@implementation LoanRegister
@synthesize citys;
-(void)loadView
{
    [super loadView];
    self.req = [Request_API shareInstance];
    self.req.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(320, 720);
    [self setTitle:@"贷款业务员注册"];
    
    UIImage *listBoxDownImage = [UIImage imageNamed:@"box1_down.png"];
    UIImage *listBoxOutImage = [UIImage imageNamed:@"box1_out.png"];    
    UIImage *boxDownImage = [UIImage imageNamed:@"box2_down.png"];
    UIImage *boxOutImage = [UIImage imageNamed:@"box2_out.png"];
    
    NSArray *placeHoldersArr = [NSArray arrayWithObjects:@"请输入您的邮箱帐号",@"请输入您的密码",@"确认密码",@"请输入您的公司名称",
                                @"请输入您的职务",@"请选择省份和城市",@"请输入公司地址",@"请输入您的真实姓名",@"区号",@"电话号码",
                                @"分机号",@"请输入您的手机",@"您的QQ号（选填）",@"推荐人姓名（选填）",@"推荐人所在城市（选填）", nil];
    for (int i = 0; i < placeHoldersArr.count; i++) {
        CustomTextField *textField = [CustomTextField new];
        textField.tag = 1000+i;
        textField.tField.text = @"";
        textField.tField.placeholder = [placeHoldersArr objectAtIndex:i];
        if (i == 5) {
            textField.textDownImage = listBoxDownImage;
            textField.textOutImage = listBoxOutImage;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(list:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(265, 0, 40, 41);
            [textField addSubview:btn];
        }
        else {
            textField.textDownImage = boxDownImage;
            textField.textOutImage = boxOutImage;
        }
        
        if (i == 0) {
            textField.tField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        else if (i == 1 || i == 2) {
            textField.tField.secureTextEntry = YES;
            textField.maxLength = 15;
        }
        else if (i > 7 && i < 13) {
            textField.tField.keyboardType = UIKeyboardTypeNumberPad;
            if (i == 8) {
                textField.maxLength = 4;
            }
            else if (i == 9) {
                textField.maxLength = 8;
            }
            else if (i == 10) {
                textField.maxLength = 6;
            }
            else if (i == 11) {
                textField.maxLength = 11;
            }
            else {
                textField.maxLength = 13;
            }
        }
        [self.scrollView addSubview:textField];
    }
    
    sex = [[SingleSelectControl alloc] initWithArray:[NSArray arrayWithObjects:@"男",@"女", nil]];
    sex.frame = CGRectMake( 60, 380, 200, 40);
    [self.scrollView addSubview:sex];
    
    CustomLabel *tip = [CustomLabel new];
    tip.textColor = [UIColor titleColor];
    tip.insets = UIEdgeInsetsMake(10, 10, 5, 10);
    tip.frame = CGRectMake(7.5f, 462, 305, 40);
    tip.backgroundImage = [UIImage imageNamed:@"box4.png"];
    tip.text = @"分机号没有可不写";
    [self.scrollView addSubview:tip];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutViews];
}

- (void)layoutViews
{
    CGRect rect;
    rect.size = CGSizeMake(305, 41);
    CGFloat x = 7.5f;
    CGFloat y = 15.0f;
    for (int i = 0; i < 18; i++) {
        CustomTextField *textField = (CustomTextField *)[self.view viewWithTag:i+1000];
        
        rect.origin = CGPointMake(x, y);
        textField.frame = rect;
        textField.leftOffset = 10;
        
        if (i > 7 && i < 11) {
            if (i == 8) {
                x += 85;
                rect.size = CGSizeMake(125, 41);
            }
            else if (i == 9) {
                x += 130;
                rect.size = CGSizeMake(90, 41);
            }
            else {
                x = 7.5f;
                y += 86;
                rect.size = CGSizeMake(305, 41);
            }
        }
        else
        {
            y += 41;
            
            if (i == 7)
            {
                y += 42;
                rect.size = CGSizeMake(80, 41);
            }
            else
            {
                if (i == 11) {
                    rect.size = CGSizeMake(305, 41);
                }
                y += 5;
            }
        }
    }
}

//弹出省市列表
-(void)list:(UIButton *)sender
{
    CustomTextField *textField = (CustomTextField *)[sender superview];
    activeText = textField;
    
    if (!self.citys) {
        [self.req loanGetCity];
    }
    else
    {
        [self showPicker];
    }
    [self.view endEditing:YES];
}

-(void)getCitys:(NSDictionary *)aDic
{
    self.citys = [[aDic objectForKey:@"loansreg1"] objectForKey:@"citys"];
    if (self.citys) {
        [self showPicker];
    }
}

-(void)showPicker
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

-(void)confirmAction:(NSString *)value WithInfo:(NSDictionary *)info
{
}

-(void)selectAction:(NSString *)value
{
    activeText.tField.text = value;
}

-(void)submit
{
    NSArray *keyArr = [NSArray arrayWithObjects:@"email",@"PWDS",@"PWD",@"workname",
                       @"worktype",@"sheng",@"workaddress",@"truename",
                       @"tel1",@"tel2",@"tel3",@"mobile",
                       @"qq",@"tjname",@"tjcity", nil];
    
    NSArray *alertMessages = [NSArray arrayWithObjects:@"公司名称不能为空！",@"职务不能为空！",
                              @"",@"公司地址不能为空！",@"真实姓名不能为空！",nil];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSString *password = nil;
    for (int i = 0; i < 15; i++) {
        CustomTextField *textField = (CustomTextField *)[self.view viewWithTag:i+1000];
        if (i == 0) {
            if (![textField.tField.text isEmailAddress]) {
                return;
            }
            else
            {
                [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
            }
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
            else {
                [mDic setObject:password forKey:[keyArr objectAtIndex:i]];
            }
        }
        else if (i == 5)
        {
            NSArray *shengshi = [textField.tField.text getStateAndCityID:self.citys];
            if (!shengshi) {
                return;
            }
            else {
                [mDic setObject:[shengshi objectAtIndex:0] forKey:[keyArr objectAtIndex:i]];
                [mDic setObject:[shengshi objectAtIndex:1] forKey:@"Shi"];
            }
        }
        else if (i == 8)
        {
            if (![textField.tField.text isAreaNumber]) {
                return;
            }
            else {
                [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
            }
        }
        else if (i == 9)
        {
            if (![textField.tField.text isTelNumber]) {
                return;
            }
            else {
                [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
            }
        }
        else if (i == 11)
        {
//            if ([textField.tField.text isEqualToString:@""]) {//手机号为空，设置为本机号码
//                textField.tField.text = [NSString myPhoneNumber];
//                [SVProgressHUD showSuccessWithStatus:@"已帮您设置成本机号码,请重新提交！" duration:0.789f];
//                return;
//            }
            if (![textField.tField.text isMobileNumber]) {
                return;
            }
            else {
                //合法非本机手机号码 需短信验证
            }
            [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
        }
        else if ( i == 10 || i > 11)//选填的参数
        {
            if (![textField.tField.text isEqualToString:@""]) {
                if (i == 10 && ![textField.tField.text isBranchNumber]) {
                    return;
                }
                [mDic setObject:textField.tField.text forKey:[keyArr objectAtIndex:i]];
            }
        }
        else
        {
            if ([textField.tField.text isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[alertMessages objectAtIndex:i-3]
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
    [self.req registerLoanWithDic:mDic];
}

-(void)regEnd:(NSDictionary *)aDic
{
    if (![aDic objectForKey:@"userreg3"]) {
        return;
    }
    CustomTextField *userField = (CustomTextField *)[self.view viewWithTag:1000];
    CustomTextField *pwdField = (CustomTextField *)[self.view viewWithTag:1002];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userField.tField.text,@"username",
                         pwdField.tField.text,@"password",nil];
    [self.req loanLoginWithDic:dic];
}

-(void)loginEnd:(id)aDic
{
    NSMutableDictionary *dic = [[aDic objectForKey:@"userlogin"] objectForKey:@"result"];
    if (dic.count) {
        CustomTextField *pwdField = (CustomTextField *)[self.view viewWithTag:1002];
        [[UserInfo shareInstance] setPassword:pwdField.tField.text];
        HomePage *homepage = [[HomePage alloc] init];
        homepage.businessType = 1;
        UserInfo *loginInfo = [UserInfo shareInstance];
        loginInfo.userInfo = dic;
        [[NSUserDefaults standardUserDefaults] setObject:loginInfo.username forKey:@"CBB_USER"];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:homepage] animated:YES];
    }
}
@end
