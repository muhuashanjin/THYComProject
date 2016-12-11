//
//  DetailViewController.m
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"DetailVC";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(100,100, 100, 40)];
    [doneBtn setTitle:@"退出" forState:UIControlStateNormal];
    doneBtn.backgroundColor = [UIColor clearColor];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [doneBtn setBackgroundImage:[[UIImage imageNamed:@"bby_create_new_item_done_image"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    [MsgHandleCenter sendMessage:kTaskMsg_Main_TestToExtension withArg:kURL_Main_TestLogin];
    
    [MsgHandleCenter sendMessage:kTaskMsg_Main_TestToVC withArg:kURL_Main_TestLogin];

}

- (void)actionDone
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - messageHandle
- (BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg
{
    if (kTaskMsg_Main_TestToExtension == messageType)
    {
        
        NSLog(@"kTaskMsg_Main_TestToExtension:%@",arg);
    }
    
    if (kTaskMsg_Main_TestToVC == messageType)
    {
        
        NSLog(@"kTaskMsg_Main_TestToVC:%@",arg);
    }
    return NO;
}

#pragma mark - overwrite super method
- (UIBarButtonItem *)leftBarBtnItem{return nil;}

#pragma mark - getters and setter

@end

