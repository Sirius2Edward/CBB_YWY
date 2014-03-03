//
//  LoanAdvisorView.m
//  CBB
//
//  Created by 卡宝宝 on 14-2-25.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "LoanAdvisorView.h"
#import "UIColor+TitleColor.h"
#import "Request_API.h"
#import "DataModel.h"

@interface LoanAdvisorCell : UITableViewCell<UIAlertViewDelegate>
{
    Request_API *req;
    Advisor *_advisor;
    UILabel *nameLabel;
    UILabel *dateLabel;
    UILabel *questLabel;
    UIButton *btn;
}
@property(nonatomic,assign)BOOL canDelete;
@property(nonatomic,retain)Advisor *advisor;
@property(nonatomic,retain)LoanAdvisorView *controller;
@end
@implementation LoanAdvisorCell
@synthesize canDelete;
@synthesize controller;
@synthesize advisor = _advisor;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        req = [Request_API shareInstance];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 125, 20)];
        nameLabel.textColor = [UIColor titleColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLabel];
        
        questLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 32, 290, 500)];
        questLabel.numberOfLines = 0;
        questLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:questLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(139, 5, 135, 20)];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:dateLabel];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(280, 0, 30, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(delAdvisor:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    return self;
}

-(void)setCanDelete:(BOOL)canDel
{
    if (canDel) {
        btn.hidden = NO;
        dateLabel.frame = CGRectMake(139, 5, 135, 20);
    }
    else {
        btn.hidden = YES;
        dateLabel.frame = CGRectMake(175, 5, 135, 20);
    }
}

-(void)setAdvisor:(Advisor *)advisor
{
    if (_advisor != advisor) {
        _advisor = advisor;
        if (advisor) {
            nameLabel.text = advisor.uname;
            dateLabel.text = advisor.addDate;
            questLabel.text = advisor.content;
            CGRect rect = questLabel.frame;
            CGSize size = [questLabel.text boundingRectWithSize:CGSizeMake(290, 500)
                                                        options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                        context:nil].size;
            rect.size.height = size.height;
            questLabel.frame = rect;
        }
    }
}

-(void)delAdvisor:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认删除？！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        UserInfo *userInfo = [UserInfo shareInstance];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             userInfo.username,@"username",
                             userInfo.password,@"password",
                             @"0",@"year",
                             @"0",@"month",
                             _advisor.ID,@"id",nil];
        req.delegate = self;
        [req loanDelAdvisorWithDic:dic];
    }
}

-(void)delAdvEnd:(id)aDic
{
    NSMutableDictionary *dic = [aDic objectForKey:@"DeleteLoanslyServlet1"];
    if (dic) {
        [self.controller removeCell:self];
    }
}
@end

@interface LoanReplyCell : UITableViewCell<UIAlertViewDelegate>
{
    UILabel *dateLabel;
    UILabel *questLabel;
}
@property(nonatomic,retain)Reply *reply;
@end
@implementation LoanReplyCell
@synthesize reply;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 50, 20)];
        nameLabel.textColor = [UIColor grayColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.text = @"回复：";
        [self.contentView addSubview:nameLabel];
        
        questLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 32, 290, 500)];
        questLabel.numberOfLines = 0;
        questLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:questLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 5, 135, 20)];
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:dateLabel];
    }
    return self;
}

-(void)setReply:(Reply *)aReply
{
    if (aReply != reply) {
        dateLabel.text = aReply.date;
        questLabel.text = aReply.content;
        CGRect rect = questLabel.frame;
        CGSize size = [questLabel.text boundingRectWithSize:CGSizeMake(290, 500)
                                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                    context:nil].size;
        rect.size.height = size.height;
        questLabel.frame = rect;
    }
}
@end

@interface LoanActionCell : UITableViewCell<UIAlertViewDelegate,UITextFieldDelegate>
{
    Request_API *req;
    UIButton *confirmBtn;
}
@property(nonatomic,retain)UITextField *textField;
@property(nonatomic,retain)LoanAdvisorView *controller;
@property(nonatomic,retain)Advisor *advisor;
@end
@implementation LoanActionCell
@synthesize textField;
@synthesize controller;
@synthesize advisor;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        req = [Request_API shareInstance];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 290, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        [self.contentView addSubview:textField];
        
        confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(320, 0, 40, 30);
        [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(submitReply:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:confirmBtn];
        confirmBtn.alpha = 0;
    }
    return self;
}

