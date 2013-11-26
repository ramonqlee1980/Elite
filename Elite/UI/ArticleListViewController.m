//
//  ArticleListViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/8/13.
//
//

#import "ArticleListViewController.h"
#import "RMArticlesView.h"
#import "CommonHelper.h"
//#import "EarnGoldMultiPageViewController.h"
#import "RMArticle.h"
#import "DAPagesContainer.h"
#import "MBProgressHUD.h"
#import "CPPropStoreViewController.h"
#import "AdsConfiguration.h"
#import "Flurry.h"
#import "UIBarButtonItem+Customed.h"

@interface ArticleListViewController ()<TableViewClickDelegate,MobiSageRecommendDelegate>
@property(nonatomic,retain)MobiSageRecommendView* mobiSageRecommendView;
@property(nonatomic,retain)RMArticlesView* articleController;
@property(nonatomic,retain)NSArray* dataList;
@property(nonatomic,assign)BOOL loadingData;
@property(nonatomic,assign)CGRect frame;
@property(nonatomic,retain)MBProgressHUD* HUD;
@end

@implementation ArticleListViewController
@synthesize title;
@synthesize dataList;
@synthesize dataDelegate;
@synthesize tableViewRefreshLoadMoreDelegate;
@synthesize tableViewClickDelegate;
@synthesize HUD;
@synthesize date;

-(void)dealloc
{
    self.mobiSageRecommendView = nil;
    self.articleController = nil;
    self.dataList = nil;
    self.HUD = nil;
    
    [super dealloc];
}
-(id)initWithRect:(CGRect)rc
{
    self = [super init];
    _frame = rc;
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *button =
    [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_navigation_back.png"]
                        selectedImage:[UIImage imageNamed:@"top_navigation_back.png"]
                               target:self
                               action:@selector(back)];
    self.navigationItem.leftBarButtonItem = button;

    
    self.view.frame = _frame;
	// Do any additional setup after loading the view.
    CGRect rc = _frame;
    if (self.parentViewController.tabBarController) {
        rc.size.height -= kTabbarHeight;
    }
    if(self.navigationController)
    {
        rc.size.height -= kNavigationBarHeight;
    }
    if ([self.parentViewController isKindOfClass:[DAPagesContainer class]]) {
        rc.size.height -= kTopTabHeight;
    }
    
    
    //    rc.size.height -= kTopTabHeight;
    
    rc.origin.y = 0;
    self.date = [NSDate date];
    
    BOOL existView = YES;
    if(!self.articleController)
    {
        existView = NO;
        self.articleController = [[RMArticlesView alloc]initWithFrame:rc];
    }
    
    self.articleController.delegate = self;
    self.articleController.tableViewDelegate = self;
    if (self.tableViewRefreshLoadMoreDelegate) {
        self.articleController.tableViewRefreshHanlder = self.tableViewRefreshLoadMoreDelegate;
    }
    
    if(!existView)
    {
        [self.view addSubview:self.articleController.view];
    }
    //add search bar
    
    if (!self.dataList && !self.loadingData) {
        //load data on background view
        [self performSelectorInBackground:@selector(updateData:) withObject:self.date];
        [self addActivityIndicatorView];
    }
    
    if (!self.mobiSageRecommendView) {
        self.mobiSageRecommendView = [[MobiSageRecommendView alloc]initWithDelegate:self];
        [self.mobiSageRecommendView release];
    }
    
    //IOS6_7_DELTA(self.view, 0, 20, 60, 0);
    
}
-(void)addActivityIndicatorView
{
#if 0
    UIActivityIndicatorView* view = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
    view.frame = self.view.frame;
    view.color = [UIColor orangeColor];
    view.hidesWhenStopped = YES;
    
    [self.view addSubview:view];
    [view startAnimating];
#else
    //初始化进度框，置于当前的View当中
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.HUD release];
    [self.view addSubview:self.HUD];
    
    //如果设置此属性则当前的view置于后台
    //    self.HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = NSLocalizedString(kLoadingDataTipMessage, "");
    
    //显示对话框
    [self.HUD show:YES];
#endif
}
-(void)stopActivityIndicatorView
{
#if 0
    for (UIView* view in [self.view subviews]) {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [((UIActivityIndicatorView*)view) stopAnimating];
        }
    }
#else
    [self.HUD hide:YES];
#endif
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#define kRecommendPopKey @"kRecommendPopKey"

