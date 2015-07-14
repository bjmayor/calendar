//
//  BHNavigationController.m
//  贱贱日历
//
//  Created by Bin on 14-9-28.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "BHNavigationController.h"
#import "BHUtils.h"

@implementation BHNavigationController

#pragma mark 一个类只会调用一次
+ (void)initialize
{
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
//    [navBar setBackgroundImage:[BHUtils createImageWithColor:[BHUtils hexStringToColor:CFF4444]] forBarMetrics:UIBarMetricsDefault];
    // 3.标题颜色
    [navBar setTitleTextAttributes:@{
                                     UITextAttributeTextColor : [UIColor whiteColor]
                                     }];
    navBar.translucent = NO;
}

-(void)viewDidLoad{
    [super viewDidLoad];
//    // 1.取出设置主题的对象
//    UINavigationBar *navBar = self.navigationBar;
//    
//    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
//    // 3.标题颜色
//    [navBar setTitleTextAttributes:@{
//                                     UITextAttributeTextColor : [UIColor whiteColor]
//                                     }];
//    navBar.translucent = NO;
}

#pragma mark 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIBarStyleBlackTranslucent;
}


@end
