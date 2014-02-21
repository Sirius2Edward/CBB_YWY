//
//  LoanClientSift.m
//  CBB
//
//  Created by 卡宝宝 on 13-9-26.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "LoanClientSift.h"
#import "Request_API.h"
#import "DataModel.h"
#import "SVProgressHUD.h"

@interface LoanClientSift ()
{
    Request_API *req;
    NSArray *titles;
    NSArray *paraKeys;
    NSArray *conditions;
    UIButton *activeButton;
    CustomPicker *picker;
    NSMutableDictionary *param;
}
@end

@implementation LoanClientSift

-(id)init
{
    if (self = [super init]) {
        titles = [NSArray arrayWithObjects:@"贷款用途",@"抵押类型",@"单位性质",@"月收入",@"工资发放形式",@"提供银行流水",@"本地户口",@"年龄", nil];
        paraKeys = [NSArray arrayWithObjects:@"rt",@"pdy",@"worktype",@"monthIncome",@"moneyin",@"monthIncomes2",@"hukou", nil];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LoanSiftConditons" ofType:@"plist"];
        conditions = [NSArray arrayWithContentsOfFile:path];
        param = [NSMutableDictionary dictionary];
        req = [Request_API shareInstance];
        req.delegate = self;
    }
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"客户筛选";
}

#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [titles objectAtIndex:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sIdentifier = @"SCell";
//    static NSString *pIdentifier = @"PCell";
    static NSString *tIdentifier = @"TCell";
    UITableViewCell *cell =  nil;
    if (indexPath.section != 7) {
        SelectorCell *sCell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
        if (nil == sCell) {
            sCell = [[SelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sIdentifier];
            sCell.button.tag = 3800+indexPath.section;
            [sCell.button addTarget:self action:@selector(list:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSInteger storage = [[param objectForKey:[paraKeys objectAtIndex:indexPath.section]] integerValue];
        NSString *itemTitle = [[conditions objectAtIndex:indexPath.section] objectAtIndex:storage];
        [sCell.button setTitle:itemTitle forState:0];
        cell = sCell;
    }
    /*
    else if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 4 || indexPath.section == 5 ||indexPath.section == 6) {
        PickerCell *pCell = [tableView dequeueReusableCellWithIdentifier:pIdentifier];
        if (nil == pCell) {
            pCell = [[PickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pIdentifier];
            pCell.dataSource = self;
            pCell.delegate = self;
            pCell.peekInset = UIEdgeInsetsMake(0, 50, 0, 50);
        }
        pCell.currentIndexPath = indexPath;
        [pCell reloadData];
        NSInteger storage = [[param objectForKey:[paraKeys objectAtIndex:indexPath.section]] integerValue];
        [pCell selectItemAtIndex:storage animated:NO];
        cell = pCell;
    }
     */
    else {
        DoubleTextCell *tCell = [tableView dequeueReusableCellWithIdentifier:tIdentifier];
        if (nil == tCell) {
            tCell = [[DoubleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tIdentifier];
        }
        cell = tCell;
    }
    return cell;
}

#pragma mark - CPPickerViewCell DataSource

- (NSInteger)numberOfItemsInPickerViewAtIndexPath:(NSIndexPath *)pickerPath {    
    return [[conditions objectAtIndex:pickerPath.section] count];
}

- (NSString *)pickerViewAtIndexPath:(NSIndexPath *)pickerPath titleForItem:(NSInteger)item {
    NSArray *items = [conditions objectAtIndex:pickerPath.section];
    if (items) {
        return [items objectAtIndex:item];
    }    
    return nil;
}

#pragma mark - CPPickerViewCell Delegate

- (void)pickerViewAtIndexPath:(NSIndexPath *)pickerPath didSelectItem:(NSInteger)item {
    [param setObject:[NSString stringWithFormat:@"%d",item] forKey:[paraKeys objectAtIndex:pickerPath.section]];
}

#pragma mark - ListSelector
-(void)list:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSInteger section = sender.tag - 3800;
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:[conditions objectAtIndex:section]
                                                    forKeys:[conditions objectAtIndex:section]];
    [self showPicker:dic Keys:[conditions objectAtIndex:section]];
    activeButton = sender;
}

-(void)showPicker:(NSDictionary *)data Keys:(NSArray *)keys
{
    if (picker) {
        [picker removeFromSuperview];
    }
    picker = [[CustomPicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, 320, 260)];
    picker.data = data;
    if (keys) {
        picker.keysInOrder = keys;
    }
    picker.components = 1;
    picker.delegate = self;
    [picker showPickerInView:self.view];
}

-(void)confirmAction:(NSString *)value WithInfo:(NSDictionary *)info
{
    [activeButton setTitle:value forState:0];
    UITableViewCell *cell = (UITableViewCell *)[[activeButton superview] superview];
    NSInteger section = [[self.tableView indexPathForCell:cell] section];
    NSArray *arr = [conditions objectAtIndex:section];
    NSInteger index = [arr indexOfObject:value];
    
    [param setObject:[NSString stringWithFormat:@"%d",index] forKey:[paraKeys objectAtIndex:section]];
    activeButton = nil;
}

-(void)selectAction:(NSString *)value
{
    [activeButton setTitle:value forState:0];
}

#pragma mark - submit
-(void)submit
{
    [super submit];
    DoubleTextCell *cell = (DoubleTextCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:7]];
    NSString *lowAge = cell.firText.text;
    NSString *highAge = cell.secText.text;
    
    if (lowAge != nil && ![lowAge isEqualToString:@""]) {
        if (lowAge.integerValue < 18 || lowAge.integerValue > 60) {
            [SVProgressHUD showErrorWithStatus:@"年龄必须在18到60岁之间" duration:1.5f];
            return;
        }
        else {
            [param setObject:lowAge forKey:@"agelow"];
        }
    }
    else{
        [param setObject:@"18" forKey:@"agelow"];
    }
    if (highAge != nil && ![highAge isEqualToString:@""]) {
        if (highAge.integerValue < 18 || highAge.integerValue > 60) {
            [SVProgressHUD showErrorWithStatus:@"年龄必须在18到60岁之间" duration:1.5f];
            return;
        }
        else {
            [param setObject:highAge forKey:@"agehight"];
        }
    }
    else {
        [param setObject:@"60" forKey:@"agehight"];
    }
    if (lowAge != nil && ![lowAge isEqualToString:@""] && highAge != nil && ![highAge isEqualToString:@""]
        && highAge.integerValue <= lowAge.integerValue) {
        [SVProgressHUD showErrorWithStatus:@"请认真填写年龄范围" duration:1.5f];
        return;
    }
    
    UserInfo *userInfo = [UserInfo shareInstance];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
             userInfo.username,@"username",
             userInfo.password,@"password",
             userInfo.ID,@"id", nil];
    [dic addEntriesFromDictionary:param];
    [req loanNewClientsWithDic:dic];
}

-(void)newLoanClientEnd:(id)aDic
{
    NSDictionary *dic = [aDic objectForKey:@"loansuserlogin2"];
    if (dic) {
        [self.delegate changeSiftPara:param Data:dic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
