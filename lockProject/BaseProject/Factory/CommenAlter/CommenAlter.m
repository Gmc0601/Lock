//
//  CommenAlter.m
//  BaseProject
//
//  Created by cc on 2018/1/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CommenAlter.h"
#import <YYKit.h>

@implementation CommenAlter


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr info:(NSString *)infoStr leftBtn:(NSString *)leftStr right:(NSString *)rightStr {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.whitView];
        [self.whitView addSubview:self.titleLab];
        self.titleLab.text = titleStr;
        if (infoStr) {
            [self.whitView addSubview:self.infoLab];
            self.infoLab.text = infoStr;
        }
        if (!rightStr) {
            self.leftBtn.centerX = self.whitView.centerX;
            [self.leftBtn setTitle:leftStr forState:UIControlStateNormal];
            [self.whitView addSubview:self.leftBtn];
        }else {
            [self.leftBtn setTitle:leftStr forState:UIControlStateNormal];
            [self.rightBtn setTitle:rightStr forState:UIControlStateNormal];
            [self.whitView addSubview:self.leftBtn];
            [self.whitView addSubview:self.rightBtn];
        }
    }
    return self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(0, 15, self.whitView.width, 15)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:14];
        
    }
    return _titleLab;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] initWithFrame:FRAME(0, self.titleLab.bottom + 10, self.whitView.width, 15)];
        _infoLab.font = [UIFont systemFontOfSize:14];
        _infoLab.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLab;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:FRAME(10, self.infoLab.bottom + 30, SizeWidth(150), SizeHeight(44))];
        _leftBtn.backgroundColor =UIColorFromHex(0xf1f2f2);
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.cornerRadius = 5;
    }
    return _leftBtn;
}

- (void)leftClick {
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:FRAME(self.whitView.width - SizeWidth(170), self.infoLab.bottom + 30, SizeWidth(150), SizeHeight(44))];
        _rightBtn.backgroundColor = UIColorFromHex(0x638edc);
        _rightBtn.layer.masksToBounds = YES;
        [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.layer.cornerRadius = 5;
    }
    return _rightBtn;
}

- (void)rightClick {
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
        _backView.backgroundColor = RGBColorAlpha(0, 0, 0, 0.7);
    }
    return _backView;
}


- (UIView *)whitView{
    if (!_whitView) {
        _whitView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW /2 - SizeWidth(170), kScreenH /2 - SizeHeight(175/2), SizeWidth(340), SizeHeight(175))];
        _whitView.backgroundColor = [UIColor whiteColor];
        [_whitView.layer setMasksToBounds: YES];
        [_whitView.layer setCornerRadius:SizeHeight(15)];
    }
    return _whitView;
}

- (void)pop {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.backView.alpha = 1;
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backView.alpha = 1;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


@end
