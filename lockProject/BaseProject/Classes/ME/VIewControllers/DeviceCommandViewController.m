//
//  DeviceCommandViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "DeviceCommandViewController.h"
#import "DCNavTabBarController.h"
#import "MyNetViewController.h"
#import "MyLockViewController.h"

@interface DeviceCommandViewController ()

@end

@implementation DeviceCommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    
    MyNetViewController *net = [[MyNetViewController alloc] init];
    net.title = @"网关";
    MyLockViewController *lock = [[MyLockViewController alloc] init];
    lock.title = @"智能锁";
    
    NSArray *subViewControllers = @[net,lock];
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    tabBarVC.view.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64);

    [self.view addSubview:tabBarVC.view];
    [self addChildViewController:tabBarVC];
    
}

- (void)resetFather {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"设备管理";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
