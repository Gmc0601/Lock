//
//  MailViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MallViewController.h"
#import "ConfirmOrderViewController.h"
#import "NetworkHelper.h"
#import "MyOrderViewController.h"
#import "LoginViewController.h"
#import "TBNavigationController.h"

@interface MallViewController ()<UIWebViewDelegate>
@property (retain,atomic) UIScrollView *scrollView;
@property (retain,atomic) UIImageView *img;
@property (retain,atomic) UIWebView *web;
@property (retain,atomic)  UIButton *btn ;
@property (retain,atomic)  NSString *goodsId ;
@property (retain,atomic)  GoodsInfo *goodsInfo ;
@end

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [ConfigModel showHud:self];
    
    [NetworkHelper getGoodsInfoWithcallBack:^(NSString *error, GoodsInfo *goodsInfo) {
        [ConfigModel hideHud:self];
       
        if (error != nil) {
            [ConfigModel mbProgressHUD:error andView:self.view];;
            return ;
        }
        
        if(_scrollView == nil){
            [self addScrollView];
            [self addBuyButton];
        }
        
        _goodsInfo = goodsInfo;
        _goodsId = goodsInfo.goods_id;
        NSString *title = [self getTitle:goodsInfo.price];
        [_btn setTitle:title forState:UIControlStateNormal];
        [_img sd_setImageWithURL:[NSURL URLWithString:goodsInfo.adverts_img]];
        NSString *strTemplateHTML = [NSString stringWithFormat:@"<html><head><style>img{width:100%%;height:auto !important};</style></head><body style='margin:0; padding:0;'>%@</body></html>", goodsInfo.goods_desc];

        [_web loadHTMLString:strTemplateHTML baseURL:nil];
        _web.scalesPageToFit = YES;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setbadgeLab) name:HaveMessage object:nil];
}
- (void)setbadgeLab {
    [self.rightBar setBadge];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![ConfigModel getBoolObjectforKey:HaveMessage]) {
        [self.rightBar hideBadge];
    }
}
- (void)resetFather {
    self.line.hidden = YES;
    self.titleLab.text = @"商城";
    [self.rightBar setTitle:@"" forState:UIControlStateNormal];
    [self.rightBar setImage:[UIImage imageNamed:@"nav_icon_xx"] forState:UIControlStateNormal];
}

- (void)more:(UIButton *)sender {
    UnloginReturn
    JumpHistory
}

-(void) addScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled= YES;
    _scrollView.backgroundColor = [UIColor whiteColor];

    _scrollView.contentSize = CGSizeMake(kScreenW, (kScreenH - self.navigationView.frame.size.height -self.tabBarController.tabBar.bounds.size.height)*2);
    
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-self.tabBarController.tabBar.bounds.size.height);
    }];
    
    CGFloat y = 0;
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kScreenW , SizeHeight(876/2))];
    _img.contentMode = UIViewContentModeScaleAspectFit;
//    _img.image = [UIImage imageNamed:@"ddxq_icon_shz"];
//    _img.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:_img];
    
    y += SizeHeight(876+149)/2;
    [self addMsgRef:CGRectMake(self.view.centerX - SizeWidth(195/4), y, SizeWidth(195/2), SizeHeight(23/2)) withText:@"上拉查看商品详情"];
    
    y+= SizeHeight(90/2);
    [self addMsgRef:CGRectMake(self.view.centerX - SizeWidth(195/4), y, SizeWidth(195/2), SizeHeight(23/2)) withText:@"下拉返回顶部"];
    
    y+= SizeHeight(60)/2;
    _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, y, kScreenW, _scrollView.contentSize.height - y )];
    _web.delegate = self;
    [_scrollView addSubview:_web];
    _web.backgroundColor = [UIColor whiteColor];

    [_web loadHTMLString:_goodsInfo.goods_desc baseURL:nil];
    
}

-(void) addMsgRef:(CGRect) frame withText:(NSString *) text{
    UILabel *lblMsg = [[UILabel alloc] initWithFrame:frame];
    lblMsg.font = PingFangSCMedium(SizeWidth(12));
    lblMsg.textColor = RGBColor(153,153,153);
    lblMsg.text = text;
    lblMsg.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:lblMsg];
}


-(void) addBuyButton{
    _btn = [UIButton new];
    [_btn setTitle:@"" forState:UIControlStateNormal];
    _btn.titleLabel.font = PingFangSCMedium(SizeWidth(15));
    [_btn setTitleColor:RGBColor(255,255,255) forState:UIControlStateNormal];
    _btn.backgroundColor = RGBColor(248,179,23);
    [_btn setImage:[UIImage imageNamed:@"nav_icon_fh"] forState:UIControlStateNormal];
    _btn.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    _btn.imageEdgeInsets = UIEdgeInsetsMake(0, SizeWidth(5), 0, 0 );
    [_btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(SizeHeight(-180/2));
        make.right.equalTo(self.view);
        make.width.equalTo(@(SizeWidth(236/2)));
        make.height.equalTo(@(SizeHeight(88/2)));
    }];
}

-(NSString *) getTitle:(NSString *) price{
    return [NSString stringWithFormat:@"￥%@购买",price];
}

-(void) buy{
    if ([ConfigModel getBoolObjectforKey:IsLogin] == NO) {
        //[ConfigModel mbProgressHUD:@"请先登录" andView:self.view];
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.homeBlocl = ^{
            self.tabBarController.selectedIndex = 0;
        };
        TBNavigationController *na = [[TBNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:na animated:YES completion:nil];
        return;

    }
    
    if (_goodsId != nil) {
        ConfirmOrderViewController *newVC = [[ConfirmOrderViewController alloc] initWithGoodsId:_goodsInfo];
     //   MyOrderViewController *newVC = [MyOrderViewController new];
        [self.navigationController pushViewController:newVC animated:YES];
    }
}


@end

