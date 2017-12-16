//
//  NetworkHelper.m
//  BaseProject
//
//  Created by LeoGeng on 10/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "NetworkHelper.h"
#import <MJExtension/MJExtension.h>

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
        
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *infoArr = datadic[@"data"];
            
            AddressModel *info = [AddressModel mj_objectWithKeyValues: infoArr];
            callback(nil,info);
        }else{
            callback(datadic[@"msg"],nil);
        }
    }];
}
@end
