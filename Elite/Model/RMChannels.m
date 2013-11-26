//
//  RMChannels.m
//  Elite
//
//  Created by Ramonqlee on 11/3/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMChannels.h"
#import "RMChannel.h"

#define kEnableTestData NO//启动测试数据

@implementation RMChannels
@synthesize subchannelArray=_subchannelArray,titleArray=_titleArray,iconArray=_iconArray;

-(id)init
{
    self = [super init];
    if (self) {
        _subchannelArray = [[NSMutableArray alloc]init];
        _titleArray = [[NSMutableArray alloc]init];
        _iconArray = [[NSMutableArray alloc]init];
    }
    
    return self;
}
-(void)dealloc
{
    //release item one by one
    for (NSObject* item in self.subchannelArray) {
        [item release];
    }
    self.subchannelArray = nil;
    self.iconArray = nil;
    
    self.titleArray = nil;
    [super dealloc];
}
-(NSMutableArray*)channelForName:(NSString*)title
{
    if (!title || title.length==0) {
        return nil;
    }
    
    for (NSInteger i = 0; i < self.titleArray.count;++i) {
        NSString* name = [self.titleArray objectAtIndex:i];
        if ([title isEqual:name]) {
            return [self.subchannelArray objectAtIndex:i];
        }
    }
    return nil;
}
+(id)initWithData:(NSData*)data
{
    //根据服务器端返回数据，解析body，header所需数据
    if (kEnableTestData) {
        return [RMChannels test];
    }
    
    if (data) {
        NSError* error;
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (res && [res isKindOfClass:[NSArray class]]) {
            RMChannels* channelsObj = [[[RMChannels alloc]init]autorelease];
            
            NSArray* channlelArray = (NSArray*)res;
            for (NSDictionary* item in channlelArray) {
                //title
                NSString* name = [item objectForKey:@"title"];
                //icon
                NSString* icon = [item objectForKey:@"icon"];
                //channel
                NSArray* data = (NSArray*)[item objectForKey:@"data"];
                
                //channel name
                NSMutableArray* channel = [[[NSMutableArray alloc]init]autorelease];
                for (NSDictionary* item in data) {
                    RMChannel *c = [[[RMChannel alloc]init]autorelease];
                    c.title = [item valueForKey:@"title"];
                    c.url = [item valueForKey:@"url"];
                    [channel addObject:c];
                }
                
                [channelsObj.titleArray addObject:name];
                [channelsObj.iconArray addObject:icon];
                [channelsObj.subchannelArray addObject:channel];
            }
            return channelsObj;
        } else {
            //NSLog(@"arr dataSourceDidError == %@",arrayData);
        }
    }

    return nil;
}
+(id)test
{
    if (!kEnableTestData) {
        return nil;
    }
    
    //1.提供频道测试数据
    //2.当前频道，缺省定位到第一个；对于已经修改过的，则定位到上次修改的频道
    //3.更新频道数据
    
    RMChannels* channelsObj = [[[RMChannels alloc]init]autorelease];
    //add channel
    for (int i = 0; i<10; i++) {
        NSMutableArray* channel = [[[NSMutableArray alloc]init]autorelease];
        for (int j = 0; j<10; j++) {
            RMChannel *item = [[RMChannel alloc]init];
            item.title = [NSString stringWithFormat:@"subchannel %d",j];
            item.url = @"http://www.sohu.com";
            [channel addObject:item];
            
        }
        
        //channle item
        [channelsObj.titleArray addObject:[NSString stringWithFormat:@"channel %d",i]];
        [channelsObj.subchannelArray addObject:channel];
    }
    
    return channelsObj;
}
@end
