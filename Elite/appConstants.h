#ifndef DailyProject_appConstants_h
#define DailyProject_appConstants_h


#define UMENG_APPKEY @"5288a23356240b9bef15f30b"//umeng sdk 所需要的key
#define kDefaultMobisageId @"620d94c9d3594cd88352a9efff1f48e6"//申请专用的id
#define kFlurryID @"6D2KNQGDFGHJ4Y5S58ZH"//mmbasics
#define kWeixinID @"wx069cb31cc2c774a0"
#define kAppId 759202888


#warning 发布时确认
//1.drappr为非测试模式
//2.更新info中的weixin appid
//3.更新drappr的appkey
//4.修改bundleId的定义，见本文件
//5.修改iap中的id，见Define.h文件

//#define __RELEASE__
#ifdef __RELEASE__
#define DPRAPR_PUSH//push广告开关
//#define __PUSH_ON__TEST_MODE__//testmode
//#define NSLog(...) {}
#endif//__RELEASE__

#define kDefaultEmailRecipients @"feedback4iosapp@gmail.com"

//db design 
#define FAVORITE_DB_NAME    @"favorite.sqlite"
#define kDBTableName    @"Content"
#define kDBTitle         @"Title"
#define kDBLowercaseTitle         @"title"
#define kDBSummary       @"Summary"
#define kDBLowercaseSummary      @"summary"
#define kDBContent       @"Content"
#define kDBLowercaseContent       @"content"
#define kDBPageUrl       @"PageUrl"
#define kDBFavoriteTime  @"FavTime"
#define kThumbnail       @"Thumbnail"
#define kDBLowercaseThumbnail       @"thumbnail"

#define kIPhoneFontSize  20//pt
#define kIPadFontSizeEx  28//pt
#define kItemPerSection 2
//#define kHuakangFontName @"DFPShaoNvW5"

#define kAdd2Favorite @"kAdd2Favorite"
#define kEnterFavorite @"kEnterFavorite"
#define kFavoriteCount @"kFavoriteCount"
#define kRemoveFromFavorite @"kRemoveFromFavorite"

//icon for tabbar
#define kIconHistory @"ICN_history"
#define kIconHomePage @"ICN_homepage"
#define kIconFavorite @"ICN_badge-favorite"
#define kIconSetting @"ICN_setting"
#define kICN_recommend_tab @"ICN_recommend_tab"


#define kTitleFontSize 17.0f
#define kContentFontSize 16.0f
#define kUIFont4Content [UIFont fontWithName:@"Times New Roman" size:kContentFontSize]
#define kUIFont4Title [UIFont boldSystemFontOfSize:kTitleFontSize]

#define kTabHeight 44.0f
#define kTopTabHeight 44.0f//33.0f
#define kNavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define kTabbarHeight kTabHeight

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define fLocalStringNotFormat(key) NSLocalizedString(key, nil)


//gold macros
#define kDefaultGold 1//default gold
#define kGoldByClickingBanner 15
#define kGoldByClickingRecommendView 40
#define kEarnGoldTipBySNSShare 5


#define kArtistId 463201091// @"iDreems",
#define kItunesSearchTerm @"idreems.com"
#define kFavoriteDBChangedEvent @"kFavoriteDBChangedEvent"
#define kHideFavoriteFlag -1
#define kDaysOfYear 365


#define kMobisageRecommendTableViewCount 14
#define kDefaultYoumiAppId @"6b875a1db75ff9e5"
#define kDefaultYouSecret @"e6983e250159ac64"

#define kAdsDelay 2
#define kAdDisplayCount 10

//in-app purchase
#ifndef kInAppPurchaseProductName
#define kInAppPurchaseProductName @"com.idreems.maketoast.inapp"
#endif

#define kAdsConfigUpdated @"kAdsConfigUpdated"

#define kNewContentScale 5
#define kMinNewContentCount 3

#define kWeiboMaxLength 140
#define kAdsSwitch @"AdsSwitch"
#define kPermanent @"Permanent"
#define kDateFormatter @"yyyy-MM-dd"

//for notification
#define kAdsUpdateDidFinishLoading @"AdsUpdateDidFinishLoading"
#define  kUpdateTableView @"UpdateTableView"

#define kOneDay (24*60*60)
#define kTrialDays  1

//flurry event
#define kFlurryRemoveTempConfirm @"kRemoveTempConfirm"
#define kFlurryRemoveTempCancel  @"kRemoveTempCancel"
#define kEnterMainViewList       @"kEnterMainViewList"
#define kFlurryOpenRemoveAdsList @"kOpenRemoveAdsList"

#define kFlurryDidSelectApp2RemoveAds @"kDidSelectApp2RemoveAds"
#define kFlurryRemoveAdsSuccessfully  @"kRemoveAdsSuccessfully"
#define kDidShowFeaturedAppNoCredit   @"kDidShowFeaturedAppNoCredit"
#define kFlurryNewChannel @"kNewChannel"

#define kShareByWeibo @"kShareByWeibo"
#define kShareByEmail @"kShareByEmail"

#define kEnterBylocalNotification @"kEnterBylocalNotification"
#define kDidShowFeaturedAppCredit @"kDidShowFeaturedAppCredit"

