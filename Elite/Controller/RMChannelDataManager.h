//  负责频道数据的管理
//  包括和服务器的数据同步，对外数据的提供等
//  RMChannelManager.h
//  Elite
//
//  Created by Ramonqlee on 11/4/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHelper.h"

@class RMChannels;


typedef void(^UPDATE)(void);

#define kChannelUrl @"http://idreems.duapp.com/beautie.php"

@interface RMChannelDataManager : NSObject

//对外数据接口
@property(nonatomic,readonly)RMChannels* channelsObj;//所有频道数据，需要持久化支持
@property(nonatomic,copy)NSString* currentChannel;//当前所在频道，需要持久化支持

Decl_Singleton(RMChannelDataManager)

//数据变更回调接口
-(void)setDataObserver:(UPDATE)callback;

//和服务器器的数据交互
-(void)startRequest:(NSString*)url;
-(void)stopRequest;
    
@end
