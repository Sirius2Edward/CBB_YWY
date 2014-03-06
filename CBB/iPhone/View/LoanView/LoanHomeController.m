//
#import "LoanHomeController.h"
#import "SVProgressHUD.h"
#import "Request_API.h"
#import "DataModel.h"
#import "ChartView.h"
#import "UserManageView.h"
#import "LoanAdvisorView.h"
#import "LoanClientTable.h"
#import "UploadPicture.h"
#import "PayRecordTable.h"
#import "WebViewController.h"
#import "UILabel+Add.h"

@interface LoanHomeController ()
{
    UILabel *doneUnit;
    UILabel *successUnit;
    UILabel *buyUnit;
    UILabel *payUnit;
    Request_API *req;
    NSInteger active;
    NSDictionary *_statistic;
}
@property(nonatomic,retain)NSMutableDictionary *appClientData;
@property(nonatomic,retain)NSMutableDictionary *doneClientData;
@property(nonatomic,retain)NSMutableDictionary *shopClientData;
@end

@implementation LoanHomeController
@synthesize appClientData;
@synthesize doneClientData;
@synthesize shopClientData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        req = [Request_API shareInstance];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    req.delegate = self;
    [self refresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    active = [[[UserInfo shareInstance].userInfo objectForKey:@"mem_ifActive"] integerValue];
    [super viewDidLoad];
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1961];
    UIImage *img = imgView.image;
    imgView.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [cal components:NSMonthCalendarUnit fromDate:[NSDate date]];
    self.monthLabel.text = [NSString stringWithFormat:@"%d月",comp.month];
    [self.payLabel addTarget:self action:@selector(goToPay)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self updateDisplay];
}

-(void)refresh
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",nil];
    [req loanLoginWithDic:dic];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit ;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          userInfo.username,@"username",
                          userInfo.password,@"password",
                          [NSString stringWithFormat:@"%d",[comps year]],@"year",
                          [NSString stringWithFormat:@"%d",[comps month]],@"month",nil];
    [req loanStatisticWithDic:dic];
}
-(void)updateDisplay
{
    UserInfo *login = [UserInfo shareInstance];
    NSString *formNum = [login.userInfo objectForKey:@"newreg"];
    NSString *myRegNum = [login.userInfo objectForKey:@"dpreg"];
    NSString *money = [login.userInfo objectForKey:@"money"];
    NSString *avaName = [login.userInfo objectForKey:@"images"];
    if (avaName && ![avaName isEqualToString:@""]) {
        
    }
    self.nameLabel.text = [login.userInfo objectForKey:@"username"];
    self.companyLabel.text = [NSString stringWithFormat:@"%@%@",
                              [[login.userInfo objectForKey:@"city"] substringFromIndex:1],
                              [login.userInfo objectForKey:@"workname"]];
    self.moneyLabel.text = money==nil?@"0分":[NSString stringWithFormat:@"%@分",money];
    self.matchReg.text = formNum==nil?@"新增0张":[NSString stringWithFormat:@"新增%@张",formNum];
    self.toMeReg.text = myRegNum==nil?@"新增0张":[NSString stringWithFormat:@"新增%@张",myRegNum];
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

-(void)pushToForMeClientTable
{
    ForMeLoanClientTable *loanClientTable = [[ForMeLoanClientTable alloc] init];
    loanClientTable.data = self.shopClientData;
    [self.navigationController pushViewController:loanClientTable animated:YES];
}

-(void)goToPay
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"在线充值" message:@"因手机客户端暂未开通在线充值！\n您可以通过支付宝把充值的金额转入我公司支付宝账号：service@cardbaobao.com\n并及时通知为您服务的客户经理！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"进入支付宝", nil];
    [alert show];
}

#pragma mark - IBAction
//进入个人管理
-(IBAction)userManage
{
    UserManageView *um = [[UserManageView alloc] initWithStyle:UITableViewStyleGrouped];
    um.businessType = 1;
    [self.navigationController pushViewController:um animated:YES];
}

//上传名片
-(IBAction)pushUpload:(id)sender
{
    //未激活
    if (!active) {
        [SVProgressHUD showErrorWithStatus:@"您尚未激活该账户！\n速联系我们..." duration:0.789f];
        return;
    }
    UploadPicture *upload = [[UploadPicture alloc] init];
    upload.businessType = 1;
    [self.navigationController pushViewController:upload animated:YES];
}

-(IBAction)advisor:(id)sender
{
    //未激活
    if (!active) {
        [SVProgressHUD showErrorWithStatus:@"您尚未激活该账户！\n速联系我们..." duration:0.789f];
        return;
    }
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         @"0",@"year",
                         @"0",@"month",
                         @"1",@"pagenum",nil];
    [req loanAdvisorWithDic:dic];
}

//新客户表
-(IBAction)newClientAction
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = @{@"username":userInfo.username,@"password":userInfo.password,@"id":userInfo.ID};
    if (!self.appClientData) {
        [req loanNewClientsWithDic:dic];
    }
    else {
        [self pushToNewLoanClientTable];
    }
}

//对我申请
-(IBAction)forMeClientAction:(id)sender
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSInteger dpreg = [[userInfo.userInfo objectForKey:@"dpreg"] integerValue];
    if (dpreg == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无客户对我提交表单" duration:0.789f];
        return;
    }
    NSDictionary *dic = @{@"username":userInfo.username,@"password":userInfo.password,@"id":userInfo.ID};
    [req loanForMyShopWithDic:dic];
