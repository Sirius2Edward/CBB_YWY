
#import "CardInfoModify.h"

@interface CardInfoModify ()
{
    NSDictionary *jobs;
    CustomPicker *picker;
    CustomTextField *activeText;
}
@end

@implementation CardInfoModify
-(void)loadView
{
    [super loadView];    
    self.scrollView.contentSize = CGSizeMake(320, 935);
    [self setTitle:@"资料修改"];
    
    UIImage *unBoxImage = [UIImage imageNamed:@"box5_out.png"];
    UIImage *listBoxDownImage = [UIImage imageNamed:@"box1_down.png"];
    UIImage *listBoxOutImage = [UIImage imageNamed:@"box1_out.png"];
    UIImage *boxDownImage = [UIImage imageNamed:@"box2_down.png"];
    UIImage *boxOutImage = [UIImage imageNamed:@"box2_out.png"];
    
    jobs = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"业务代表（一线销售）",@"2"
            ,@"业务组长（管理5-30人）",@"3",@"业务经理（管理30人以上）", @"4",@"其他管理层",nil];
    
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *info = userInfo.userInfo;
    
    NSArray *infoArr = [NSArray arrayWithObjects:
                        @"请输入您的密码以便确认",
                        userInfo.username,
                        [info objectForKey:@"company"],
                        [info objectForKey:@"city"],
                        [info objectForKey:@"bank1"],
                        [info objectForKey:@"workid"],
                        [info objectForKey:@"username"],
                        [info objectForKey:@"tel"],
                        [info objectForKey:@"mobile"],
                        [info objectForKey:@"email"],
                        [info objectForKey:@"remark"],
                        [info objectForKey:@"address"],
                        [info objectForKey:@"qq"],nil];
    NSArray *placeHolders = [NSArray arrayWithObjects:@"请输入您的联系地址",
                             @"请输入QQ号码", nil];
    
    for (int i = 0; i < 13; i++) {
        CustomTextField *textField = [CustomTextField new];
        textField.tag = 1000+i;
        if (i > 0 && i < 10) {
            textField.textOutImage = unBoxImage;
            textField.tField.text = [infoArr objectAtIndex:i];
            textField.tField.enabled = NO;
        }
        else if (i == 10) {
            textField.textDownImage = listBoxDownImage;
            textField.textOutImage = listBoxOutImage;
            textField.tField.text = [infoArr objectAtIndex:i];
            textField.tField.placeholder = @"请输入您的职务";
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(265, 0, 40, 41);
            [btn addTarget:self action:@selector(listJobs:) forControlEvents:UIControlEventTouchUpInside];
            [textField addSubview:btn];
        }
        else {
            textField.textOutImage = boxOutImage;
            textField.textDownImage = boxDownImage;
            if (i == 0) {
                textField.maxLength = 15;
                textField.tField.secureTextEntry = YES;
                textField.tField.placeholder = [infoArr objectAtIndex:i];
                textField.tField.text = @"";
            }
            else {
                if (i == 12 ) {
                    textField.tField.keyboardType = UIKeyboardTypeNumberPad;
                    textField.maxLength = 13;
                }
                textField.tField.text = [infoArr objectAtIndex:i];
                textField.tField.placeholder = [placeHolders objectAtIndex:i-11];
            }
        }
        [self.scrollView addSubview:textField];
    }
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    tip.font = [UIFont systemFontOfSize:14];
    tip.backgroundColor = [UIColor whiteColor];
    tip.alpha = 0.81;
    tip.text = @"     温馨提示：* 为不能修改";
    tip.textColor = [UIColor titleColor];
    [self.view addSubview:tip];
    
    CGFloat x = 13;
    CGFloat y = 67;
    CGRect rect;
    rect.size = CGSizeMake(200, 41);
    NSArray *arr = [NSArray arrayWithObjects:@"会员账号",@"公司名称",@"所在城市",@"所属银行",@"工作证号",
                    @"真实姓名",@"联系电话",@"手机号码",@"电子邮箱",@"职务",@"联系地址",@"联系QQ", nil];
    for (int j = 0; j < arr.count; j++) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = [arr objectAtIndex:j];
        rect.origin = CGPointMake(x, y);
        label.frame = rect;
        [self.scrollView addSubview:label];
        y += 70;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutViews];
}

- (void)layoutViews
{
    CGRect rect;
    rect.size = CGSizeMake(305, 41);
    CGFloat x = 7.5f;
    CGFloat y = 30.0f;
    for (int i = 0; i < 15; i++) {
        CustomTextField *textField = (CustomTextField *)[self.view viewWithTag:i+1000];
        rect.origin = CGPointMake(x, y);
        textField.frame = rect;
        textField.leftOffset = 10;
        
        if (i == 10) {
            textField.rightOffset = 40;
        }
        y += 70;
    }
}

//弹出职务列表
-(void)listJobs:(UIButton *)sender
{
    CustomTextField *textField = (CustomTextField *)[sender superview];
    activeText = textField;
    
    if (picker) {
        [picker removeFromSuperview];
    }
    picker = [[CustomPicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, 320, 260)];
    picker.data = jobs;
    picker.components = 1;
    picker.delegate = self;
    [picker showPickerInView:self.view];
    [self.view endEditing:YES];
}


-(void)submit
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    UserInfo *info = [UserInfo shareInstance];
    [mDic setObject:info.username forKey:@"username"];
    [mDic setObject:info.ID forKey:@"id"];
    
    for (int i = 0; i < 13; i++) {
        CustomTextField *textField = (CustomTextField *)[self.view viewWithTag:i+1000];
        if (i == 0)
        {
            if ([textField.tField.text isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"密码不能为空！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"重新输入"
                                                      otherButtonTitles: nil];
                [alert show];
                return;
            }
            [mDic setObject:textField.tField.text forKey:@"password"];
        }
        else if (i == 7)
        {
            [mDic setObject:textField.tField.text forKey:@"Mem_Tel"];
        }
        else if (i == 8)
        {
            [mDic setObject:textField.tField.text forKey:@"mem_mobile"];
        }
        else if (i == 9)
        {
            [mDic setObject:textField.tField.text forKey:@"Mem_email"];
        }
        if (i > 9 && i < 13) {
            if (i == 10) {
                NSString *jobID = [textField.tField.text getIDfromDic:jobs WithTypeName:@"职务"];
                if (!jobID) {
                    return;
                }
                [mDic setObject:textField.tField.text forKey:@"Mem_Remark"];
            }
            else if (i == 12) {
                if (![textField.tField.text isQQNumber]) {
                    return;
                }
                [mDic setObject:textField.tField.text forKey:@"Mem_qq"];
            }
            else {
                if ([textField.tField.text isEqualToString:@""]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"联系地址不能为空！"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"重新输入"
                                                          otherButtonTitles: nil];
                    [alert show];
                    return;
                }
                [mDic setObject:textField.tField.text forKey:@"mem_addr"];
            }
        }
    }
//    for (NSString *key in [mDic allKeys]) {
//        NSLog(@"%@ -- %@",key,[mDic objectForKey:key]);
//    }
    self.req = [Request_API shareInstance];
    self.req.delegate = self;
    [self.req cardInfoModifyWithDic:mDic];
}

-(void)connectEnd:(id)aDic
{
    [self popAction];
}
#pragma mark -
-(void)confirmAction:(NSString *)value WithInfo:(NSDictionary *)info
{
    activeText.tField.text = value;
    activeText = nil;
}

-(void)selectAction:(NSString *)value
{
    activeText.tField.text = value;
}
@end
