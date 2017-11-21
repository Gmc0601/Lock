//
//  FirstViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FirstViewController.h"
#import <UIImage+GIF.h>

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
