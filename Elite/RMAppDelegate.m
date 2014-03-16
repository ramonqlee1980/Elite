//
//  RMAppDelegate.m
//  Elite
//
//  Created by Ramonqlee on 11/2/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMAppDelegate.h"
#import "RMUIMainController.h"
#import "RMUISettingMenu.h"
#import "RMUIChannelsUIController.h"
#import "RMChannelDataManager.h"
#import "RMAppData.h"
#import "RMChannels.h"
#import "UMSocial.h"
#import "MobiSageSDK.h"
#import "AdsConfiguration.h"
#import "Flurry.h"
#import "RMSyncAdData.h"
#import "UMSocialWechatHandler.h"

#ifdef DPRAPR_PUSH
#import "DMAPService.h"
#import "DMAPTools.h"
#endif

@interface RMAppDelegate()
{
    BOOL retryWhenFail2SyncChannels;
}
@end
@implementation RMAppDelegate
@synthesize sideBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    sideBarController = [[[SideBarViewController alloc]initWithNibName:@"SideBarViewController" bundle:nil]autorelease];
    sideBarController.delegate = self;
    self.window.rootViewController = sideBarController;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //navigation bar style
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_navigation_background_88.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    [self refreshChannels];
    [self initSettings:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self refreshChannels];
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    /*
     //如果你要处理自己的url，你可以把这个方法的实现，复制到你的代码中：
     
     if ([url.description hasPrefix:@"sina"]) {
     return (BOOL)[[UMSocialSnsService sharedInstance] performSelector:@selector(handleSinaSsoOpenURL:) withObject:url];
     }
     else if([url.description hasPrefix:@"wx"]){
     return [WXApi handleOpenURL:url delegate:(id <WXApiDelegate>)[UMSocialSnsService sharedInstance]];
     }
     */
    
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark SideBarViewControllerDelegate
- (UIViewController*)middleViewController
{
    //TODO::subchannel of current channel
    RMUIMainController* scrollBarController = [[[RMUIMainController alloc]init]autorelease];
    [RMAppData sharedInstance].scrollBarController = scrollBarController;
    
    return [[UINavigationController alloc]initWithRootViewController:[RMAppData sharedInstance].scrollBarController];
}
-(UIViewController*)leftViewController:(id<SiderBarDelegate>)delegate
{
#if 0//暂时关闭左边栏
    [RMAppData sharedInstance].channelsUIController= [[[RMUIChannelsUIController alloc]init]autorelease];
    return [RMAppData sharedInstance].channelsUIController;
#endif
    return nil;
}
-(UIViewController*)rightViewController:(id<SiderBarDelegate>)delegate
{
    return nil;
    //    [RMAppData sharedInstance].settinController = [[[RMUISettingController alloc]init]autorelease];
    //    return [[[UINavigationController alloc]initWithRootViewController:[RMAppData sharedInstance].settinController]autorelease];
}
#pragma mark data observer
-(void)addDataObserver
{
    //set data observer
    RMAppData* appData = [RMAppData sharedInstance];
    RMChannelDataManager* mgr = appData.channelDataManager;
    [mgr setDataObserver:^{
        //error occurs?
        if (!mgr.channelsObj || mgr.channelsObj.titleArray.count==0) {
            if (retryWhenFail2SyncChannels) {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      
                                      initWithTitle:NSLocalizedString(kDlgTitle,@"")
                                      
                                      message:NSLocalizedString(kRetry2SyncChannels, @"")
                                      
                                      delegate: self
                                      
                                      cancelButtonTitle:NSLocalizedString(kCancel, @"")
                                      
                                      otherButtonTitles:NSLocalizedString(kOK, @""),nil];
                
                [alert show];  //显示
                
                [alert release];
            }
            return;
        }
        //current channel ui controller
        appData.scrollBarController.channelName = mgr.currentChannel;
        [appData.scrollBarController setChannelItemArray:[mgr.channelsObj channelForName:mgr.currentChannel]];
        //TODO::setting ui controller
        
        //channels manager ui controller
        appData.channelsUIController.currentChannel = mgr.currentChannel;
        appData.channelsUIController.channelsArray = mgr.channelsObj;
        
    }];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
#define kOKButton 1
    retryWhenFail2SyncChannels = NO;
    if (buttonIndex==kOKButton) {
        [self refreshChannels];
        retryWhenFail2SyncChannels = YES;
    }
}

#pragma mark switch left&right viewcontroller
-(void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    if (sideBarController) {
        [sideBarController showSideBarControllerWithDirection:direction];
    }
}

#pragma util method
-(void)initSettings:(NSDictionary *)launchOptions
{
    //打开调试log的开关
    [UMSocialData openLog:NO];
    //向微信注册
    [UMSocialWechatHandler setWXAppId:kWeixinID url:nil];
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //set umeng key
    [UMSocialData setAppKey:UMENG_APPKEY];
    
    [[MobiSageManager getInstance]setPublisherID:[[AdsConfiguration sharedInstance]mobisageId]];
    //start flurry session
    [Flurry startSession:kFlurryID];
    [Flurry setCrashReportingEnabled:YES];
    
    retryWhenFail2SyncChannels = YES;//初始化重试标示
    
#ifdef DPRAPR_PUSH
    // Required
    [DMAPService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                     UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    // Required
    [DMAPService setupWithOption:launchOptions];

//    [DMAPTools developerTestMode];
#endif
    
}
//请求频道数据
-(void)refreshChannels
{
    [self addDataObserver];
    [[RMAppData sharedInstance].channelDataManager startRequest:kChannelUrl];
    //TODO::请求广告数据，包括广告的id和开关信息
    [[RMSyncAdData sharedInstance]startRequest];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //   token deviceId  publicKey
#ifdef DPRAPR_PUSH
    [DMAPService registerDeviceToken:deviceToken];
#endif
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error:%@", [error description]);
    
}

-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    // Required
#ifdef DPRAPR_PUSH
    [DMAPService handleRemoteNotification:userInfo];
#endif
}

@end
