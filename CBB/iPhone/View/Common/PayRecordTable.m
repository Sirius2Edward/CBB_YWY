//
//  PayRecordTable.m
//  CBB
//
//  Created by 卡宝宝 on 13-9-10.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "PayRecordTable.h"
#import "Request_API.h"
#import "DataModel.h"
#import "CustomLabel.h"
#import "UIColor+TitleColor.h"

@interface PayCell : UITableViewCell
{
    PayRecord *_item;
}
@property(nonatomic,retain)PayRecord *item;
@property(nonatomic,retain)PayRecordTable *controller;
-(void)removeCell;
@end

@implementation PayCell
@synthesize item = _item;
@synthesize controller;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView.image = [UIImage imageNamed:@"pay_record.png"];
        self.imageView.frame = CGRectMake(7, 5, 306, 80);
        
        NSArray *rectArr = [NSArray arrayWithObjects:
                            [NSValue valueWithCGRect:CGRectMake(30, 1, 75, 32)],
                            [NSValue valueWithCGRect:CGRectMake(100, 1, 206, 32)],
                            [NSValue valueWithCGRect:CGRectMake(35, 29, 70, 25)],
                            [NSValue valueWithCGRect:CGRectMake(100, 29, 206, 25)],
                            [NSValue valueWithCGRect:CGRectMake(35, 50, 70, 29)],
                            [NSValue valueWithCGRect:CGRectMake(102, 50, 204, 29)],nil];
        
        UILabel *label = nil;
        for (int i = 0; i < 6; i++) {
            label = [UILabel new];
            label.tag = 3000+i;
            label.backgroundColor = [UIColor clearColor];
            label.frame = [[rectArr objectAtIndex:i] CGRectValue];
            if (i == 1) {
                label.textColor = [UIColor titleColor];
            }
            else {
                if (i>1) {
                    label.font = [UIFont systemFontOfSize:13];
                    if (i%2 == 0) {
                        label.textColor = [UIColor darkGrayColor];
                    }
                }
                else {
                    label.font = [UIFont systemFontOfSize:15];
                }
            }
            [self.imageView addSubview:label];
        }
        KeyWordLabel *kLabel = [[KeyWordLabel alloc] init];
        kLabel.backgroundColor = [UIColor clearColor];
        kLabel.tag = 3006;
        [self.imageView addSubview:kLabel];
        
    }
    return self;
}

-(void)setItem:(PayRecord *)item
{
    _item = item;
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"支付金额：",item.money,@"交易状态：",item.ptype, nil];
    if (![item.successdate isEqualToString:@""]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [arr addObjectsFromArray:[NSArray arrayWithObjects:@"付款时间：",item.successdate, nil]];
    }
    else {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [arr addObjectsFromArray:[NSArray arrayWithObjects:@"下单时间：",item.paydate, nil]];
    }
    for (int i = 0; i < 6; i++) {
        UILabel *label = (CustomLabel*)[self.contentView viewWithTag:i+3000];
        label.text = [arr objectAtIndex:i];
    }
    CGSize size = [item.money sizeWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:17]];
    KeyWordLabel *kLabel = (KeyWordLabel *)[self.contentView viewWithTag:3006];
    [kLabel setText:[NSString stringWithFormat:@"元（可到账%@积分）",item.jifen]
           WithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]
           AndColor:[UIColor darkGrayColor]];
    [kLabel setKeywordLight:item.jifen WithFont:[UIFont systemFontOfSize:14] AndColor:[UIColor titleColor]];
    kLabel.frame = CGRectMake(100+size.width, 9, 186-size.width, 25);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)removeCell
{
    NSIndexPath *indexPath = [self.controller.tableView indexPathForCell:self];
    [self.controller.items removeObjectAtIndex:indexPath.row];
    [self.controller.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self.controller.tableView indexPathForCell:self]]
                                     withRowAnimation:UITableViewRowAnimationRight];
}
@end

#pragma  mark - Table -
@interface PayRecordTable ()
{
    Request_API *req;
    NSMutableDictionary *_data;
    PayCell *activeCell;
}
@end

