//
//  MapViewController.m
//  CBB
//
//  Created by 卡宝宝 on 14-3-6.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()
{
    CLGeocoder *geoCoder;
    CLLocation *location;
}
@property(nonatomic,retain)MKMapView *mapView;
@end

@implementation MapViewController
@synthesize mapView;
- (id)init
{
    if (self = [super init]) {
        geoCoder = [CLGeocoder new];
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
    
    self.title = @"你的位置";
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGRect rect = self.view.frame;
    mapView = [[MKMapView alloc] initWithFrame:rect];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *oreillyAddress =@"北京市朝阳区广顺北大街33号院1号楼福码大厦B座12层";
    [geoCoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil){
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            location = firstPlacemark.location;
            MKCoordinateRegion viewRegion=MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000);
            MKCoordinateRegion adjustRegion=[mapView regionThatFits:viewRegion];
            [mapView setRegion:adjustRegion];
            
//            annotaion.streetAddress=firstPlacemark.name;
//            annotaion.coordinate= firstPlacemark.location.coordinate;
//            [mapView addAnnotation:]
        }
        
        else if ([placemarks count] == 0 &&
                 
                 error == nil){
            
            NSLog(@"Found no placemarks.");
            
        }
        
        else if (error != nil){
            
            NSLog(@"An error occurred = %@", error);
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
