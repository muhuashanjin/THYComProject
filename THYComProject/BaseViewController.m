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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //去掉navBar边线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
}

- (void)setUpNavBar
{
    //设置导航栏的背景颜色
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    //设置导航栏的题目
    self.navigationItem.title = @"UINavigationBar使用总结";
    
    //设置导航栏的背景图片(ps:背景为透明设置有效)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hm_zlbg@2x.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
//    //1. 设置导航栏的背景图片
//    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"hm_zlbg@2x.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"hm_zlbg@2x.png"]]];
//    bar.barStyle = UIStatusBarStyleDefault;
//    
//    //1.2 设置返回按钮的颜色  在plist中添加 View controller-based status bar appearance=NO切记。
//    [bar setTintColor:[UIColor yellowColor]];
//    
//    //	//设置返回按钮指示器图片
//    //	UIImage *backImage=[[UIImage imageNamed:@"navigationbar_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 5)];
//    //	[[UINavigationBar appearance] setBackIndicatorImage:backImage];
//    //	[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navigationbar_back_highlighted"]];
//    
//    //2. 设置导航栏文字的主题
//    [bar setTitleTextAttributes:@{
//                                  NSForegroundColorAttributeName:[UIColor blackColor],
//                                  }];
//    //3. 设置UIBarButtonItem的外观
//    UIBarButtonItem *barItem=[UIBarButtonItem appearance];
//    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//    
//    //4. 该item上边的文字样式
//    NSDictionary *fontDic=@{
//                            NSForegroundColorAttributeName:[UIColor blackColor],
//                            NSFontAttributeName:[UIFont systemFontOfSize:19.f],  //粗体
//                            };
//    [barItem setTitleTextAttributes:fontDic
//                           forState:UIControlStateNormal];
//    [barItem setTitleTextAttributes:fontDic
//                           forState:UIControlStateHighlighted];
//    
//    // 5.设置状态栏样式
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
