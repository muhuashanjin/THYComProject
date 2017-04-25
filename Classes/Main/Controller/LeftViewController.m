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

- (UIBarButtonItem *)leftBarBtnItem{return nil;}

@end
