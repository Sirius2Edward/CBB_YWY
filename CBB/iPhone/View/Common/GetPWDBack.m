//
//  GetPWDBack.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-22.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "GetPWDBack.h"
#import "SingleSelectControl.h"

@interface GetPWDBack ()

@end

//找回密码
@implementation GetPWDBack
{
    SingleSelectControl *selectControl;
    CustomTextField *textField;
    Request_API *req;
    NSString *code;
    NSString *newPWD;
}
@synthesize businessType;
-(void)loadView
{
    [super loadView];
    
    [self setTitle:@"找回密码"];
    
    req = [Request_API shareInstance];
    req.delegate = self;
    
    selectControl = [[SingleSelectControl alloc] initWithArray:[NSArray arrayWithObjects:@"邮箱找回",@"手机找回", nil]];
    selectControl.frame = CGRectMake( 20, 20, 280, 40);
    [self.scrollView addSubview:selectControl];
    [selectControl addObserver:self forKeyPath:@"selectIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    UIImage *boxDownImage = [UIImage imageNamed:@"box2_down.png"];
    UIImage *boxOutImage = [UIImage imageNamed:@"box2_out.png"];
    
    textField = [CustomTextField new];
    textField.textDownImage = boxDownImage;
    textField.textOutImage = boxOutImage;
    textField.frame = CGRectMake(7.5f, 70, 305, 41);
    textField.tField.text = @"";
    textField.tField.placeholder = @"请输入您的邮箱帐号";
    textField.tField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.leftOffset = 10;
    [self.scrollView addSubview:textField];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.view endEditing:YES];
    if (selectControl.selectIndex) {
        textField.tField.placeholder = @"请输入您的手机";
        textField.tField.keyboardType = UIKeyboardTypeNumberPad;
        textField.maxLength = 11;
    }
    else {
        textField.tField.placeholder = @"请输入您的邮箱帐号";
        textField.tField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    
}

-(void)submit
{
    if (selectControl.selectIndex) {//手机找回
        if (![textField.tField.text isMobileNumber]) {
            return;
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"typ",textField.tField.text,@"useremail",nil];
        if (self.businessType) {
            [req loanPasswordBackWithDic:dic];
        }
        else {
            [req cardPasswordBackWithDic:dic];
        }        
    }
    else {//邮箱找回
        if (![textField.tField.text isEmailAddress]) {
            return;
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"typ",textField.tField.text,@"useremail",nil];
        if (self.businessType) {
            [req loanPasswordBackWithDic:dic];
        }
        else {
            [req cardPasswordBackWithDic:dic];
        }
    }
}

-(void)connectEnd:(id)aDic
{
    NSDictionary *dic = [[aDic objectForKey:@"carduserlogin16"] objectForKey:@"result"];
    if (dic) {
        if (selectControl.selectIndex) {
            code = [dic objectForKey:@"code"];
            newPWD = [dic objectForKey:@"newpwd"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机找回" message:@"请输入收到的验证码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alert textFieldAtIndex:0] setPlaceholder:@"输入验证码"];
            [alert show];
            
        }
        else {
            
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        if ([[[alertView textFieldAtIndex:0] text] isEqualToString:code]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您的新密码是%@。请牢记或马上更改！",newPWD] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不对" delegate:nil cancelButtonTitle:@"重试" otherButtonTitles: nil] ;
            [alert show];
        }
    }
}

-(void)checkCode
{
    
}

-(void)popAction
{
    [selectControl removeObserver:self forKeyPath:@"selectIndex"];
    [super popAction];
}
@end
