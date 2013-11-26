//
//  RMAppData.m
//  Elite
//
//  Created by Ramonqlee on 11/4/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMAppData.h"
#import "RMChannelDataManager.h"
#import "RMArticle.h"
#import "SQLiteManager.h"
#import "StringUtil.h"

@implementation RMAppData
@synthesize scrollBarController,settinController,channelsUIController;
@synthesize channelDataManager;

Impl_Singleton(RMAppData)

-(RMChannelDataManager*)getChannelDataManager
{
    return [RMChannelDataManager sharedInstance];
}


+(void)addToFavorite:(RMArticle*)article
{
    [RMAppData makeSureDBExist];
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%d', '%d', '%d')",
                     kDBTableName, kDBTitle, kDBSummary, kDBContent,kDBPageUrl,kCommentNumber,kFavoriteNumber,kLikeNumber,[article.title sqliteEscape],[article.summary sqliteEscape],[article.content sqliteEscape],article.url,article.commentNumber,article.favoriteNumber,article.likeNumber];
    [dbManager doQuery:sql];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kFavoriteDBChangedEvent object:nil];
}
+(void)makeSureDBExist
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc]initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    if (![dbManager openDatabase]) {
        //create table
        
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT PRIMARY KEY,%@ INTEGER,%@ INTEGER,%@ INTEGER )",kDBTableName,kDBTitle,kDBSummary,kDBContent,kDBPageUrl,kCommentNumber,kFavoriteNumber,kLikeNumber];
        [dbManager doQuery:sqlCreateTable];
        
        //update table for timestamp
        //        ALTER TABLE table_name
        //        ADD column_name datatype
        //NSString* sqlUpdateTableSql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ DOUBLE",kDBTableName,kDBFavoriteTime];
        //[dbManager doQuery:sqlUpdateTableSql];
        
        [dbManager closeDatabase];
    }
}
+(void)removeFromFavorite:(NSString*)url
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    NSString *sql = [NSString stringWithFormat:@"delete from Content where PageUrl = '%@'",url];
    [dbManager doQuery:sql];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kFavoriteDBChangedEvent object:nil];
}
+(NSArray*)getFavoriteValues:(NSRange)range
{
    return  [RMAppData getTableValue:FAVORITE_DB_NAME withTableName:kDBTableName withRange:range];
}
+(NSArray*)getTableValue:(NSString*)dbName withTableName:(NSString*)tableName withRange:(NSRange)range
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:dbName]autorelease];
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d OFFSET %d",tableName,range.length,range.location];
    
    NSLog(@"query:%@",query);
    
    NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    
    NSArray* items =  [dbManager getRowsForQuery:query];
    //    for (NSDictionary* item in items)
    for (NSInteger i = items.count-1; i>=0;i--)//descending order
    {
        NSDictionary* item = [items objectAtIndex:i];
        RMArticle* article = [[[RMArticle alloc]init]autorelease];
        article.title = [item objectForKey:kDBTitle];
        article.summary = [item objectForKey:kDBSummary];
        article.content = [item objectForKey:kDBContent];
        article.url = [item objectForKey:kDBPageUrl];
        
        article.title = [article.title sqliteUnescape];
        article.summary = [article.summary sqliteUnescape];
        article.content = [article.content sqliteUnescape];
        
        article.likeNumber = ((NSString*)[item objectForKey:kLikeNumber]).intValue;
        article.commentNumber = ((NSString*)[item objectForKey:kCommentNumber]).intValue;
        article.favoriteNumber = ((NSString*)[item objectForKey:kFavoriteNumber]).intValue;
        [data addObject:article];
    }
    return data;
}

@end
