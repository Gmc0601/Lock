//
//  OrderCell.h
//  BaseProject
//
//  Created by LeoGeng on 04/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol OrderCellDelegate <NSObject>
    -(void) showConfirmView:(NSString *) orderId;
@end

@interface OrderCell : UITableViewCell
@property(retain,nonatomic) OrderModel *model;
@property(weak,atomic) id<OrderCellDelegate> delegate;
@end