#pragma  mark tableviewDelegate
- (BOOL)canSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMArticle* article = [self.dataList objectAtIndex:indexPath.row];
    if (kHideFavoriteFlag==article.favoriteNumber) {//favorite items
        return YES;
    }
    
    //FIXME::temp for test
    NSInteger gold = [CommonHelper gold];
    [CommonHelper setGold:--gold];
    NSLog(@"gold left:%d",gold);
    
    AdsConfiguration* config = [AdsConfiguration sharedInstance];
    //TODO::pop up recommend every 10 times
    //init or reset
    if ([config getCount]>0)//ad enabled
    {
        const NSInteger kRecommendPopTimes = [config RecommendAdPopTimes];
        NSInteger c = [CommonHelper defaultsForInt:kRecommendPopKey];
        [CommonHelper saveDefaultsForInt:kRecommendPopKey withValue:(c+1)];
        if (c>=kRecommendPopTimes) {
            //pop ad
            if (kRecommendPopTimes==c) {
                if ([config recommendViewInSettingEnabled] && self.mobiSageRecommendView) {
                    [self.mobiSageRecommendView OpenAdSageRecmdModalView];
                    [Flurry logEvent:kOpenRecommendAdInDetailViewEvent];
                    [CommonHelper saveDefaultsForInt:kRecommendPopKey withValue:0];
                }
            }
            else//close ad
            {
                //time'up to pop up ad
                //显示一个选项，其中包括
                //1.购买积分
                //2.做任务，赚积分
//                UIViewController *responder = [[[UIApplication sharedApplication]keyWindow]rootViewController];
//                
//                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//                [responder presentViewController:[storyBoard instantiateViewControllerWithIdentifier:@"CPPropStoreViewController"] animated:NO completion:nil];
//                [Flurry logEvent:kOpenIAPListInDetailViewEvent];
//                
//                //reset count for next loop
//                [CommonHelper saveDefaultsForInt:kRecommendPopKey withValue:0];
            }
        }
    }
    
    return YES;//gold>=0;
}

-(void)popTipView
{
    //pop up gold-earning view
//    UIResponder *responder = self;
//    while (responder && ![responder isKindOfClass:[MultiPageViewController class]]) {
//        responder = [responder nextResponder];
//    }
//    if (![[AdsConfiguration sharedInstance] IAPEnabled]) {
//        CGRect rect = self.view.frame;
//        EarnGoldMultiPageViewController* controller = [[[EarnGoldMultiPageViewController alloc]initWithFrame:rect]autorelease];
//        UINavigationController* navi = [[[UINavigationController alloc]initWithRootViewController:controller]autorelease];
//        [(UIViewController*)responder presentViewController:navi animated:YES completion:nil];
//    }
//    
//    else
    {
        //TODO::显示一个选项，其中包括
        //1.购买积分
        //2.做任务，赚积分
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//        [(UIViewController*)responder presentViewController:[storyBoard instantiateViewControllerWithIdentifier:@"CPPropStoreViewController"] animated:NO completion:nil];
    }
}
-(BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
#pragma mark update data methods
-(void)refreshData:(NSDate*)time
{
    if (!self.loadingData) {
        self.date = time;
        //load data on background view
        [self performSelectorInBackground:@selector(updateData:) withObject:time];
        [self addActivityIndicatorView];
    }
}
-(void)updateData:(NSDate*)objTime
{
    if(self.loadingData)
    {
        return;
    }
    self.loadingData = YES;
    NSDate* time = objTime?objTime:[NSDate date];
    
    self.dataList = [dataDelegate loadData:self.title withKeyWord:self.title withDate:time];
    self.loadingData = NO;
    [self performSelectorOnMainThread:@selector(loadDataOnMainThread) withObject:nil waitUntilDone:YES];
}
-(void)loadDataOnMainThread
{
    [self stopActivityIndicatorView];
    [self.articleController setItemArray:dataList];
}
-(void)setTableViewRefreshLoadMoreDelegate:(id<TableViewRefreshLoadMoreDelegate>)delegate
{
    tableViewRefreshLoadMoreDelegate = delegate;
    if(tableViewRefreshLoadMoreDelegate)
    {
        [tableViewRefreshLoadMoreDelegate retain];
    }
    if(self.articleController)
    {
        self.articleController.tableViewRefreshHanlder = delegate;
    }
}
-(void)setTableViewClickDelegate:(id<TableViewClickDelegate>)delegate
{
    tableViewClickDelegate = delegate;
    if(tableViewClickDelegate)
    {
        [tableViewClickDelegate retain];
    }
    if (self.articleController) {
        self.articleController.tableViewDelegate = self.tableViewClickDelegate;
    }
}
-(void)setData:(NSArray*)data
{
    [self.articleController setItemArray:data];
}
-(NSArray*)getData
{
    return self.articleController.itemArray;
}

#pragma mobisage recommendview delegate
/**
 *  嵌入应用推荐界面对象中实现Delegate
 */
- (UIViewController *)viewControllerForPresentingModalView
{
    return [[[UIApplication sharedApplication]keyWindow]rootViewController];
}

#pragma mark back
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
