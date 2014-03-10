//

#import "LoanClientSift.h"
#import "Request_API.h"
#import "DataModel.h"
#import "SVProgressHUD.h"
#import "UIColor+TitleColor.h"

@implementation LoanClientSift
{
    NSDictionary *_city;
    NSArray *_usage;
    NSArray *_pickerData;
}
@synthesize city = _city;
@synthesize usage= _usage;
@synthesize pickerData = _pickerData;
@synthesize paramters;
@synthesize completion;
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
}

-(void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSDictionary *)city
{
    if (!_city) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        NSDictionary *userinfo = [UserInfo shareInstance].userInfo;
        NSString *cities = [userinfo objectForKey:@"dlcity"];
        NSArray *citiesArray = [cities componentsSeparatedByString:@","];
        for (NSString *ck in citiesArray) {
            NSArray *cityArr = [ck componentsSeparatedByString:@"|"];
            if (cityArr.count == 2) {
                [mDic setObject:[cityArr objectAtIndex:0] forKey:[cityArr objectAtIndex:1]];
            }
        }
        [mDic setObject:@"0" forKey:@"城市(全部)"];
        _city = mDic;
    }
    return _city;
}

-(NSArray *)usage
{
    if (!_usage) {
        _usage = @[@"贷款用途(全部)",@"房贷",@"车贷" ,@"消费贷款",@"经营贷款"];
    }
    return _usage;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerData objectAtIndex:row];
}
@end

#pragma mark -
@implementation NewClientSift
{
    UITextField *cityTF;
    UITextField *usageTF;
    UITextField *dnDateTF;
    UITextField *upDateTF;
    UIPickerView *picker;
}
-(void)loadView
{
    [super loadView];
    UILabel *label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 30)];
    label.text = @"城 市 ：";
    [self.view addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 80, 30)];
    label.text = @"用 途 ：";
    [self.view addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 80, 30)];
    label.text = @"申请时间:";
    [self.view addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(151, 160, 20, 30)];
    label.text = @"至";
    [self.view addSubview:label];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    
    cityTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 50, 210, 30)];
    cityTF.borderStyle = UITextBorderStyleRoundedRect;
    cityTF.font = [UIFont systemFontOfSize:15];
    cityTF.placeholder = @"城市（全部）";
    cityTF.inputView = picker;
    cityTF.delegate = self;
    [self.view addSubview:cityTF];
    
    usageTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 90, 210, 30)];
    usageTF.borderStyle = UITextBorderStyleRoundedRect;
    usageTF.font = [UIFont systemFontOfSize:15];
    usageTF.placeholder = @"贷款用途（全部）";
    usageTF.inputView = picker;
    usageTF.delegate = self;
    [self.view addSubview:usageTF];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    dnDateTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, 130, 30)];
    dnDateTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    dnDateTF.borderStyle = UITextBorderStyleRoundedRect;
    dnDateTF.textAlignment = NSTextAlignmentCenter;
    dnDateTF.font = [UIFont systemFontOfSize:15];
    dnDateTF.placeholder = @"较早时间";
    dnDateTF.inputView = datePicker;
    [self.view addSubview:dnDateTF];
    
    upDateTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 160, 130, 30)];
    upDateTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    upDateTF.borderStyle = UITextBorderStyleRoundedRect;
    upDateTF.textAlignment = NSTextAlignmentCenter;
    upDateTF.font = [UIFont systemFontOfSize:15];
    upDateTF.placeholder = @"较晚时间";
    upDateTF.inputView = datePicker;
    [self.view addSubview:upDateTF];
    
    UIButton *button = nil;
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(70, 210, 80, 30);
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(170, 210, 80, 30);
    [self.view addSubview:button];

    [cityTF becomeFirstResponder];
}

