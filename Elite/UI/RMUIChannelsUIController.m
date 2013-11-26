//
//  RMRightViewController.m
//  Elite
//
//  Created by Ramonqlee on 11/2/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMUIChannelsUIController.h"
#import "RMAppDelegate.h"
#import "RMChannels.h"
#import "RMUIMainController.h"
#import "RMAppData.h"
#import "RMTableCellImageTextType.h"
#import "UIImageView+WebCache.h"
#import "SettingsViewController.h"

#define kSingleCellHeight 70.0f

@interface RMUIChannelsUIController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@end

@implementation RMUIChannelsUIController
@synthesize currentChannel,channelsArray=_channelsArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    self.tableView = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //reset view's frame
    CGRect rc = self.view.frame;
    CGFloat h = [[UIApplication sharedApplication] statusBarFrame].size.height;
    rc.origin.y = IOS7_OR_LATER?h:0;
    
    self.view.frame = rc;
    
    if (!self.tableView) {
        rc.origin.y = 0;
        self.tableView = [[UITableView alloc]initWithFrame:rc style:UITableViewStylePlain];
        [self.tableView release];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:rc]autorelease];
    imageView.image = [UIImage imageNamed:@"sidebar_bg.jpg"];
    self.tableView.backgroundView = imageView;
    
    //tableview's global setting
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark setter
-(void)setChannelsArray:(RMChannels *)data
{
    _channelsArray = data;
    
    //reload data
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.channelsArray&&self.channelsArray.titleArray)?self.channelsArray.titleArray.count:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSingleCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMTableCellImageTextType *cell = (RMTableCellImageTextType*) [tableView dequeueReusableCellWithIdentifier:@"RMTableCellImageTextType"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RMTableCellImageTextType" owner:[RMTableCellImageTextType class] options:nil];
        cell = (RMTableCellImageTextType *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.titleLabel.text = [self.channelsArray.titleArray objectAtIndex:indexPath.row];
    NSString* iconUrl = [self.channelsArray.iconArray objectAtIndex:indexPath.row];
    if(iconUrl && iconUrl != (id)[NSNull null])
    {
        [cell.imageview setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"sidebar_nav_default.png"]];
    }    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO::打开一个新的RMWebViewController查看内容
    
    RMAppDelegate* delegate = (RMAppDelegate*)ShareAppDelegate;
    if (delegate) {
        //update data
        NSString* channelName = [self.channelsArray.titleArray objectAtIndex:indexPath.row];
        
        RMAppData* appData = [RMAppData sharedInstance];
        
        appData.scrollBarController.channelName = channelName;
        
        appData.scrollBarController.channelName = channelName;
        appData.scrollBarController.channelItemArray = [self.channelsArray.subchannelArray objectAtIndex:indexPath.row];
        
        NSLog(@"switch to channel %@",channelName);
        
        [delegate showSideBarControllerWithDirection:SideBarShowDirectionNone];
    }
}

@end
