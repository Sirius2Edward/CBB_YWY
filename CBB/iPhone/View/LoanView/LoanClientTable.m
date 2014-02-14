//
//  LoanClientTable.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-14.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "LoanClientTable.h"
#import "CustomLabel.h"
#import "Request_API.h"
#import "ClientDetail.h"
#import "SVProgressHUD.h"

@implementation BaseLoanCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_loan.png"]];
        bg.frame = CGRectMake(7, 10, 306, 223);
        [self addSubview:bg];       
        
        NSArray *rectArr = [NSArray arrayWithObjects:
                            [NSValue valueWithCGRect:CGRectMake(95, 3, 206, 42)],
                            [NSValue valueWithCGRect:CGRectMake(95, 42, 206, 33)],
                            [NSValue valueWithCGRect:CGRectMake(95, 76, 206, 33.5)],
                            [NSValue valueWithCGRect:CGRectMake(95, 145, 206, 32)],
                            [NSValue valueWithCGRect:CGRectMake(235, 150, 70, 20)],nil];
        
        UILabel *label = nil;
        for (int i = 0; i < 5; i++) {
            label = [UILabel new];
            label.tag = 3000+i;
            label.backgroundColor = [UIColor clearColor];
            label.frame = [[rectArr objectAtIndex:i] CGRectValue];
            label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14];
            [bg addSubview:label];
        }
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

-(void)setItem:(LoanClient *)item
{
    NSArray *arr = [NSArray arrayWithObjects:item.Rt,item.worktype,item.loanmoney,item.yearmonth,item.adddate, nil];
    for (int i = 0; i < 5; i++) {
        UILabel *label = (CustomLabel*)[self viewWithTag:i+3000];
        label.text = [arr objectAtIndex:i];
    }
    for (int k = 0; k < 5; k++) {
        NSString *image = nil;
        if (k < item.Xing.integerValue) {
            image = @"xing01.png";
        }
        else {
            image = @"xing02.png";
        }
        UIImageView *xing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        xing.frame = CGRectMake(100+k*11, 130, 10, 10);
        [self addSubview:xing];
    }
}
@end

#pragma mark - 新申请客户Cell
@implementation NewLoanClientCell
{
    NSString *uid;
    NSString *orderID;
    NSArray *reasons;
    NSString *reason;
}
@synthesize controller;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *rectArr = [NSArray arrayWithObjects:
                            [NSValue valueWithCGRect:CGRectMake(11, 186.5, 103.5, 42)],
                            [NSValue valueWithCGRect:CGRectMake(115.5, 186.5, 88.5, 42)],
                            [NSValue valueWithCGRect:CGRectMake(205, 186.5, 104, 42)], nil];
        
        NSArray *selArr = [NSArray arrayWithObjects:@"detail",@"buyAction",@"deleteClient", nil];
        for (int j = 0; j < 3; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *buttonBG = [NSString stringWithFormat:@"x_%d.png",j+7];
            [button setBackgroundImage:[UIImage imageNamed:buttonBG] forState:0];
            [button addTarget:self action:NSSelectorFromString([selArr objectAtIndex:j]) forControlEvents:UIControlEventTouchUpInside];
            button.frame = [[rectArr objectAtIndex:j] CGRectValue];
            [self addSubview:button];
        }
        reasons = [NSArray arrayWithObjects:@"资料达不到标准",@"位置偏远",@"资料错误",@"其他",nil];
    }
    return self;
}

-(void)setItem:(LoanClient *)item
{
    [super setItem:item];
    uid = item.ID;
    orderID = item.orderid;
}

//查看详情
-(void)detail
{
    UserInfo *info = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         info.username,@"username",
                         info.password,@"password",
                         info.ID,@"id",
                         uid,@"uid",nil];
    Request_API *req = [Request_API shareInstance];
    req.delegate = self;
    [req loanClientInfoWithDic:dic];
}

