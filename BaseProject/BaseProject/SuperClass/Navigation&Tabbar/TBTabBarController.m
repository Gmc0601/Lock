//
//  TBTabBarController.m
//  BaseProject
//
//  Created by cc on 2017/6/22.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "TBTabBarController.h"


#import "FirstViewController.h"
#import "MallViewController.h"
#import "FindViewController.h"
#import "MeViewController.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import "TBNavigationController.h"
#import "TBTabBar.h"

@interface TBTabBarController ()

@end

@implementation TBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化所有控制器
    [self setUpChildVC];
    
}


#pragma mark -初始化所有控制器 

- (void)setUpChildVC {

    FirstViewController *newsVc = [[FirstViewController alloc] init];
    [self setChildVC:newsVc title:@"首页" image:@"tab_icon_sy" selectedImage:@"tab_icon_sy_pre"];
    
    MallViewController *investment = [[MallViewController alloc] init];
    [self setChildVC:investment title:@"商城" image:@"tab_icon_sc" selectedImage:@"tab_icon_sc_pre"];
    
    FindViewController *myVC = [[FindViewController alloc] init];
    [self setChildVC:myVC title:@"发现" image:@"tab_icon_zx_pre" selectedImage:@"tab_icon_zx"];

    MeViewController *me = [[MeViewController alloc] init];
    [self setChildVC:me title:@"我的" image:@"tab_icon_wd" selectedImage:@"tab_icon_wd_pre"];
    
}

- (void) setChildVC:(UIViewController *)childVC title:(NSString *) title image:(NSString *) image selectedImage:(NSString *) selectedImage {
    
    childVC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = RGBColor(90, 142, 218);
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    TBNavigationController *nav = [[TBNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item name = %@", item.title);
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer] 
     addAnimation:pulse forKey:nil]; 
}

@end
