//
//  RightViewController.m
//  THYComProject
//
//  Created by thy on 16/12/5.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"RightVC";
    
    self.view.backgroundColor = [UIColor lightGrayColor];

}

#pragma mark - messageHandle
- (BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg
{
    return NO;
}

- (UIBarButtonItem *)leftBarBtnItem{return nil;}

@end

