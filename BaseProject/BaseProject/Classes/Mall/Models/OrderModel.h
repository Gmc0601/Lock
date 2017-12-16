//
//  OrderModel.h
//  BaseProject
//
//  Created by LeoGeng on 04/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    OrderStatus_waitingPay,
    OrderStatus_padyed,
    OrderStatus_hasSend,
    OrderStatus_complete,
    OrderStatus_waitingRefund,
    OrderStatus_RefundComplete,
    OrderStatus_RefundCancel
    
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
@end
