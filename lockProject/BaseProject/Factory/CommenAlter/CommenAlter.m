//
//  CommenAlter.m
//  BaseProject
//
//  Created by cc on 2018/1/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CommenAlter.h"
#import <YYKit.h>
#define keyheight 120

@implementation CommenAlter


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr info:(NSString *)infoStr leftBtn:(NSString *)leftStr right:(NSString *)rightStr {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.whitView];
        [self.whitView addSubview:self.titleLab];
        self.titleLab.text = titleStr;
        //监听当键盘将要出现时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //监听当键将要退出时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        if (infoStr) {
            
            if ([infoStr isEqualToString:@"请验证管理员密码"]) {
                self.havePwd = YES;
                self.text = [[UITextField alloc] initWithFrame:FRAME(SizeWidth(10), self.titleLab.bottom + SizeHeight(20), self.whitView.width - SizeWidth(20), SizeHeight(25))];
                self.text.placeholder = @" 请输入管理员密码";
                [self.text becomeFirstResponder];
                self.text.secureTextEntry = YES;
                self.text.textAlignment = NSTextAlignmentCenter;
                self.text.keyboardType = UIKeyboardTypeNumberPad;
                [self.text addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
                [self.whitView addSubview:self.text];
                [self.rightBtn addTarget:self action:@selector(textClick) forControlEvents:UIControlEventTouchUpInside];
            }else {
                self.havePwd = NO;
                [self.whitView addSubview:self.infoLab];
                self.infoLab.text = infoStr;
            }
            
        }
        if (!rightStr) {
            [self.titleLab setTop:SizeHeight(25)];
            self.titleLab.font = [UIFont systemFontOfSize:15];
            [self.leftBtn setCenterX:self.titleLab.centerX];
            self.leftBtn.backgroundColor = MainBlue;
            [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.leftBtn setTitle:leftStr forState:UIControlStateNormal];
            [self.whitView addSubview:self.leftBtn];
        }else {
            [self.leftBtn setTitle:leftStr forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.rightBtn.backgroundColor = MainBlue;
            [self.rightBtn setTitle:rightStr forState:UIControlStateNormal];
            [self.whitView addSubview:self.leftBtn];
            [self.whitView addSubview:self.rightBtn];
        }
    }
    return self;
}
//   监听键盘输入变化 
- (void)textchange {
    if (self.text.text.length > 12) {
        NSString *str3 = [self.text.text substringToIndex:12];
        self.text.text = str3;
        [ConfigModel mbProgressHUD:@"请输入6-12位数字" andView:nil];
    }
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    [self.whitView setTop:kScreenH /2 - SizeHeight(175/2) - keyheight];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    [self.whitView setTop:kScreenH /2 - SizeHeight(175/2) ];
}

- (void)textClick {
    if (self.text.text.length < 6) {
        [ConfigModel mbProgressHUD:@"请输入6-12位数字" andView:nil];
        return;
    }
    
    [self dismiss];
    if (self.textBlock) {
        self.textBlock(self.text.text);
    }
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(0, SizeHeight(15), self.whitView.width, 15)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:15];
        
    }
    return _titleLab;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] initWithFrame:FRAME(0, self.titleLab.bottom + 10, self.whitView.width, 15)];
        _infoLab.font = [UIFont systemFontOfSize:13];
        _infoLab.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLab;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:FRAME(10, self.whitView.frame.size.height - SizeHeight(59), SizeWidth(150), SizeHeight(44))];
        _leftBtn.backgroundColor =UIColorFromHex(0xf1f2f2);
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.cornerRadius = 5;
    }
    return _leftBtn;
}

- (void)leftClick {
    [self dismiss];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:FRAME(self.whitView.width - SizeWidth(170), self.whitView.frame.size.height - SizeHeight(59), SizeWidth(150), SizeHeight(44))];
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
