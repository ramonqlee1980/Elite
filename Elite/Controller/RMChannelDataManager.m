//
//  RMChannelManager.m
//  Elite
//
//  Created by Ramonqlee on 11/4/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMChannelDataManager.h"
#import "RMChannels.h"
#import "RMChannel.h"
#import "RMAppData.h"
#import "HTTPHelper.h"

@interface RMChannelDataManager()
{
    NSString* channelUrl;
}
@property(copy)UPDATE dataCallback;
@end

@implementation RMChannelDataManager
@synthesize channelsObj,currentChannel;

Impl_Singleton(RMChannelDataManager)

-(void)startRequest:(NSString*)url
{
    //请求频道数据
    NSDictionary* dict = [CommonHelper getAdPostReqParams];
    channelUrl = url;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResult:) name:url object:nil];
    [[HTTPHelper sharedInstance]beginPostRequest:url withDictionary: dict];
}

//TODO::根据从服务器获得的数据，更新本地数据
-(void)getResult:(NSNotification*)notification
{
    if (notification && notification.object && ![notification.object isKindOfClass:[NSError class]]) {
        if (!notification.userInfo || notification.userInfo.count==0) {
            return;
        }
        NSData* data = [notification.userInfo objectForKey:channelUrl];
//        NSLog(@"%@",data);
        
        channelsObj = [RMChannels initWithData:data];
        [channelsObj retain];
        if (channelsObj) {
            self.currentChannel = (channelsObj.titleArray&&channelsObj.titleArray.count)?[channelsObj.titleArray objectAtIndex:0]:@"";
        }
        //remove observer
        [[NSNotificationCenter defaultCenter]removeObserver:self name:channelUrl object:nil];
    }
    
    if (self.dataCallback) {
        self.dataCallback();
    }
}

-(void)stopRequest
{
    
}

-(void)setDataObserver:(UPDATE)callback
{
    self.dataCallback = callback;
}


@end
