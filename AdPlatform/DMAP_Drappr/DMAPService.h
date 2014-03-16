//
//  DMAPLib.h
//  DMAPLib
//
//  Created by besterChen on 13-1-6.
//  Copyright (c) 2013年 besterChen. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMAPService : NSObject

+ (DMAPService *)sharedInstance;

+ (void)registerDeviceToken:(NSData *)deviceToken;            // 向服务器上报Device Token
+ (void)setupWithOption:(NSDictionary *)launchingOption;      // 初始化
+ (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;        // 注册APNS类型
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;  // 处理收到的APNS消息，向服务器上报收到APNS消息

+ (NSString *)openUDID; // UDID

#pragma mark -- 可选接口
// 设置地理位置信息(最好设置在可重复调用的位置，比如:应用后台切到前台时调用)
+ (void)setLocation:(CLLocation *)location;
// 设置用户信息
+ (void)setUserInfo:(NSString*)name gender:(NSString*)gender birthday:(NSString*)birthday
           postCode:(NSString*)postCode telNumber:(NSString*)telNumber email:(NSString*)mailString;
@end


