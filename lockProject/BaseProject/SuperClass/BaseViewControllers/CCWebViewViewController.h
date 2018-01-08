//
//  CCWebViewViewController.h
//  CCWebView
//
//  Created by cc on 2017/11/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)getUser_token;

@end

@interface CCWebViewViewController : CCBaseViewController

@property (nonatomic, copy) NSString *UrlStr;

@property (nonatomic, copy) NSString *titlestr;

@end
