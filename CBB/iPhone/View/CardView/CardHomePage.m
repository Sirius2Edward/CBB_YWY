//

#import "CardHomePage.h"
#import "UILabel+Add.h"
#import "UserManageView.h"
#import "DataModel.h"
#import "Request_API.h"
#import "SVProgressHUD.h"
#import "CardClientTable.h"
#import "PayRecordTable.h"
#import "CardChartView.h"
#import "Login.h"

@interface CardHomePage ()
{
    NSInteger active;
    Request_API *req;
    UILabel *curUnit;
    UILabel *moneyUnit;
    UILabel *doneUnit;
    UILabel *successUnit;
    UILabel *buyUnit;
    UILabel *payUnit;
}
@property(nonatomic,retain)NSMutableDictionary *appClientData;
@property(nonatomic,retain)NSMutableDictionary *doneClientData;
@end

@implementation CardHomePage
@synthesize appClientData;
@synthesize doneClientData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        req = [Request_API shareInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"信用卡业务员";
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake(320, 455);
    scrollView.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    
    //刷新按钮
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setBackgroundImage:[UIImage imageNamed:@"right_btn.png"] forState:0];
    [barButton setTitle:@"刷新" forState:0];
    barButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    [barButton sizeToFit];
    [barButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    active = [[[UserInfo shareInstance].userInfo objectForKey:@"mem_ifActive"] integerValue];
    
    [self.payLabel addTarget:self action:@selector(goToPay)
            forControlEvents:UIControlEventTouchUpInside];
    
    //获取月份
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [cal components:NSMonthCalendarUnit fromDate:[NSDate date]];
    self.monthLabel.text = [NSString stringWithFormat:@"%d月",comp.month];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    req.delegate = self;
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)updateDisplay
{
    UserInfo *login = [UserInfo shareInstance];
    
    self.nameLabel.text = nil?@"name":[login.userInfo objectForKey:@"username"];
    self.cityLabel.text = nil?@"city":[login.userInfo objectForKey:@"city"];
    self.bankLabel.text = nil?@"bank":[login.userInfo objectForKey:@"bank1"];
    [self.latestButton setTitle:nil?@"0":[login.userInfo objectForKey:@"newreg"]
                       forState:UIControlStateNormal];
    self.moneyLabel.text = nil?@"0":[login.userInfo objectForKey:@"money"];
//    self.moneyLabel.text =
    
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor darkGrayColor];
    if (curUnit) {
        [curUnit removeFromSuperview];
    }
    if (moneyUnit) {
        [moneyUnit removeFromSuperview];
    }
    if (doneUnit) {
        [doneUnit removeFromSuperview];
    }
    if (successUnit) {
        [successUnit removeFromSuperview];
    }
    if (buyUnit) {
        [buyUnit removeFromSuperview];
    }
    if (payUnit) {
        [payUnit removeFromSuperview];
    }
    curUnit = [self.latestButton.titleLabel addUnit:@"张与您匹配的客户表" Font:font Color:color xOffset:2 yOffset:1];
    moneyUnit = [self.moneyLabel addUnit:@"分" Font:font Color:color xOffset:2 yOffset:2];
    doneUnit = [self.doneNumLabel addUnit:@"张" Font:font Color:color xOffset:2 yOffset:1];
    successUnit = [self.successNumLabel addUnit:@"张" Font:font Color:color xOffset:2 yOffset:1];
    buyUnit = [self.buyNumLabel addUnit:@"张" Font:font Color:color xOffset:2 yOffset:1];
    payUnit = [self.payNumLabel addUnit:@"元" Font:font Color:color xOffset:2 yOffset:1];
}
#pragma mark - Action
//刷新
-(void)refreshAction
{
    [SVProgressHUD showWithMaskType:4];
    [self refresh];
}

-(void)refresh
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",nil];
    [req cardLoginWithDic:dic];
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

//进入个人管理
-(IBAction)userManage
{
    UserManageView *um = [[UserManageView alloc] initWithStyle:UITableViewStyleGrouped];
    um.businessType = 0;
    [self.navigationController pushViewController:um animated:YES];
}

//安全退出
-(IBAction)resign
{
    //清空登陆数据，返回登陆界面
    [[UserInfo shareInstance] clearInfo];
    Login *login = [[Login alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:login] animated:YES];
}

//新客户表
-(IBAction)newClientAction
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
        [req cardNewClientsWithDic:dic];
    }
    else {
        [self pushToNewCardClientTable];
    }
}

//已购买表
-(IBAction)doneClientAction
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
        [req cardBuyersInfoWithDic:dic];
    }
    else {
        [self pushToDoneCardClientTable];
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

-(IBAction)lookChart
{
    CardChartView *ccv = [[CardChartView alloc] init];
    [self.navigationController pushViewController:ccv animated:YES];
}

-(IBAction)thisMonthBuy
{
    
}

//充值记录
-(IBAction)payRecord
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         userInfo.ID,@"id",
                         @"1",@"page",nil];
    [req cardPayRecordWithDic:dic];
}

-(void)goToPay
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"因手机客户端暂未开通在线充值！\n您可以通过支付宝把充值的金额转入我公司支付宝账号：service@cardbaobao.com\n并及时通知为您服务的客户经理！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"进入支付宝", nil];
    [alert show];
}

#pragma mark - connectEnd
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
    data = [aDic objectForKey:@"PARSEcarduserlogin7"];
    if (!data) {
        return;
    }
    if (![[data objectForKey:@"TotalRS"] intValue]) {
        [SVProgressHUD showErrorWithStatus:@"暂无充值记录" duration:1.5f];
        return;
    }
    PayRecordTable *pay = [[PayRecordTable alloc] init];
    pay.businessType = 0;
    pay.data = data;
    [self.navigationController pushViewController:pay animated:YES];
}
@end