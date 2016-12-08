//
//  BaseViewController.m
//  THYComProject
//
//  Created by thy on 16/12/5.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpNavBar];
}

- (void)setUpNavBar
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;

    //设置导航栏的背景颜色
    navigationBar.barTintColor = [UIColor whiteColor];
    
    //设置导航栏的题目
//    self.navigationItem.title = @"title";
    
    //设置导航栏的题目属性(ps:设置titleView为自定义题目)
//    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],NSForegroundColorAttributeName,nil];
//    [navigationBar setTitleTextAttributes:attributes];
    
    //设置导航栏的背景图片(ps:背景为透明设置有效)
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hm_zlbg@2x.png"] forBarMetrics:UIBarMetricsDefault];
    
    //设置导航栏的按钮颜色
    navigationBar.tintColor = [UIColor redColor];

    //设置导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [self leftBarBtnItem];

    //设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [self rightBarBtnItem];
    
    //在导航栏上左边多个按钮
//    self.navigationItem.leftBarButtonItems = [self leftBarBtnItems];

    //在导航栏上右边多个按钮
//    self.navigationItem.leftBarButtonItems = [self rightBarBtnItems];

    //设置使底部线条失效
//    [navigationBar setShadowImage:[UIImage new]];   //第一种(ps:设置透明的背景图，便于识别底部线条有没有被隐藏)
    
    //在导航栏上添加分段控件
//    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"消息",@"电话"]];
//    segControl.tintColor = [UIColor colorWithRed:0.07 green:0.72 blue:0.96 alpha:1];
//    [segControl setSelectedSegmentIndex:0];
//    self.navigationItem.titleView = segControl;
}

- (UIBarButtonItem *)leftBarBtnItem
{
    //设置返回按钮的图片
    UIImage *leftButtonIcon = [[UIImage imageNamed:@"freshnavibar_back@2x.png"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:leftButtonIcon
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goToBack)];
    //设置返回按钮的文字
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
//                                                                    style:UIBarButtonItemStylePlain
//                                                                   target:self action:@selector(goToBack)];

    //设置自定义返回按钮
//    UIView* leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
//    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    leftButton.backgroundColor = [UIColor clearColor];
//    leftButton.frame = leftButtonView.frame;
//    [leftButton setImage:[UIImage imageNamed:@"LeftButton_back_Icon"] forState:UIControlStateNormal];
//    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    leftButton.tintColor = [UIColor redColor];
//    leftButton.autoresizesSubviews = YES;
//    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
//    [leftButton addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
//    [leftButtonView addSubview:leftButton];
//    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];

    return leftBarButton;
}

- (UIBarButtonItem *)rightBarBtnItem{return nil;}

- (NSArray *)leftBarBtnItems{
    
//    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
//    
//    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    leftButton.backgroundColor = [UIColor clearColor];
//    leftButton.frame = CGRectMake(0, 0, 45, 40);
//    [leftButton setImage:[UIImage imageNamed:@"LeftButton_back_Icon"] forState:UIControlStateNormal];
//    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    leftButton.tintColor = [UIColor whiteColor];
//    leftButton.autoresizesSubviews = YES;
//    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
//    [leftButton addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    
//    return @[backItem,closeItem];
    
    return nil;
}

- (NSArray *)rightBarBtnItems{return nil;}

- (void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//更改状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
