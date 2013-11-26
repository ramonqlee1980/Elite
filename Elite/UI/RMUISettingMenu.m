//
//  RMLeftViewController.m
//  Elite
//
//  Created by Ramonqlee on 11/2/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMUISettingMenu.h"
#import "REMenu.h"
#import "SettingsViewController.h"
#import "RMFavoriteController.h"
#import "RMAppData.h"
#import "SoftRcmListViewController.h"

//#define kEnableTestData

#ifdef kEnableTestData
#import "RMArticle.h"
#endif

@interface RMUISettingMenu ()
{
    
}
@property(nonatomic,retain)UIViewController* parentViewController;
@property(nonatomic,retain)REMenu* menu;
@end

@implementation RMUISettingMenu
@synthesize parentViewController=_parentViewController;
@synthesize menu=_menu;
-(void)dealloc
{
    self.menu = nil;
    self.parentViewController = nil;
    
    [super dealloc];
}
-(void)showFromController:(UIViewController *)controller
{
    self.parentViewController = controller;
    
    if (_menu && _menu.isOpen)
        return [_menu close];
    
    REMenuItem *settingItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Tab_Title_Setting", @"Setting")
                                                    subtitle:@""
                                                       image:nil//[UIImage imageNamed:@"sidebar_nav_default.png"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                          SettingsViewController* vc = [[SettingsViewController alloc]init];
                                                          UINavigationController *navController = [[[UINavigationController alloc]initWithRootViewController:vc]autorelease];
                                                          [self.parentViewController presentViewController:navController animated:YES completion:nil];
                                                      }];
    REMenuItem *recommendItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Tab_Title_RecommmendApps", @"Setting")
                                                       subtitle:@""
                                                          image:nil//[UIImage imageNamed:@"sidebar_nav_default.png"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             SoftRcmListViewController* recommendController = [[[SoftRcmListViewController alloc]initWithStyle:UITableViewStyleGrouped]autorelease];
                                                             UINavigationController* navi = [[[UINavigationController alloc]initWithRootViewController:recommendController]autorelease];
                                                             recommendController.title = NSLocalizedString(Tab_Title_RecommmendApps, @"");
                                                             [self.parentViewController presentViewController:navi animated:YES completion:nil];
                                                         }];
    
    
    
    REMenuItem *favoriteItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Tab_Title_Favorites",@"Favorite")
                                                       subtitle:@""
                                                          image:nil//[UIImage imageNamed:@"sidebar_nav_default.png"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             
                                                             RMFavoriteController* vc = [[[RMFavoriteController alloc]init]autorelease];
                                                             vc.title = NSLocalizedString(Tab_Title_Favorites, @"");
                                                             UINavigationController *navController = [[[UINavigationController alloc]initWithRootViewController:vc]autorelease];
                                                             [self.parentViewController presentViewController:navController animated:YES completion:nil];
                                                         }];
    
    
    
    settingItem.tag = 0;
    favoriteItem.tag = 1;
    recommendItem.tag = 2;
    
    _menu = [[REMenu alloc] initWithItems:@[settingItem,recommendItem,favoriteItem]];
    _menu.cornerRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    
    [_menu showFromNavigationController:controller.navigationController];
}

@end
