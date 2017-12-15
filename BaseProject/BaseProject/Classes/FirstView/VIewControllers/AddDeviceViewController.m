//
//  AddDeviceViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "AddDeviceNextViewController.h"

@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
}

- (void)resetFather {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"添加设备";
}
// 添加网关
- (IBAction)addNet:(id)sender {
    [self.navigationController pushViewController:[AddDeviceNextViewController new] animated:YES];
}
//  添加设备
- (IBAction)addLock:(id)sender {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
