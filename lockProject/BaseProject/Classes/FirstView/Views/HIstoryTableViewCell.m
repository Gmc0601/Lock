//
//  HIstoryTableViewCell.m
//  BaseProject
//
//  Created by cc on 2018/1/4.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "HIstoryTableViewCell.h"
#import <YYKit.h>
#import <Masonry.h>
#import "PCBClickLabel.h"
#import "UILabel+Width.h"

@implementation HIstoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.logo];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}


- (void)update {
    
    
    LockHistory *model = [[LockHistory alloc] init];
    model = self.model;
    NSString *str = [NSString stringWithFormat:@"  %@%@", model.user, model.content];
    UILabel *lab = [[UILabel alloc] init];
    float width = kScreenW - self.logo.frame.size.width - SizeWidth(30);
    CGFloat labwidth = [UILabel getWidthWithTitle:str font:[UIFont systemFontOfSize:14]];
    
    CGFloat labheight;
    if (labwidth > width) {
        labwidth = width;
        labheight = [UILabel getHeightByWidth:width title:str font:[UIFont systemFontOfSize:14]] ;
    }else {
        labheight = SizeHeight(20);
    }
    self.contentLab.size = CGSizeMake(labwidth, labheight);
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, model.user.length + 2)];
    [self.contentLab setAttributedText:noteStr];
    
    UILabel *clickLabel = [[UILabel alloc] initWithFrame:FRAME(self.logo.right + 8, self.timeLab.bottom + SizeHeight(12), [UILabel getWidthWithTitle:model.user font:[UIFont systemFontOfSize:14]], SizeHeight(13))];
    clickLabel.backgroundColor = [UIColor clearColor];
    clickLabel.font = [UIFont systemFontOfSize:14];
    clickLabel.textColor = MainBlue;
    clickLabel.text = model.user;
    
    UILabel *line = [[UILabel alloc] initWithFrame:FRAME(self.logo.right + 8, self.timeLab.bottom + SizeHeight(25), [UILabel getWidthWithTitle:model.user font:[UIFont systemFontOfSize:14]], 1)];
    line.backgroundColor = MainBlue;
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:clickLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:clickLabel.frame];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(labClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
    self.timeLab.text = model.time;
    
}


- (void)labClick {
    NSLog(@"//////dianjia");
    if (self.nameBlock) {
        self.nameBlock(self.model.unlock_user_id,  self.model.user);
    }
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(45), 0, 1, SizeHeight(95))];
        _line.backgroundColor = UIColorFromHex(0xF1F2F2);
    }
    return _line;
}

- (UIImageView *)logo {
    if (!_logo) {
        UIImage *image = [UIImage imageNamed:@"ksjl_icon_zc"];
        _logo = [[UIImageView alloc] init];
        _logo.backgroundColor = [UIColor clearColor];
        _logo.image = image;
        _logo.size = image.size;
        _logo.centerX = self.line.centerX;
        _logo.centerY = self.contentView.centerY + SizeHeight(27);
    }
    return _logo;
}


- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:FRAME(self.logo.right + 5, 5, kScreenW/2, SizeHeight(15))];
        _timeLab.textColor = UIColorFromHex(0x999999);
        _timeLab.font = [UIFont systemFontOfSize:14];
    }
    return _timeLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:FRAME(self.logo.right + 5, self.timeLab.bottom + SizeHeight(10), 100, 30)];
        _contentLab.backgroundColor = UIColorFromHex(0xF1F2F2);
        _contentLab.layer.masksToBounds = YES;
        _contentLab.layer.cornerRadius = SizeHeight(5);
        _contentLab.numberOfLines = 0;
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = UIColorFromHex(0x999999);
    }
    return _contentLab;
}


@end
