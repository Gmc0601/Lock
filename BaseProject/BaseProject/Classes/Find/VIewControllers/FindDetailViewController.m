//
//  FindDetailViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FindDetailViewController.h"

@interface FindDetailViewController ()

@property (nonatomic, retain) UIWebView *webView;

@end

@implementation FindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"资讯详情";
    self.rightBar.hidden = YES;
    self.webView = [[UIWebView alloc] initWithFrame:FRAME(0, 64, kScreenW, kScreenH - 64)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"www.taobao.com"]];
    [self.webView loadRequest:request];
    [self.webView reload];
    [self.view addSubview:self.webView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
