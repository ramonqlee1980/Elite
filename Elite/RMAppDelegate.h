//
//  RMAppDelegate.h
//  Elite
//
//  Created by Ramonqlee on 11/2/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarViewController.h"

@class  RMAppDelegate;
@class  RMUIMainController;

#define ShareAppDelegate [[UIApplication sharedApplication]delegate]

@interface RMAppDelegate : UIResponder <UIApplicationDelegate,SideBarViewControllerDelegate,UIAlertViewDelegate>

@property (retain, nonatomic)SideBarViewController* sideBarController;
@property (strong, nonatomic) UIWindow *window;


-(void)showSideBarControllerWithDirection:(SideBarShowDirection)direction;
@end
