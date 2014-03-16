//
//  AppDelegate.m
//  DMAPClient
//
//  Created by besterChen on 13-5-18.
//  Copyright (c) 2013年 besterChen. All rights reserved.
//

#import "AppDelegate.h"
#import "DMAPService.h"
#import "DMAPTools.h"

#import "ViewController.h"

@implementation AppDelegate
@synthesize locManager;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    
    // 开启开发者测试模式
    [DMAPTools developerTestMode];
    
    // Required
    [DMAPService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    // Required
    [DMAPService setupWithOption:launchOptions];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //   token deviceId  publicKey
    [DMAPService registerDeviceToken:deviceToken];
    
    [self.viewController setDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error:%@", [error description]);
    
}

-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    // Required
    [DMAPService handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locManager.distanceFilter = 5.0;
    [self.locManager startUpdatingLocation];
    
    [DMAPService setUserInfo:@"besterChen" gender:@"男" birthday:@"未知" postCode:@"2703645" telNumber:@"1373838438" email:@"boatcjz@gmail.com"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [DMAPService setLocation:newLocation];
    [self.locManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.locManager stopUpdatingLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
