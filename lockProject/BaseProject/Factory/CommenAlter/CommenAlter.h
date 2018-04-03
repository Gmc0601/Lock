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

@property (nonatomic, retain) UITextField *text;

@property (nonatomic, copy) void(^leftBlock)();

@property (nonatomic, copy) void(^textBlock)(NSString *pwd);

@property (nonatomic, copy) void(^rightBlock)();

@property (nonatomic) BOOL havePwd;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr info:(NSString *)infoStr leftBtn:(NSString *)leftStr right:(NSString *)rightStr;

- (void)pop;

- (void)dismiss;

@end
