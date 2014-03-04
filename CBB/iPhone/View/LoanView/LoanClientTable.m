//
#import "LoanClientTable.h"
#import "CustomLabel.h"
#import "Request_API.h"
#import "ClientDetail.h"
#import "SVProgressHUD.h"
#import "UIColor+TitleColor.h"
#import "WebViewController.h"

@implementation BaseLoanCell
{
    UILabel *nameLabel;
    UILabel *amountLabel;
    UILabel *adDateLabel;
}
@synthesize bg;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        UIImage *bgImg = [UIImage imageNamed:@"loanCell_bg.png"];
        bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(100, 0, 20, 0)];
        bg = [[UIImageView alloc] initWithImage:bgImg];
        [self.contentView addSubview:bg];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 200, 20)];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [bg addSubview:nameLabel];
        
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 29, 150, 20)];
        amountLabel.font = [UIFont systemFontOfSize:14];
        [bg addSubview:amountLabel];
        
        adDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 29, 120, 20)];
        adDateLabel.textAlignment = NSTextAlignmentRight;
        adDateLabel.font = [UIFont systemFontOfSize:13];
        adDateLabel.textColor = [UIColor grayColor];
        [bg addSubview:adDateLabel];
    }
    return self;
}

-(void)setItem:(LoanClient *)item
{

    nameLabel.text = [NSString stringWithFormat:@"%@(%@)",item.username,item.usersex];
    amountLabel.text = [NSString stringWithFormat:@"贷%@万",item.loanmoney];
    adDateLabel.text = item.adddate;
}
@end

#pragma mark - 新申请客户Cell
@implementation NewLoanClientCell
{
    NSString *uid;
    NSString *orderID;
    UILabel *usageLabel;
    UILabel *identLabel;
    UILabel *infoLabel;
    UILabel *oriPriceLabel;
    UILabel *dscPriceLabel;
    UIButton *buyButton;
    UIProgressView *grade;
}
@synthesize controller;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"iponeV3btn002.png"] forState:UIControlStateNormal];
        delBtn.frame = CGRectMake(285, 23, 10, 10);
        [delBtn addTarget:self action:@selector(deleteClient) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
        
        NSArray *arr = @[@"贷款用途：",@"职业身份：",@"客户资质：",@"手 机 号 ："];
        CGFloat yCo = 60;
        for (int i = 0; i < arr.count; i++) {
            UILabel *itemL = [[UILabel alloc] initWithFrame:CGRectMake(30, yCo, 80, 25)];
            itemL.font = [UIFont systemFontOfSize:15];
            itemL.textColor = [UIColor darkGrayColor];
            itemL.text = [arr objectAtIndex:i];
            [self.contentView addSubview:itemL];
            yCo += 25;
        }
        
        usageLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 180, 25)];
        usageLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:usageLabel];
        
        identLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 85, 180, 25)];
        identLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:identLabel];
        
        grade = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        grade.frame = CGRectMake(110, 122, 100, 30);
        [self.contentView addSubview:grade];
        
        buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.hidden = YES;
        buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [buyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.contentView addSubview:buyButton];
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 138, 100, 20)];
        infoLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:infoLabel];
        
        oriPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 158, 100, 20)];
        [self.contentView addSubview:oriPriceLabel];
        
        dscPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 178, 100, 20)];
        dscPriceLabel.font = [UIFont systemFontOfSize:15];
        dscPriceLabel.textColor = [UIColor titleColor];
        dscPriceLabel.text = @"折后：2.7分";
        [self.contentView addSubview:dscPriceLabel];
        
        uid = [UserInfo shareInstance].ID;
    }
    return self;
}

