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
#import "LoginViewController.h"
#import "NODataView.h"

@interface FirstViewController ()

@property (nonatomic, retain) NODataView *nodataView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self createView];
}

- (void)resetFather {
    if (1) {
        self.titleLab.text = @"大门锁";
    }else {
        self.titleLab.text = @"暂无门锁";
    }
    self.line.hidden = YES;
    [self.rightBar setTitle:@"" forState:UIControlStateNormal];
    [self.leftBar setImage:[UIImage imageNamed:@"nav_icon_zj"] forState:UIControlStateNormal];
    [self.rightBar setImage:[UIImage imageNamed:@"nav_icon_xx"] forState:UIControlStateNormal];
}

- (void)createView {
    [self.view addSubview:self.nodataView];
}

//- (void)viewWillAppear:(BOOL)animated {
//
//}

- (void)back:(UIButton *)sender {
//    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)more:(UIButton *)sender {
    NSLog(@"111");
    AddGateWayViewController *add = [[AddGateWayViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NODataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[NODataView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(65), kScreenH/2, SizeWidth(130), SizeHeight(110)) withimage:@"椭圆4" andtitle:@"暂无设备 点击添加"];
        WeakSelf(weak);
        _nodataView.clickBlock = ^{
            [weak.navigationController pushViewController:[AddDeviceViewController new] animated:YES];
        };
    }
    return _nodataView;
}


@end
