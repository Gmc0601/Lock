//
//  AppDelegate+UmengSDK.m
//  BaseProject
//
//  Created by cc on 2017/12/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AppDelegate+UmengSDK.h"

#define UmengAPPKey @"5a3a3ac8f43e481a2d00001e"

@implementation AppDelegate (UmengSDK)

- (void)initUmeng {
    //  友盟
    [[UMSocialManager defaultManager] openLog:YES];
    
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengAPPKey];
    
    [self configUSharePlatformsset];
}

- (void)configUSharePlatformsset
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:@"wxca2816298afcf527"
                                       appSecret:@"1fd22df350beff66bb55c3a1478ae077"
                                     redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine
                                          appKey:@"wxca2816298afcf527"
                                       appSecret:@"1fd22df350beff66bb55c3a1478ae077"
                                     redirectURL:nil];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:@"1106531057"
                                       appSecret:@"ZfdAQRkvA1VXIR8O"
                                     redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone
                                          appKey:@"1106531057"
                                       appSecret:@"ZfdAQRkvA1VXIR8O"
                                     redirectURL:nil];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Tim
                                          appKey:@"1106531057"
                                       appSecret:@"ZfdAQRkvA1VXIR8O"
                                     redirectURL:nil];
    
}

//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        if ([url.host isEqualToString:@"safepay"]) {
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
//                                                      standbyCallback:^(NSDictionary *resultDic) {
//                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySuccessNotification" object:resultDic];
//                                                      }];
//            
//            return YES;
//        }
//    }
//    return result;
//}
//
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
//    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
//    if (!result) {
//        if ([url.host isEqualToString:@"safepay"]) {
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
//                                                      standbyCallback:^(NSDictionary *resultDic) {
//                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySuccessNotification" object:resultDic];
//                                                      }];
//            
//            return YES;
//        }
//    }
//    return result;
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        if ([url.host isEqualToString:@"safepay"]) {
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
//                                                      standbyCallback:^(NSDictionary *resultDic) {
//                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySuccessNotification" object:resultDic];
//                                                      }];
//            
//            return YES;
//        }
//    }
//    return result;
//}

@end
