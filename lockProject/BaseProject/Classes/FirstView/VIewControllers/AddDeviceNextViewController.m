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
    [self.NextBtn setTitleColor:MainBlue forState:UIControlStateNormal];
    self.NextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
}

- (void)resetFather {
    self.rightBar.hidden = YES;
    if (self.type == AddNetWork) {
        self.titleLab.text = @"添加网关";
        NSString *text1 = @"接通电源，长按网关背后匹配键3秒后松开，当最外侧绿灯和最外侧红点闪烁时，表示网关进入匹配状态，点击“下一步”开始进行匹配";
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
