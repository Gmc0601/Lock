//
//  NetworkHelper.h
//  BaseProject
//
//  Created by LeoGeng on 10/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsInfo.h"

@interface NetworkHelper : NSObject
+(void) getGoodsInfoWithcallBack:(void(^)(NSString *error,GoodsInfo *goodsInfo)) callback;
@end
