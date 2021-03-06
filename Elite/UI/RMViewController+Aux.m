//
//  RMViewController+Aux.m
//  MessageGuru
//
//  Created by ramonqlee on 2/26/14.
//  Copyright (c) 2014 iDreems. All rights reserved.
//

#import "RMViewController+Aux.h"
#import "MobiSageSDK.h"
#import "Constants.h"
#import <objc/runtime.h>
#import "PulsingHaloLayer.h"

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)

NSString* kClientViewKey   = @"kClientView";
NSString* kPulsingHaloKey  = @"kPulsingHaloKey";

@interface UIViewController(RMViewController_Aux_Private)<MobiSageAdBannerDelegate>
@end

@implementation UIViewController(RMViewController_Aux)
//适配ios7
-(UIView*)clientView
{
    UIView* adapterView = (UIView*)objc_getAssociatedObject(self,&kClientViewKey);
    
    if (adapterView) {
        return adapterView;
    }
    
    CGFloat minusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (self.navigationController && !self.navigationController.navigationBar.hidden ) {
        minusHeight += self.navigationController.navigationBar.frame.size.height;
    }
    
    //adapterview，适配ios7
    adapterView = [[UIView alloc]initWithFrame:CGRectZero];
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.size.height -= minusHeight;
    if (IOS7) {
        rect.origin.y += minusHeight;
    }
    
    adapterView.frame = rect;
    [self.view addSubview:adapterView];
    [adapterView release];
    
    objc_setAssociatedObject(self, &kClientViewKey, adapterView, OBJC_ASSOCIATION_ASSIGN);
    
    return adapterView;
}
- (void)addNavigationButton:(UIBarButtonItem*)leftButtonItem withRightButton:(UIBarButtonItem*)rightButtonItem;
{
    // Dispose of any resources that can be recreated.
    if (!leftButtonItem) {
        self.navigationItem.leftBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"")
                                          style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(back)] autorelease];
    }
    
    if (leftButtonItem) {
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
    if (rightButtonItem) {
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
}

#pragma mark dismiss selector
-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark mobisage banner
-(UIView*)getMobisageBanner
{
    MobiSageAdBanner* adBanner = nil;
    if (adBanner == nil) {
        if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom) {
            adBanner = [[[MobiSageAdBanner alloc] initWithAdSize:Ad_728X90 withDelegate:self]autorelease];
            adBanner.frame = CGRectMake(20, 80, 728, 90);
        }
        else {
            adBanner = [[[MobiSageAdBanner alloc] initWithAdSize:Ad_320X50 withDelegate:self]autorelease];
            adBanner.frame = CGRectMake(0, 80, 320, 50);
        }
        
        //设置广告轮播动画效果
        [adBanner setSwitchAnimeType:Random];
    }
    return adBanner;
}

#pragma  mark MobiSageAdBannerDelegate
#pragma mark
- (UIViewController *)viewControllerToPresent
{
    return self;
}

/**
 *  横幅广告被点击
 *  @param adBanner
 */
- (void)mobiSageAdBannerClick:(MobiSageAdBanner*)adBanner
{
    NSLog(@"横幅广告被点击");
}

/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageAdBannerSuccessToShowAd:(MobiSageAdBanner*)adBanner
{
    NSLog(@"横幅广告请求成功并展示广告");
}
/**
 *  adBanner请求失败
 *  @param adBanner
 */
- (void)mobiSageAdBannerFaildToShowAd:(MobiSageAdBanner*)adBanner
{
    NSLog(@"横幅广告请求失败");
}
/**
 *  adBanner被点击后弹出LandingSit
 *  @param adBanner
 */
- (void)mobiSageAdBannerPopADWindow:(MobiSageAdBanner*)adBanner
{
    NSLog(@"被点击后弹出LandingSit");
}
/**
 *  adBanner弹出的LandingSit被关闭
 *  @param adBanner
 */
- (void)mobiSageAdBannerHideADWindow:(MobiSageAdBanner*)adBanner
{
    NSLog(@"弹出的LandingSit被关闭");
}

#pragma mark PulsingHalo
-(void)pulsingView:(UIView*)decoratedView
{
    [self pulsingView:decoratedView withRadius:0.0 withColor:nil];
}
-(void)pulsingView:(UIView*)decoratedView withRadius:(CGFloat)radius withColor:(UIColor *)color
{
    PulsingHaloLayer* adapterView = (PulsingHaloLayer*)objc_getAssociatedObject(self,&kPulsingHaloKey);
    
    if (adapterView) {
        return;
    }
    
    adapterView = [PulsingHaloLayer layer];
    adapterView.position = decoratedView.center;
    [decoratedView.superview.layer insertSublayer:adapterView below:decoratedView.layer];
    
    adapterView.radius = (radius<=1.0)?40:radius;
    if(!color)
    {
        color = [UIColor colorWithRed:1.0
                                green:0
                                 blue:0
                                alpha:1.0];
    }
    
    adapterView.backgroundColor = color.CGColor;
    
    objc_setAssociatedObject(self, &kPulsingHaloKey, adapterView, OBJC_ASSOCIATION_ASSIGN);
}
@end