-(void)dateChanged:(UIDatePicker *)sender
{
    NSDateComponents *component = [sender.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:sender.date];
    if ([dnDateTF isFirstResponder]) {
        dnDateTF.text = [NSString stringWithFormat:@"%d-%d-%d", component.year,component.month,component.day];
    }
    else if ([upDateTF isFirstResponder]) {
        upDateTF.text = [NSString stringWithFormat:@"%d-%d-%d", component.year,component.month,component.day];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == cityTF) {
        self.pickerData = [[self.city allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([[self.city objectForKey:obj1] integerValue] < [[self.city objectForKey:obj2] integerValue]) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        [picker reloadAllComponents];
    }
    else if (textField == usageTF) {
        self.pickerData = self.usage;
        [picker reloadAllComponents];
    }
    return YES;
}

-(void)searchAction
{
    UserInfo *userInfo = [UserInfo shareInstance];
    [self.paramters setDictionary:@{@"username":userInfo.username,@"password":userInfo.password,@"id":userInfo.ID}];
    if ([cityTF.text isEqualToString:@""]) {
        [self.paramters setObject:@"0" forKey:@"ucity"];
    }
    else {
        [self.paramters setObject:[self.city objectForKey:cityTF.text] forKey:@"ucity"];
    }
    
    if ([usageTF.text isEqualToString:@""]) {
        [self.paramters setObject:@"0" forKey:@"uyt"];
    }
    else {
        [self.paramters setObject:[NSString stringWithFormat:@"%d",[self.usage indexOfObject:usageTF.text] ] forKey:@"uyt"];
    }
    
    [self.paramters setObject:dnDateTF.text forKey:@"syear"];
    [self.paramters setObject:upDateTF.text forKey:@"eyear"];
    
    [self dismissViewControllerAnimated:YES completion:self.completion];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([cityTF isFirstResponder]) {
        cityTF.text = [self.pickerData objectAtIndex:row];
    }
    else if ([usageTF isFirstResponder]) {
        usageTF.text = [self.pickerData objectAtIndex:row];
    }
}
@end

#pragma mark -
@implementation ForMyShopClientSift
{
    UITextField *cityTF;
    UITextField *dnDateTF;
    UITextField *upDateTF;
    UIPickerView *picker;
}
-(void)loadView
{
    [super loadView];
    UILabel *label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 30)];
    label.text = @"城 市 ：";
    [self.view addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 80, 30)];
    label.text = @"申请时间:";
    [self.view addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(151, 120, 20, 30)];
    label.text = @"至";
    [self.view addSubview:label];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    
    cityTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 50, 210, 30)];
    cityTF.borderStyle = UITextBorderStyleRoundedRect;
    cityTF.font = [UIFont systemFontOfSize:15];
    cityTF.placeholder = @"城市（全部）";
    cityTF.inputView = picker;
    cityTF.delegate = self;
    [self.view addSubview:cityTF];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    dnDateTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 130, 30)];
    dnDateTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    dnDateTF.borderStyle = UITextBorderStyleRoundedRect;
    dnDateTF.textAlignment = NSTextAlignmentCenter;
    dnDateTF.font = [UIFont systemFontOfSize:15];
    dnDateTF.placeholder = @"较早时间";
    dnDateTF.inputView = datePicker;
    [self.view addSubview:dnDateTF];
    
    upDateTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 120, 130, 30)];
    upDateTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    upDateTF.borderStyle = UITextBorderStyleRoundedRect;
    upDateTF.textAlignment = NSTextAlignmentCenter;
    upDateTF.font = [UIFont systemFontOfSize:15];
    upDateTF.placeholder = @"较晚时间";
    upDateTF.inputView = datePicker;
    [self.view addSubview:upDateTF];
    
    UIButton *button = nil;
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(70, 170, 80, 30);
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(170, 170, 80, 30);
    [self.view addSubview:button];
    
    self.pickerData = [[self.city allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[self.city objectForKey:obj1] integerValue] < [[self.city objectForKey:obj2] integerValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    [cityTF becomeFirstResponder];
}

-(void)dateChanged:(UIDatePicker *)sender
{
    NSDateComponents *component = [sender.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:sender.date];
    if ([dnDateTF isFirstResponder]) {
        dnDateTF.text = [NSString stringWithFormat:@"%d-%d-%d", component.year,component.month,component.day];
    }
    else if ([upDateTF isFirstResponder]) {
        upDateTF.text = [NSString stringWithFormat:@"%d-%d-%d", component.year,component.month,component.day];
    }
}

-(void)searchAction
{
    UserInfo *userInfo = [UserInfo shareInstance];
    [self.paramters setDictionary:@{@"username":userInfo.username,@"password":userInfo.password,@"id":userInfo.ID}];
    if ([cityTF.text isEqualToString:@""]) {
        [self.paramters setObject:@"0" forKey:@"ucity"];
    }
    else {
        [self.paramters setObject:[self.city objectForKey:cityTF.text] forKey:@"ucity"];
    }
    
    [self.paramters setObject:dnDateTF.text forKey:@"syear"];
    [self.paramters setObject:upDateTF.text forKey:@"eyear"];
    
    [self dismissViewControllerAnimated:YES completion:self.completion];
}
@end

#pragma mark -
@implementation ForMyProductClientSift

@end

#pragma mark -
@implementation BoughtClientSift
{
    NSArray *_status;
    UITextField *nameTF;
    UITextField *statTF;
    UITextField *usageTF;
    UITextField *dnDateTF;
    UITextField *upDateTF;
    UIPickerView *picker;
}
@synthesize status = _status;
-(void)loadView
{
    [super loadView];
    UILabel *label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 85, 30)];
    label.text = @"客户姓名：";
    [self.view addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 85, 30)];
    label.text = @"处理状态：";
    [self.view addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 85, 30)];
    label.text = @"贷款用途：";
    [self.view addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 155, 85, 30)];
    label.text = @"购买时间：";
    [self.view addSubview:label];
    label = [[UILabel alloc] initWithFrame:CGRectMake(151, 185, 20, 30)];
    label.text = @"至";
    [self.view addSubview:label];
    
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 35, 200, 30)];
    nameTF.borderStyle = UITextBorderStyleRoundedRect;
    nameTF.font = [UIFont systemFontOfSize:15];
    nameTF.placeholder = @"按客户姓名搜索...";
    nameTF.delegate = self;
    [self.view addSubview:nameTF];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    
    statTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 75, 200, 30)];
    statTF.borderStyle = UITextBorderStyleRoundedRect;
    statTF.font = [UIFont systemFontOfSize:15];
    statTF.placeholder = @"处理状态（全部）";
    statTF.inputView = picker;
    statTF.delegate = self;
    [self.view addSubview:statTF];
    
    usageTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 115, 200, 30)];
    usageTF.borderStyle = UITextBorderStyleRoundedRect;
    usageTF.font = [UIFont systemFontOfSize:15];
    usageTF.placeholder = @"贷款用途（全部）";
    usageTF.inputView = picker;
    usageTF.delegate = self;
    [self.view addSubview:usageTF];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    dnDateTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 185, 130, 30)];
    dnDateTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    dnDateTF.borderStyle = UITextBorderStyleRoundedRect;
    dnDateTF.textAlignment = NSTextAlignmentCenter;
    dnDateTF.font = [UIFont systemFontOfSize:15];
    dnDateTF.placeholder = @"较早时间";
    dnDateTF.inputView = datePicker;
    [self.view addSubview:dnDateTF];
    
    upDateTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 185, 130, 30)];
    upDateTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    upDateTF.borderStyle = UITextBorderStyleRoundedRect;
    upDateTF.textAlignment = NSTextAlignmentCenter;
    upDateTF.font = [UIFont systemFontOfSize:15];
    upDateTF.placeholder = @"较晚时间";
    upDateTF.inputView = datePicker;
    [self.view addSubview:upDateTF];
    
    UIButton *button = nil;
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(70, 225, 80, 30);
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor titleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(170, 225, 80, 30);
    [self.view addSubview:button];
    
    [nameTF becomeFirstResponder];
}

