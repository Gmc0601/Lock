//
//  NODataView.h
//  BaseProject
//
//  Created by cc on 2017/12/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NODataView : UIView

@property (nonatomic, retain) UIImageView *imageview;

@property (nonatomic, retain) UILabel *titlelab;

@property (nonatomic, retain) UIButton *btn;

@property (nonatomic, copy) void(^clickBlock)();

- (instancetype)initWithFrame:(CGRect)frame withimage:(NSString *)image andtitle:(NSString *)str;


@end
