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
                             @"1",@"pagenum",nil];
        [[Request_API shareInstance] loanDelAdvisorWithDic:dic];
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

@interface LoanActionCell : UITableViewCell<UIAlertViewDelegate>
@property(nonatomic,retain)UITextField *textField;
@end
@implementation LoanActionCell
@synthesize textField;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 290, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.contentView addSubview:textField];
    }
    return self;
}
@end

#pragma mark -
@implementation LoanAdvisorView
{
    Request_API *req;
    UISegmentedControl *seg;
    NSArray  *advis;
    NSInteger totalPage;
}
@synthesize data;
-(void)loadView
{
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
}

-(void)loadData
{
    advis     = [self.data objectForKey:@"list"];
    totalPage = [[self.data objectForKey:@"pageTotal"] integerValue];
}

-(void)changeContent:(UISegmentedControl *)sender
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         userInfo.username,@"username",
                         userInfo.password,@"password",
                         @"0",@"year",
                         @"0",@"month",
                         @"1",@"pagenum",nil];
    if (sender.selectedSegmentIndex) {
        [req loanRepliedAdvisorWithDic:dic];
    }
    else {
        [req loanAdvisorWithDic:dic];
    }
}

#pragma mark - TableView delegate
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 2;
    if (seg.selectedSegmentIndex) {
        ReAdvisor *ra = [advis objectAtIndex:section];
        num += ra.replyList.count;
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
        ReAdvisor *reAdv = [advis objectAtIndex:indexPath.section];
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
    else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]-1) {//回复栏
        LoanActionCell *tCell = [tableView dequeueReusableCellWithIdentifier:tIdentifier];
        tCell.textField.text = @"";
        if (Nil == tCell) {
            tCell = [[LoanActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tIdentifier];
        }
        tCell.textField.placeholder = _placeholder;
        cell = tCell;
    }
    else {
        LoanReplyCell *rCell = [tableView dequeueReusableCellWithIdentifier:rIdentifier];
        if (Nil == rCell) {
            rCell = [[LoanReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rIdentifier];
        }
        rCell.reply = [((ReAdvisor *)_advisor).replyList objectAtIndex:indexPath.row-1];
        cell = rCell;
    }

    return cell;
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)advisorEnd:(id)aDic
{
    NSMutableDictionary *dic = nil;
    if (seg.selectedSegmentIndex) {
        dic = [aDic objectForKey:@"LoanslyReServlet1"];
    }
    else {
        dic = [aDic objectForKey:@"LoanslyServlet1"];
    }
    NSLog(@"%@",dic);
    if (dic) {
        self.data = dic;
        [self loadData];
        [self.tableView reloadData];
    }
}

-(void)delAdvEnd:(id)aDic
{
    NSMutableDictionary *dic = [aDic objectForKey:@"DeleteLoanslyServlet1"];
    if (dic) {
        [self.tableView deleteSections:nil withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
