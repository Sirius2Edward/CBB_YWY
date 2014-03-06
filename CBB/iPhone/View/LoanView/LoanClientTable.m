//
#import "LoanClientTable.h"
#import "CustomLabel.h"
#import "Request_API.h"
#import "ClientDetail.h"
#import "SVProgressHUD.h"
#import "UIColor+TitleColor.h"
#import "WebViewController.h"

@implementation BaseLoanCell
@synthesize nameLabel;
@synthesize amountLabel;
@synthesize adDateLabel;
@synthesize bg;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        delBtn.frame = CGRectMake(285, 21, 10, 10);
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
                         orderID,@"uid",nil];
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
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"免费抢"]) {
        NSDictionary *dic = @{@"username":info.username, @"password":info.password, @"id":info.ID, @"uid":orderID};
        Request_API *req = [Request_API shareInstance];
        req.delegate = self;
        [req loanBuyApplicationWithDic:dic];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定购买?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",nil];
        NSString *isfirst = [info.userInfo objectForKey:@"isfirst"];
        if (!isfirst || isfirst.intValue == 0) {
            NSString *firstBuyStr = @"注：这是您第一次使用卡贝贝购买表单\n    购买成功后，您将获赠20积分。\n\n";
            alert.message = [firstBuyStr stringByAppendingString:alert.message];
        }
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
        NSDictionary *dic = @{@"username":info.username, @"password":info.password, @"id":info.ID, @"uid":orderID};
        Request_API *req = [Request_API shareInstance];
        req.delegate = self;
        NSString *isfirst = [info.userInfo objectForKey:@"isfirst"];
        if (!isfirst || isfirst.intValue == 0) {
            [req loanUpdateFirstBuy];
        }
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
//        if (buttonIndex == 1) {
            //查看客户详情
//            UserInfo *info = [UserInfo shareInstance];
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 info.username,@"username",
//                                 info.password,@"password",
//                                 info.ID,@"id",
//                                 orderID,@"uid",nil];
//            Request_API *req = [Request_API shareInstance];
//            req.delegate = self;
//            [req loanBuyerDetailWithDic:dic];
//        }
//        else {
            //已购买客户表
            UserInfo *userInfo = [UserInfo shareInstance];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userInfo.username,@"username",
                                 userInfo.password,@"password",
                                 userInfo.ID,@"id", nil];
            Request_API *req = [Request_API shareInstance];
            req.delegate = self;
            [req loanBuyersInfoWithDic:dic];
//        }
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
    
    NSMutableDictionary *usi = [UserInfo shareInstance].userInfo;
    NSInteger qnum = [[usi objectForKey:@"qnum"] integerValue];
    if (![[usi objectForKey:@"dpset"] isEqualToString:@"1"] && qnum < 3) {
        qnum++;
        [usi setObject:[NSString stringWithFormat:@"%d",qnum] forKey:@"qnum"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"抢取表单成功！您还剩下%d次免费抢表机会！电脑登录卡宝宝网开通店铺吧，可不限次数免费抢！",3-qnum] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"已购买客户表",nil];
        alert.tag = 6602;
        [alert show];
    }
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
    UILabel *usageLabel;
    UILabel *identLabel;
    UILabel *incomLabel;
    UILabel *mortgLabel;
    UILabel *mobilLabel;
    UILabel *bDateLabel;
    UIButton *statusButton;
    UIProgressView *grade;
}
@synthesize controller;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bg.frame = CGRectMake(10, 5, 300, 212);
        NSArray *arr = @[@"贷款用途：",@"职业身份：",@"打卡工资：",@"有无抵押：",@"手 机 号 ：",@"购买时间："];
        CGFloat yCo = 60;
        for (int i = 0; i < arr.count; i++) {
            UILabel *itemL = [[UILabel alloc] initWithFrame:CGRectMake(30, yCo, 80, 25)];
            itemL.font = [UIFont systemFontOfSize:15];
            itemL.textColor = [UIColor darkGrayColor];
            itemL.text = [arr objectAtIndex:i];
            [self.contentView addSubview:itemL];
            yCo += 25;
        }
        statusButton = [UIButton buttonWithType:UIButtonTypeSystem];
        statusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [statusButton setTitle:@"未联系" forState:UIControlStateNormal];
        statusButton.frame = CGRectMake(150, 8, 150, 30);
        [statusButton addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:statusButton];
        
        usageLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 130, 25)];
        usageLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:usageLabel];
        
        identLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 85, 130, 25)];
        identLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:identLabel];
        
        incomLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 110, 180, 25)];
        incomLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:incomLabel];
        
        mortgLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 135, 180, 25)];
        mortgLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:mortgLabel];
        
        mobilLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 160, 180, 25)];
        mobilLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:mobilLabel];
        
        bDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 185, 180, 25)];
        bDateLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:bDateLabel];
    }
    return self;
}

