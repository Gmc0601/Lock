//
//  PayTool.h
//  SimpleLife
//
//  Created by cc on 17/5/4.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OrderResult.h"
typedef NS_ENUM (NSInteger, PayType) {
    PayTypeAlipay = 2 ,
    PayTypeWeChat = 3
};

@interface PayManager : NSObject

+ (PayManager *)manager;

///*
// *   (づ￣3￣)づ╭❤～  MARK:-   支付宝 支付结果回调
// */
- (void)alipayResult:(NSDictionary *)resultDic;


/*
 *   (づ￣3￣)づ╭❤～  MARK:-   微信支付接口
 */
- (void)payByWeChatWithPrice:(NSString *)price order_num:(NSString *)order_num;

- (void)payByAlipay:(OrderResult *) order;

@end












