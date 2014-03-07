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
}
@synthesize city = _city;
@synthesize usage= _usage;
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

-(void)searchAction{}

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
    return 0;
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
    NSArray *pickerData;
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
    label = [[UILabel alloc] initWithFrame:CGRectMake(151, 165, 20, 30)];
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
    
    dnDateTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 165, 130, 30)];
    dnDateTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    dnDateTF.borderStyle = UITextBorderStyleRoundedRect;
    dnDateTF.textAlignment = NSTextAlignmentCenter;
    dnDateTF.font = [UIFont systemFontOfSize:15];
    dnDateTF.placeholder = @"较早时间";
    dnDateTF.inputView = datePicker;
    [self.view addSubview:dnDateTF];
    
    upDateTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 165, 130, 30)];
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

#pragma mark Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == cityTF) {
        pickerData = [[self.city allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([[self.city objectForKey:obj1] integerValue] < [[self.city objectForKey:obj2] integerValue]) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
    }
    else if (textField == usageTF) {
        pickerData = self.usage;
    }
    [picker reloadAllComponents];
    return YES;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
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
    label = [[UILabel alloc] initWithFrame:CGRectMake(151, 125, 20, 30)];
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
    
    dnDateTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 125, 130, 30)];
    dnDateTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    dnDateTF.borderStyle = UITextBorderStyleRoundedRect;
    dnDateTF.textAlignment = NSTextAlignmentCenter;
    dnDateTF.font = [UIFont systemFontOfSize:15];
    dnDateTF.placeholder = @"较早时间";
    dnDateTF.inputView = datePicker;
    [self.view addSubview:dnDateTF];
    
    upDateTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 125, 130, 30)];
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
    button.frame = CGRectMake(170, 170, 80, 30);
    [self.view addSubview:button];
    
    [cityTF becomeFirstResponder];
}

@end

#pragma mark -

@implementation ForMyProductClientSift

@end

#pragma mark -
@implementation BoughtClientSift
{
    UITextField *nameTF;
    UITextField *statTF;
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
    label = [[UILabel alloc] initWithFrame:CGRectMake(151, 165, 20, 30)];
    label.text = @"至";
    [self.view addSubview:label];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    
    
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
    
    dnDateTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 165, 130, 30)];
    dnDateTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    dnDateTF.borderStyle = UITextBorderStyleRoundedRect;
    dnDateTF.textAlignment = NSTextAlignmentCenter;
    dnDateTF.font = [UIFont systemFontOfSize:15];
    dnDateTF.placeholder = @"较早时间";
    dnDateTF.inputView = datePicker;
    [self.view addSubview:dnDateTF];
    
    upDateTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 165, 130, 30)];
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
    button.frame = CGRectMake(170, 210, 80, 30);
    [self.view addSubview:button];
    
    [nameTF becomeFirstResponder];
}
@end