-(void)loanNewDetail:(id)mDic
{
    NewLoanClientDetail *clientDetail = [[NewLoanClientDetail alloc] init];
    clientDetail.detailInfo = [[mDic objectForKey:@"PARSEloansuserlogin3"] objectForKey:@"result"];
    clientDetail.cell = self;
    [self.controller.navigationController pushViewController:clientDetail animated:YES];
}

-(void)loanBoughtDetail:(id)mDic
{
    DoneLoanClientDetail *clientDetail = [[DoneLoanClientDetail alloc] init];
    clientDetail.detailInfo = [[mDic objectForKey:@"PARSEloansuserlogin6"] objectForKey:@"result"];
    [self.controller.navigationController pushViewController:clientDetail animated:YES];
}
//购买
-(void)buyAction
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒您" message:@"本次购买将消费您的积分\n是否确定购买?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",nil];
//    alert.tag = 6600;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒您" message:@"请登录卡宝宝网站购买，卡贝贝正对此功能优化升级中！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

//删除
-(void)deleteClient
{
    reason = nil;
    SBTableAlert *alert = [[SBTableAlert alloc] initWithTitle:@"请选择删除原因" cancelButtonTitle:@"取消" messageFormat:nil];
    alert.style = SBTableAlertStyleApple;
    alert.delegate = self;
    alert.dataSource = self;
    [alert.view addButtonWithTitle:@"确定"];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        return;
    }
    if (alertView.tag == 6600) {
        UserInfo *info = [UserInfo shareInstance];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             info.username,@"username",
                             info.password,@"password",
                             info.ID,@"id",
                             uid,@"uid",nil];
        Request_API *req = [Request_API shareInstance];
        req.delegate = self;
        [req loanBuyApplicationWithDic:dic];
    }
    else if (alertView.tag == 6601){
        NSString *content = [alertView textFieldAtIndex:0].text;
        if ([content isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"输入原因才能删除！" duration:1.5f];
        }
        else
        {
            UserInfo *info = [UserInfo shareInstance];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 info.username,@"username",
                                 info.password,@"password",
                                 info.ID,@"id",
                                 orderID,@"orderid",
                                 content,@"content",nil];
            Request_API *req = [Request_API shareInstance];
            req.delegate = self;
            [req loanDeleteClientWithDic:dic];
        }
    }
    else if (alertView.tag == 6602) {
        if (buttonIndex == 1) {
            //查看客户详情
            UserInfo *info = [UserInfo shareInstance];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 info.username,@"username",
                                 info.password,@"password",
                                 info.ID,@"id",
                                 uid,@"uid",nil];
            Request_API *req = [Request_API shareInstance];
            req.delegate = self;
            [req loanBuyerDetailWithDic:dic];
        }
        else {
            //已购买客户表
            UserInfo *userInfo = [UserInfo shareInstance];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userInfo.username,@"username",
                                 userInfo.password,@"password",
                                 userInfo.ID,@"id", nil];
            Request_API *req = [Request_API shareInstance];
            req.delegate = self;
            [req loanBuyersInfoWithDic:dic];
        }
    }
}

-(void)buyClient:(id)mDic
{
    NSString *result = [[mDic objectForKey:@"PARSEloansuserlogin4"] objectForKey:@"result"];
    if (!result) {
        return;
    }
    //购买成功
    [self removeCell];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看客户详情",@"已购买客户表",nil];
    alert.tag = 6602;
    [alert show];
}

-(void)delClient:(id)mDic
{
    if (![mDic objectForKey:@"PARSEloansuserlogin14"]) {
        return;
    }
    [self removeCell];
}

-(void)removeCell
{
    NSIndexPath *indexPath = [self.controller.tableView indexPathForCell:self];
    [self.controller.items removeObjectAtIndex:indexPath.row];
    [self.controller.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self.controller.tableView indexPathForCell:self]]
                                     withRowAnimation:UITableViewRowAnimationRight];
}

