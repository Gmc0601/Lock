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


- (void)setModel:(LockHistory *)model {
    CGSize titleSize = [model.content sizeWithFont:[UIFont systemFontOfSize:20.0f] constrainedToSize:CGSizeMake(kScreenW - self.logo.frame.size.width, 200)];
    self.contentLab.text = model.content;
    self.timeLab.text = model.time;
    self.contentLab.frame = CGRectMake(self.logo.right + 5, self.timeLab.bottom + 5, titleSize.width, titleSize.height);
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
        _contentLab = [[UILabel alloc] initWithFrame:FRAME(self.logo.right + 5, self.timeLab.bottom + 5, 100, 30)];
        _contentLab.backgroundColor = UIColorFromHex(0xF1F2F2);
        _contentLab.layer.masksToBounds = YES;
        _contentLab.layer.cornerRadius = 5;
        _contentLab.numberOfLines = 0;
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = UIColorFromHex(0x999999);
    }
    return _contentLab;
}


@end
