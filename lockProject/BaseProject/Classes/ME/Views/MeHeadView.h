//
//  MeHeadView.h
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCButton.h"

@interface MeHeadView : UIView

@property (nonatomic, retain) UIImageView *backView, *headImg;

@property (nonatomic, retain) UILabel *nicknameLab;

@property (nonatomic, retain) UIButton *messageBtn, *headBtn;

@property (nonatomic, copy) void(^orderBlock)(int num);

@property (nonatomic, copy) void(^messageBlock)();

@property (nonatomic, copy) void(^headImgBlock)();

@property (nonatomic, retain) NSArray *countArr;;

@property (nonatomic, retain)CCButton *btn1, *btn2, *btn3;

- (void)update;

@end