-(void)doneLoanClientEnd:(id)aDic
{
    NSMutableDictionary *data = [aDic objectForKey:@"PARSEloansuserlogin5"];
    if (!data) {
        return;
    }
    DoneLoanClientTable *loanClientTable = [[DoneLoanClientTable alloc] init];
    loanClientTable.data = data;
    [self.controller.navigationController pushViewController:loanClientTable animated:YES];
}

#pragma mark - SBTableAlertDataSource
- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[SBTableAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	[cell.textLabel setText:[reasons objectAtIndex:indexPath.row]];
	return cell;
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section
{
    return reasons.count;
}

#pragma mark - SBTableAlertDelegate
- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    reason = [reasons objectAtIndex:indexPath.row];
}

- (void)tableAlert:(SBTableAlert *)tableAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex) {
        if (!reason) {
            [SVProgressHUD showErrorWithStatus:@"输入原因才能删除！" duration:1.5f];
        }
        else if ([reason isEqualToString:@"其他"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入删除原因"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 6601;
            [alert textFieldAtIndex:0].placeholder = @"输入删除原因";
            [alert show];
        }
        else {
            UserInfo *info = [UserInfo shareInstance];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 info.username,@"username",
                                 info.password,@"password",
                                 info.ID,@"id",
                                 orderID,@"orderid",
                                 reason,@"content",nil];
            Request_API *req = [Request_API shareInstance];
            req.delegate = self;
            [req loanDeleteClientWithDic:dic];
        }
    }
}
@end

#pragma mark - 已购买客户Cell
@implementation DoneLoanClientCell
{
    NSString *uid;
}
@synthesize controller;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"detail01.png"] forState:0];
        [button setBackgroundImage:[UIImage imageNamed:@"detail02.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(11.5, 186.5, 297, 42);
        [self addSubview:button];
    }
    return self;
}

-(void)setItem:(LoanClient *)item
{
    [super setItem:item];
    uid = item.ID;
}

//查看详情
-(void)detail
{
    UserInfo *info = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         info.username,@"username",
                         info.password,@"password",
                         info.ID,@"id",
                         uid,@"uid",nil];
    Request_API *req = [Request_API shareInstance];
    req.delegate = self;
    [req loanBuyerDetailWithDic:dic];
}

-(void)loanBoughtDetail:(id)mDic
{
    DoneLoanClientDetail *clientDetail = [[DoneLoanClientDetail alloc] init];
    clientDetail.detailInfo = [[mDic objectForKey:@"PARSEloansuserlogin6"] objectForKey:@"result"];
    [self.controller.navigationController pushViewController:clientDetail animated:YES];
}
@end


#pragma mark - table -
@interface NewLoanClientTable ()
{
    Request_API *req;
    NSMutableDictionary *_data;
    NSMutableDictionary *param;
}
@end
@implementation NewLoanClientTable
@synthesize data = _data;
@synthesize items;
@synthesize page;
- (id)init
{
    self = [super init];
    if (self) {
        req = [Request_API shareInstance];
        UserInfo *userInfo = [UserInfo shareInstance];
        param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 userInfo.username,@"username",
                 userInfo.password,@"password",
                 userInfo.ID,@"id", nil];
    }
    return self;
}

