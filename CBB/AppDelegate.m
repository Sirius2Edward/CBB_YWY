//
//  AppDelegate.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-6.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "AppDelegate.h"
#import "Login.h"
#import "UIColor+TitleColor.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    Login *login = [Login new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        nav.navigationBar.barTintColor = [UIColor titleColor];
        nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                                 NSForegroundColorAttributeName,
                                                 [UIFont fontWithName:@"Arial-Bold" size:20.0],
                                                 NSFontAttributeName,nil];
    }
    else
    {
        nav.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top.jpg"]];
    }
#endif
    
//     Image:[UIImage imageNamed:@"top.jpg"] forBarMetrics:UIBarMetricsDefault];
//    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{}

- (void)applicationDidEnterBackground:(UIApplication *)application{}

- (void)applicationWillEnterForeground:(UIApplication *)application{}

- (void)applicationDidBecomeActive:(UIApplication *)application{}

- (void)applicationWillTerminate:(UIApplication *)application{}

@end
