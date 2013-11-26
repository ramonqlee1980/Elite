//  负责app运行时全局数据的管理
//  RMAppData.h
//  Elite
//
//  Created by Ramonqlee on 11/4/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHelper.h"

@class RMUIMainController;
@class RMChannelDataManager;
@class RMUISettingMenu;
@class RMUIChannelsUIController;
@class RMArticle;

@interface RMAppData : NSObject

@property(retain,nonatomic)RMUIMainController* scrollBarController;//当前频道的ui管理类
@property(retain,nonatomic)RMUISettingMenu* settinController;//当前设置
@property(retain,nonatomic)RMUIChannelsUIController* channelsUIController;//频道管理

@property(readonly,getter = getChannelDataManager)RMChannelDataManager* channelDataManager;

Decl_Singleton(RMAppData)

//收藏库的操作
+(void)addToFavorite:(RMArticle*)article;//添加到收藏库中
+(void)removeFromFavorite:(NSString*)url;
+(NSArray*)getFavoriteValues:(NSRange)range;
@end
