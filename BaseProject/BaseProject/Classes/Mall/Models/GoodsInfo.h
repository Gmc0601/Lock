//
//  GoodsInfo.h
//  BaseProject
//
//  Created by LeoGeng on 10/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfo : NSObject
@property(retain,atomic) NSString *goods_id;
@property(retain,atomic) NSString *goods_name;
@property(retain,atomic) NSString *head_img;
@property(retain,atomic) NSString *price;
@property(retain,atomic) NSString *trial_price;
@property(retain,atomic) NSString *goods_desc;
@end
