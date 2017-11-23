//
//  MailViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MallViewController.h"

@interface MallViewController ()<UIWebViewDelegate>
@property (retain,atomic) UIScrollView *scrollView;
@property (retain,atomic) UIImageView *img;
@property (retain,atomic) UIWebView *web;
@end

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self addScrollView];
}

- (void)resetFather {
    self.line.hidden = YES;
    self.titleLab.text = @"商城";
    [self.rightBar setTitle:@"" forState:UIControlStateNormal];
    [self.rightBar setImage:[UIImage imageNamed:@"nav_icon_xx"] forState:UIControlStateNormal];
}

-(void) addScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled= YES;
    _scrollView.contentSize = CGSizeMake(kScreenW, kScreenH *2);
    
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-self.tabBarController.tabBar.bounds.size.height);
    }];
    
    CGFloat heightOfImage = kScreenH - SizeHeigh(450/2);
    CGFloat y = SizeHeigh(30);
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(SizeWidth(52), y, kScreenW - SizeWidth(104), heightOfImage)];
    _img.image = [UIImage imageNamed:@"ddxq_icon_shz"];
    _img.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:_img];
    
    y += SizeHeigh(876+149)/2;
    [self addMsgRef:CGRectMake(SizeWidth(227/2), y, SizeWidth(195/2), SizeHeigh(23/2)) withText:@"上拉查看商品详情"];
    
    y+= SizeHeigh(90/2);
    [self addMsgRef:CGRectMake(SizeWidth(227/2), y, SizeWidth(195/2), SizeHeigh(23/2)) withText:@"下拉返回顶部"];
    
    y+= SizeHeigh(60)/2;
    _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, y, kScreenW, SizeHeigh(996/2))];
    _web.delegate = self;
    [_scrollView addSubview:_web];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];

    [_web loadRequest:request];
    
}

-(void) addMsgRef:(CGRect) frame withText:(NSString *) text{
    UILabel *lblMsg = [[UILabel alloc] initWithFrame:frame];
    lblMsg.font = PingFangSCMedium(SizeWidth(12));
    lblMsg.textColor = RGBColor(153,153,153);
    lblMsg.text = text;
    lblMsg.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:lblMsg];
}


@end
