//
//  CenterViewController.m
//  THYComProject
//
//  Created by thy on 16/12/5.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "CenterViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "Employee.h"
#import "Department.h"

@interface CenterViewController ()<UITabBarDelegate>

@end

@implementation CenterViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"CenterVC";
    
    [self setUpTabBarVC];
    
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(100,100, 100, 40)];
    [doneBtn setTitle:@"点击" forState:UIControlStateNormal];
    doneBtn.backgroundColor = [UIColor clearColor];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [doneBtn setBackgroundImage:[[UIImage imageNamed:@"bby_create_new_item_done_image"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    NSLog(@"%@",NSDocumentsPath());
}


- (void)actionDone
{
    [self.navigationController pushViewController:[NSClassFromString(@"LeftViewController") new] animated:YES];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}

#pragma mark - event response
- (void)leftDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)rightDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

#pragma mark - messageHandle
- (BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg
{
    if (kTaskMsg_Main_TestToNetWork == messageType)
    {
        NSLog(@"kTaskMsg_Main_TestToNetWork:%@",arg);
    }
    return NO;
}

#pragma mark - overwrite super method
- (UIBarButtonItem *)leftBarBtnItem
{
    MMDrawerBarButtonItem * leftBarButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton animated:YES];

    return leftBarButton;
    
}

- (UIBarButtonItem *)rightBarBtnItem
{
    MMDrawerBarButtonItem * rightBarButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress)];
    
    return rightBarButton;
    
}

#pragma mark - private method
- (void)setUpTabBarVC
{
    UITabBar* tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0,kScreenHeight-49,kScreenWidth,49)];
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"qiakr1" image:[UIImage imageNamed:@"tabbarItem@2x.png"] tag:0];
    tabBarItem1.badgeValue = [NSString stringWithFormat:@"%d", 3];
    UITabBarItem * tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"qiakr2" image:[UIImage imageNamed:@"tabbarItem@2x.png"] tag:1];
    UITabBarItem * tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"qiakr3" image:[UIImage imageNamed:@"tabbarItem@2x.png"] tag:2];
    UITabBarItem * tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"qiakr4" image:[UIImage imageNamed:@"tabbarItem@2x.png"] tag:3];
    NSArray *tabBarItemArray = [[NSArray alloc] initWithObjects: tabBarItem1, tabBarItem2, tabBarItem3, tabBarItem4,nil];
    [tabBar setItems: tabBarItemArray];
}

@end
