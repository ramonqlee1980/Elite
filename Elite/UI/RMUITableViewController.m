//
//  RMMainViewController.m
//  Elite
//
//  Created by Ramonqlee on 11/2/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMUITableViewController.h"
#import "IntroModel.h"
#import "IntroControll.h"
#import "HTTPHelper.h"
#import "RMArticle.h"
#import "RMWebViewController.h"
#import "UIImageView+WebCache.h"
#import "RMTableCellImageTwinTextType.h"
#import "Flurry.h"
#import "RMSyncAdData.h"


#define kEnableTestData NO//FIXME::测试数据
#define kCoverFlowHeight 145.0f

//分类过滤
#define kCoverPushFilter @"coverpush"
#define kNormalListFilter @"list"

@interface RMUITableViewController ()
@property (nonatomic) int count;
@property (nonatomic,retain) NSMutableArray *bodyItemsArr;//列表数据
@property (nonatomic,retain) NSMutableArray *coverPushItemsArr;//滚动推荐数据
//@property (nonatomic,retain) IntroControll* coverPush;
@end

@implementation RMUITableViewController
@synthesize url,bodyItemsArr,coverPushItemsArr;
- (id)initWithStyle:(UITableViewStyle)style withUrl:(NSString*)urlString
{
    self = [super initWithStyle:style];
    if (self) {
        self.url = urlString;
    }
    return self;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithStyle:style withUrl:nil];
}

-(void)dealloc
{
    self.bodyItemsArr = nil;
    self.coverPushItemsArr = nil;
    //    self.coverPush = nil;
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.count = 0;
    self.bodyItemsArr = [[[NSMutableArray alloc] initWithCapacity:16] autorelease];
    self.coverPushItemsArr = [[[NSMutableArray alloc] initWithCapacity:16] autorelease];
    
    [self test];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[[NSAttributedString alloc] initWithString:@"Pull to Refresh"] autorelease];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [refresh release];
    
    [self reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.bodyItemsArr.count==0) {
        [self beginRefreshingTableView];
    }
}
- (void)beginRefreshingTableView {
    
    [self.refreshControl beginRefreshing];
    
    if (self.tableView.contentOffset.y == 0) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            
            self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
            
        } completion:^(BOOL finished){
            [self getDataFromServer];
        }];
    }
}

-(void)reloadData
{
    [self reloadCoverPush];
    [self.tableView reloadData];
}

#pragma mark refresh data
-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing)
    {
        refresh.attributedTitle = [[[NSAttributedString alloc]initWithString:@"Refreshing data..."] autorelease];
        [self getDataFromServer];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bodyItemsArr.count;//+((self.coverPush!=nil)?1:0);
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
        cell = [RMTableCellImageTwinTextType loadCell];
    }
    
    RMArticle* article = [self.bodyItemsArr objectAtIndex:indexPath.row];
    
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
    if ([[RMSyncAdData sharedInstance]recommmendWallVisible]) {
        [CommonHelper showRecommendWall];
    }
    
    //check before going on
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (self.tableViewDelegate && [self.tableViewDelegate respondsToSelector:@selector(canSelectRowAtIndexPath:)])
    //    {
    //        if(![self.tableViewDelegate canSelectRowAtIndexPath:indexPath])
    //        {
    //            [Flurry logEvent:kPopGoldEarningUI];
    //            [self.tableViewDelegate popTipView];
    //            return;
    //        }
    //    }
    //    if (!self.delegate) {
    //        return;
    //    }
    RMArticle* article = [self.bodyItemsArr objectAtIndex:indexPath.row];
    //
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:article.title,kClickArticle,nil];
    [Flurry logEvent:kClickArticle withParameters:dict];
    
    UIViewController* presentController = nil;
    //    if ([article.content rangeOfString:@"<"].length==0) {
    //        RMTextViewController* innerController = [[[RMTextViewController alloc]init]autorelease];
    //        [innerController setText:article.content withTitle:article.title];
    //        innerController.Url = article.url;
    //        presentController = innerController;
    //    }
    //    else
    {
        RMWebViewController* innerController = [[[RMWebViewController alloc]init]autorelease];
        [innerController setText:article.content withTitle:article.title];
        innerController.Url = article.url;
        innerController.article = article;
        
        //        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        innerController.mTextString = article.content;
        
        presentController = innerController;
    }
    
    UINavigationController* controller = [[UINavigationController alloc]initWithRootViewController:presentController];
    controller.title = article.title;
    
    //    UIResponder *responder = self.delegate;
    //    while (responder && ![responder isKindOfClass:[MultiPageViewController class]]) {
    //        responder = [responder nextResponder];
    //    }
    
    UIViewController* rootController = [[[UIApplication sharedApplication]keyWindow]rootViewController];
    [rootController presentViewController:controller animated:YES completion:nil];
}

