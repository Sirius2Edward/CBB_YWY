//
//  CardClientTable.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-14.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "CardClientTable.h"
#import "CustomLabel.h"
#import "Request_API.h"
#import "ClientDetail.h"
#import "UIColor+TitleColor.h"
#import "SVProgressHUD.h"
#import "WebViewController.h"

@implementation BaseCardCell
{
    UIImageView *level;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *rectArr = [NSArray arrayWithObjects:
                            [NSValue valueWithCGRect:CGRectMake(7, 10, 306, 42)],
                            [NSValue valueWithCGRect:CGRectMake(7, 52, 306, 33)],
                            [NSValue valueWithCGRect:CGRectMake(7, 85, 306, 33.5)],
                            [NSValue valueWithCGRect:CGRectMake(7, 152, 306, 32)],
                            [NSValue valueWithCGRect:CGRectMake(195, 160, 110, 20)],
                            [NSValue valueWithCGRect:CGRectMake(7, 118.5, 306, 33.5)],
                            [NSValue valueWithCGRect:CGRectMake(7, 184, 306, 49)], nil];
        
        CustomLabel *label = nil;
        for (int i = 0; i < 4; i++) {
            label = [CustomLabel new];
            label.tag = 3000+i;
            label.backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"x_%d.png",i+1]];
            label.numberOfLines = 1;
            label.insets = UIEdgeInsetsMake(5, 90, 0, 10);
            label.frame = [[rectArr objectAtIndex:i] CGRectValue];
            [self addSubview:label];
        }
        
        UILabel *date = [UILabel new];
        date.textAlignment = NSTextAlignmentRight;
        date.tag = 3004;
        date.backgroundColor = [UIColor clearColor];
        date.textColor = [UIColor darkGrayColor];
        date.font = [UIFont systemFontOfSize:12];
        date.frame = [[rectArr objectAtIndex:4] CGRectValue];
        [self addSubview:date];        
        
        level = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"x_5.png"]]];
        level.frame = [[rectArr objectAtIndex:5] CGRectValue];
        [self addSubview:level];
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x_6.png"]];
        bg.frame = [[rectArr objectAtIndex:6] CGRectValue];
        bg.userInteractionEnabled = YES;
        [self addSubview:bg];
    }
    return self;
}

-(void)setItem:(CardClient *)item
{
    NSArray *arr = [NSArray arrayWithObjects:item.orderid,item.CardName,item.Address,item.LL,item.Date, nil];
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
        xing.frame = CGRectMake(90+k*11, 12, 10, 10);
        [level addSubview:xing];
    }
}
@end

///////////////
@implementation NewCardClientCell
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
        reasons = [NSArray arrayWithObjects:@"资料达不到标准",@"位置偏远",@"资料错误",@"有本行信用卡",@"其他",nil];
    }
    return self;
}

-(void)setItem:(CardClient *)item
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
    [req cardClientInfoWithDic:dic];
}

-(void)cardNewDetail:(id)mDic
{
    NewCardClientDetail *clientDetail = [[NewCardClientDetail alloc] init];
    clientDetail.detailInfo = [[mDic objectForKey:@"PARSEcarduserlogin3"] objectForKey:@"result"];
    clientDetail.cell = self;
    [self.controller.navigationController pushViewController:clientDetail animated:YES];
}

-(void)cardBoughtDetail:(id)mDic
{
    DoneCardClientDetail *clientDetail = [[DoneCardClientDetail alloc] init];
    clientDetail.detailInfo = [[mDic objectForKey:@"PARSEcarduserlogin6"] objectForKey:@"result"];
    [self.controller.navigationController pushViewController:clientDetail animated:YES];
}

//购买
-(void)buyAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒您" message:@"本次购买将消费您的积分\n是否确定购买?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",nil];
    alert.tag = 6600;
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
        [req cardBuyApplicationWithDic:dic];
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
            [req cardDeleteClientWithDic:dic];
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
            [req cardBuyerDetailWithDic:dic];
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
            [req cardBuyersInfoWithDic:dic];
        }
    }
}

-(void)buyClient:(id)mDic
{
    NSString *result = [[mDic objectForKey:@"PARSEcarduserlogin4"] objectForKey:@"result"];
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
    if (![mDic objectForKey:@"PARSEcarduserlogin14"]) {
        return;
    }
    [self removeCell];
}