-(void)setItem:(LoanClient *)item
{
    [super setItem:item];
    uid = item.ID;
    
    if (item.usersex.integerValue == 1) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@(先生)",item.username];
    }
    else if (item.usersex.integerValue == 2) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@(女士)",item.username];
    }
    usageLabel.text = item.Rt;
    identLabel.text = item.worksf;
    incomLabel.text = item.monthIncome;
    mortgLabel.text = item.loans_dyw;
    mobilLabel.text = item.mobile;
    bDateLabel.text = item.mon_date;
}

-(void)setStatus:(NSString *)status
{
    [statusButton setTitle:status forState:UIControlStateNormal];
}

-(void)changeStatus:(UIButton *)sender
{
    [self.controller updateStatus:self];
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

#pragma mark - 对我店铺表单Cell
@implementation LoanShopClientCell
{
    NSString *uid;
    UILabel *identLabel;
    UILabel *incomLabel;
    UILabel *mortgLabel;
    UILabel *oriPriceLabel;
    UIButton *statusButton;
    UIProgressView *grade;
}
@synthesize controller;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bg.frame = CGRectMake(10, 5, 300, 203);
        NSArray *arr = @[@"职业身份：",@"打卡工资：",@"有无抵押：",@"客户资质：",@"手 机 号 ："];
        CGFloat yCo = 60;
        for (int i = 0; i < arr.count; i++) {
            UILabel *itemL = [[UILabel alloc] initWithFrame:CGRectMake(30, yCo, 80, 25)];
            itemL.font = [UIFont systemFontOfSize:15];
            itemL.textColor = [UIColor darkGrayColor];
            itemL.text = [arr objectAtIndex:i];
            [self.contentView addSubview:itemL];
            yCo += 25;
        }
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"iponeV3btn002.png"] forState:UIControlStateNormal];
        delBtn.frame = CGRectMake(285, 21, 10, 10);
        [delBtn addTarget:self action:@selector(deleteClient) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
        
        identLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 130, 25)];
        identLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:identLabel];
        
        incomLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 85, 180, 25)];
        incomLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:incomLabel];
        
        mortgLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 110, 180, 25)];
        mortgLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:mortgLabel];
        
        grade = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        grade.frame = CGRectMake(110, 147, 100, 30);
        [self.contentView addSubview:grade];
        
        
        oriPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 160, 100, 20)];
        [self.contentView addSubview:oriPriceLabel];
        
        UILabel *dscPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 180, 90, 20)];
        dscPriceLabel.font = [UIFont systemFontOfSize:15];
        dscPriceLabel.textColor = [UIColor titleColor];
        dscPriceLabel.text = @"折后：1.8分";
        [self.contentView addSubview:dscPriceLabel];
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [buyButton setTitle:@"购买" forState:UIControlStateNormal];
        [buyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        buyButton.frame = CGRectMake(200, 175, 50, 30);
        [self.contentView addSubview:buyButton];
    }
    return self;
}

