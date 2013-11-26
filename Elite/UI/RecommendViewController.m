//
//  RecommendViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "RecommendViewController.h"
#import "CommonHelper.h"
#import "MobiSageSDK.h"
#import "MobiSageRecommendView+MobiSageRecommendViewEx.h"

#define kMobisageRecommendCount 2

@interface RecommendViewController ()<MobiSageRecommendDelegate>
@property (nonatomic, retain) MSRecommendContentView *recommendView;
@end

@implementation RecommendViewController
@synthesize recommendView;
@synthesize adCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        adCount = kMobisageRecommendCount;
        self.showTipView = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.recommendView = [[MSRecommendContentView alloc] initWithdelegate:self width:kDeviceWidth adCount:adCount];
    [self.recommendView release];
    [self.view addSubview:self.recommendView];
    
    //hook tableview in this view
    if ([self.recommendView respondsToSelector:@selector(hookTableView)]) {
        [self.recommendView performSelector:@selector(hookTableView)];
    }
    NSString* tipMessage = [NSString stringWithFormat:NSLocalizedString(kEarnGoldTipForRecommend, nil),kGoldByClickingRecommendView];
    
    if(self.showTipView)
    {
        [BaseViewController showPopTipView:self.recommendView inView:self.view withMessage:tipMessage];
    }
}
- (void)viewDidUnload {
    self.recommendView = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - MobiSageRecommendDelegate 委托函数
#pragma mark

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

@end
