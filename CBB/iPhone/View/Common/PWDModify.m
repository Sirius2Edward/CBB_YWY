//
//  pwdModify.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-22.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "pwdModify.h"

//密码修改
@implementation PWDModify
{
    Request_API *req;
}
-(void)loadView
{
    [super loadView];
    self.title = @"修改密码";
    req = [Request_API shareInstance];
    req.delegate = self;
    
    //    self.scrollView.contentSize = CGSizeMake(320, self.view.bounds.size.height-68);
    
    NSArray *placeHolder = [NSArray arrayWithObjects:@"请输入原密码",@"请输入新密码",@"请再输一遍新密码", nil];
    UIImage *boxDownImage = [UIImage imageNamed:@"box2_down.png"];
    UIImage *boxOutImage = [UIImage imageNamed:@"box2_out.png"];
    CGFloat y = 15;
    for (int i = 0; i < 3; i++) {
        CustomTextField *textField = [CustomTextField new];
        textField.tag = 1000 + i;
        textField.frame = CGRectMake(7.5f, y, 305, 41);
        textField.leftOffset = 10;
        textField.maxLength = 15;
        textField.textOutImage = boxOutImage;
        textField.textDownImage = boxDownImage;
        textField.tField.secureTextEntry = YES;
        textField.tField.text = @"";
        textField.tField.placeholder = [placeHolder objectAtIndex:i];
        [self.scrollView addSubview:textField];
        y += 50;
    }
}

-(void)submit
{
    NSString *oldpwd;
    NSString *newpwd;
    for (int i = 0; i < 3; i++) {
        CustomTextField *textField = (CustomTextField *)[self.view viewWithTag:i+1000];
        if (i == 0) {
            oldpwd = textField.tField.text;
            if ([textField.tField.text isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请输入原密码"
                                                               delegate:nil
                                                      cancelButtonTitle:@"重新输入"
                                                      otherButtonTitles: nil];
                [alert show];
                return;
            }
        }
        else if (i == 1) {
            if (textField.tField.text.length < 6) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"新密码不能少于6位"
                                                               delegate:nil
                                                      cancelButtonTitle:@"重新输入"
                                                      otherButtonTitles: nil];
                [alert show];
                return;
            }
            newpwd = textField.tField.text;
        }
        else {
            if (![textField.tField.text isEqualToString:newpwd]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"新密码两次输入不一致"
                                                               delegate:nil
                                                      cancelButtonTitle:@"重新输入"
                                                      otherButtonTitles: nil];
                [alert show];
                return;
            }
        }
        if (textField.tField.text.length < 6) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"密码不能少于6位！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"重新输入"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         oldpwd,@"password",
                         userInfo.ID,@"id",
                         newpwd,@"newpassword", nil];
    if (self.businessType) {
        [req loanPasswordModifyWithDic:dic];
    }
    else {
        [req cardPasswordModifyWithDic:dic];
    }
}

-(void)connectEnd:(id)aDic
{
    [self.view endEditing:YES];
    if (![aDic objectForKey:@"loansuserlogin9"] && ![aDic objectForKey:@"carduserlogin9"]) {
        return;
    }
    CustomTextField *textField = (CustomTextField *)[self.view viewWithTag:1002];
    [[UserInfo shareInstance] setPassword:textField.tField.text];
    [self popAction];
}
@end
