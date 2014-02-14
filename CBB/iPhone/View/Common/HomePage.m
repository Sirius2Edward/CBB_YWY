//
//  HomePage.m

#import "HomePage.h"
#import "Login.h"
#import "LoanClientTable.h"
#import "LoanInfoModify.h"
#import "CardClientTable.h"
#import "CardInfoModify.h"
#import "PWDModify.h"
#import "CustomLabel.h"
#import "Request_API.h"
#import "DataModel.h"
#import "UIColor+TitleColor.h"
#import "SVProgressHUD.h"
#import "AreaSift.h"
#import "UploadPicture.h"
#import "PayRecordTable.h"

@interface HomePage ()
{
    Request_API *req;
    KeyWordLabel *newClientSheet;
    KeyWordLabel *doneSheet;
    UILabel *money;
    NSDictionary *areaList;
    NSInteger active;
}
@end

@implementation HomePage
@synthesize businessType;
@synthesize appClientData;
@synthesize doneClientData;

-(id)init
{
    if (self = [super init]) {
        req = [Request_API shareInstance];
    }
    return self;
}

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
    
    if (self.businessType) {
        active = [[[UserInfo shareInstance].userInfo objectForKey:@"ifActive"] integerValue];
    }
    else {
        active = [[[UserInfo shareInstance].userInfo objectForKey:@"mem_ifActive"] integerValue];
    }
    //刷新按钮
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setBackgroundImage:[UIImage imageNamed:@"right_btn.png"] forState:0];
    [barButton setTitle:@"刷新" forState:0];
    barButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    [barButton sizeToFit];
    [barButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    self.title = @"首页";
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];

    UIImageView *applicationBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id_bg1.png"]];
    applicationBG.userInteractionEnabled = YES;
    applicationBG.frame = CGRectMake(8, 10, 304, 121);
    [self.view addSubview:applicationBG];
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor titleColor];
    [applicationBG addSubview:titleLabel];
    if (self.businessType) {
        titleLabel.text = @"贷款客户申请表";
    }
    else {
        titleLabel.text = @"信用卡客户申请表";
    }
    
    newClientSheet = [[KeyWordLabel alloc] initWithFrame:CGRectMake(60, 50, 250, 40)];
    [applicationBG addSubview:newClientSheet];
    
    doneSheet = [[KeyWordLabel alloc] initWithFrame:CGRectMake(60, 90, 250, 40)];
    [applicationBG addSubview:doneSheet];
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:@selector(newClientAction) forControlEvents:UIControlEventTouchUpInside];
    newButton.frame = CGRectMake(0, 40, 304, 40);
    [applicationBG addSubview:newButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton addTarget:self action:@selector(doneClientAction) forControlEvents:UIControlEventTouchUpInside];
    doneButton.frame = CGRectMake(0, 80, 304, 40);
    [applicationBG addSubview:doneButton];
    
    CustomLabel *baseInfo = [[CustomLabel alloc] init];
    baseInfo.frame = CGRectMake(1, 145, 318, 25);
    baseInfo.text = @"基本资料";
    baseInfo.insets = UIEdgeInsetsMake(0, 15, 0, 0);
    baseInfo.backgroundImage = [UIImage imageNamed:@"id_bg2.png"];
    [self.view addSubview:baseInfo];

    CGFloat y = 175;

    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"基本资料修改",@"密码修改",@"注销", nil];
    NSMutableArray *selArr = [NSMutableArray arrayWithObjects:@"pushModifyInfo",@"pushModifyPWD",@"resign", nil];
    if (!self.businessType) {
        [titleArr insertObject:@"可服务区域" atIndex:2];
        [titleArr insertObject:@"上传工作名片" atIndex:3];
        [selArr insertObject:@"areaSel" atIndex:2];
        [selArr insertObject:@"pushUpload" atIndex:3];
    }
    for (int i = 0; i < titleArr.count; i++) {
        NSString *bgName = nil;
        if (i == 0) {
            bgName = @"id_tab1";
        }
        else if (i == titleArr.count-1) {
            bgName = @"id_tab3";
        }
        else {
            bgName = @"id_tab2";
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",bgName]] forState:0];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down.png",bgName]] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:0];
        [button setTitle:[titleArr objectAtIndex:i] forState:0];
        button.titleLabel.font = [UIFont fontWithName:@"Arial" size:15];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [button addTarget:self action:NSSelectorFromString([selArr objectAtIndex:i])
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(8.5f, y, 303, 36);
        [self.view addSubview:button];
        y += 36;
    }
    
    //
    CustomLabel *moneyInfo = [[CustomLabel alloc] init];
    moneyInfo.userInteractionEnabled = YES;
    moneyInfo.frame = CGRectMake(7.25f, y+5, 305.5, 39.5);
    moneyInfo.font = [UIFont fontWithName:@"Arial" size:15];
    moneyInfo.text = @"您的积分余额：";
    moneyInfo.insets = UIEdgeInsetsMake(0, 15, 0, 0);
    moneyInfo.backgroundImage = [UIImage imageNamed:@"id_tab4.png"];
    [self.view addSubview:moneyInfo];
    
    money = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 100, 38)];
    money.backgroundColor = [UIColor clearColor];
    money.font = [UIFont fontWithName:@"ArialHebrew-Bold" size:20];
    money.textColor = [UIColor titleColor];
    [moneyInfo addSubview:money];
    
    UIButton *payRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    [payRecord setBackgroundImage:[UIImage imageNamed:@"czjl.png"] forState:0];
    [payRecord setBackgroundImage:[UIImage imageNamed:@"czjl_down.png"] forState:UIControlStateHighlighted];
    payRecord.frame = CGRectMake(220, 9, 74, 22);
    [payRecord addTarget:self action:@selector(payRecAction:) forControlEvents:UIControlEventTouchUpInside];
    [moneyInfo addSubview:payRecord];
}

