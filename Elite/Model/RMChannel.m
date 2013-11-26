//
//  RMChannel.m
//  Elite
//
//  Created by Ramonqlee on 11/3/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMChannel.h"

@implementation RMChannel
@synthesize title,url;
+(id)initWithData:(NSData*)data
{
//    if (data) {
//        NSError* error;
//        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//        if (res && [res isKindOfClass:[NSDictionary class]]) {
//            NSObject* items = [res objectForKey:use];
//            if (items && [items isKindOfClass:[NSArray class]]) {
//                NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:((NSArray*)items).count];
//                for (NSDictionary* item in (NSArray*)items) {
//                    RMArticle* article = [[[RMArticle alloc]init]autorelease];
//                    article.title = [item valueForKey:kDBTitle];
//                    article.summary = [item valueForKey:kDBSummary];
//                    article.thumbnailUrl = [item valueForKey:kThumbnail];
//                    article.content = [item valueForKey:kDBContent];
//                    
//                    [array addObject:article];
//                }
//                
//                //TODO::other field reserved for future use
//                return array;
//            }
//        } else {
//            //NSLog(@"arr dataSourceDidError == %@",arrayData);
//        }
//    }
    
    return nil;
}
@end
