//
//  CCWebViewViewController.m
//  CCWebView
//
//  Created by cc on 2017/11/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCWebViewViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface CCWebViewViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) JSContext *context;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CCWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    [self loadWebView];
}

- (void)createView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}

- (void)loadWebView {
    NSString *httpStr ;
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        //  如果登录拼接usertoken
        if ([httpStr hasPrefix:@"?"]) {
            httpStr = [NSString stringWithFormat:@"%@%@%@", self.UrlStr, @"app=2&user_token=", [ConfigModel getStringforKey:UserToken]];
        }else {
            httpStr = [NSString stringWithFormat:@"%@%@%@", self.UrlStr, @"?app=2&user_token=", [ConfigModel getStringforKey:UserToken]];
        }
    }else {
        httpStr = self.UrlStr;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:httpStr]];
    [self.webView loadRequest:request];
    [self.webView reload];
}


#pragma mark WebViewDelagate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //    截获当前H5页面的链接，做相应处理
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"requestString : %@",requestString);
    
    
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
    //    if ([str1 rangeOfString:@"shop"].location == NSNotFound) {
    ////        不包含某段字符串
    //    }else{
    ////        包含某段字符串
    //    }
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
    
    
    //    documentView.webView.mainFrame.javaScriptContext 获取context的固定写法。
    _context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //获取首页返回键的方法，
    _context[@"home"] = ^(){
        [[[UIAlertView alloc] initWithTitle:@"恭喜！" message:@"截取到了返回的方法，在这里可以返回我们自己的页面！！！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
        
        
        //        方法带参数时获取方法参数
        NSArray *array = [JSContext currentArguments];//H5方法里的参数
        NSString *url = [array lastObject];
        //        NSString *urlGame = [url substringToIndex:url.length].description;
        NSLog(@"%@, %@", array, url);
    };
    
    
    if (self.navigationController) {
        //        获得H5标题作为页面title。
        self.navigationItem.title = self.title?:[_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIWebView *)webView {
    if (!_webView) {
         _webView = [[UIWebView alloc] init];
        _webView.frame = self.view.bounds;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        _webView.multipleTouchEnabled = YES;
        _webView.autoresizingMask = YES;
    }
    return _webView;
}

@end