#pragma mark -
//刷新
-(void)refresh
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",nil];
    if (self.businessType) {
        [req loanLoginWithDic:dic];
    }
    else {
        [req cardLoginWithDic:dic];
    }
}

-(void)loginEnd:(id)aDic
{
    NSMutableDictionary *dic = [[aDic objectForKey:@"PARSEuserlogin"] objectForKey:@"result"];
    if (dic.count) {
        UserInfo *loginInfo = [UserInfo shareInstance];
        loginInfo.userInfo = dic;
    }
    [self updateDisplay];
}

//注销
-(void)resign
{
    //清空登陆数据，返回登陆界面
    [[UserInfo shareInstance] clearInfo];
    Login *login = [[Login alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:login] animated:YES];
}

-(void)newClientAction
{
    //未激活
    if (!active) {
        [SVProgressHUD showErrorWithStatus:@"您尚未激活该账户！\n速联系我们..." duration:1.5];
        return;
    }
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         userInfo.ID,@"id", nil];
    if (!self.appClientData) {
        if (self.businessType) {
            [req loanNewClientsWithDic:dic];
        }
        else {
            [req cardNewClientsWithDic:dic];
        }
    }
    else {
        if (self.businessType) {
            [self pushToNewLoanClientTable];
        }
        else {
            [self pushToNewCardClientTable];
        }
    }
}

//已购买表
-(void)doneClientAction
{
    //未激活
    if (!active) {
        [SVProgressHUD showErrorWithStatus:@"您尚未激活该账户！\n速联系我们..." duration:1.5];
        return;
    }
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         userInfo.ID,@"id", nil];
    if (!self.doneClientData) {
        if (self.businessType) {
            [req loanBuyersInfoWithDic:dic];
        }
        else {
            [req cardBuyersInfoWithDic:dic];
        }
    }
    else {
        if (self.businessType) {
            [self pushToDoneLoanClientTable];
        }
        else {
            [self pushToDoneCardClientTable];
        }
    }
}

-(void)pushToNewCardClientTable
{
    NewCardClientTable *cardClientTable = [[NewCardClientTable alloc] init];
    cardClientTable.data = self.appClientData;
    [self.navigationController pushViewController:cardClientTable animated:YES];   
}

-(void)pushToDoneCardClientTable
{
    DoneCardClientTable *cardClientTable = [[DoneCardClientTable alloc] init];
    cardClientTable.data = self.doneClientData;
    [self.navigationController pushViewController:cardClientTable animated:YES];
}

-(void)pushToNewLoanClientTable
{
    NewLoanClientTable *loanClientTable = [[NewLoanClientTable alloc] init];
    loanClientTable.data = self.appClientData;
    [self.navigationController pushViewController:loanClientTable animated:YES];
}

-(void)pushToDoneLoanClientTable
{
    DoneLoanClientTable *loanClientTable = [[DoneLoanClientTable alloc] init];
    loanClientTable.data = self.doneClientData;
    [self.navigationController pushViewController:loanClientTable animated:YES];
}

-(void)pushModifyInfo
{
    if (self.businessType) {
        LoanInfoModify *loanModify = [[LoanInfoModify alloc] init];
        [self.navigationController pushViewController:loanModify animated:YES];
    }
    else {
        CardInfoModify *cardModify = [[CardInfoModify alloc] init];
        [self.navigationController pushViewController:cardModify animated:YES];
    }
}

-(void)pushModifyPWD
{
    PWDModify *pwd = [[PWDModify alloc] init];
    pwd.businessType = self.businessType;
    [self.navigationController pushViewController:pwd animated:YES];
}

-(void)pushToAreaSift
{
    AreaSift *area = [[AreaSift alloc] init];
    area.areaList = areaList;
    [self.navigationController pushViewController:area animated:YES];
}

//区域选择
-(void)areaSel
{
    //未激活
    if (!active) {
        [SVProgressHUD showErrorWithStatus:@"您尚未激活该账户！\n速联系我们..." duration:1.5];
        return;
    }
    if (areaList) {
        [self pushToAreaSift];
    }
    else {
        UserInfo *userInfo = [UserInfo shareInstance];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             userInfo.username,@"username",
                             userInfo.password,@"password",
                             userInfo.ID,@"id", nil];
        req.delegate = self;
        [req cardAreaListWithDic:dic];
    }
}

