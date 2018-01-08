//
//  FindDetailViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FindDetailViewController.h"
#import "CCWebViewViewController.h"

@interface FindDetailViewController ()

@property (nonatomic, retain) UIWebView *webView;

@end

@implementation FindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CCWebViewViewController *web = [[CCWebViewViewController alloc] init];
    web.UrlStr = self.urlStr;
    [self addChildViewController:web];
    [self.view addSubview:web.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
