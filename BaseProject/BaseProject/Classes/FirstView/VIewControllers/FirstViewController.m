//
//  FirstViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FirstViewController.h"
#import <UIImage+GIF.h>
#import "AddGateWayViewController.h"
#import "AddDeviceViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
}

- (void)resetFather {
    self.line.hidden = YES;
    self.titleLab.text = @"大门锁";
    [self.rightBar setTitle:@"" forState:UIControlStateNormal];
    [self.leftBar setImage:[UIImage imageNamed:@"nav_icon_zj"] forState:UIControlStateNormal];
    [self.rightBar setImage:[UIImage imageNamed:@"nav_icon_xx"] forState:UIControlStateNormal];
}

- (void)back:(UIButton *)sender {
    NSLog(@"111");
    AddGateWayViewController *add = [[AddGateWayViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)more:(UIButton *)sender {
    NSLog(@"111");
    AddGateWayViewController *add = [[AddGateWayViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