-(void)getDataFromServer
{
    //TODO::开始同步数据，完成后通知界面更新数据
    //从self.url开始请求数据
    //首先将尝试从本地缓存中加载本地数据，然后再去服务器同步
    NSDictionary* dict = [CommonHelper getAdPostReqParams];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResult:) name:self.url object:nil];
    [[HTTPHelper sharedInstance]beginPostRequest:self.url withDictionary: dict];
}

//TODO::根据从服务器获得的数据，更新本地数据
-(void)getResult:(NSNotification*)notification
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm:ss a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:lastUpdated] autorelease];
    
    NSData* data = nil;
    if (notification && notification.object && ![notification.object isKindOfClass:[NSError class]]) {
        if (!notification.userInfo || notification.userInfo.count==0) {
            return;
        }
        data = [notification.userInfo objectForKey:self.url];
    }
    
    [self.bodyItemsArr removeAllObjects];
    NSArray* array = [RMArticle initWithData:data withKey:kNormalListFilter];
    if (array && array.count) {
        [self.bodyItemsArr addObjectsFromArray:array];
    }
    
    array = [RMArticle initWithData:data withKey:kCoverPushFilter];
    if (array && array.count) {
        [self.coverPushItemsArr addObjectsFromArray:array];
    }
    
    //remove observer
    [[NSNotificationCenter defaultCenter]removeObserver:self name:self.url object:nil];
    [self.refreshControl endRefreshing];
    [self reloadData];
}

#pragma mark cover push
//make the first tableview item as the cover push
-(void)reloadCoverPush
{
    //TODO:根据coverpush 数据，更新界面
    if (self.coverPushItemsArr||self.coverPushItemsArr.count==0) {
        return;
    }
    
    IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"Example 1" description:@"Hi, my name is Dmitry" image:@"image1.jpg"];
    
    IntroModel *model2 = [[IntroModel alloc] initWithTitle:@"Example 2" description:@"Several sample texts in Old, Middle, Early Modern, and Modern English are provided here for practice, reference, and reading." image:@"image2.jpg"];
    
    IntroModel *model3 = [[IntroModel alloc] initWithTitle:@"Example 3" description:@"The Tempest is the first play in the First Folio edition (see the signature) even though it is a later play (namely 1610) than Hamlet (1600), for example. The first page is reproduced here" image:@"image3.jpg"];
    
    IntroControll* coverPush = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kCoverFlowHeight) pages:@[model1, model2, model3]];
    self.tableView.tableHeaderView = coverPush;
    [coverPush release];
}

#pragma mark test data
-(void)test
{
    if (!kEnableTestData) {
        return;
    }
    //init data
    for (NSInteger i = 0;i<16;++i) {
        RMArticle* v = [[[RMArticle alloc]init]autorelease];
        v.title = [NSString stringWithFormat:@"title for item %d",i];
        v.summary= [NSString stringWithFormat:@"summary for item %d",i];
        v.url = @"http://www.sohu.com";
        v.content = [NSString stringWithFormat:@"content for item %d",i];
        [self.bodyItemsArr addObject:v];
    }
}
@end
