//
//  OrderModel.h
//  BaseProject
//
//  Created by LeoGeng on 04/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    waitingPay,
    waitingDeliver,
    waitingReceiving,
    complete,
    waitingRefund,
    RefundComplete
    
} OrderStatus;

@interface OrderModel : NSObject
@property(retain,atomic) NSString *title;
@property(retain,atomic) NSString *price;
@property(retain,atomic) NSString *img;
@property(retain,atomic) NSString *_id;
@property(assign,atomic) OrderStatus status;
@end
