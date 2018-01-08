//
//  OpenView.h
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCButton.h"

@interface OpenView : UIView

@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UIButton *openBtn;
@property (nonatomic, retain) CCButton *leftBtn, *rightBtn;

//弹出
- (void)pop;

//隐藏
- (void)dismiss;

@end
