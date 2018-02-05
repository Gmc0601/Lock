//
//  FeailView.h
//  BaseProject
//
//  Created by cc on 2018/1/12.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeailView : UIView

@property (nonatomic, retain) UIView *backView, *whitView;

@property (nonatomic, retain) UILabel *titleLab;

@property (nonatomic, retain) UITextView *content;

@property (nonatomic, retain) UIButton *clickBtn;

- (void)pop;

- (void)dismiss;

@end
