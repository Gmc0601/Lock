//
//  AddDeviceNextViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AddDeviceNextViewController.h"
#import "AddGateWayViewController.h"

@interface AddDeviceNextViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *NextBtn;

@end

@implementation AddDeviceNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
}

- (void)resetFather {
    
    if (self.type == AddNetWork) {
        self.titleLab.text = @"添加网关";
    }else {
        self.titleLab.text = @"添加智能锁";
        [self.NextBtn setTitle:@"" forState:UIControlStateNormal];
    }
    NSString *text1 = @"";
}

- (IBAction)nextBtnClick:(id)sender {
    
    if (self.type == AddNetWork) {
        [self.navigationController pushViewController:[AddGateWayViewController new] animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
