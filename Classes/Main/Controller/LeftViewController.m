//
//  LeftViewController.m
//  THYComProject
//
//  Created by thy on 16/12/5.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"LeftVC";

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self sendMessage:kTaskMsg_Main_TestToNetWork withArg:kURL_Main_TestToNetWork];
}

#pragma mark - messageHandle
- (BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg
{
    if (messageType == kTaskMsg_Main_TestToNetWork) {
        NSLog(@"arg:%@",arg);
    }
    
    return NO;
}

- (UIBarButtonItem *)leftBarBtnItem{return nil;}

@end
