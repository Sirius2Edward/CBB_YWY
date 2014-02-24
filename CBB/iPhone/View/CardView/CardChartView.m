//
#import <QuartzCore/QuartzCore.h>
#import "CardChartView.h"
#import "Request_API.h"
#import "UIColor+TitleColor.h"
#import "DataModel.h"

@interface CardChartView ()
{
    PieChartView *pieChartView;
    Request_API *req;
    NSInteger year;
    NSInteger month;
    UILabel *dateLabel;
    UILabel *percentLabel;
    NSArray *titles;
    NSMutableArray *values;
    NSString *total;
    
    NSCalendar *cal;
    NSDateComponents *comp;
}
@end

@implementation CardChartView
@synthesize statistics;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        req = [Request_API shareInstance];
        req.delegate = self;
        
        titles = [NSArray arrayWithObjects:@"成功量",@"条件不符",@"待办",@"未联系", nil];
        values = [NSMutableArray array];
        
        cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        comp = [cal components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
        year = comp.year;
        month = comp.month;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.title = @"月表量统计";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif
    
    //返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backBarButton.frame = CGRectMake(0, 0, 51, 33);
    [backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    
    [self reloadData];
    
    UIImageView *topBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"box2_out.png"]];
    topBG.frame = CGRectMake(7.5, 15, 305, 41);
    topBG.userInteractionEnabled = YES;
    [self.view addSubview:topBG];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 205, 41)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor titleColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = [NSString stringWithFormat:@"%d年%d月",year,month];
    [topBG addSubview:dateLabel];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"btn2.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"btn1.png"] forState:UIControlStateHighlighted];
    leftBtn.frame = CGRectMake(9, 10, 21.5, 21.5);
    [leftBtn addTarget:self action:@selector(decMonth:) forControlEvents:UIControlEventTouchUpInside];
    [topBG addSubview:leftBtn];
    leftBtn.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"btn2.png"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"btn1.png"] forState:UIControlStateHighlighted];
    rightBtn.frame = CGRectMake(275, 10, 21.5, 21.5);
    [rightBtn addTarget:self action:@selector(incMonth:) forControlEvents:UIControlEventTouchUpInside];
    [topBG addSubview:rightBtn];
    
    NSMutableArray *colorArray = [NSMutableArray arrayWithObjects:
                                  [UIColor colorWithHue:((3/4)%20)/20.0+0.02 saturation:(3%4+3)/10.0 brightness:91/100.0 alpha:1],
                                  [UIColor colorWithHue:((2/4)%20)/20.0+0.02 saturation:(2%4+3)/10.0 brightness:91/100.0 alpha:1],
                                  [UIColor colorWithHue:((1/4)%20)/20.0+0.02 saturation:(1%4+3)/10.0 brightness:91/100.0 alpha:1],
                                  [UIColor colorWithHue:((0/4)%20)/20.0+0.02 saturation:(0%4+3)/10.0 brightness:91/100.0 alpha:1], nil];
    
    ///图表绘制    
    UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
    UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
    shadowImgView.frame = CGRectMake(0, 290, shadowImg.size.width, shadowImg.size.height);
    [self.view addSubview:shadowImgView];
    
    pieChartView = [[PieChartView alloc]initWithFrame:CGRectMake(50, 100, 220, 220) withValue:values withColor:colorArray];
    pieChartView.delegate = self;
    [pieChartView setTitleText:@"本月受理"];
    [pieChartView setAmountText:[NSString stringWithFormat:@"%@张",total]];//
    [self.view addSubview:pieChartView];
    
    UIImageView *selView = [[UIImageView alloc]init];
    selView.image = [UIImage imageNamed:@"detailLabel.png"];
    selView.frame = CGRectMake((self.view.frame.size.width - selView.image.size.width)/2, pieChartView.frame.origin.y + pieChartView.frame.size.height, selView.image.size.width, selView.image.size.height);
    [self.view addSubview:selView];
    
    percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, selView.image.size.width, 21)];
    percentLabel.backgroundColor = [UIColor clearColor];
    percentLabel.textAlignment = NSTextAlignmentCenter;
    percentLabel.font = [UIFont systemFontOfSize:17];
    percentLabel.textColor = [UIColor whiteColor];
    [selView addSubview:percentLabel];
    
    CGFloat x = 30;
    CGFloat y = 70;
    for (int i = 0 ; i < 8; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i%2) {
            label.font = [UIFont systemFontOfSize:14];
            label.text = [titles objectAtIndex:i/2];
            label.backgroundColor = [UIColor clearColor];
            label.frame = CGRectMake(x, y, 20, 20);
            [label sizeToFit];            
            x += label.bounds.size.width+5;
        }
        else {
            label.backgroundColor = [colorArray objectAtIndex:i/2];
            label.frame = CGRectMake(x, y, 18, 18);
            x +=20;
        }
        [self.view addSubview:label];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [pieChartView reloadChart];
}

