//
//  DeviceCommandViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "DeviceCommandViewController.h"

@interface DeviceCommandViewController ()

@end

@implementation DeviceCommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetFather];
}

- (void)resetFather {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"设备管理";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