-(NSArray *)status
{
    if (!_status) {
        _status = @[@"处理状态（全部）",@"未联系",@"已联系待办",@"已上门",@"已联系条件不符",@"已上门条件不符",@"已办理",@"已查阅条件不符"];
    }
    return _status;
}

-(void)dateChanged:(UIDatePicker *)sender
{
    NSDateComponents *component = [sender.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:sender.date];
    if ([dnDateTF isFirstResponder]) {
        dnDateTF.text = [NSString stringWithFormat:@"%d-%d-%d", component.year,component.month,component.day];
    }
    else if ([upDateTF isFirstResponder]) {
        upDateTF.text = [NSString stringWithFormat:@"%d-%d-%d", component.year,component.month,component.day];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == statTF) {
        self.pickerData = [[self.city allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([[self.city objectForKey:obj1] integerValue] < [[self.city objectForKey:obj2] integerValue]) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        [picker reloadAllComponents];
    }
    else if (textField == usageTF) {
        self.pickerData = self.usage;
        [picker reloadAllComponents];
    }
    return YES;
}

-(void)searchAction
{
    UserInfo *userInfo = [UserInfo shareInstance];
    [self.paramters setDictionary:@{@"username":userInfo.username,@"password":userInfo.password,@"id":userInfo.ID}];
    if ([statTF.text isEqualToString:@""]) {
        [self.paramters setObject:@"0" forKey:@"uzt"];
    }
    else {
        [self.paramters setObject:[NSString stringWithFormat:@"%d",[self.status indexOfObject:statTF.text]] forKey:@"ucity"];
    }
    
    if ([usageTF.text isEqualToString:@""]) {
        [self.paramters setObject:@"0" forKey:@"uyt"];
    }
    else {
        [self.paramters setObject:[NSString stringWithFormat:@"%d",[self.usage indexOfObject:usageTF.text] ] forKey:@"uyt"];
    }
    
    [self.paramters setObject:nameTF.text forKey:@"uname"];
    [self.paramters setObject:dnDateTF.text forKey:@"syear"];
    [self.paramters setObject:upDateTF.text forKey:@"eyear"];
    
    [self dismissViewControllerAnimated:YES completion:self.completion];
}
@end