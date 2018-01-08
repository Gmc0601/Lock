//
//  NODataView.m
//  BaseProject
//
//  Created by cc on 2017/12/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "NODataView.h"
#import <YYKit.h>

@implementation NODataView

- (instancetype)initWithFrame:(CGRect)frame withimage:(NSString *)image andtitle:(NSString *)str {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageview = [[UIImageView alloc] initWithFrame:FRAME((frame.size.width - SizeWidth(55))/2, 0, SizeWidth(55), SizeWidth(55))];
        self.imageview.backgroundColor = [UIColor clearColor];
        self.imageview.image = [UIImage imageNamed:image];
        [self addSubview:self.imageview];
        
        self.titlelab = [[UILabel alloc] initWithFrame:FRAME(0, self.imageview.bottom + SizeHeight(10),frame.size.width, SizeHeight(15))];
        self.titlelab.backgroundColor = [UIColor clearColor];
        self.titlelab.textAlignment = NSTextAlignmentCenter;
        self.titlelab.font = [UIFont systemFontOfSize:13];
        self.titlelab.textColor = UIColorFromHex(0x666666);
        self.titlelab.text = str;
        [self addSubview:self.titlelab];
        
        self.btn = [[UIButton alloc] initWithFrame:FRAME(0, 0, frame.size.width, frame.size.height)];
        self.btn.backgroundColor = [UIColor clearColor];
        [self.btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
    }
    return self;
}


- (void)click:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
