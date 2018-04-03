//
//  CCWebViewViewController.m
//  CCWebView
//
//  Created by cc on 2017/11/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCWebViewViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LoginViewController.h"
#import "TBNavigationController.h"
#import "KLCPopup.h"
#import "UIColor+BGHexColor.h"
#import <UMSocialCore/UMSocialCore.h>
#define Share_TAG 100000
#define CBX_PAY_TAG 2003

@interface CCWebViewViewController ()<UIWebViewDelegate, JSObjcDelegate, TSWebViewDelegate>

@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) UIWebView *webView;
@property(retain,atomic) KLCPopup* sharePopup;
@property (nonatomic, copy) NSString *title, *content, *url, *immgUrl;

@end

@implementation CCWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
//    [self loadWebView];
    
    if (self.titlestr) {
        self.titleLab.text = self.titlestr;
    }else {
       self.titleLab.text = @"资讯详情";
    }
    
    self.rightBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (void)createView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}
//- (void)viewWillDisappear:(BOOL)animated {
//    if (self.titlestr) {
//        self.leftBar.hidden = NO;
//    }else {
//      self.leftBar.hidden = YES;
//    }
//    
//    self.navigationController.navigationBar.hidden = YES;
//    //    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
//    
//}

- (void)loadWebView {
    
    if ([ConfigModel getBoolObjectforKey:IsLogin] && [self.UrlStr rangeOfString:@"user_token"].location == NSNotFound ) {
        self.UrlStr = [NSString stringWithFormat:@"%@/user_token/%@", self.UrlStr, [ConfigModel getStringforKey:UserToken]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlStr]];
//    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"" message:self.UrlStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//    [view show];
    [self.webView loadRequest:request];
    [self.webView reload];
}


#pragma mark WebViewDelagate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //    截获当前H5页面的链接，做相应处理
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"requestString : %@",requestString);
    
    NSLog(@">>>>>%@", requestString);
    
    NSArray *components = [requestString componentsSeparatedByString:@"|"];
//    NSLog(@"=components=====%@",components);
    
    
    NSString *str1 = [components objectAtIndex:0];
//    NSLog(@"str1:::%@",str1);
    
    
    NSArray *array2 = [str1 componentsSeparatedByString:@"/"];
//    NSLog(@"array2:====%@",array2);
    
    
    NSInteger coun = array2.count;
    
    NSString *method = array2[coun-1];
    
//    NSLog(@"method:===%@",method);
    
    //    if ([str1 hasPrefix:@"http:"]) {
    ////        链接以什么开头
    //    }
    //    if ([str1 hasSuffix:@"jifen.html"]) {
    ////        链接以什么结尾
    //    }
        if ([ConfigModel getBoolObjectforKey:IsLogin] && [requestString rangeOfString:@"user_token"].location == NSNotFound ) {
    //        不包含某段字符串
            return NO;
        }
    
    //    if ([str1 containsString:@"shop"]) {
    ////        iOS8以后判断是否包含某段字符串
    //    }
    
    NSString *arrayToString = [components componentsJoinedByString:@","];
//    NSLog(@"------------%@-----------------", arrayToString);
    
    
    //    if ([method isEqualToString:@"jifen.html"])//查看详情，其中红色部分是HTML5跟咱们约定好的，相应H5上的按钮的点击事件后，H5发送超链接，客户端一旦收到这个超链接信号。把其中的点击按钮的约定的信号标示符截取出来跟本地的标示符来进行匹配，如果匹配成功，那么就执行相应的操作，详情见如下所示。
    //    {
    //        return NO;
    //    }else if ([method isEqualToString:@"jifen.html"])
    //    {
    //
    //        return NO;
    //    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    //    返回的H5方法
    
    //js方法名＋参数
    //    NSString* jsCode = @"history.go(-1)";
    
    //调用html页面的js方法
    //    [webView stringByEvaluatingJavaScriptFromString:jsCode];
    
    if (!self.context){
        self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    self.context[@"localMethod"] = self;
    
    self.context.exceptionHandler = ^(JSContext *context, JSValue *ex){
        context.exception = ex;
        NSLog(@"异常信息%@",ex);
    };
    
    
}

- (void)getUserToken {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([ConfigModel getBoolObjectforKey:IsLogin]) {
            JSValue *picCallBack = self.context[@"getUserTokenCallBack"];
            [picCallBack callWithArguments:@[[ConfigModel getStringforKey:UserToken]]];
        }
    });
    
}

- (void)reload {
//    NSLog(@"reload");
    dispatch_async(dispatch_get_main_queue(), ^{
//        [ConfigModel mbProgressHUD:@"刷新了" andView:nil];
        [self loadWebView];
    });
    
}

- (void)toLogin {
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [ConfigModel mbProgressHUD:@"登录" andView:nil];
        LoginViewController *vc = [[LoginViewController alloc] init];
        TBNavigationController *na = [[TBNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:na animated:YES completion:nil];
    });
    
    
}

