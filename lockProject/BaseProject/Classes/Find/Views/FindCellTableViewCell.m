//
//  FindCellTableViewCell.m
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FindCellTableViewCell.h"
#import <YYKit.h>
#import <UIImageView+WebCache.h>

@implementation FindCellTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.logoImg];
    [self.backView addSubview:self.titlLab];
    [self.backView addSubview:self.timeLab];
    [self.backView addSubview:self.commenLab];
}

- (void)update:(FindModel *)model {
    
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
    self.titlLab.text = model.title;
    self.timeLab.text = model.info_date;
    NSString *count = [NSString stringWithFormat:@"%@评论", model.comment_count];
    self.commenLab.text = count;
    
}

- (void)videoType {
    self.backView.frame = FRAME(SizeWidth(15), SizeHeight(15), kScreenW - SizeWidth(30), SizeHeight(289));
    self.logoImg.frame = FRAME(0, 0, kScreenW - SizeWidth(30), SizeHeight(200));
    [self.logoImg addSubview:self.smalLogo];
    self.titlLab.frame = FRAME(SizeWidth(15), self.logoImg.bottom + SizeHeight(15), kScreenW - SizeWidth(60), SizeHeight(40));
    self.timeLab.frame = FRAME(SizeWidth(15),self.titlLab.bottom + SizeHeight(10), SizeWidth(100), SizeHeight(15));
    self.commenLab.frame = FRAME(self.timeLab.right + SizeWidth(15), self.titlLab.bottom + SizeHeight(10), SizeWidth(80), SizeHeight(15));
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeight(15), kScreenW - SizeWidth(30), SizeHeight(114))];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.borderWidth = 1;
        _backView.layer.borderColor = [UIColorFromHex(0xe0e0e0) CGColor];
    }
    return _backView;
}

- (UIImageView *)logoImg {
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc] initWithFrame:FRAME(0, 0, SizeHeight(114), SizeHeight(114))];
        _logoImg.backgroundColor = [UIColor clearColor];
        _logoImg.image = [UIImage imageNamed:@""];
    }
    return _logoImg;
}

- (UILabel *)titlLab {
    if (!_titlLab) {
        _titlLab = [[UILabel alloc] initWithFrame:FRAME(self.logoImg.right + SizeWidth(15), SizeHeight(25), SizeWidth(190), SizeHeight(40))];
        _titlLab.font = ArialFont(SizeHeight(13));
        _titlLab.numberOfLines = 2;
        _titlLab.text = @"adsfasdfasdfasdfasd4654654654654654654";
    }
    return _titlLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:FRAME(self.logoImg.right+ SizeWidth(15), self.titlLab.bottom + SizeHeight(10), SizeWidth(100), SizeHeight(15))];
        _timeLab.text = @"3分钟前";
        _timeLab.font = ArialFont(12);
        _timeLab.textColor = UIColorFromHex(0xe0e0e0);
    }
    return _timeLab;
}

- (UILabel *)commenLab {
    if (!_commenLab) {
        _commenLab = [[UILabel alloc] initWithFrame:FRAME(self.timeLab.right + SizeWidth(15), self.titlLab.bottom + SizeHeight(10), SizeWidth(80), SizeHeight(15))];
        _commenLab.textColor = UIColorFromHex(0xe0e0e0);
        _commenLab.text = @"100评论";
        _commenLab.font = ArialFont(12);
    }
    return _commenLab;
}

- (UIImageView *)smalLogo {
    if (!_smalLogo) {
        _smalLogo = [[UIImageView alloc] initWithFrame:FRAME(SizeWidth(150), SizeHeight(84), SizeWidth(30), SizeWidth(30))];
        _smalLogo.backgroundColor = [UIColor clearColor];
        _smalLogo.image = [UIImage imageNamed:@"zx_icon_ztbf"];
    }
    return _smalLogo;
}

@end