#define kClickOwnRecommendApp @"kClickOwnRecommendApp" 
#define kFlurrySharedChannel @"kFlurrySharedChannel"
#define kFlurryDidSelectAppFromRecommend @"kFlurryDidSelectAppFromRecommend"
#define kFlurryDidSelectAppFromMainList  @"kFlurryDidSelectAppFromMainList"
#define kFlurryDidReviewContentFromMainList  @"kFlurryDidReviewContentFromMainList"
#define kLoadRecommendAdsWall @"kLoadRecommendAdsWall"
//favorite
#define kEnterNewFavorite @"kEnterNewFavorite"
#define kOpenExistFavorite @"kOpenExistFavorite"
#define kQiushiReviewed @"kQiushiReviewed"
#define kQiushiRefreshed @"kQiushiRefreshed"
#define kReviewCloseAdPlan @"kReviewCloseAdPlan"
#define kOpenYoumiWall @"openYoumiWall"
#define TrialPoints @"TrialPoints"
#define GetCoins @"GetCoins"

#define kGoldEvent @"kGoldEvent"
#define kDecrementGoldEvent @"kDecrementGoldEvent"
#define kClickRecommendViewEvent @"kClickingRecommendViewEvent"
#define kClickYoumiWallEvent @"kClickYoumiWallEvent"
#define kClickBannerEvent @"kClickingBannerEvent"
#define kClickArticle @"kClickArticle"
#define kPopGoldEarningUI @"kPopGoldEarningUI"
#define kGoldAmount @"kGoldAmount"
#define kEarnGoldAmount @"kEarnGoldAmount"

//iap
#define kInAppPurchaseEvent @"InAppPurchaseEvent"
#define kRequestIAPProductData @"RequestIAPProductData"
#define kCompleteIAPTransaction @"CompleteIAPTransaction"
#define kFailedIAPTransaction @"FailedIAPTransaction"
#define kRestoreIAPTransaction @"RestoreIAPTransaction"
#define kReceiveIAPProducts @"ReceiveIAPProducts"
#define kFailtoReceiveIAPProducts @"FailtoReceiveIAPProducts"


#define kSocialEvent @"kSocialEvent"
#define kOpenCommentEvent @"kOpenCommentEvent"
#define kOpenLikeEvent @"kOpenLikeEvent"
#define kOpenFavoriteEvent @"kOpenFavoriteEvent"

#define kOpenFeedbackEvent @"kOpenFeedbackEvent"
#define kSetQuitNotificationEvent @"kSetQuitNotificationEvent"
#define kOpenRecommendAppListEvent @"kOpenRecommendAppListEvent"
#define kOpenEarnGoldListInSettingEvent @"kOpenEarnGoldListInSettingEvent"
#define kOpenIAPListInSettingEvent @"kOpenIAPListInSettingEvent"
#define kOpenIAPListInDetailViewEvent @"kOpenIAPListInDetailViewEvent"
#define kOpenRateInSettingEvent @"kOpenRateInSettingEvent"
#define kOpenRecommendAdInDetailViewEvent @"kOpenRecommendAdInDetailViewEvent"

#define kDeviceTokenForStat @"token"
#define kDeviceToken @"kDeviceToken"
#define kDidReceiveRemoteNotification @"kDidReceiveRemoteNotification"


//weixin
#define kFlurryConfirmOpenWeixinInAppstore @"kConfirmOpenWeixinInAppstore"
#define kFlurryCancelOpenWeixinInAppstore @"kCancelOpenWeixinInAppstore"
#define kShareByWeixin @"kShareByWeixin"
#define kShareByShareKit @"kShareByShareKit"
#define kSharePlatform @"kSharePlatform"

#define kCountPerSection 3
#ifndef kMobiSageIDOther_iPhone
#define kMobiSageIDOther_iPhone kMobiSageID_iPhone
#endif

#define kCoinsEffectDelay 11.0//6s

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kHistoryTipKey @"kHistoryTipKey"

#define kOneMillionBytes 1024*1024
#define  kMaxMemoryCapacity 4*kOneMillionBytes
#define  kMaxDiskCapacity 32*kMaxMemoryCapacity

//hosted on developer@baidu
#define kStatUrl @"http://1.checknewversion.duapp.com/stat.php"
#define kAdsJsonUrl @"http://1.checknewversion.duapp.com/getadsconfig.php"//@"http://www.idreems.com/adsconfig/getadsconfig.php"
#define kAppListXMLUrl @"http://1.checknewversion.duapp.com/getapplist.php"
#define kImageUrlFormater @"http://1.checknewversion.duapp.com/images/%@"

#define kCellHeight 157//recommendview cell height
//#define kSideBarMargin  300

#ifndef MobiSageAdView_Click_AD
#define MobiSageAdView_Click_AD @"MobiSageAdView_Click_AD"
#endif

#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IOS6_7_DELTA(V,X,Y,W,H) if (IOS_7) {CGRect f = V.frame;f.origin.x += X;f.origin.y += Y;f.size.width += W;f.size.height += H;V.frame=f;}
#define IOS6_7_DELTA_RECT(rc,X,Y,W,H) if (IOS_7) {rc.origin.x += X;rc.origin.y += Y;rc.size.width += W;rc.size.height += H;}
#endif

