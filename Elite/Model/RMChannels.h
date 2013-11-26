//用于描述频道信息，比如一个应用内部可以包含多个频道，在此请求到频道信息后，可以进行数据的组织，完成频道的展示
//每个频道下面又可以有多个子频道，每个子频道用RMChannel进行描述
//  RMChannels.h
//  Elite
//
//  Created by Ramonqlee on 11/3/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMChannels : NSObject
@property(nonatomic,retain)NSMutableArray* titleArray;
@property(nonatomic,retain)NSMutableArray* iconArray;
@property(nonatomic,retain)NSMutableArray* subchannelArray;//每个元素存储一个当前title对应的channel数组

-(NSMutableArray*)channelForName:(NSString*)title;
+(id)initWithData:(NSData*)data;
@end
