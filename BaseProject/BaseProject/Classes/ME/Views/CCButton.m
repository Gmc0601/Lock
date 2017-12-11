//
//  CCButton.m
//  CarSticker
//
//  Created by cc on 2017/3/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCButton.h"
#define C3  [UIColor colorWithRed:(((0x577dbc & 0xFF0000) >> 16))/255.0 green:(((0x577dbc &0xFF00) >>8))/255.0 blue:((0x577dbc &0xFF))/255.0 alpha:1.0]
@implementation CCButton

- (instancetype)init {
    if (self == [super init]) {
        [self createView];
    }
    return self;
}

- (void)setPic:(NSString *)picName title:(NSString *)title {
    self.pic.image = [UIImage imageNamed:picName];
    self.title.text = title;
}

- (void)createView {
    [self addSubview:self.pic];
    [self addSubview:self.title];
    [self addSubview:self.btn];
}

- (UIImageView *)pic {
    if (!_pic) {
        _pic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 28, 28)];
        _pic.backgroundColor = [UIColor clearColor];
    }
    return _pic;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, 58, 15)];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:13];
        _title.textAlignment = NSTextAlignmentCenter;

    }
    return _title;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
        _btn.backgroundColor = [UIColor clearColor];
        [_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (void)click:(id)sender {
    if (_cliclBlock) {
        _cliclBlock();
    }
}

@end