-(void)removeCell
{
    NSIndexPath *indexPath = [self.controller.tableView indexPathForCell:self];
    [self.controller.items removeObjectAtIndex:indexPath.row];
    [self.controller.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self.controller.tableView indexPathForCell:self]]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)doneCardClientEnd:(id)aDic
{
    NSMutableDictionary *data = [aDic objectForKey:@"PARSEcarduserlogin5"];
    if (!data) {
        return;
    }
    DoneCardClientTable *cardClientTable = [[DoneCardClientTable alloc] init];
    cardClientTable.data = data;
    [self.controller.navigationController pushViewController:cardClientTable animated:YES];
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

- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert
{
    return 1;
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
            [req cardDeleteClientWithDic:dic];
        }
    }
}
@end

CustomPicker *picker;
UIButton *statusButton;
///////////////////
@implementation DoneCardClientCell
{
    NSString *uid;
    UIButton *ztBtn;
}
@synthesize controller;
@synthesize statusList;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailBtn setBackgroundImage:[UIImage imageNamed:@"cha01.png"] forState:0];
        [detailBtn setBackgroundImage:[UIImage imageNamed:@"cha02.png"] forState:UIControlStateHighlighted];
        [detailBtn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        detailBtn.frame = CGRectMake(11, 186.5, 148, 42);
        [self addSubview:detailBtn];
        
        ztBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ztBtn setBackgroundImage:[UIImage imageNamed:@"status_up.png"] forState:0];
        [ztBtn setBackgroundImage:[UIImage imageNamed:@"status_down.png"] forState:UIControlStateHighlighted];
        [ztBtn setBackgroundImage:[UIImage imageNamed:@"status_down.png"] forState:UIControlStateSelected];
        [ztBtn setTitleColor:[UIColor titleColor] forState:0];
        ztBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
        [ztBtn addTarget:self action:@selector(statusAction:) forControlEvents:UIControlEventTouchUpInside];
        ztBtn.frame = CGRectMake(161, 186.5, 148, 42);
        [self addSubview:ztBtn];
    }
    return self;
}

-(void)setItem:(CardClient *)item
{
    [super setItem:item];
    uid = item.ID;
    [ztBtn setTitle:[[self.statusList allKeysForObject:item.zt] objectAtIndex:0] forState:0];
}

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
    [req cardBuyerDetailWithDic:dic];
}

-(void)cardBoughtDetail:(id)mDic
{
    DoneCardClientDetail *clientDetail = [[DoneCardClientDetail alloc] init];
    clientDetail.detailInfo = [[mDic objectForKey:@"PARSEcarduserlogin6"] objectForKey:@"result"];
    [self.controller.navigationController pushViewController:clientDetail animated:YES];
}

-(void)statusAction:(UIButton *)sender
{
    if (picker) {
        [picker removeFromSuperview];        
    }
    picker = [[CustomPicker alloc] initWithFrame:CGRectMake(0, self.controller.view.frame.size.height-260, 320, 260)];

    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"UID", nil];
    picker.userInfo = info;
    picker.components = 1;
    picker.data = self.statusList;
    picker.delegate = self.controller;
    [picker showPickerInView:self.controller.view];
    statusButton.selected = NO;
    statusButton.userInteractionEnabled = YES;
    statusButton = sender;
    statusButton.userInteractionEnabled = NO;
    statusButton.selected = YES;
}
@end

#pragma mark - Table -
@implementation CardClientTable
@end


@interface NewCardClientTable ()
{
    Request_API *req;
    NSMutableDictionary *_data;
    NSMutableDictionary *param;
    CYCustomMultiSelectPickerView *multiPickerView;
}
@end

@implementation NewCardClientTable
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
    
    //区域筛选按钮
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
    CardClientSift *sift = [[CardClientSift alloc] init];
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