@implementation PayRecordTable
@synthesize businessType;
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
    self.title = @"充值记录";
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setBackgroundImage:[UIImage imageNamed:@"right_btn.png"] forState:0];
    [barButton setTitle:@"删除" forState:0];
    barButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    [barButton sizeToFit];
    [barButton addTarget:self action:@selector(trush:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    ///
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)trush:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [sender setTitle:@"删除" forState:0];
        if (self.tableView.indexPathsForSelectedRows.count) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒您"
                                                            message:@"这些记录都将被永久删除\n是否确定删除?"
                                                           delegate:self cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"删除",nil];
            alert.tag = 6600;
            [alert show];
        }
        else {
            [self setEditing:sender.selected animated:YES];
            [self.tableView setEditing:sender.selected animated:YES];
        }
    }
    else {
        [sender setTitle:@"确定" forState:0];
        [self setEditing:sender.selected animated:YES];
        [self.tableView setEditing:sender.selected animated:YES];
    }
}

//-(void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    if (!editing) {
//        
//    }
//}

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
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    PayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[PayCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.controller = self;
    }
    cell.item = [self.items objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIView *v in [[tableView cellForRowAtIndexPath:indexPath].imageView subviews]) {
        if ([v isKindOfClass:[UILabel class]]) {
            v.backgroundColor = [UIColor clearColor];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayRecord *item = [self.items objectAtIndex:indexPath.row];
    if (![item.successdate isEqualToString:@""]) {
        return UITableViewCellEditingStyleNone;
    }
    if (tableView.isEditing) {
        return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        activeCell = (PayCell *)[tableView cellForRowAtIndexPath:indexPath];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒您" message:@"该记录将被永久删除\n是否确定删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil];
        alert.tag = 6601;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self setEditing:NO animated:YES];
    if (!buttonIndex) {
        [self.tableView setEditing:NO animated:YES];
        activeCell = nil;
        return;
    }
    if (alertView.tag == 6600) {
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
        for (NSIndexPath *index in [self.tableView indexPathsForSelectedRows]) {
            [indexes addIndex:index.row];
            PayRecord *item = (PayRecord *)[self.items objectAtIndex:index.row];
            UserInfo *info = [UserInfo shareInstance];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 info.username,@"username",
                                 info.password,@"password",
                                 info.ID,@"id",
                                 item.ID,@"orderid",nil];
            req.delegate = self;
            if (self.businessType) {
                [req loanDeletePayWithDic:dic];
            }
            else {
                [req cardDeletePayWithDic:dic];
            }
        }
        [self.items removeObjectsAtIndexes:indexes];
        [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows]
                              withRowAnimation:UITableViewRowAnimationRight];
    }
    else if(alertView.tag == 6601){
        UserInfo *info = [UserInfo shareInstance];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             info.username,@"username",
                             info.password,@"password",
                             info.ID,@"id",
                             activeCell.item.ID,@"orderid",nil];
        req.delegate = self;
        if (self.businessType) {
            [req loanDeletePayWithDic:dic];
        }
        else {
            [req cardDeletePayWithDic:dic];
        }
    }
    [self.tableView setEditing:NO animated:YES];
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
                         userInfo.ID,@"id",
                         @"1",@"page", nil];
    req.delegate = self;
    if (self.businessType) {
        [req loanPayRecordWithDic:dic];
    }
    else {
        [req cardPayRecordWithDic:dic];
    }
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
        if (self.businessType) {
            [req loanPayRecordWithDic:dic];
        }
        else {
            [req cardPayRecordWithDic:dic];
        }
    }
    else {
        [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];//线程安全
    }
}

-(void)payRecordEnd:(id)aDic
{
    NSMutableDictionary *data = nil;
    if (self.businessType) {
        data = [aDic objectForKey:@"loansuserlogin7"];
    }
    else {
        data = [aDic objectForKey:@"carduserlogin7"];
    }
    if (!data) {
        return;
    }
    if ([[data objectForKey:@"Page"] integerValue] == 1) {
        self.page = 1;
        [self.items setArray:[data objectForKey:@"UL"]];
    }
    else {
        [self.items addObjectsFromArray:[data objectForKey:@"UL"]];
    }
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2f];
}

-(void)delPayEnd:(id)aDic
{
    NSMutableDictionary *data = nil;
    if (self.businessType) {
        data = [aDic objectForKey:@"loansuserlogin8"];
    }
    else {
        data = [aDic objectForKey:@"carduserlogin8"];
    }
    if (!data) {
        return;
    }
    if (activeCell) {
        [activeCell removeCell];
        activeCell = nil;
    }
}

-(void)popAction
{
    [self.data setObject:self.items forKey:@"UL"];
    [self.data setObject:[NSString stringWithFormat:@"%d",page] forKey:@"Page"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
