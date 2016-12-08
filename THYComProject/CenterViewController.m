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

@interface CenterViewController ()<UITabBarDelegate>

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"CenterVC";
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UITabBar* tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0,size.height-49,size.width,49)];
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"排队人数" image:[UIImage imageNamed:@"tabbarItem@2x.png"] tag:0];
    tabBarItem1.badgeValue = [NSString stringWithFormat:@"%d", 3];
    UITabBarItem * tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"人均" image:[UIImage imageNamed:@"tabbarItem@2x.png"] tag:1];
    UITabBarItem * tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"距离" image:[UIImage imageNamed:@"tabbarItem@2x.png"] tag:2];
    UITabBarItem * tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"好评" image:[UIImage imageNamed:@"tabbarItem@2x.png"] tag:3];
    NSArray *tabBarItemArray = [[NSArray alloc] initWithObjects: tabBarItem1, tabBarItem2, tabBarItem3, tabBarItem4,nil];
    [tabBar setItems: tabBarItemArray];
        
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}

- (UIBarButtonItem *)leftBarBtnItem
{
    MMDrawerBarButtonItem * leftBarButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress)];

    return leftBarButton;
    
}

- (UIBarButtonItem *)rightBarBtnItem
{
    MMDrawerBarButtonItem * rightBarButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress)];

    return rightBarButton;

}

- (void)leftDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)rightDrawerButtonPress
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


@end
