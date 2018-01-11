//
//  OrderModel.h
//  BaseProject
//
//  Created by LeoGeng on 04/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    OrderStatus_waitingPay = 0,
    OrderStatus_padyed = 1,
    OrderStatus_hasSend = 2,
    OrderStatus_complete = 3,
    OrderStatus_waitingRefund = 4,
    OrderStatus_RefundComplete = 5,
    OrderStatus_RefundCancel = 6,
    OrderStatus_Cancel =  10,
    
} OrderStatus;

@interface OrderModel:NSObject
    @property(retain,atomic) NSString *goods_id;
    @property(assign,atomic) NSInteger goods_num;
    @property(assign,atomic) NSInteger type;
    @property(assign,atomic) NSInteger is_install;
    @property(retain,atomic) NSString *province;
    @property(retain,atomic) NSString *city;
    @property(retain,atomic) NSString *county;
    @property(retain,atomic) NSString *address;
    @property(retain,atomic) NSString *consignee;
    @property(retain,atomic) NSString *phone;
    @property(retain,atomic) NSString *install_fee;
    @property(retain,atomic) NSString *discount_amount;
    @property(assign,atomic) NSInteger pay_type;
    @property(retain,atomic) NSString *remark;
@property(retain,atomic) NSString *order_sn;
@property(retain,atomic) NSString *order_id;
@property(retain,atomic) NSString *order_amount;
@property(retain,atomic) NSString *pay_time;
@property(retain,atomic) NSString *goods_name;
@property(retain,atomic) NSString *head_img;
@property(assign,atomic) OrderStatus status;
@property(retain,atomic) NSString *trade_no;
@property(retain,atomic) NSString *user_id;
@property(retain,atomic) NSString *goods_price;
@property(retain,atomic) NSString *create_time;
@property(retain,atomic) NSString *update_time;
@property(retain,atomic) NSString *added_fee;
@property(retain,atomic) NSString *express_name;
@property(retain,atomic) NSString *express_no;
@property(retain,atomic) NSString *express_status;
@property(assign,atomic) NSString * wuliu_type;
@end