-(void)setData:(NSMutableDictionary *)data
{
    _data = data;
    self.items = [NSMutableArray arrayWithArray:[data objectForKey:@"UL"]];
    self.page = [[self.data objectForKey:@"Page"] integerValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setBackgroundImage:[UIImage imageNamed:@"sift.png"] forState:0];
    [barButton sizeToFit];
    [barButton addTarget:self action:@selector(pushToSift:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    self.title = @"新客户申请表";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)pushToSift:(UIButton *)sender
{
    LoanClientSift *sift = [[LoanClientSift alloc] init];
    sift.delegate = self;
    [self.navigationController pushViewController:sift animated:YES];
}


-(void)changeSiftPara:(NSMutableDictionary *)aDic Data:(NSDictionary *)data
{
    param = nil;
    UserInfo *userInfo = [UserInfo shareInstance];
    param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
             userInfo.username,@"username",
             userInfo.password,@"password",
             userInfo.ID,@"id", nil];
    [param addEntriesFromDictionary:aDic];
    [self.items setArray:[data objectForKey:@"UL"]];
    self.page = 1;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    NewLoanClientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[NewLoanClientCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.controller = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = [self.items objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark -

//刷新数据
- (void)reloadTableViewDataSource
{
    [super reloadTableViewDataSource];
    req.delegate = self;
    [req loanNewClientsWithDic:param];
}

//请求更多数据
- (void)loadNextTableViewDataSource
{
    [super loadNextTableViewDataSource];
    if (self.page < [[self.data objectForKey:@"TotalPage"] integerValue]) {
        self.page ++;
 
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
        [dic setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
        req.delegate = self;
        [req loanNewClientsWithDic:dic];
    }
    else {
        [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];//线程安全
    }
}

-(void)newLoanClientEnd:(id)aDic
{
    NSDictionary *dic = [aDic objectForKey:@"PARSEloansuserlogin2"];
    if ([[dic objectForKey:@"Page"] integerValue] == 1) {
        self.page = 1;
        [self.items setArray:[dic objectForKey:@"UL"]];
    }
    else {
        [self.items addObjectsFromArray:[dic objectForKey:@"UL"]];
    }
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2f];
}

-(void)popAction
{
    [self.data setObject:self.items forKey:@"UL"];
    [self.data setObject:[NSString stringWithFormat:@"%d",page] forKey:@"Page"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end



@interface DoneLoanClientTable ()
{
    Request_API *req;
    NSMutableDictionary *_data;
}
@end
@implementation DoneLoanClientTable
@synthesize data = _data;
@synthesize items;
@synthesize page;
- (id)init
{
    self = [super init];
    if (self) {
        req = [Request_API shareInstance];
    }
    return self;
}

-(void)setData:(NSMutableDictionary *)data
{
    _data = data;
    self.items = [NSMutableArray arrayWithArray:[data objectForKey:@"UL"]];
    self.page = [[self.data objectForKey:@"Page"] integerValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"正在受理客户表";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    DoneLoanClientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[DoneLoanClientCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.controller = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = [self.items objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark -

//刷新数据
- (void)reloadTableViewDataSource
{
    [super reloadTableViewDataSource];
    
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         userInfo.ID,@"id", nil];
    req.delegate = self;
    [req loanBuyersInfoWithDic:dic];
}

//请求更多数据
- (void)loadNextTableViewDataSource
{
    [super loadNextTableViewDataSource];
    if (self.page < [[self.data objectForKey:@"TotalPage"] integerValue]) {
        self.page ++;
        UserInfo *userInfo = [UserInfo shareInstance];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             userInfo.username,@"username",
                             userInfo.password,@"password",
                             userInfo.ID,@"id",
                             [NSString stringWithFormat:@"%d",self.page] ,@"page",nil];
        req.delegate = self;
        [req loanBuyersInfoWithDic:dic];
    }
    else {
        [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];//线程安全
    }
}

-(void)doneLoanClientEnd:(id)aDic
{
    NSDictionary *dic = [aDic objectForKey:@"PARSEloansuserlogin5"];
    if ([[dic objectForKey:@"Page"] integerValue] == 1) {
        self.page = 1;
        [self.items setArray:[dic objectForKey:@"UL"]];
    }
    else {
        [self.items addObjectsFromArray:[dic objectForKey:@"UL"]];
    }
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2f];
}

-(void)popAction
{
    [self.data setObject:self.items forKey:@"UL"];
    [self.data setObject:[NSString stringWithFormat:@"%d",page] forKey:@"Page"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

#pragma mark -
@interface LoanClientTable ()
@end
@implementation LoanClientTable
@end
