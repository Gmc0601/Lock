//
//  AddDeviceViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "AddDeviceNextViewController.h"
#import "AddLockViewController.h"

@interface AddDeviceViewController (){
    BOOL haveNet;
}

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    
    haveNet = NO;
    [HttpRequest postPath:@"GateWay/getlist" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSArray *data = datadic[@"data"];
            
            if (IsNULL(data)) {
                
            }else {
                haveNet = YES;
            }
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}

- (void)resetFather {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"添加设备";
}
// 添加网关
- (IBAction)addNet:(id)sender {
    AddDeviceNextViewController *next = [[AddDeviceNextViewController alloc] init];
    next.type = AddNetWork;
    [self.navigationController pushViewController:next animated:YES];
}
//  添加设备
- (IBAction)addLock:(id)sender {
    if (haveNet) {
        AddLockViewController *vc = [[AddLockViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        AddDeviceNextViewController *next = [[AddDeviceNextViewController alloc] init];
        next.type = AddLock;
        [self.navigationController pushViewController:next animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
