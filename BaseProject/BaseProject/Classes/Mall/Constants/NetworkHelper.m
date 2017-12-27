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
#import "RegionModel.h"
#import "WXApi.h"
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

+(void) addOrder:(OrderModel *) order withCallBack:(void(^)(NSString *error,OrderResult *result)) callback{
    NSDictionary *dict = [order mj_keyValues];
    [HttpRequest getPath:@"order/add.html" params:dict resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *dict = datadic[@"data"];
            OrderResult *result = [OrderResult mj_objectWithKeyValues:dict];
            callback(nil,result);
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
    if ([RegionModel hasLoad]) {
        return;
    }
    [HttpRequest getPath:@"public/getArea" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSArray *infoArr = datadic[@"data"];
            NSMutableArray *models = [NSMutableArray new];
            for (NSDictionary *dict in infoArr) {
                RegionModel *model = [RegionModel new];
                model.name = dict[@"name"];
                model.id = dict[@"id"];
                model.fid = dict[@"fid"];
                [models addObject:model];
            }
            [RegionModel insertRegions:models];
        }
    }];
}

+ (void)WXPay:(OrderResult *) result{
    
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = result.appid;
    
    // 商家id，在注册的时候给的
    req.partnerId = result.mch_id;
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = result.prepay_id;
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package   = @"Sign=WXPay";
    
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = result.nonce_str;
    
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    req.timeStamp = time;
    
    // 这个签名也是后台做的
    req.sign = result.sign;
    
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:req];
}

@end