- (void)showShare:(NSString *)title :(NSString *)content :(NSString *)url :(NSString *)imgUrl {
    NSLog(@"%@<>%@<>%@<>%@", title, content ,url, imgUrl);
    
    self.title = title; self.content = content ; self.url = url; self.immgUrl = imgUrl;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showShareView];
        
    });
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx {
    if (!self.context){
        self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    self.context[@"localMethod"] = self;
    
    self.context.exceptionHandler = ^(JSContext *context, JSValue *ex){
        context.exception = ex;
        NSLog(@"异常信息%@",ex);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIWebView *)webView {
    if (!_webView) {
         _webView = [[UIWebView alloc] init];
        _webView.frame = FRAME(0, 64, kScreenW, kScreenH - 64);
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        _webView.multipleTouchEnabled = YES;
        _webView.autoresizingMask = YES;
    }
    return _webView;
}

-(void) showShareView{
    if (_sharePopup == nil) {
        UIView* contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        CGFloat width = self.view.frame.size.width;
        contentView.frame = CGRectMake(self.view.centerX, self.view.centerX - SizeHeight(368/2), width, SizeHeight(368/2));
        
        
        CGFloat offset = - SizeWidth(88+62+62/2+88/2)/2;
        [self addButtonToShareView:contentView withImage:@"fx_icon_pyq" withTitle:@"朋友圈" withLeft:offset withIndex:1];
        offset = -SizeWidth(62/2+88/2)/2;
        [self addButtonToShareView:contentView withImage:@"fx_icon_wx" withTitle:@"微信好友" withLeft:offset withIndex:2];
        
        offset = SizeWidth(62/2+88/2)/2;
        [self addButtonToShareView:contentView withImage:@"fx_icon_qq" withTitle:@"QQ好友" withLeft:offset withIndex:3];
        offset = SizeWidth(88+62+62/2+88/2)/2;
        
        [self addButtonToShareView:contentView withImage:@"fx_icon_kj" withTitle:@"QQ空间" withLeft:offset withIndex:4];
        
        
        UIButton *btnClose = [UIButton new];
        [btnClose setTitleColor:RGBColor(51,51,51) forState:UIControlStateNormal];;
        btnClose.titleLabel.font = PingFangSCBOLD(SizeWidth(18));
        btnClose.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnClose setTitle:@"取消" forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btnClose];
        [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView.mas_centerX);
            make.bottom.equalTo(contentView.mas_bottom).offset(-SizeHeight(29/2));
            make.width.equalTo(@(SizeWidth(90/2)));
            make.height.equalTo(@(SizeHeight(34/2)));
        }];
        
        _sharePopup = [KLCPopup popupWithContentView:contentView];
        _sharePopup.showType = KLCPopupShowTypeSlideInFromBottom;
        _sharePopup.dismissType = KLCPopupDismissTypeSlideOutToBottom;
    }
    
    [_sharePopup showAtCenter:CGPointMake(self.view.centerX, self.view.centerY * 2 - SizeHeight(368/4)) inView:self.view];
}

-(void) addButtonToShareView:(UIView *) superView withImage:(NSString *) img withTitle:(NSString *) title withLeft:(CGFloat) offset withIndex:(NSInteger) index{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    imgView.tag = Share_TAG + index;
    [superView addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShareButton:)];
    [imgView addGestureRecognizer:tapGuesture];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.mas_centerX).offset(offset);
        make.top.equalTo(superView).offset(SizeHeight(62/2));
        make.width.equalTo(@(SizeWidth(88/2)));
        make.height.equalTo(@(SizeHeight(88/2)));
    }];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCMedium(SizeWidth(13));
    lblTitle.textColor = RGBColor(51,51,51);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = title;
    [superView addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgView.mas_centerX);
        make.top.equalTo(imgView.mas_bottom).offset(SizeHeight(48/2));
        make.width.equalTo(@(SizeWidth(70)));
        make.height.equalTo(@(SizeHeight(12)));
    }];
}

-(void) tapShareButton:(UITapGestureRecognizer *) gesture{
    NSInteger index = gesture.view.tag;
    UMSocialPlatformType type = UMSocialPlatformType_WechatTimeLine ;
    switch (index) {
        case 100002:
            type = UMSocialPlatformType_WechatSession;
            break;
        case 100003:
            type = UMSocialPlatformType_Tim;
            break;
        case 100004:
            type = UMSocialPlatformType_Qzone;
            break;
    }
    
    [self shareWebPageToPlatformType:type];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{

        [KLCPopup dismissAllPopups];
    
        
        NSString *thumbURL = self.immgUrl;
        NSString *title = self.title;
        NSString *desc = self.content;
        NSString *url = self.url;
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = url;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
         [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
//                _hasShare = true;
//                [self changePrice:YES];
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    
}

-(void) dismissPopup{
    [KLCPopup dismissAllPopups];
}

@end
