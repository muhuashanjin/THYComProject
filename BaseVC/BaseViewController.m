//
//  BaseViewController.m
//  THYComProject
//
//  Created by thy on 16/12/5.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [MsgHandleCenter addController:self];
    }
    return self;
}

- (void)dealloc
{
    [MsgHandleCenter removeController:self];
}

-(BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg{return NO;}
-(void)PreProcessMessage:(int)messageType withResult:(int)result withArg:(id)arg{}
-(void)PostProcessMessage:(int)messageType withResult:(int)result withArg:(id)arg{}

@end