-(void)submitReply:(UIBarButtonItem *)sender
{
    [self.controller.view endEditing:YES];
    if ([textField.text isEqualToString:@""]) {
        return;
    }
    else {
        UserInfo *userInfo = [UserInfo shareInstance];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             userInfo.username,@"username",
                             userInfo.password,@"password",
                             @"0",@"year",
                             @"0",@"month",
                             textField.text,@"content",
                             advisor.ID,@"id",nil];
        [self.controller replyWithDic:dic];
        textField.text = @"";
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    [UIView animateWithDuration:0.23f animations:^{
        aTextField.frame = CGRectMake(15, 0, 250, 30);
        confirmBtn.alpha = 1;
        confirmBtn.frame = CGRectMake(272, 0, 40, 30);
        CGRect tFrame = self.controller.tableView.frame;
        tFrame.size.height -= 214;
        self.controller.tableView.frame = tFrame;
    }];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)aTextField
{
    [UIView animateWithDuration:0.23f animations:^{
        aTextField.frame = CGRectMake(15, 0, 290, 30);
        confirmBtn.frame = CGRectMake(320, 0, 40, 30);
        confirmBtn.alpha = 0;
        CGRect tFrame = self.controller.tableView.frame;
        tFrame.size.height += 214;
        self.controller.tableView.frame = tFrame;
    }];
}
@end

#pragma mark -
@implementation LoanAdvisorView
{
    Request_API *req;
    UISegmentedControl *seg;
    NSMutableArray  *advis;
    NSInteger totalPage;
    NSInteger currentPage;
}
@synthesize data;
-(void)loadView
{
    currentPage = 1;
    req = [Request_API shareInstance];
    req.delegate = self;
    self.tableStyle = UITableViewStyleGrouped;
    [super loadView];
    self.title = @"用户咨询";
    seg = [[UISegmentedControl alloc] initWithItems:@[@"未回复",@"已回复"]];
    seg.frame = CGRectMake(90, 5, 110, 32);
    seg.tintColor = [UIColor whiteColor];
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *bItem = [[UIBarButtonItem alloc] initWithCustomView:seg];
    self.navigationItem.rightBarButtonItem=bItem;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.tableView addGestureRecognizer:tap];
}

-(void)loadData
{
    if (currentPage > 1) {
        [advis addObjectsFromArray:[self.data objectForKey:@"list"]];
    }
    else if (currentPage == 1) {
        advis = [self.data objectForKey:@"list"];
    }
    totalPage = [[self.data objectForKey:@"pageTotal"] integerValue];
}

-(void)changeContent:(UISegmentedControl *)sender
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    currentPage = 1;
    [self requestDataPage:currentPage];
}

-(void)requestDataPage:(NSInteger)page
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         @"0",@"year",
                         @"0",@"month",
                         [NSString stringWithFormat:@"%d",page],@"pagenum",nil];
    req.delegate = self;
    if (seg.selectedSegmentIndex) {
        [req loanRepliedAdvisorWithDic:dic];
    }
    else {
        [req loanAdvisorWithDic:dic];
    }
}

