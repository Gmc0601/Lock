//
//  NetCellTableViewCell.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "NetCellTableViewCell.h"

@implementation NetCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.logoImage];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)setModel:(NetModel *)model {
    self.titleLab.text = model.name;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(15, 10, kScreenW/2, 15)];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.text = @"ddd";
    }
    return _titleLab;
}

- (UIImageView *)logoImage {
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] initWithFrame:FRAME(kScreenW - 20 - 16 - 20, 10, 16, 16)];
        _logoImage.backgroundColor = [UIColor clearColor];
        _logoImage.image = [UIImage imageNamed:@"icon_xz"];//icon_xz_pre
    }
    return _logoImage;
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:FRAME(10, SizeHeight(55) - 1, kScreenW - 40, 1)];
        _line.backgroundColor = RGBColor(239, 240, 241);
    }
    return _line;
}


@end