-(void)pushToWeb:(UIButton *)sender
{
    WebViewController *web = [WebViewController new];
    web.title = @"优惠活动";
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    header.backgroundColor = self.tableView.backgroundColor;
    header.alpha = 0.85f;
    
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 115, 15)];
    label.text = @"卡贝贝专属福利！";
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(153, 10, 160, 15)];
    label.text = @"第一次使用卡贝贝购买表";
    label.textColor = [UIColor titleColor];
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 125, 15)];
    label.text = @"单送20分，再9折。";
    label.textColor = [UIColor titleColor];
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(175, 30, 110, 15)];
    label.text = @"点此查看详情 》";
    label.textColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(pushToWeb:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(5, 5, 310, 39);
    [header addSubview:btn];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

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
    NewCardClientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[NewCardClientCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.controller = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = [self.items objectAtIndex:indexPath.row];
    return cell;
}

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
    [req cardNewClientsWithDic:dic];
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
        [req cardNewClientsWithDic:dic];        
    }
    else {
        [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];//线程安全
    }
}

-(void)newCardClientEnd:(id)aDic
{
    NSDictionary *dic = [aDic objectForKey:@"PARSEcarduserlogin2"];
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


@implementation DoneCardClientTable
{
    Request_API *req;
    NSMutableDictionary *_data;
    ListView *view;
    ListButton *button;
    NSMutableArray *resultList;
}
@synthesize data = _data;
@synthesize items;
@synthesize page;
@synthesize zts;
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
    self.zts = [data objectForKey:@"ZTS"];
    resultList = [NSMutableArray arrayWithArray:self.items];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    button = [[ListButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    [button addTarget:self action:@selector(list:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    view = [[ListView alloc] initWithStat:[NSArray arrayWithObjects:@"已购买客户",@"未联系",@"已联系待办",@"已上门",
                                           @"已联系条件不符",@"已上门条件不符",@"已办理",@"已查阅条件不符", nil]];
    view.frame = CGRectMake(90, 5, 148, 0);
    view.delegate = self;
    [self.view addSubview:view];
}

-(void)list:(UIBarButtonItem *)sender
{
    if (view.isShow) {
        [view closeList];
    }
    else {
        [view showList];
    }
}

-(void)changeTitleAndSift:(NSString *)title
{
    [button setTitle:title];
    
    if ([title isEqualToString:@"已购买客户"]) {
        [resultList setArray:self.items];
    }
    else {
        NSString *zt = [self.zts objectForKey:title];
        [resultList removeAllObjects];
        for (CardClient *item in self.items) {
            if ([item.zt isEqualToString:zt]) {
                [resultList addObject:item];
            }
        }
    }
    [self.tableView reloadData];
    [self setFooterView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    DoneCardClientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[DoneCardClientCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.controller = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.statusList = self.zts;
    cell.item = [resultList objectAtIndex:indexPath.row];
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
    [req cardBuyersInfoWithDic:dic];
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
        [req cardBuyersInfoWithDic:dic];
    }
    else {
        [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];//线程安全
    }
}

-(void)doneCardClientEnd:(id)aDic
{
    NSDictionary *dic = [aDic objectForKey:@"PARSEcarduserlogin5"];
    if ([[dic objectForKey:@"Page"] integerValue] == 1) {
        self.page = 1;
        [self.items setArray:[dic objectForKey:@"UL"]];
    }
    else {
        [self.items addObjectsFromArray:[dic objectForKey:@"UL"]];
    }
    
    
    if ([button.title isEqualToString:@"已购买客户"]) {
        [resultList setArray:self.items];
    }
    else {
        NSString *zt = [self.zts objectForKey:button.title];
        [resultList removeAllObjects];
        for (CardClient *item in self.items) {
            if ([item.zt isEqualToString:zt]) {
                [resultList addObject:item];
            }
        }
    }
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2f];
}

-(void)popAction
{
    [self.data setObject:self.items forKey:@"UL"];
    [self.data setObject:[NSString stringWithFormat:@"%d",page] forKey:@"Page"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)confirmAction:(NSString *)value WithInfo:(NSDictionary *)info
{
    statusButton.selected = NO;
    statusButton.userInteractionEnabled = YES;
    if ([[statusButton titleForState:0] isEqualToString:value]) {
        return;
    }
    [statusButton setTitle:value forState:0];
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         userInfo.ID,@"id",
                         [info objectForKey:@"UID"],@"uid",
                         [self.zts objectForKey:value],@"zt",nil];
    req.delegate = self;
    [req cardZTChangeWithDic:dic];
}

-(void)ztChangeEnd:(id)aDic{}
-(void)selectAction:(NSString *)value{}
@end
