//
//  HostViewController.m
//  ICViewPager
//

#import "RMUIMainController.h"
#import "RMUITableViewController.h"
#import "RMAppDelegate.h"
#import "DraggableController.h"
#import "RMChannel.h"
#import "UIBarButtonItem+Customed.h"
#import "UIColor+DigitalColorMeter.h"
#import "REMenu.h"
#import "RMUISettingMenu.h"
#import "MBProgressHUD.h"

#define kEnableTestData NO//FIXME::测试数据
#define kTopTextFontSize 15.0f


@interface RMUIMainController () <ViewPagerDataSource, ViewPagerDelegate>
{
    SideBarShowDirection sidebarDirecton;
}
@property(nonatomic,retain)RMUISettingMenu* settingMenuController;
@end

@implementation RMUIMainController
@synthesize channelName=_channelName,channelItemArray=_channelItemArray,settingMenuController=_settingMenuController;

-(void)showLeft:(id)sender
{
    [(RMAppDelegate*)ShareAppDelegate showSideBarControllerWithDirection:SideBarShowDirectionLeft];
}


-(void)dealloc
{
    self.channelName = nil;
    self.channelItemArray = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    sidebarDirecton = SideBarShowDirectionNone;
    
    [self test];
    self.dataSource = self;
    self.delegate = self;
    
    self.title = self.channelName;

    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
#if 0//暂时关闭左边栏
    UIBarButtonItem *button =
    [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_navigation_menuicon.png"]
                        selectedImage:[UIImage imageNamed:@"top_navigation_menuicon.png"]
                               target:self
                               action:@selector(showLeft:)];
    self.navigationItem.leftBarButtonItem = button;
#endif
    
   UIBarButtonItem *button =
    [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"setting_icon.png"]
                        selectedImage:[UIImage imageNamed:@"setting_icon.png"]
                               target:self
                               action:@selector(showMenu:)];
    self.navigationItem.rightBarButtonItem = button;

    [super viewDidLoad];
    
//    remove temp
//    CGRect rc = CGRectMake(self.view.frame.size.width-kDefaultTabWidth, 0, kDefaultTabWidth, kDefaultTabHeight);
//    UIButton* addButton = [self createAddButton:rc];
//    [self.view addSubview:addButton];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.channelItemArray?self.channelItemArray.count:0;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    if (!self.channelItemArray || self.channelItemArray.count==0) {
        return nil;
    }
    RMChannel* item = [self.channelItemArray objectAtIndex:index];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:kTopTextFontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];

    
    label.text = item.title;
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (!self.channelItemArray || self.channelItemArray.count==0) {
        return nil;
    }
    RMChannel* item = [self.channelItemArray objectAtIndex:index];
    if (!item) {
        return nil;
    }
    
    return [[[RMUITableViewController alloc]initWithStyle:UITableViewStylePlain withUrl:item.url]autorelease];
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    
    return color;
}

#pragma mark add plus button

- (UIButton*)createAddButton:(CGRect)rc
{
    
    UIButton *addButton = [[[UIButton alloc] initWithFrame:rc]autorelease];
    [addButton setBackgroundImage:[self createRoundPlusImageWithSize:rc.size] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addViewButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    return addButton;
}

- (UIImage *)createRoundPlusImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat minSize = (size.width>size.height)?size.height:size.width;
    const CGFloat height = minSize*3.0/5;
    
    const CGFloat offsetY = (size.height - height)/2;
    const CGFloat offsetX = (size.width - height)/2;
    // 填充外框
    UIColor* backgroundColor = [UIColor colorWithDigitalColorMeterString:@"87.0	87.0	87.0	" alpha:0.5];
    [backgroundColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // 画加号
    CGContextSetLineWidth(context, 2.f);
    backgroundColor = [UIColor colorWithDigitalColorMeterString:@"78.0	78.0	78.0	" alpha:1.0];
    [backgroundColor set];
    
    CGContextMoveToPoint(context, offsetX, size.height/2);
    CGContextAddLineToPoint(context, offsetX + height, size.height / 2);
    CGContextMoveToPoint(context, size.width / 2, offsetY);
    CGContextAddLineToPoint(context, size.width / 2, offsetY+height);
    
    //竖直分割线
    CGContextMoveToPoint(context,0, 0);
    CGContextAddLineToPoint(context, 0, size.height);
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)addViewButtonTouch
{
    DraggableController* vc = [[DraggableController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}
#pragma mark setter
-(void)setChannelName:(NSString *)name
{
    if (!name || name.length ==0) {
        return;
    }
    
    _channelName = name;
    self.title = name;
}
-(void)setChannelItemArray:(NSArray *)data
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //invalid array
    if(!data || data.count==0)
    {
        return;
    }
    
    if (!self.channelItemArray) {
        _channelItemArray = [[NSMutableArray alloc]initWithCapacity:data.count];
    }
    [_channelItemArray removeAllObjects];
    
    [self.channelItemArray addObjectsFromArray:data];
    
    [self reloadData];
}
#pragma mark back item
-(void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark test data
-(void)test
{
    if(!kEnableTestData)
    {
        return;
    }
    self.channelName = @"美容秘笈";
   
    for (int i=0; i<15; ++i) {
        RMChannel* item = [[RMChannel alloc]init];
        
        item.title = [NSString stringWithFormat:@"itemA %d",i];
        item.url = @"http://www.sohu.com";
        
        [self.channelItemArray addObject:item];
        [item release];
    }
}

#pragma mark show menu
- (void)showMenu:(id)sender
{
    if(!self.settingMenuController)
    {
        _settingMenuController = [[[RMUISettingMenu alloc]init]autorelease];
    }
    [self.settingMenuController showFromController:self];
    
}

@end
