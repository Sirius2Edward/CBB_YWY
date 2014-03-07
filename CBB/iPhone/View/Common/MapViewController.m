//

#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
#import "DataModel.h"

@interface MapViewController ()
{
    NSArray *statusArray;
    CLGeocoder *geoCoder;
    CLLocation *location;
    CAnnotation *annotation;
}
@property(nonatomic,retain)MKMapView *mapView;
@end

@implementation MapViewController
@synthesize mapView;
@synthesize address;
@synthesize status;
- (id)init
{
    if (self = [super init]) {
        geoCoder = [CLGeocoder new];
        annotation = [CAnnotation new];
        statusArray = @[@"未联系",@"已联系待办",@"已上门",@"已联系条件不符",@"已上门条件不符",@"已办理",@"已查阅条件不符"];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
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
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGRect rect = self.view.frame;
    mapView = [[MKMapView alloc] initWithFrame:rect];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
}
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"卡宝宝的位置";
    NSString *oreillyAddress =@"广州市萝岗区科学大道121号科城大厦B206";
    annotation.streetAddress = oreillyAddress;
    [geoCoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil){
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            location = firstPlacemark.location;
            MKCoordinateRegion viewRegion=MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000);
            MKCoordinateRegion adjustRegion=[mapView regionThatFits:viewRegion];
            [mapView setRegion:adjustRegion];
            annotation.status = @"已办理";
            annotation.coordinate= firstPlacemark.location.coordinate;
            [mapView addAnnotation:annotation];
            [mapView selectAnnotation:annotation animated:YES];
        }
        else if ([placemarks count] == 0 && error == nil){
            NSLog(@"Found no placemarks.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
}
*/
-(void)setAddress:(NSString *)aAddress
{
    annotation.streetAddress = aAddress;
    [geoCoder geocodeAddressString:aAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil){
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            location = firstPlacemark.location;
            MKCoordinateRegion viewRegion=MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000);
            MKCoordinateRegion adjustRegion=[mapView regionThatFits:viewRegion];
            [mapView setRegion:adjustRegion];
            annotation.coordinate = firstPlacemark.location.coordinate;
            [mapView addAnnotation:annotation];
            [mapView selectAnnotation:annotation animated:YES];
        }
        else if ([placemarks count] == 0 && error == nil){
            NSLog(@"Found no placemarks.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

-(void)setStatus:(NSString *)aStatus
{
    if (status == aStatus) return;
    if (aStatus.integerValue>0 && aStatus.integerValue < 8) {
        status = [statusArray objectAtIndex:aStatus.integerValue-1];
    }
    else {
        status = @"未知";
    }
    annotation.status = status;
}

-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Delegate

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
