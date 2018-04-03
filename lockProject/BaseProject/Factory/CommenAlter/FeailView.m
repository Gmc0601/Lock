//
//  FeailView.m
//  BaseProject
//
//  Created by cc on 2018/1/12.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "FeailView.h"
#import <YYKit.h>

@implementation FeailView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self ==[super initWithFrame:frame]) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.whitView];
        [self.whitView addSubview:self.titleLab];
        [self.whitView addSubview:self.content];
        [self.whitView addSubview:self.clickBtn];
        [HttpRequest postPath:@"Public/lianjieshibai" params:nil resultBlock:^(id responseObject, NSError *error) {
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"success"] intValue] == 1) {
                
                NSString  *data = datadic[@"data"];
                
                
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[data dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                self.content.attributedText = attributedString;
                
//                self.content.text = data;
                
            }else {
                NSString *str = datadic[@"msg"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
        
    }
    return self;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
        _backView.backgroundColor = RGBColorAlpha(0, 0, 0, 0.7);
    }
    return _backView;
}


- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(0, 15, self.whitView.width, 15)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"网关匹配失败原因";
        _titleLab.font = [UIFont systemFontOfSize:14];
        
    }
    return _titleLab;
}


- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] initWithFrame:FRAME(5, self.titleLab.bottom + 10, self.whitView.width - 10, 150)];
        _content.textColor = UIColorFromHex(0x999999);
        _content.text = @"啊时的发生的发生的发啊 打打对方大师傅asd按时安达市啊发";
        _content.font = [UIFont systemFontOfSize:14];
        _content.userInteractionEnabled = NO;
    }
    return _content;
}


- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [[UIButton alloc] initWithFrame:FRAME(0, SizeHeight(250), self.whitView.width, SizeHeight(30))];
        [_clickBtn setTitle:@"重新匹配" forState:UIControlStateNormal];
        [_clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clickBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _clickBtn;
}

- (UIView *)whitView{
    if (!_whitView) {
        _whitView = [[UIView alloc] initWithFrame:CGRectMake(SizeWidth(20), kScreenH /2 - SizeHeight(150), kScreenW - SizeWidth(40), SizeHeight(300))];
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
