//
//  ViewController.m
//  DMAPClient
//
//  Created by besterChen on 13-5-18.
//  Copyright (c) 2013年 besterChen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString *tokenInfo;
}


@end

@implementation ViewController

-(void)dealloc
{
    [tokenInfo release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    tokenInfo = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDeviceToken:(NSData *)deviceToken_{
    NSString *token = [[deviceToken_ description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *strDeviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenInfo = [strDeviceToken retain];
}

- (IBAction)buttonClickAction:(id)sender {
    NSString *alertString = nil;
    
    if (50 <= tokenInfo.length) {
        alertString = [NSString stringWithFormat:@"当前设备的token为:%@", tokenInfo];
    }else{
        alertString = @"没有获取到token信息";
    }
    
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:alertString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alert show];    
}

@end
