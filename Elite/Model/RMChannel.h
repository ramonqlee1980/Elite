//描述具体的频道，具体数据的请求，需要通过url再请求一次，通过RMArticle进行描述
//  RMChannel.h
//  Elite
//
//  Created by Ramonqlee on 11/3/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMChannel : NSObject
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* url;

+(id)initWithData:(NSData*)data;
@end
