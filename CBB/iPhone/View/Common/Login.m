//
//  Login.m

#import "Login.h"
#import "SingleSelectControl.h"
#import "HomePage.h"
#import "LoanRegister.h"
#import "CardRegister.h"
#import "GetPWDBack.h"
#import "CardHomePage.h"
#import "SVProgressHUD.h"

@interface Login ()
{
    UIImageView *bgView;
    
    SingleSelectControl *selectControl;
    CustomTextField *userField;
    CustomTextField *pwdField;
    UIButton *loginBtn;
    TouchLabel *forgotBtn;
    TouchLabel *registBtn;
    
    Request_API *req;
}
@end

@implementation Login

-(void)loadView
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    req = [Request_API shareInstance];
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];    
    [self setTitle:@"登录"];
    
    bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"l_write_bg.png"]];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    selectControl = [[SingleSelectControl alloc] initWithArray:[NSArray arrayWithObjects:@"信用卡业务",@"贷款业务", nil]];
    [bgView addSubview:selectControl];
    
    userField = [CustomTextField new];
    userField.textDownImage = [UIImage imageNamed:@"user_down.png"];
    userField.textOutImage = [UIImage imageNamed:@"user_out.png"];
    userField.tField.placeholder = @"请输入邮箱或手机号";
    userField.tField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userField.tField.keyboardType = UIKeyboardTypeEmailAddress;
    [bgView addSubview:userField];
    
    pwdField = [CustomTextField new];
    pwdField.textDownImage = [UIImage imageNamed:@"pass_down.png"];
    pwdField.textOutImage = [UIImage imageNamed:@"pass_out.png"];
    pwdField.tField.placeholder = @"请输入密码";
    pwdField.tField.secureTextEntry = YES;
    pwdField.maxLength = 15;
    [bgView addSubview:pwdField];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setImage:[UIImage imageNamed:@"login_out.png"] forState:UIControlStateNormal];
    [loginBtn setImage:[UIImage imageNamed:@"login_down.png"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginBtn];
    
    forgotBtn = [TouchLabel new];
    forgotBtn.text = @"忘记密码？找回密码";
    [forgotBtn addTarget:self action:@selector(fotgotTouchAction)
        forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:forgotBtn];
    
    registBtn = [TouchLabel new];
    registBtn.text = @"没有账号？马上注册";
    [registBtn addTarget:self action:@selector(registTouchAction)
        forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:registBtn];
    
    userField.tField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"CBB_USER"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutViews];
}

- (void)layoutViews
{
    bgView.center = CGPointMake(self.view.center.x, self.view.center.y-50);
    
    selectControl.frame = CGRectMake( 15, 15, 266.5, 40);
    
    CGRect rect ;
    rect.origin = CGPointMake(15, 65);
    rect.size = userField.textOutImage.size;
    userField.frame = rect;
    userField.leftOffset = 50;
    
    rect.origin = CGPointMake(15, 110);
    pwdField.frame = rect;
    pwdField.leftOffset = 50;
    
    rect.origin = CGPointMake(15, 170);
    rect.size = [loginBtn imageForState:0].size;
    loginBtn.frame = rect;
    
    rect.origin = CGPointMake(80, 230);
    rect.size = [forgotBtn.text sizeWithFont:forgotBtn.font];
    forgotBtn.frame = rect;
    
    rect.origin = CGPointMake(80, 260);
    registBtn.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//文字标签点击事件
-(void)fotgotTouchAction
{
    //找回密码
    GetPWDBack *getPWD = [GetPWDBack new];
    getPWD.businessType = selectControl.selectIndex;
    [self.navigationController pushViewController:getPWD animated:YES];
}

-(void)registTouchAction
{
    //注册
    if (selectControl.selectIndex) {
        LoanRegister *loanReg = [LoanRegister new];
        [self.navigationController pushViewController:loanReg animated:YES];
    }
    else {
        CardRegister *cardReg = [CardRegister new];
        [self.navigationController pushViewController:cardReg animated:YES];
    }

}

-(void)login:(UIButton *)sender
{
    [SVProgressHUD showWithMaskType:4];
    req.delegate = self;
    [self.view endEditing:YES];
    if (!userField.tField.text || [userField.tField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱不能为空！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
//    if (![userField.tField.text isEmailAddress])  return;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userField.tField.text,@"username",
                         pwdField.tField.text,@"password",nil];
    selectControl.userInteractionEnabled = NO;
    if (selectControl.selectIndex) {
        [req loanLoginWithDic:dic];
    }
    else {
        [req cardLoginWithDic:dic];
    }
}

#pragma mark -
//请求结束时自动调用
-(void)loginEnd:(id)aDic
{
    selectControl.userInteractionEnabled = YES;
    NSMutableDictionary *dic = [[aDic objectForKey:@"userlogin"] objectForKey:@"result"];
    if (dic.count) {
        [[NSUserDefaults standardUserDefaults] setObject:userField.tField.text forKey:@"CBB_USER"];
        [[UserInfo shareInstance] setPassword:pwdField.tField.text];
        
        UserInfo *loginInfo = [UserInfo shareInstance];
        loginInfo.userInfo = dic;
        if (selectControl.selectIndex) {
            HomePage *homepage = [[HomePage alloc] init];
            homepage.businessType = selectControl.selectIndex;
            [self.navigationController setViewControllers:[NSArray arrayWithObject:homepage] animated:YES];
        }
        else {
            CardHomePage *cardHomePage = [[CardHomePage alloc] init];
            [self.navigationController setViewControllers:[NSArray arrayWithObject:cardHomePage] animated:YES];
        }
    }
}
@end
