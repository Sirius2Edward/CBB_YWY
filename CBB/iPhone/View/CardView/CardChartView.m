//
#import <QuartzCore/QuartzCore.h>
#import "CardChartView.h"
#import "Request_API.h"
#import "UIColor+TitleColor.h"

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
        
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comp = [cal components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
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
    //返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backBarButton.frame = CGRectMake(0, 0, 51, 33);
    [backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    
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
    
    [values setArray:[NSArray arrayWithObjects:@200,@0,@100,@140, nil]];
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
    [pieChartView setAmountText:@"300张"];//
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [pieChartView reloadChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    dateLabel.text = [NSString stringWithFormat:@"%d年%d月",year,month];
    
    //更新月统计数据
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
}

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    percentLabel.text = [NSString stringWithFormat:@"%@占 %2.2f%%",[titles objectAtIndex:index],per*100];
}
- (void)onCenterClick:(PieChartView *)PieChartView
{
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < titles.count; i++) {
        [str appendFormat:@"%@:%@张\n",[titles objectAtIndex:i],[values objectAtIndex:i]];
    }
    [str appendString:@"\n受理成功率：40%"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据统计"
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [alert show];
}
@end
