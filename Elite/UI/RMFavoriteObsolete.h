//
//  RMFirstViewController.h
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiPageViewController.h"

@class RMArticle;
@interface RMFavoriteObsolete : MultiPageViewController

+(void)addToFavorite:(RMArticle*)article;

@end