-(void)areaListEnd:(NSDictionary *)mDic
{
    areaList = [[mDic objectForKey:@"PARSEcarduserlogin11"] objectForKey:@"QL"];
    if (areaList) {
        [self pushToAreaSift];
    }
}

-(void)pushUpload
{
//    [SVProgressHUD showSuccessWithStatus:@"此功能即将开通！\n敬请期待..." duration:1.5];
    UploadPicture *upload = [[UploadPicture alloc] init];
    upload.businessType = self.businessType;
    [self.navigationController pushViewController:upload animated:YES];
}

//充值记录
-(void)payRecAction:(UIButton *)sender
{
    
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         userInfo.ID,@"id",
                         @"1",@"page",nil];
    if (self.businessType) {
        [req loanPayRecordWithDic:dic];
    }
    else {
        [req cardPayRecordWithDic:dic];
    }
}

#pragma mark - ConnectEnd -
-(void)newLoanClientEnd:(id)aDic
{
    NSMutableDictionary *data = [aDic objectForKey:@"PARSEloansuserlogin2"];
    if (!data) {
        return;
    }
    self.appClientData = data;
    [self pushToNewLoanClientTable];
}

-(void)doneLoanClientEnd:(id)aDic
{
    NSMutableDictionary *data = [aDic objectForKey:@"PARSEloansuserlogin5"];
    if (!data) {
        return;
    }
    self.doneClientData = data;
    [self pushToDoneLoanClientTable];
}

-(void)newCardClientEnd:(id)aDic
{
    NSMutableDictionary *data = [aDic objectForKey:@"PARSEcarduserlogin2"];
    if (!data) {
        return;
    }
    if (![[data objectForKey:@"TotalRS"] intValue]) {
        [SVProgressHUD showErrorWithStatus:@"暂无新申请表" duration:1.5f];
        return;
    }
    self.appClientData = data;
    [self pushToNewCardClientTable];
}

-(void)doneCardClientEnd:(id)aDic
{
    NSMutableDictionary *data = [aDic objectForKey:@"PARSEcarduserlogin5"];
    if (!data) {
        return;
    }
    if (![[data objectForKey:@"TotalRS"] intValue]) {
        [SVProgressHUD showErrorWithStatus:@"未购买任何客户" duration:1.5f];
        return;
    }
    self.doneClientData = data;
    [self pushToDoneCardClientTable];
}

-(void)payRecordEnd:(id)aDic
{
    NSMutableDictionary *data = nil;
    if (self.businessType) {
        data = [aDic objectForKey:@"PARSEloansuserlogin7"];
    }
    else {
        data = [aDic objectForKey:@"PARSEcarduserlogin7"];
    }
    if (!data) {
        return;
    }
    if (![[data objectForKey:@"TotalRS"] intValue]) {
        [SVProgressHUD showErrorWithStatus:@"暂无充值记录" duration:1.5f];
        return;
    }
    PayRecordTable *pay = [[PayRecordTable alloc] init];
    pay.businessType = self.businessType;
    pay.data = data;
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma mark -
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    req.delegate = self;
    [self refresh];
}

-(void)updateDisplay
{
    UserInfo *login = [UserInfo shareInstance];
    NSString *newClientText = nil;
    NSString *doneText = nil;
    NSString *newReg = nil?@"0":[login.userInfo objectForKey:@"newreg"];
    NSString *oldReg = nil?@"0":[login.userInfo objectForKey:@"oldreg"];
    NSString *city = nil?@"  ":[login.userInfo objectForKey:@"city"];
    NSString *bank = nil?@"  ":[login.userInfo objectForKey:@"bank1"];
    NSString *account = nil?@"0":[login.userInfo objectForKey:@"money"];
    if (self.businessType) {
        newClientText = [NSString stringWithFormat:@"新贷款申请表%@张",newReg];
        doneText = [NSString stringWithFormat:@"已购买的客户表%@张",oldReg];
    }
    else {
        newClientText = [NSString stringWithFormat:@"%@%@新申请表%@张",city ,bank ,newReg];
        doneText = [NSString stringWithFormat:@"已购买的客户表%@张",oldReg];
    }
    [newClientSheet setText:newClientText WithFont:[UIFont systemFontOfSize:14] AndColor:[UIColor blackColor]];
    [newClientSheet setKeywordLight:newReg WithFont:[UIFont systemFontOfSize:18] AndColor:[UIColor titleColor]];
    [doneSheet setText:doneText WithFont:[UIFont systemFontOfSize:14] AndColor:[UIColor blackColor]];
    [doneSheet setKeywordLight:oldReg WithFont:[UIFont systemFontOfSize:18] AndColor:[UIColor titleColor]];
    money.text = [NSString stringWithFormat:@"%@",account];
}
@end