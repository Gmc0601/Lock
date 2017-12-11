//
//  FindCellTableViewCell.h
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Find_Noraml,
    Find_Video,
} FindCellType;

@interface FindCellTableViewCell : UITableViewCell

@property (nonatomic, assign) FindCellType type;

@property (nonatomic, retain) UIView *backView;

@property (nonatomic, retain) UILabel *titlLab, *timeLab, *commenLab;

@property (nonatomic, retain) UIImageView *logoImg, *smalLogo;

- (void)videoType;

@end
