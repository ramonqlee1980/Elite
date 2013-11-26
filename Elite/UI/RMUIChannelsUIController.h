//  频道管理类:用于切换频道,目前通过appdelegate进行数据的交换
//  RMRightViewController.h
//  Elite
//
//  Created by Ramonqlee on 11/2/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMChannels;

@interface RMUIChannelsUIController : UIViewController

@property(nonatomic,retain)RMChannels* channelsArray;//所有频道数据，需要持久化支持
@property(nonatomic,copy)NSString* currentChannel;//当前所在频道，需要持久化支持
@end
