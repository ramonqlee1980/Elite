//  展示界面：顶部为封推大图(可选)，下面为一个列表的形式
//  RMMainViewController.h
//  Elite
//
//  Created by Ramonqlee on 11/2/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMUITableViewController : UITableViewController

@property(nonatomic,copy)NSString* url;//请求内容的url,必须在初始化的时候进行设置

- (id)initWithStyle:(UITableViewStyle)style withUrl:(NSString*)url;

@end
