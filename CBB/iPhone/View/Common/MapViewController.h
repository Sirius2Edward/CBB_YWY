//
//  MapViewController.h
//  CBB
//
//  Created by 卡宝宝 on 14-3-6.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController<MKMapViewDelegate>
@property(nonatomic,retain)NSString *address;
@end
