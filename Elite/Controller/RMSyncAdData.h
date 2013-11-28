//
//  RMSyncAdData.h
//  同步广告数据下来，主要是广告是否开启，开启的话，一些广告平台的id等信息
//
//  Created by Ramonqlee on 11/29/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHelper.h"

typedef void(^UPDATE)(void);

@interface RMSyncAdData : NSObject

Decl_Singleton(RMSyncAdData)
    
    //数据变更回调接口
-(void)setDataObserver:(UPDATE)callback;
    
    //和服务器器的数据交互
-(void)startRequest;
-(void)stopRequest;
    
-(BOOL)recommmendWallVisible;//recommendwall广告是否可以显示
@end
