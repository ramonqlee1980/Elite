//
//  RMFavoriteController.m
//  Elite
//
//  Created by Ramonqlee on 11/17/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMFavoriteController.h"
#import "RMTableCellImageTwinTextType.h"
#import "RMArticle.h"
#import "UIImageView+WebCache.h"
#import "RMWebViewController.h"
#import "UIBarButtonItem+Customed.h"
#import "RMAppData.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "Flurry.h"

#define kEnableTestData NO//FIXME::测试数据
#define kLoadMorePageCount 10//单页加载的item数目
#define kLoadUIDelay 0.5f

@interface RMFavoriteController ()
@property (nonatomic,retain) NSMutableArray *itemsArr;//列表数据
@end


@implementation RMFavoriteController
@synthesize itemsArr;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.itemsArr = [[[NSMutableArray alloc] initWithCapacity:16] autorelease];
    [self loadData:NSMakeRange(0,kLoadMorePageCount)];
    [self updateTableViewHandler];
    
    UIBarButtonItem *button =
    [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_navigation_back.png"]
                        selectedImage:[UIImage imageNamed:@"top_navigation_back.png"]
                               target:self
                               action:@selector(back)];
    self.navigationItem.leftBarButtonItem = button;
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.itemsArr.count],kFavoriteCount,nil];
    [Flurry logEvent:kEnterFavorite withParameters:dict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArr.count;//+((self.coverPush!=nil)?1:0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RMTableCellImageTwinTextType *cell = (RMTableCellImageTwinTextType*) [tableView dequeueReusableCellWithIdentifier:@"RMTableCellImageTwinTextType"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RMTableCellImageTwinTextType" owner:[RMTableCellImageTwinTextType class] options:nil];
        cell = (RMTableCellImageTwinTextType *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    RMArticle* article = [self.itemsArr objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = article.title;
    cell.subTitleLabel.text = article.summary;
    if(article.thumbnailUrl && article.thumbnailUrl != (id)[NSNull null])
    {
        cell.imageView.hidden = NO;
        [cell.imageview setImageWithURL:[NSURL URLWithString:article.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
    }
    else
    {
        //make imageview gone
        cell.imageView.hidden = YES;
        CGRect frame = cell.subTitleLabel.frame;
        frame.size.width += cell.subTitleLabel.frame.origin.x - cell.imageView.frame.origin.x;
        frame.origin.x = cell.titleLabel.frame.origin.x;
        
        cell.subTitleLabel.frame = frame;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //check before going on
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    RMArticle* article = [self.itemsArr objectAtIndex:indexPath.row];

    //flurry
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:article.title,kClickArticle,nil];
    [Flurry logEvent:kClickArticle withParameters:dict];
    
    UIViewController* presentController = nil;
    RMWebViewController* innerController = [[[RMWebViewController alloc]init]autorelease];
    [innerController setText:article.content withTitle:article.title];
    innerController.Url = article.url;
    
    innerController.mTextString = article.content;
    
    presentController = innerController;
    
    UINavigationController* controller = [[UINavigationController alloc]initWithRootViewController:presentController];
    controller.title = article.title;
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark tableview edit
// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RMArticle* article = [self.itemsArr objectAtIndex:indexPath.row];
    if (article) {
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:article.title,kRemoveFromFavorite,nil];
        [Flurry logEvent:kRemoveFromFavorite withParameters:dict];
        
        [RMAppData removeFromFavorite:article.url];
        
        [self.itemsArr removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark test data
-(void)loadData:(NSRange)r
{
    if (!kEnableTestData) {
        NSArray* items = [RMAppData getFavoriteValues:r];
        if (items && items.count) {
            [self.itemsArr removeAllObjects];
            [self.itemsArr addObjectsFromArray:items];
        }
        return;
    }
    //init data
    for (NSInteger i = 0;i<16;++i) {
        RMArticle* v = [[[RMArticle alloc]init]autorelease];
        v.title = [NSString stringWithFormat:@"title for item %d",i];
        v.summary= [NSString stringWithFormat:@"summary for item %d",i];
        v.url = @"http://www.sohu.com";
        v.content = [NSString stringWithFormat:@"content for item %d",i];
        [self.itemsArr addObject:v];
    }
}

#pragma mark back
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark util methods

//-(void)dataDidRefresh
//{
//    if(![self PullToRefreshHandler])
//    {
//        //        [self.tableView setPullToRefreshHandler:nil];
//    }
//    [self.tableView refreshFinished];
//}
-(void)dataDidLoadMore
{
    NSArray* r  = [RMAppData getFavoriteValues:NSMakeRange(self.itemsArr.count, self.itemsArr.count+kLoadMorePageCount)];
    if (r!=nil&&r.count>0) {
        [self.itemsArr addObjectsFromArray:r];
    }
    [self.tableView loadMoreFinished];
    [self.tableView reloadData];
}

-(void)updateTableViewHandler
{
    if (self.tableView) {
//        if ([self respondsToSelector:@selector(PullToRefreshHandler)])
//        {
//            [self.tableView setPullToRefreshHandler:^{
//                [self performSelector:@selector(dataDidRefresh) withObject:nil afterDelay:kLoadUIDelay];
//            }];
//        }
        
            [self.tableView setPullToLoadMoreHandler:^{
                [self performSelector:@selector(dataDidLoadMore) withObject:nil afterDelay:kLoadUIDelay];
            }];
    }
}


@end
