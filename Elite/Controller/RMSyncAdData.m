//
//  RMSyncAdData.m
//  Elite
//
//  Created by Ramonqlee on 11/29/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMSyncAdData.h"
#import "HTTPHelper.h"
#import "AdsConfiguration.h"
#import "MobiSageSDK.h"


#define kSyncAdsJsonUrl @"http://checknewversion.duapp.com/getadsconfig.php"


@interface RMSyncAdData()
@property(copy)UPDATE dataCallback;
    @property(assign)BOOL displayed;
@end

@implementation RMSyncAdData
    
    Impl_Singleton(RMSyncAdData)
    
-(void)startRequest
    {
        //请求频道数据
        NSDictionary* dict = [CommonHelper getAdPostReqParams];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResult:) name:kSyncAdsJsonUrl object:nil];
        [[HTTPHelper sharedInstance]beginPostRequest:kSyncAdsJsonUrl withDictionary: dict];
    }
    
    //TODO::根据从服务器获得的数据，更新本地数据
-(void)getResult:(NSNotification*)notification
    {
        if (notification && notification.object && ![notification.object isKindOfClass:[NSError class]]) {
            if (!notification.userInfo || notification.userInfo.count==0) {
                return;
            }
            
            //parse ads and send notification
            AdsConfiguration* adsConfig = [AdsConfiguration sharedInstance];
            if(![adsConfig initWithJson:[notification.userInfo objectForKey:kSyncAdsJsonUrl]])
            {
                return;
            }
            
            //youmi config
            //            [YouMiConfig setShouldGetLocation:NO];
            //            [YouMiConfig launchWithAppID:[[AdsConfiguration sharedInstance]youmiAppId] appSecret:[[AdsConfiguration sharedInstance]youmiSecret]];
            //            BOOL rewarded = YES;
            //            [YouMiSpot requestSpotADs:rewarded];
            
            //adsage
            //        [[AdSageManager getInstance]setAdSageKey:[[AdsConfiguration sharedInstance]mobisageId]];
//            [[MobiSageManager getInstance]setPublisherID:[[AdsConfiguration sharedInstance]mobisageId]];
            
            //notify
            [[NSNotificationCenter defaultCenter]postNotificationName:kAdsConfigUpdated object:nil];
            
            [[NSNotificationCenter defaultCenter]removeObserver:self name:kSyncAdsJsonUrl object:nil];
        }
    }
-(void)stopRequest
    {
        
    }
    
-(void)setDataObserver:(UPDATE)callback
    {
        self.dataCallback = callback;
    }
-(BOOL)recommmendWallVisible
    {
        if (_displayed) {
            return NO;
        }
        _displayed = YES;
        return _displayed;
    }
    @end
