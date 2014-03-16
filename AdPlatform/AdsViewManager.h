//
//  AdsViewManager.h
//  HappyLife
//
//  Created by ramonqlee on 4/4/13.
//
//

#import <Foundation/Foundation.h>
#import "CommonHelper.h"
#import "RMIndexedArray.h"
#import "MobiSageSDK.h"

@interface AdsViewManager : NSObject<MobiSageRecommendDelegate,MobiSageAdBannerDelegate>

@property(nonatomic,retain)NSDictionary* configDict;//adType--RMIndexedArray

Decl_Singleton(AdsViewManager)

//get recommand button
-(UIView*)getMobisageRecommandButton:(NSDictionary*)item;

//get banner view
-(UIView*)getBannerView:(NSDictionary*)adsItem inViewController:(UIViewController*)controller;
-(UIView*)getFullscreenView:(NSDictionary*)adsItem inViewController:(UIViewController*)controller;

//recommend wall
-(BOOL)initRecommendWall:(NSDictionary*)item;
-(void)showRecommendWall:(NSDictionary*)item;

//offer wall
-(BOOL)initOfferwall:(NSDictionary*)item;
-(void)showOfferWall:(NSDictionary*)item;

@end
