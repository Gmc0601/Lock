//
//  ConnectionAlter.h
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionAlter : UIView<CAAnimationDelegate>{
    int time;
}

@property (nonatomic, retain) UIView *whitView,*moreView;

@property (nonatomic, retain) UIButton *closebtn;

@property (nonatomic,retain) UILabel *infolab;

@property (nonatomic, retain) UIImageView *logoImage;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic)BOOL lock;

- (instancetype)initWithFrame:(CGRect)frame lock:(BOOL)lock;

- (void)pop;

- (void)dismiss;

@end
