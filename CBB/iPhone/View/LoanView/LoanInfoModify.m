
#import "LoanInfoModify.h"

@interface LoanInfoModify ()

@end

@implementation LoanInfoModify
-(void)loadView
{
    [super loadView];
    self.scrollView.contentSize = CGSizeMake(320, 800);
    [self setTitle:@"资料修改"];
    
    UIImage *unBoxImage = [UIImage imageNamed:@"box5_out.png"];
    UIImage *boxDownImage = [UIImage imageNamed:@"box2_down.png"];
    UIImage *boxOutImage = [UIImage imageNamed:@"box2_out.png"];
    
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *info = userInfo.userInfo;

    NSArray *infoArr = [NSArray arrayWithObjects:
                        @"请输入您的密码以便确认",
                        userInfo.username,
                        [info objectForKey:@"workname"],
                        [info objectForKey:@"workaddress"],
                        [NSString stringWithFormat:@"%@ - %@",[info objectForKey:@"sheng"],[info objectForKey:@"city"]],
                        [info objectForKey:@"username"],
                        [info objectForKey:@"worktel"],
                        [info objectForKey:@"mobile"],
                        [info objectForKey:@"email"],
                        [info objectForKey:@"worktype"],
                        [info objectForKey:@"qq"],nil];
    
    NSArray *placeHolders = [NSArray arrayWithObjects:@"请输入您的电子邮箱",@"请输入您的职务",@"请输入QQ号码", nil];
    
    for (int i = 0; i < 11; i++) {
        CustomTextField *textField = [CustomTextField new];
        textField.tag = 1000+i;
        if (i > 0 && i < 8) {
            textField.textOutImage = unBoxImage;
            textField.tField.enabled = NO;
            textField.tField.text = [infoArr objectAtIndex:i];
        }
        else {
            textField.textOutImage = boxOutImage;
            textField.textDownImage = boxDownImage;
            if (i == 0) {
                textField.tField.secureTextEntry = YES;
                textField.tField.placeholder = [infoArr objectAtIndex:i];
                textField.tField.text = @"";
            }
            else {                
                if (i == 8) {
                    textField.tField.keyboardType = UIKeyboardTypeEmailAddress;
                }
                else if(i == 10){
                    textField.tField.keyboardType = UIKeyboardTypeNumberPad;
                }
                textField.tField.placeholder = [placeHolders objectAtIndex:i-8];
                textField.tField.text = [infoArr objectAtIndex:i];
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
    NSArray *arr = [NSArray arrayWithObjects:@"邮箱账号",@"公司名称",@"公司地址",@"所在城市",
                    @"真实姓名",@"联系电话",@"手机号码",@"电子邮箱",@"职务",@"QQ", nil];
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
    for (int i = 0; i < 13; i++) {
        CustomTextField *textField = (CustomTextField *)[self.view viewWithTag:i+1000];
        rect.origin = CGPointMake(x, y);
        textField.frame = rect;
        textField.leftOffset = 10;        
        y += 70;
    }
}


-(void)submit
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    UserInfo *info = [UserInfo shareInstance];
    [mDic setObject:info.username forKey:@"username"];
    [mDic setObject:info.ID forKey:@"id"];
    
    for (int i = 0; i < 11; i++) {
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
        else if (i == 6) {
            [mDic setObject:textField.tField.text forKey:@"worktel"];
        }        
        else if (i == 7) {
            [mDic setObject:textField.tField.text forKey:@"mobile"];
        }
        else if (i == 8) {
            if (![textField.tField.text isEmailAddress]) {
                return;
            }
            [mDic setObject:textField.tField.text forKey:@"email"];
        }
        else if (i == 9){
            if ([textField.tField.text isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"职务不能为空！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"重新输入"
                                                      otherButtonTitles: nil];
                [alert show];
                return;
            }
            [mDic setObject:textField.tField.text forKey:@"worktype"];
        }
        else if (i == 10) {
            if ([textField.tField.text isEqualToString:@""]) {
                continue;
            }
            if (![textField.tField.text isQQNumber]) {
                return;
            }
            [mDic setObject:textField.tField.text forKey:@"QQ"];
        }
    }    
//    for (NSString *key in [mDic allKeys]) {
//        NSLog(@"%@ -- %@",key,[mDic objectForKey:key]);
//    }    
    self.req = [Request_API shareInstance];
    self.req.delegate = self;
    [self.req loanInfoModifyWithDic:mDic];
}

-(void)connectEnd:(id)aDic
{
    [self popAction];
}
@end
