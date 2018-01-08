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
    self.rightBar.hidden = YES;
    if (self.type == AddNetWork) {
        self.titleLab.text = @"添加网关";
        NSString *text1 = @"1. 手机连接家庭WiFi(暂不支持5G频段WiFi)；\n2. 接通电源，按下网关匹配键，听到“等待连接WiFi”并看到指示灯闪烁即表示网关已进入匹配模式；";
        self.infoLab.text = text1;
    }else {
        self.titleLab.text = @"添加智能锁";
        [self.NextBtn setTitle:@"添加网关" forState:UIControlStateNormal];
        self.infoLab.text = @"您还没有添加网关，请先添加网关后再添加智能锁";
    }
    
}

- (IBAction)nextBtnClick:(id)sender {
    
        [self.navigationController pushViewController:[AddGateWayViewController new] animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
