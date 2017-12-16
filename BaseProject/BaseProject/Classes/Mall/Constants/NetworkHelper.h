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
@interface NetworkHelper : NSObject
+(void) getGoodsInfoWithcallBack:(void(^)(NSString *error,GoodsInfo *goodsInfo)) callback;
+(void)getDiscountAmount:(void(^)(NSString *error,NSString *money)) callback;
+(void) getAddressWtihCallBack:(void(^)(NSString *error,AddressModel *goodsInfo)) callback;
+(void) getAddServiceCallBack:(void(^)(NSString *error,NSString *addedValueService)) callback;
+(void) getInstallCallBack:(void(^)(NSString *error,NSArray *requireInstall, NSArray *unReqiureInstall)) callback;
+(void) addOrder:(OrderModel *) order withCallBack:(void(^)(NSString *error,NSString *installFee)) callback;
+(void) getOrderListWithCallBack:(void(^)(NSString *error,NSArray *orders)) callback;
+(void) getOrderDetailWithId:(NSString *) order_id WithCallBack:(void(^)(NSString *error,OrderModel *order)) callback;
@end