-(void)setItem:(LoanClient *)item
{
    [super setItem:item];
    uid = item.ID;
    identLabel.text = item.worksf;
    incomLabel.text = item.monthIncome;
    mortgLabel.text = item.loans_dyw;
    if (item.Xing.intValue>3) {
        grade.progressTintColor = [UIColor greenColor];
    }
    else {
        grade.progressTintColor = [UIColor orangeColor];
    }
    grade.progress = item.Xing.floatValue/6;
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

-(void)deleteClient
{
    
}

-(void)buyAction:(UIButton *)sender
{
    NSDictionary *usi = [UserInfo shareInstance].userInfo;
    if (![[usi objectForKey:@"ifActive"] isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需先电脑登录卡宝宝进行资质认证才可购买!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定购买?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",nil];
        NSString *isfirst = [usi objectForKey:@"isfirst"];
        if (!isfirst || isfirst.intValue == 0) {
            NSString *firstBuyStr = @"注：这是您第一次使用卡贝贝购买表单\n    购买成功后，您将获赠20积分。\n\n";
            alert.message = [firstBuyStr stringByAppendingString:alert.message];
        }
        alert.tag = 6800;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        return;
    }
    if (alertView.tag == 6800) {
        [self.controller buyForMeClient:self];
    }
    else if (alertView.tag == 6801){
    }
}
@end

#pragma mark - 对我产品表单Cell
@implementation LoanProductClientCell
{
    NSString *uid;
    UILabel *usageLabel;
    UILabel *identLabel;
    UILabel *incomLabel;
    UILabel *mortgLabel;
    UILabel *oriPriceLabel;
    UIButton *statusButton;
    UIProgressView *grade;
}
//@synthesize controller;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bg.frame = CGRectMake(10, 5, 300, 228);
        NSArray *arr = @[@"贷款用途：",@"职业身份：",@"打卡工资：",@"有无抵押：",@"客户资质：",@"手 机 号 ："];
        CGFloat yCo = 60;
        for (int i = 0; i < arr.count; i++) {
            UILabel *itemL = [[UILabel alloc] initWithFrame:CGRectMake(30, yCo, 80, 25)];
            itemL.font = [UIFont systemFontOfSize:15];
            itemL.textColor = [UIColor darkGrayColor];
            itemL.text = [arr objectAtIndex:i];
            [self.contentView addSubview:itemL];
            yCo += 25;
        }
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"iponeV3btn002.png"] forState:UIControlStateNormal];
        delBtn.frame = CGRectMake(285, 21, 10, 10);
        [delBtn addTarget:self action:@selector(deleteClient) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
        
        usageLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 130, 25)];
        usageLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:usageLabel];
        
        identLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 85, 130, 25)];
        identLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:identLabel];
        
        incomLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 110, 180, 25)];
        incomLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:incomLabel];
        
        mortgLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 135, 180, 25)];
        mortgLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:mortgLabel];
        
        grade = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        grade.frame = CGRectMake(110, 172, 100, 30);
        [self.contentView addSubview:grade];
        
        oriPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 185, 100, 20)];
        [self.contentView addSubview:oriPriceLabel];
        
        UILabel *dscPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 205, 100, 20)];
        dscPriceLabel.font = [UIFont systemFontOfSize:15];
        dscPriceLabel.textColor = [UIColor titleColor];
        dscPriceLabel.text = @"折后：1.8分";
        [self.contentView addSubview:dscPriceLabel];
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [buyButton setTitle:@"购买" forState:UIControlStateNormal];
        [buyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        buyButton.frame = CGRectMake(200, 200, 50, 30);
        [self.contentView addSubview:buyButton];
    }
    return self;
}
-(void)setItem:(LoanClient *)item
{
    [super setItem:item];
    uid = item.ID;
    usageLabel.text = item.Rt;
    identLabel.text = item.worksf;
    incomLabel.text = item.monthIncome;
    mortgLabel.text = item.loans_dyw;
    if (item.Xing.intValue>3) {
        grade.progressTintColor = [UIColor greenColor];
    }
    else {
        grade.progressTintColor = [UIColor orangeColor];
    }
    grade.progress = item.Xing.floatValue/6;
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

-(void)deleteClient
{
    
}

-(void)buyAction:(UIButton *)sender
{
    NSDictionary *usi = [UserInfo shareInstance].userInfo;
    if (![[usi objectForKey:@"ifActive"] isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需先电脑登录卡宝宝进行资质认证才可购买!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定购买?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",nil];
        NSString *isfirst = [usi objectForKey:@"isfirst"];
        if (!isfirst || isfirst.intValue == 0) {
            NSString *firstBuyStr = @"注：这是您第一次使用卡贝贝购买表单\n    购买成功后，您将获赠20积分。\n\n";
            alert.message = [firstBuyStr stringByAppendingString:alert.message];
        }
        alert.tag = 6800;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        return;
    }
    if (alertView.tag == 6800) {
        [self.controller buyForMeClient:self];
    }
    else if (alertView.tag == 6801){
    }
}
@end

#pragma mark - table -
@implementation LoanClientTable
@synthesize items;
@synthesize page;
@end
#pragma mark -
@implementation NewLoanClientTable
{
    Request_API *req;
    NSMutableDictionary *_data;
    NSMutableDictionary *param;
}
@synthesize data = _data;
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
    return 173;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    NewLoanClientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[NewLoanClientCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.controller = self;
    }
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
    [self.data setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"Page"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
#pragma mark -
@implementation DoneLoanClientTable
{
    Request_API *req;
    CustomPicker *picker;
    NSMutableDictionary *_data;
    NSArray *zts;
}
@synthesize data = _data;
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
    
    NSDictionary *ztDic = [data objectForKey:@"ZTS"];
    zts = [[ztDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[ztDic objectForKey:obj1] integerValue] < [[ztDic objectForKey:obj2] integerValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"已购买的表单";
}

-(void)updateStatus:(DoneLoanClientCell *)cell
{
    if (picker) {
        [picker removeFromSuperview];
    }
    picker = [[CustomPicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, 320, 260)];
    picker.text.text = [NSString stringWithFormat:@"%@  %@",cell.nameLabel.text,cell.amountLabel.text];
    picker.userInfo = @{@"CELL":cell};
    picker.components = 1;
    picker.keysInOrder = zts;
    picker.delegate = self;
    [picker showPickerInView:self.view];
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    header.backgroundColor = self.tableView.backgroundColor;
    header.alpha = 0.85f;
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iponeV3img001.png"]];
    imgV.frame = CGRectMake(5, 2, 52, 42);
    [header addSubview:imgV];
    
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 85, 15)];
    label.text = @"修改跟进状态";
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(145, 10, 42, 15)];
    label.text = @"送积分";
    label.textColor = [UIColor titleColor];
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(187, 10, 125, 15)];
    label.text = @"，修改一次送0.1分";
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 260, 15)];
    label.text = @"最多送2次，请勿恶意修改！点状态修改";
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
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
    return 222.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    DoneLoanClientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[DoneLoanClientCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.controller = self;
    }
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
    [self.data setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"Page"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma CustomPicker
-(void)confirmAction:(NSString *)value WithInfo:(NSDictionary *)info
{
    DoneLoanClientCell *cell = [info objectForKey:@"CELL"];
    cell.status = value;
    
    LoanClient *item = [self.items objectAtIndex:[self.tableView indexPathForCell:cell].row];
}

-(void)selectAction:(NSString *)value {}
@end
#pragma mark - --
@implementation ForMeLoanClientTable
{
    Request_API *req;
    UISegmentedControl *seg;
    NSMutableDictionary *_data;
    NSMutableDictionary *_shopData;
    NSMutableDictionary *_productData;
}
@synthesize data = _data;
-(void)setData:(NSMutableDictionary *)data
{
    _data = data;
    self.items = [NSMutableArray arrayWithArray:[data objectForKey:@"UL"]];
    self.page = [[self.data objectForKey:@"Page"] integerValue];
}

-(void)loadView
{
    req = [Request_API shareInstance];
    req.delegate = self;
    [super loadView];
    seg = [[UISegmentedControl alloc] initWithItems:@[@"店铺申请表",@"产品申请表"]];
    seg.frame = CGRectMake(0, 0, 150, 32);
    seg.tintColor = [UIColor whiteColor];
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    self.navigationItem.prompt = @"对我申请的表单";
    
    _shopData = self.data;
}

-(void)changeContent:(UISegmentedControl *)sender
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    NSMutableDictionary *dic = nil;
    if (sender.selectedSegmentIndex) {
        dic = _productData;
    }
    else {
        dic = _shopData;
    }
    if (dic) {
        self.data = dic;
        [self.tableView reloadData];
        [self setFooterView];
    }
    else {
        [self requestDataPage:1];
    }
}

