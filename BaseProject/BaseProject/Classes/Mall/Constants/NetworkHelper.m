//
//  NetworkHelper.m
//  BaseProject
//
//  Created by LeoGeng on 10/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "NetworkHelper.h"
#import <MJExtension/MJExtension.h>
#import "Utils.h"

@implementation NetworkHelper
+(void) getGoodsInfoWithcallBack:(void(^)(NSString *error,GoodsInfo *goodsInfo)) callback{
    [HttpRequest getPath:@"index/goodsInfo.html" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *infoArr = datadic[@"data"];
            
            GoodsInfo *info = [GoodsInfo mj_objectWithKeyValues: infoArr];
            callback(nil,info);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}

+(void)getDiscountAmount:(void(^)(NSString *error,NSString *money)) callback{
    [HttpRequest getPath:@"public/fenxianglijian" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *dict = datadic[@"data"];
            
            callback(nil,dict[@"lijian"]);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}

+(void) getAddressWtihCallBack:(void(^)(NSString *error,AddressModel *goodsInfo)) callback{
    [HttpRequest getPath:@"users/getAddress.html" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1 && datadic[@"data"] != [NSNull null]) {
            NSDictionary *infoArr = datadic[@"data"];
            
            AddressModel *info = [AddressModel mj_objectWithKeyValues: infoArr];
            callback(nil,info);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}

+(void) getAddServiceCallBack:(void(^)(NSString *error,NSString *addedValueService)) callback{
    [HttpRequest getPath:@"public/tuiyajin.html" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSString *strService = datadic[@"data"];
            
            callback(nil,strService);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}

+(void) getRefundCallBack:(void(^)(NSString *error,NSString *addedValueService)) callback{
    [HttpRequest getPath:@"public/tuiyajin.html" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSString *strService = datadic[@"data"];
            
            callback(nil,strService);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}

+(void) getInstallCallBack:(void(^)(NSString *error,NSArray *requireInstall, NSArray *unReqiureInstall)) callback{
    [HttpRequest getPath:@"public/getInstallArea.html" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *dict = datadic[@"data"];
            NSArray *req = dict[@"qiangzhi"];
            NSArray *unReq = dict[@"feiqiangzhi"];
            
            callback(nil,req,unReq);
        }else{
            callback(datadic[@"msg"],nil,nil);
        }
    }];
}

+(void) getInstallFeeWithArea:(NSString *) area_id WithCallBack:(void(^)(NSString *error,NSString *installFee,bool canInstall, bool forceInstall)) callback{
    [HttpRequest getPath:@"Public/getInstallFee" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *dict = datadic[@"data"];
            
            callback(nil,dict[@"install_fee"],[dict[@"is_install"]  isEqual: @"1"],[dict[@"is_force"] isEqual: @"1"]);
        }else{
            callback(datadic[@"msg"],nil,nil,nil);
        }
    }];
}

+(void) addOrder:(OrderModel *) order withCallBack:(void(^)(NSString *error,NSString *installFee)) callback{
    NSDictionary *dict = [order mj_keyValues];
    [HttpRequest getPath:@"order/add.html" params:dict resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *dict = datadic[@"data"];
            
            callback(nil,datadic[@"msg"]);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}

+(void) getOrderListWithCallBack:(void(^)(NSString *error,NSArray *orders)) callback{
    
    [HttpRequest getPath:@"order/getlist" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSArray *infoArr = datadic[@"data"];
            NSMutableArray *models = [NSMutableArray new];
            for (NSDictionary *dict in infoArr) {
                OrderModel *model = [OrderModel new];
                model.goods_name = dict[@"goods_name"];
                model.order_id = dict[@"order_id"];
                model.order_amount = dict[@"order_amount"];
                model.pay_time = dict[@"pay_time"];
                model.order_sn = dict[@"order_sn"];
                model.goods_id = dict[@"goods_id"];
                model.head_img = dict[@"head_img"];
                model.status = [self getOrderStatusFrom:dict[@"status"]];
                [models addObject:model];
            }
            
            
            callback(nil,models);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}

+(OrderStatus) getOrderStatusFrom:(NSString *) strStatus{
    if ([strStatus isEqualToString:@"0"]) {
        return OrderStatus_waitingPay;
    }else if ([strStatus isEqualToString:@"1"]) {
        return OrderStatus_padyed;
    }else if ([strStatus isEqualToString:@"2"]) {
        return OrderStatus_hasSend;
    }else if ([strStatus isEqualToString:@"3"]) {
        return OrderStatus_complete;
    }else if ([strStatus isEqualToString:@"4"]) {
        return OrderStatus_waitingRefund;
    }else if ([strStatus isEqualToString:@"5"]) {
        return OrderStatus_RefundComplete;
    }else if ([strStatus isEqualToString:@"10"]) {
        return OrderStatus_Cancel;
    }
    
    return OrderStatus_Cancel;
}

+(void) getOrderDetailWithId:(NSString *) order_id WithCallBack:(void(^)(NSString *error,OrderModel *order)) callback{
NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:order_id forKey:@"order_id"];
    
    [HttpRequest getPath:@"order/orderInfo" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *infoArr = datadic[@"data"];
            
            
            OrderModel *info = [OrderModel mj_objectWithKeyValues:infoArr];
            callback(nil,info);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}


+(void) getAddedFeeWithCallBack:(void(^)(NSString *error,NSString* installFee)) callback{
    [HttpRequest getPath:@"Public/getAddedFee" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSString *infoArr = datadic[@"data"][@"added_fee"];
            
            callback(nil,infoArr);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}

+(void) modifyOrderWithOrderId:(NSString *) order_id withStatus:(NSString *) status WithCallBack:(void(^)(NSString *error,NSString *msg)) callback{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:order_id forKey:@"order_id"];
    [params setValue:status forKey:@"status"];
    
    [HttpRequest getPath:@"order/setOrderStatus" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSString *msg = datadic[@"msg"];
            callback(nil,msg);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}


+(void) loadRegion{
    if ([Utils fileIsExist]) {
//        [self getRegionData];
        return;
    }
    [HttpRequest getPath:@"public/getArea" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *infoArr = datadic[@"data"];
            
            [Utils writeStringToFile:infoArr];
        }
    }];
}

@end


