//

#import "UserManageView.h"
#import "CardInfoModify.h"
#import "LoanInfoModify.h"
#import "PWDModify.h"
#import "AreaSift.h"
#import "Request_API.h"
#import "SVProgressHUD.h"
#import "UIColor+TitleColor.h"
#import "Login.h"

@interface UserManageView ()
{
    NSMutableArray *items;
    NSMutableArray *pushAcitons;
    NSDictionary *areaList;
    Request_API *req;
    NSInteger active;
}
@end

@implementation UserManageView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        items = [NSMutableArray arrayWithObjects://@"推送服务开关",
                                    @"基本资料修改",@"密码修改", nil];//@"意见反馈",@"关于我们",
        pushAcitons = [NSMutableArray arrayWithObjects:@"pushModifyInfo",
                       @"pushModifyPWD", nil];//@"feedBack",@"aboutUs",
        req = [Request_API shareInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.scrollEnabled = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    self.title = @"账号管理";
    //返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backBarButton.frame = CGRectMake(0, 0, 51, 33);
    [backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    
    // 隐藏多余分隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    if (self.businessType) {
        active = [[[UserInfo shareInstance].userInfo objectForKey:@"ifActive"] integerValue];
    }
    else {
        [items insertObject:@"可服务区域" atIndex:2];
        [pushAcitons insertObject:@"areaSel" atIndex:2];
        active = [[[UserInfo shareInstance].userInfo objectForKey:@"mem_ifActive"] integerValue];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)popAction
{
    [req cancel];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [items objectAtIndex:indexPath.row];
//        if (indexPath.row == 0) {
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            UISwitch *swch = [[UISwitch alloc] initWithFrame:CGRectMake(255, 7, 50, 30)];
//            swch.onTintColor = [UIColor titleColor];
//            [swch addTarget:self action:@selector(pushServiceChange:) forControlEvents:UIControlEventValueChanged];
//            [cell.contentView addSubview:swch];
//        }
    }
    else {
        cell.textLabel.text = @"退出账号";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor titleColor];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        SuppressPerformSelectorLeakWarning([self performSelector:NSSelectorFromString([pushAcitons objectAtIndex:indexPath.row])]);
    }
    else {
        [self resign];
    }
}

#pragma mark - PUSH
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

//区域选择
-(void)areaSel
{
    //未激活
    if (!active) {
        [SVProgressHUD showErrorWithStatus:@"您尚未激活该账户！\n速联系我们..." duration:0.789f];
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
    areaList = [[mDic objectForKey:@"carduserlogin11"] objectForKey:@"QL"];
    if (areaList) {
        [self pushToAreaSift];
    }
}

-(void)pushToAreaSift
{
    AreaSift *area = [[AreaSift alloc] init];
    area.areaList = areaList;
    [self.navigationController pushViewController:area animated:YES];
}

-(void)feedBack{}
-(void)aboutUs{}

//推送服务开关
-(void)pushServiceChange:(UISwitch *)sender
{
    if (sender.on) {
//        NSLog(@"on");
    }
    else {
//        NSLog(@"off");
    }
}

//安全退出
-(void)resign
{
    //清空登陆数据，返回登陆界面
    [[UserInfo shareInstance] clearInfo];
    Login *login = [[Login alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:login] animated:YES];
}
@end
