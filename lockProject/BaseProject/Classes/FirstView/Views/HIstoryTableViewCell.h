//
//  HIstoryTableViewCell.h
//  BaseProject
//
//  Created by cc on 2018/1/4.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LockHistory.h"

@interface HIstoryTableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *logo;

@property (nonatomic, retain) UILabel *timeLab, *contentLab, *line;

@property (nonatomic,retain) LockHistory *model;

@property (nonatomic, copy) void (^nameBlock)(NSString * , NSString *);

@end