-(void)removeCell:(UITableViewCell *)aCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:aCell];
    [advis removeObjectAtIndex:indexPath.section];
    [self.tableView deleteSections:[[NSIndexSet alloc] initWithIndex:indexPath.section]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)replyWithDic:(NSDictionary *)aDic
{
    req.delegate = self;
    if (seg.selectedSegmentIndex) {
        NSMutableDictionary *mDic = [aDic mutableCopy];
        [mDic setObject:[UserInfo shareInstance].ID forKey:@"loansid"];
        [mDic setObject:[aDic objectForKey:@"id"] forKey:@"lyid"];
        [mDic removeObjectForKey:@"id"];
        [req loanAgainReplyWithDic:mDic];
    }
    else {
        [req loanFirstReplyWithDic:aDic];
    }
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView delegate
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 2;
    if (seg.selectedSegmentIndex) {
        Advisor *ra = [advis objectAtIndex:section];
        NSArray *replyL = ra.replyList;
        if (replyL) {
            num += ra.replyList.count;
        }
    }
    return num;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return advis.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contentStr = nil;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    if (indexPath.row ==0) {
        contentStr = ((Advisor *)[advis objectAtIndex:indexPath.section]).content;
        CGSize size = [contentStr boundingRectWithSize:CGSizeMake(290, 500)
                                      options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:dic
                                      context:nil].size;
        return size.height+45;
    }
    else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]-1) {
        return 37;
    }
    else {
        Advisor *reAdv = [advis objectAtIndex:indexPath.section];
        Reply *reply = [reAdv.replyList objectAtIndex:indexPath.row-1];
        contentStr = reply.content;
        CGSize size = [contentStr boundingRectWithSize:CGSizeMake(290, 500)
                                               options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:dic
                                               context:nil].size;
        return size.height+39;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *aIdentifier = @"Acell";
    static NSString *rIdentifier = @"Rcell";
    static NSString *tIdentifier = @"Tcell";
    
    NSString *_placeholder = nil;
    BOOL canDel;
    if (seg.selectedSegmentIndex) {
        _placeholder = @"补充回复";
        canDel = NO;
    }
    else {
        _placeholder = @"回复该咨询";
        canDel = YES;
    }
    Advisor *_advisor = [advis objectAtIndex:indexPath.section];
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        LoanAdvisorCell *aCell = [tableView dequeueReusableCellWithIdentifier:aIdentifier];
        if (Nil == aCell) {
            aCell = [[LoanAdvisorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aIdentifier];
        }
        aCell.advisor = _advisor;
        aCell.controller = self;
        aCell.canDelete = canDel;
        cell = aCell;
    }
    else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//回复栏
        LoanActionCell *tCell = [tableView dequeueReusableCellWithIdentifier:tIdentifier];
        if (Nil == tCell) {
            tCell = [[LoanActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tIdentifier];
        }
        tCell.textField.text = @"";
        tCell.textField.placeholder = _placeholder;
        tCell.advisor = _advisor;
        tCell.controller = self;
        cell = tCell;
    }
    else {
        LoanReplyCell *rCell = [tableView dequeueReusableCellWithIdentifier:rIdentifier];
        if (Nil == rCell) {
            rCell = [[LoanReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rIdentifier];
        }
        if (_advisor.replyList) {
            rCell.reply = [_advisor.replyList objectAtIndex:indexPath.row-1];
        }
        cell = rCell;
    }

    return cell;
}

#pragma mark - Refresh
//刷新数据
- (void)reloadTableViewDataSource
{
    [super reloadTableViewDataSource];
    currentPage = 1;
    [self requestDataPage:currentPage];
}

//请求更多数据
- (void)loadNextTableViewDataSource
{
    [super loadNextTableViewDataSource];
    if (currentPage < totalPage) {
        currentPage ++;
        [self requestDataPage:currentPage];
    }
    else {
        [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];//线程安全
    }
}

#pragma mark - Connect END


-(void)advisorEnd:(id)aDic
{
    NSMutableDictionary *dic = nil;
    if (seg.selectedSegmentIndex) {
        dic = [aDic objectForKey:@"LoanslyReServlet1"];
    }
    else {
        dic = [aDic objectForKey:@"LoanslyServlet1"];
    }
    if (dic) {
        self.data = dic;
        [self loadData];
    }
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];
    
}

-(void)replyEnd:(id)aDic
{
    NSMutableDictionary *dic = nil;
    if (seg.selectedSegmentIndex) {
        dic = [aDic objectForKey:@"AgainReplyLoanslyServlet1"];
    }
    else {
        dic = [aDic objectForKey:@"ReplyLoanslyServlet1"];
    }
    if (dic) {
        [self requestDataPage:currentPage];
    }
}
@end
