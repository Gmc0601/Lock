//
//  ConfirmOrderViewController.h
//  BaseProject
//
//  Created by LeoGeng on 27/11/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBaseViewController.h"
#import "GoodsInfo.h"

@interface ConfirmOrderViewController : CCBaseViewController
- (instancetype)initWithGoodsId:(GoodsInfo *) goodsId;
@end