//    [self pushToForMeClientTable];
}

//已购买表
-(IBAction)doneClientAction
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = @{@"username":userInfo.username,@"password":userInfo.password,@"id":userInfo.ID};
    if (!self.doneClientData) {
        [req loanBuyersInfoWithDic:dic];
    }
    else {
        [self pushToDoneLoanClientTable];
    }
}


-(IBAction)lookChart
{
    if (!_statistic) {
        [SVProgressHUD showErrorWithStatus:@"获取不到统计数据！" duration:0.789f];
        return;
    }
    ChartView *cv = [[ChartView alloc] init];
    cv.businessType = 1;
    cv.statistics = _statistic;
    [self.navigationController pushViewController:cv animated:YES];
}

-(IBAction)thisMonthBuy
{
    
}

//充值记录
-(IBAction)payRecord
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = @{@"username":userInfo.username,@"password":userInfo.password,@"id":userInfo.ID,@"page":@"1"};
    [req loanPayRecordWithDic:dic];
}



-(IBAction)saleActivity:(id)sender
{
    WebViewController *web = [WebViewController new];
    web.title = @"优惠活动";
    web.url = @"http://192.168.1.32:8082/cardbaobao-3g/kbbywy/dkhd.html";
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - Request END
-(void)loginEnd:(id)aDic
{
    NSMutableDictionary *dic = [[aDic objectForKey:@"userlogin"] objectForKey:@"result"];
    if (dic.count) {
        UserInfo *loginInfo = [UserInfo shareInstance];
        loginInfo.userInfo = dic;
    }
    active = [[dic objectForKey:@"ifActive"] integerValue];
}

-(void)advisorEnd:(id)aDic
{
    NSMutableDictionary *dic = [aDic objectForKey:@"LoanslyServlet1"];
    if (dic) {
        LoanAdvisorView *lav = [LoanAdvisorView new];
        lav.data = [dic copy];
        [self.navigationController pushViewController:lav animated:YES];
    }
}

-(void)newLoanClientEnd:(id)aDic
{
    NSMutableDictionary *data = [aDic objectForKey:@"loansuserlogin18"];
    if (!data) {
        return;
    }
    if (![[data objectForKey:@"TotalRS"] intValue]) {
        [SVProgressHUD showErrorWithStatus:@"暂无新申请表" duration:0.789f];
        return;
    }
    self.appClientData = data;
    [self pushToNewLoanClientTable];
}

-(void)doneLoanClientEnd:(id)aDic
{
    NSMutableDictionary *data = [aDic objectForKey:@"loansuserlogin5"];
    if (!data) {
        return;
    }
    if (![[data objectForKey:@"TotalRS"] intValue]) {
        [SVProgressHUD showErrorWithStatus:@"未购买任何客户" duration:0.789f];
        return;
    }
    self.doneClientData = data;
    [self pushToDoneLoanClientTable];
}

-(void)forMeClientEnd:(id)aDic
{
    NSMutableDictionary *data = [aDic objectForKey:@"loansuserlogin17"];
    if (!data) {
        return;
    }
    self.shopClientData = data;
    [self pushToForMeClientTable];
}

-(void)payRecordEnd:(id)aDic
{
    NSMutableDictionary *data = nil;
    data = [aDic objectForKey:@"loansuserlogin7"];
    if (!data) {
        return;
    }
    if (![[data objectForKey:@"TotalRS"] intValue]) {
        [SVProgressHUD showErrorWithStatus:@"暂无充值记录" duration:0.789f];
        return;
    }
    PayRecordTable *pay = [[PayRecordTable alloc] init];
    pay.businessType = 1;
    pay.data = data;
    [self.navigationController pushViewController:pay animated:YES];
}

-(void)statisticEnd:(id)aDic
{
    [self updateDisplay];
    
    _statistic = [[[aDic objectForKey:@"DkServlet1"] objectForKey:@"result"] copy];
    UserInfo *loginInfo = [UserInfo shareInstance];
    [loginInfo.userInfo addEntriesFromDictionary:_statistic];
    
    NSString *askNum   = [_statistic objectForKey:@"zxnum"];
    NSString *tMontPay = [_statistic objectForKey:@"bycz"];
    NSString *success  = [_statistic objectForKey:@"success"];
    NSString *total    = [_statistic objectForKey:@"total"];
    
    CGFloat persent = 0;
    if (total && success && ![total isEqualToString:@"0"]) {
        int sInt = [success intValue];
        int tInt = [total intValue];
        persent = sInt/tInt*100;
    }
    self.askLabel.text = askNum==nil?@"0":askNum;
    self.successPercentLabel.text = [NSString stringWithFormat:@"%.1f%%",persent];
    self.doneNumLabel.text = total==nil?@"0":total;
    self.successNumLabel.text = success==nil?@"0":success;
    self.buyNumLabel.text = total==nil?@"0":total;
    self.payNumLabel.text = tMontPay==nil?@"0":tMontPay;
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
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *color = [UIColor darkGrayColor];
    doneUnit = [self.doneNumLabel addUnit:@"张" Font:font Color:color xOffset:2 yOffset:1];
    successUnit = [self.successNumLabel addUnit:@"张" Font:font Color:color xOffset:2 yOffset:1];
    buyUnit = [self.buyNumLabel addUnit:@"张" Font:font Color:color xOffset:2 yOffset:1];
    payUnit = [self.payNumLabel addUnit:@"元" Font:font Color:color xOffset:2 yOffset:1];
}
@end
