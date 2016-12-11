//
//  RootViewController.m
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "RootViewController.h"
#import "CenterViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "BaseNavViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self setUpShowVC];
}

- (void)setUpShowVC
{
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    BaseNavViewController *leftNav = [[BaseNavViewController alloc] initWithRootViewController:leftVC];
    
    RightViewController *rightVC = [[RightViewController alloc] init];
    BaseNavViewController *rightNav = [[BaseNavViewController alloc] initWithRootViewController:rightVC];
    
    CenterViewController *centerVC = [[CenterViewController alloc] init];
    BaseNavViewController *centerNav = [[BaseNavViewController alloc] initWithRootViewController:centerVC];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:centerNav
                                            leftDrawerViewController:leftNav
                                            rightDrawerViewController:rightNav];
    
    [drawerController setShowsShadow:YES];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setMaximumLeftDrawerWidth:200.0];
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    [self addChildVC:drawerController];
}

- (void)addChildVC:(UIViewController *)currentViewController
{
    [self addChildViewController:currentViewController];
    [self.view  addSubview:currentViewController.view];
    [currentViewController didMoveToParentViewController:self];
}

- (void)removeChildVC:(UIViewController *)currentViewController
{
    [currentViewController removeFromParentViewController];
    [currentViewController willMoveToParentViewController:nil];
    [currentViewController.view removeFromSuperview];
}

-(BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg
{
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    for (Class clazz in app.extensionArray) {
        if ([clazz respondsToSelector:@selector(handleOnRootController:message:withResult:withArg:)]
            && [clazz handleOnRootController:self message:messageType withResult:result withArg:arg]) {
            return YES;
        }
    }
    return NO;
}

@end
