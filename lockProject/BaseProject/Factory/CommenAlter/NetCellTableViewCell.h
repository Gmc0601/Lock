//
//  NetCellTableViewCell.h
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetAlter.h"

@interface NetCellTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLab;

@property (nonatomic, retain) UIImageView *logoImage;

@property (nonatomic, retain) UILabel *line;

@property (nonatomic, retain) NetModel *model;

@end
