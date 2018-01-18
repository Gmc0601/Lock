//
//  OrderResult.h
//  BaseProject
//
//  Created by LeoGeng on 27/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderResult : NSObject
@property (retain,atomic) NSString *appid;
@property (retain,atomic) NSString *mch_id;
@property (retain,atomic) NSString *nonce_str;
@property (retain,atomic) NSString *prepay_id;
@property (retain,atomic) NSString *result_code;
@property (retain,atomic) NSString *return_code;
@property (retain,atomic) NSString *return_msg;
@property (retain,atomic) NSString *sign;
@property (retain,atomic) NSString *trade_type;
@property (retain,atomic) NSString  *order_id;
@property (retain,atomic) NSString  *order_sn;
@property (retain,atomic) NSString  *timeout_express;
@property (retain,atomic) NSString  *subject;
@property (retain,atomic) NSString  *total_amount;
@property (retain,atomic) NSString  *timestamp;
@end
