//
//  CommenAlter.h
//  BaseProject
//
//  Created by cc on 2018/1/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum {
//
//
//
//}AlterType;

@interface CommenAlter : UIView

@property (nonatomic, retain) UIView *backView, *whitView;

@property (nonatomic, retain) UILabel *titleLab, *infoLab;

@property (nonatomic, retain) UIButton *leftBtn, *rightBtn;

@property (nonatomic, copy) void(^leftBlock)();

@property (nonatomic, copy) void(^rightBlock)();

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr info:(NSString *)infoStr leftBtn:(NSString *)leftStr right:(NSString *)rightStr;

- (void)pop;

- (void)dismiss;

@end