-(void)requestDataPage:(NSInteger)page
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = @{@"username":userInfo.username,@"password":userInfo.password,@"id":userInfo.ID,@"page":[NSString stringWithFormat:@"%d",page]};
    req.delegate = self;
    if (seg.selectedSegmentIndex) {
        [req loanForMyProductWithDic:dic];
    }
    else {
        [req loanForMyShopWithDic:dic];
    }
}

-(void)buyForMeClient:(BaseLoanCell *)cell
{
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    LoanClient *lc = (LoanClient *)[self.items objectAtIndex:row];
    UserInfo *info = [UserInfo shareInstance];
    NSString *isfirst = [info.userInfo objectForKey:@"isfirst"];
    if (!isfirst || isfirst.intValue == 0) {
        [req loanUpdateFirstBuy];
    }
    [req loanBuyForMeFormWithDic:@{@"username":info.username, @"password":info.password, @"id":info.ID, @"uid":lc.ID}];
}

-(void)pushToWeb:(UIButton *)sender
{
    WebViewController *web = [WebViewController new];
    web.title = @"优惠活动";
    web.url = @"http://192.168.1.32:8082/cardbaobao-3g/kbbywy/dkhd.html";
    [self.navigationController pushViewController:web animated:YES];
}

-(void)popAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    header.backgroundColor = self.tableView.backgroundColor;
    header.alpha = 0.85f;
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iponeV3img001.png"]];
    imgV.frame = CGRectMake(5, 2, 52, 42);
    [header addSubview:imgV];
    
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 167, 15)];
    label.text = @"大福利：此处表单2分/张，";
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(225, 10, 95, 15)];
    label.text = @"首次使用卡贝";
    label.textColor = [UIColor titleColor];
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(55, 30, 185, 15)];
    label.text = @"贝购买送20积分，再折上折！";
    label.textColor = [UIColor titleColor];
    label.font = [UIFont systemFontOfSize:14];
    [header addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(239, 30, 80, 15)];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (seg.selectedSegmentIndex) {
        return 235;
    }
    else {
        return 210;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sIdentifier = @"ShopCell";
    static NSString *pIdentifier = @"ProdCell";
    BaseLoanCell *cell = nil;
    if (seg.selectedSegmentIndex) {
        cell = [tableView dequeueReusableCellWithIdentifier:pIdentifier];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
    }
    if (nil == cell) {
        if (seg.selectedSegmentIndex) {
            cell = [[LoanProductClientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pIdentifier];
            ((LoanProductClientCell *)cell).controller = self;
        }
        else {
            cell = [[LoanShopClientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sIdentifier];
            ((LoanShopClientCell *)cell).controller = self;
        }
    }
    cell.item = [self.items objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Refresh
//刷新数据
- (void)reloadTableViewDataSource
{
    [super reloadTableViewDataSource];
    [self requestDataPage:1];
}

//请求更多数据
- (void)loadNextTableViewDataSource
{
    [super loadNextTableViewDataSource];
    if (self.page < [[self.data objectForKey:@"TotalPage"] integerValue]) {
        self.page ++;
        [self requestDataPage:self.page];
    }
    else {
        [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];//线程安全
    }
}

#pragma mark - Connect END
-(void)forMeClientEnd:(id)aDic
{
    NSMutableDictionary *dic = nil;
    if (seg.selectedSegmentIndex) {
        _productData = [aDic objectForKey:@"loansuserlogin19"];
        dic = _productData;
    }
    else {
        _shopData = [aDic objectForKey:@"loansuserlogin17"];
        dic = _shopData;
    }
    
    if (!dic)  return;
    self.data = dic;
    
    if ([[dic objectForKey:@"Page"] integerValue] == 1) {
        self.page = 1;
        [self.items setArray:[dic objectForKey:@"UL"]];
    }
    else {
        [self.items addObjectsFromArray:[dic objectForKey:@"UL"]];
    }
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2f];
}

-(void)buyEnd:(id)aDic
{
    NSString *result = [[aDic objectForKey:@"loansuserlogin20"] objectForKey:@"result"];
    if (!result) {
        return;
    }
    //购买成功
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    alert.tag = 6602;
    [alert show];
}
@end
