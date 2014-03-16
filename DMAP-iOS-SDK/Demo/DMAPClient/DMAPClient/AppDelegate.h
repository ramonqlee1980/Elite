//
//  AppDelegate.h
//  DMAPClient
//
//  Created by besterChen on 13-5-18.
//  Copyright (c) 2013年 besterChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) ViewController *viewController;

@end
