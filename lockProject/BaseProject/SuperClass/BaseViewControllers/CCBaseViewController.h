//
//  BaseViewController.h
//  EasyMake
//
//  Created by cc on 2017/5/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Utils.h"
#import "NSString+Category.h"
#import "UIImageView+WebCache.h"

@interface CCBaseViewController : UIViewController

@property (nonatomic, retain) UIView *navigationView;

@property (nonatomic, retain) UIButton *leftBar;

@property (nonatomic, retain) UIButton *rightBar;

@property (nonatomic, retain) UILabel *titleLab;

@property (nonatomic, retain) UILabel *line;
//  左侧点击
- (void)back:(UIButton *)sender ;
//  右侧点击
- (void)more:(UIButton *)sender ;
//  重写父类方法
- (void)resetFather;

@end
