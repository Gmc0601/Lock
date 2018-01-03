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
#import "PayManager.h"
#import "NSString+MD5.h"

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
    [WXApi registerApp:result.appid];

    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
//    req.openID = result.appid;
    // 商家id，在注册的时候给的
    req.partnerId = result.mch_id;
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = result.prepay_id;
    
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package   = @"Sign=WXPay";
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = result.nonce_str;
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    UInt32 timeStamp =[timeSp intValue];
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    req.timeStamp = timeStamp;
    
    req.sign = result.sign;
    
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:req];
}
//
+(NSString *)createMD5SingForPayWithAppID:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];//微信appid 例如wxfb132134e5342
    [signParams setObject:noncestr_key forKey:@"noncestr"];//随机字符串
    [signParams setObject:package_key forKey:@"package"];//扩展字段  参数为 Sign=WXPay
    [signParams setObject:partnerid_key forKey:@"partnerid"];//商户账号
    [signParams setObject:prepayid_key forKey:@"prepayid"];//此处为统一下单接口返回的预支付订单号
    [signParams setObject:[NSString stringWithFormat:@"%u",timestamp_key] forKey:@"timestamp"];//时间戳

    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段  API 密钥
    [contentString appendFormat:@"key=%@", @"1fd22df350beff66bb55c3a1478ae077"];
    NSString *result = [((NSString *)contentString) md5WithString];//md5加密
    return result;
}


+(void) pay:(NSString *) order_id {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:order_id forKey:@"order_id"];
    
    [HttpRequest getPath:@"order/getPayInfo" params:params resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *dict = datadic[@"data"];
            NSString *type = dict[@"pay_type"];

            if ([type isEqualToString:@"0"]) {
                NSDictionary *data = dict[@"alipay_info"];
                OrderResult *result = [OrderResult mj_objectWithKeyValues:data];

                [[PayManager manager] payByAlipay:result];
            }else{
                NSDictionary *data = dict[@"wx_pay_info"];
                OrderResult *result = [OrderResult mj_objectWithKeyValues:data];

                [NetworkHelper WXPay:result];
            }
        }
    }];
}


@end