-(void)setItem:(LoanClient *)item
{
    [super setItem:item];
    orderID = item.ID;
    usageLabel.text = item.Rt;
    identLabel.text = item.worksf;
    if (item.Xing.intValue>3) {
        grade.progressTintColor = [UIColor greenColor];
    }
    else {
        grade.progressTintColor = [UIColor orangeColor];
    }
    grade.progress = item.Xing.floatValue/6;
    NSDictionary *usi = [UserInfo shareInstance].userInfo;
    buyButton.hidden = NO;
    self.bg.frame = CGRectMake(10, 5, 300, 161);
    if (![[usi objectForKey:@"ifActive"] isEqualToString:@"1"]) {//未认证
        infoLabel.hidden = YES;
        oriPriceLabel.hidden = YES;
        dscPriceLabel.hidden = YES;
        buyButton.frame = CGRectMake(110, 135, 100, 25);
        [buyButton setTitle:@"认证后免费抢" forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(authorAlert) forControlEvents:UIControlEventTouchUpInside];
        return;
    }
    if ([[usi objectForKey:@"dpset"] isEqualToString:@"1"]) {   //已开通店铺
        buyButton.frame = CGRectMake(200, 173, 50, 30);
        [buyButton setTitle:@"购买" forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        if (item.buynum.integerValue < 5) {//免费抢
            infoLabel.hidden = YES;
            oriPriceLabel.hidden = YES;
            dscPriceLabel.hidden = YES;
            buyButton.frame = CGRectMake(110, 135, 100, 25);
            [buyButton setTitle:@"免费抢" forState:UIControlStateNormal];
        }
        else if (item.buynum.integerValue == 10){//已购买5次
            infoLabel.hidden = NO;
            oriPriceLabel.hidden = YES;
            dscPriceLabel.hidden = YES;
            infoLabel.text = @"已购买5次";
            buyButton.hidden = YES;
        }
        else {       //被买x次
            self.bg.frame = CGRectMake(10, 5, 300, 200);
            infoLabel.hidden = NO;
            oriPriceLabel.hidden = NO;
            dscPriceLabel.hidden = NO;
            if (item.buynum.integerValue == 5) {
                infoLabel.text = @"您来晚了";
            }
            else {
                infoLabel.text = [NSString stringWithFormat:@"被买%d次",item.buynum.integerValue-5];
            }
            if ([item.worksf isEqualToString:@"上班族"] || [item.worksf isEqualToString:@"无固定职业"]) {
                oriPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@"原价：10分"
                                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                            NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                            NSStrikethroughStyleAttributeName:@2}];
            }
            else {
                oriPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:@"原价：30分"
                                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                            NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                            NSStrikethroughStyleAttributeName:@2}];
            }
        }
        
    }
    else {  //未开通店铺
        infoLabel.hidden = YES;
        oriPriceLabel.hidden = YES;
        dscPriceLabel.hidden = YES;
        buyButton.frame = CGRectMake(110, 135, 100, 25);
        [buyButton setTitle:@"免费抢" forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
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
    clientDetail.detailInfo = [[mDic objectForKey:@"loansuserlogin3"] objectForKey:@"result"];
    clientDetail.cell = self;
    [self.controller.navigationController pushViewController:clientDetail animated:YES];
}

-(void)loanBoughtDetail:(id)mDic
{
    DoneLoanClientDetail *clientDetail = [[DoneLoanClientDetail alloc] init];
    clientDetail.detailInfo = [[mDic objectForKey:@"loansuserlogin6"] objectForKey:@"result"];
    [self.controller.navigationController pushViewController:clientDetail animated:YES];
}

//
-(void)authorAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录卡宝宝网站认证！\n客户端暂不支持认证..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

//购买
-(void)buyAction:(UIButton *)sender
{
    UserInfo *info = [UserInfo shareInstance];
    if (![[info.userInfo objectForKey:@"dpset"] isEqualToString:@"1"] &&
        [[info.userInfo objectForKey:@"qnum"] isEqualToString:@"3"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"抱歉，您未开通店铺，所以只能免费抢3次表单，电脑登录卡宝宝网开通店铺吧！"
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"免费抢"]) {
        NSDictionary *dic = @{@"username":info.username, @"password":info.password, @"id":info.ID, @"uid":uid};
        Request_API *req = [Request_API shareInstance];
        req.delegate = self;
        [req loanBuyApplicationWithDic:dic];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定购买?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",nil];
        alert.tag = 6600;
        [alert show];
    }
}

//删除
-(void)deleteClient
{
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"请选择删除原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"其他" otherButtonTitles:@"资料达不到标准",@"位置偏远",@"资料错误", nil];
    [alert showInView:self.controller.view];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        return;
    }
    if (alertView.tag == 6600) {
        UserInfo *info = [UserInfo shareInstance];
        NSDictionary *dic = @{@"username":info.username, @"password":info.password, @"id":info.ID, @"uid":uid};
        Request_API *req = [Request_API shareInstance];
        req.delegate = self;
        [req loanBuyApplicationWithDic:dic];
    }
    else if (alertView.tag == 6601){
        NSString *content = [alertView textFieldAtIndex:0].text;
        if ([content isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"输入原因才能删除！" duration:0.789f];
        }
        else
        {
            UserInfo *info = [UserInfo shareInstance];
            NSDictionary *dic = @{@"username":info.username, @"password":info.password,@"id":info.ID,
                                  @"orderid":orderID,@"content":content};
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
    NSString *result = [[mDic objectForKey:@"loansuserlogin4"] objectForKey:@"result"];
    if (!result) {
        return;
    }
    //购买成功
    [self removeCell];
    
    NSDictionary *usi = [UserInfo shareInstance].userInfo;
    if ([[usi objectForKey:@"dpset"] isEqualToString:@"1"]) {
        
    }
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看客户详情",@"已购买客户表",nil];
    alert.tag = 6602;
    [alert show];
}

-(void)delClient:(id)mDic
{
    if (![mDic objectForKey:@"loansuserlogin14"]) {
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
    NSMutableDictionary *data = [aDic objectForKey:@"loansuserlogin5"];
    if (!data) {
        return;
    }
    DoneLoanClientTable *loanClientTable = [[DoneLoanClientTable alloc] init];
    loanClientTable.data = data;
    [self.controller.navigationController pushViewController:loanClientTable animated:YES];
}


#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *reason = [actionSheet buttonTitleAtIndex:buttonIndex];
	if (buttonIndex != 4) {
        if ([reason isEqualToString:@"其他"]){
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
    clientDetail.detailInfo = [[mDic objectForKey:@"loansuserlogin6"] objectForKey:@"result"];
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

-(void)pushToWeb:(UIButton *)sender
{
    WebViewController *web = [WebViewController new];
    web.title = @"优惠活动";
    web.url = @"http://192.168.1.32:8082/cardbaobao-3g/kbbywy/dkhd.html";
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    header.backgroundColor = self.tableView.backgroundColor;
    header.alpha = 0.85f;
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iponeV3img001.png"]];
    imgV.frame = CGRectMake(2, 2, 52, 42);
    [header addSubview:imgV];
    
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 115, 15)];
    label.text = @"大福利：客户表可";
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(168, 10, 42, 15)];
    label.text = @"免费抢";
    label.textColor = [UIColor titleColor];
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 125, 15)];
    label.text = @"了，次数满则需";
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(55, 30, 170, 15)];
    label.text = @"购买，价格也有折上折喔！";
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(220, 30, 80, 15)];
    label.text = @"详细介绍 》";
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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
    NSDictionary *usi = [UserInfo shareInstance].userInfo;
    if ([[usi objectForKey:@"ifActive"] isEqualToString:@"1"]&&[[usi objectForKey:@"dpset"] isEqualToString:@"1"]) {
        NSInteger buynum = ((LoanClient *)[self.items objectAtIndex:indexPath.row]).buynum.integerValue;
        if (buynum > 4 && buynum < 10) {
            return 210;
        }
    }
    return 175;
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
    NSDictionary *dic = [aDic objectForKey:@"loansuserlogin18"];
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
    NSDictionary *dic = [aDic objectForKey:@"loansuserlogin5"];
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
