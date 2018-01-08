//
//  UserAgreeViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/12.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "UserAgreeViewController.h"

#import "CCWebViewViewController.h"

@interface UserAgreeViewController ()

@end

@implementation UserAgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CCWebViewViewController *web = [[CCWebViewViewController alloc] init];
    web.UrlStr = @"http://116.62.142.20/Public/zcxy";
    [self addChildViewController:web];
    [self.view addSubview:web.view];
    
    /*
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
