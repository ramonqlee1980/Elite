//  顶部包含tab的页面管理
//  HostViewController.h
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ViewPagerController.h"

@interface RMUIMainController : ViewPagerController

@property(nonatomic,copy)NSString* channelName;//当前频道显示用的名字
@property(nonatomic,retain)NSMutableArray* channelItemArray;//当前频道的子频道数组,其中数据项为RMChannel

@end