-(void)reloadData
{
    //加载本月数据
    NSString *success = [statistics objectForKey:@"success"];
    NSString *noMatch = [statistics objectForKey:@"nomatch"];
    NSString *wait    = [statistics objectForKey:@"wait"];
    NSString *noCont  = [statistics objectForKey:@"nocontact"];
    total   = [statistics objectForKey:@"total"];
    
    if (total.intValue == 0) {
        [values setArray:@[@77777,@0,@0,@0]];
    }
    else {
        [values setArray:@[[NSNumber numberWithInt:success.intValue],
                           [NSNumber numberWithInt:noMatch.intValue],
                           [NSNumber numberWithInt:wait.intValue],
                           [NSNumber numberWithInt:noCont.intValue]]];
    }
}

-(void)requestWithMonth:(NSInteger)aMonth Year:(NSInteger)aYear
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSDictionary *sDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          userInfo.username,@"username",
                          userInfo.password,@"password",
                          [NSString stringWithFormat:@"%d",aMonth],@"year",
                          [NSString stringWithFormat:@"%d",aYear],@"month",nil];
    [req cardStatisticWithDic:sDic];
}

#pragma mark - Action
-(void)popAction
{
    [req cancel];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)incMonth:(UIButton *)sender
{
    month++;
    if (month>12) {
        month = 1;
        year++;
    }
    if (year>=comp.year && month>comp.month) {
        month = comp.month;
        year = comp.year;
        return;
    }
    dateLabel.text = [NSString stringWithFormat:@"%d年%d月",year,month];
    
    //更新月统计数据
    [self requestWithMonth:month Year:year];
}

-(void)decMonth:(UIButton *)sender
{
    month--;
    if (month<1) {
        month = 12;
        year--;
    }
    dateLabel.text = [NSString stringWithFormat:@"%d年%d月",year,month];
    
    //更新月统计数据
    [self requestWithMonth:month Year:year];
}

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    percentLabel.text = [NSString stringWithFormat:@"%@占 %2.2f%%",[titles objectAtIndex:index],per*100];
}
- (void)onCenterClick:(PieChartView *)PieChartView
{
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < titles.count; i++) {
        NSNumber *val = [values objectAtIndex:i];
        if ([val isEqualToNumber:@77777]) {
            val = @0;
        }
        [str appendFormat:@"%@:%@张\n",[titles objectAtIndex:i],val];
    }
    int sucNum = [(NSNumber *)[values objectAtIndex:0] intValue];
    int totNum = total.intValue;
    if (totNum == 0) {
        [str appendString:@"\n受理成功率：100%"];
    }
    else {
        float percent = sucNum/total.intValue*100;
        [str appendFormat:@"\n受理成功率：%.1f%%",percent];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据统计"
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)statisticEnd:(id)aDic
{
    self.statistics = [[[aDic objectForKey:@"XYKServlet1"] objectForKey:@"result"] copy];
    [self reloadData];
    [pieChartView reloadChart];
}
@end
