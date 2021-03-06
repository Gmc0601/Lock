//
//  NetworkHelper.h
//  BaseProject
//
//  Created by LeoGeng on 10/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsInfo.h"
#import "AddressModel.h"
#import "OrderModel.h"
#import "OrderResult.h"

@interface NetworkHelper : NSObject
+(void) getGoodsInfoWithcallBack:(void(^)(NSString *error,GoodsInfo *goodsInfo)) callback;
+(void)getDiscountAmount:(void(^)(NSString *error,NSString *money)) callback;
+(void) getAddressWtihCallBack:(void(^)(NSString *error,AddressModel *goodsInfo)) callback;
+(void) getAddServiceCallBack:(void(^)(NSString *error,NSString *addedValueService)) callback;
+(void) getInstallCallBack:(void(^)(NSString *error,NSArray *requireInstall, NSArray *unReqiureInstall)) callback;
+(void) addOrder:(OrderModel *) order withCallBack:(void(^)(NSString *error,OrderResult *result)) callback;
+(void) getOrderListWithStatus:(NSString *)status WithCallBack:(void(^)(NSString *error,NSArray *orders)) callback;
+(void) getOrderDetailWithId:(NSString *) order_id WithCallBack:(void(^)(NSString *error,OrderModel *order)) callback;
+(void) loadRegion;
+(void) modifyOrderWithOrderId:(NSString *) order_id  withStatus:(NSString *) status WithCallBack:(void(^)(NSString *error,NSString *msg)) callback;
+(void) getRefundCallBack:(void(^)(NSString *error,NSString *addedValueService)) callback;
+(void) getInstallFeeWithArea:(NSString *) area_id WithCallBack:(void(^)(NSString *error,NSString* installFee,BOOL canInstall, BOOL forceInstall)) callback;
+(void) getAddedFeeWithCallBack:(void(^)(NSString *error,NSString* installFee)) callback;
+ (void)WXPay:(OrderResult *) result;
+(void) pay:(NSString *) order_id;
@end
