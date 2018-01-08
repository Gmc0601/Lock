//
//  NetAlter.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "NetAlter.h"
#import <Masonry.h>
#import "NetCellTableViewCell.h"

#define tableViewHeight [UIScreen mainScreen].bounds.size.height - 80 -100

@implementation NetModel
@end

@interface NetAlter () <UITableViewDataSource, UITableViewDelegate>
//背景
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;
//标题
@property (nonatomic, strong) UILabel *title;
//子标题
@property (nonatomic, strong) UILabel *subTitle;
//线条
@property (nonatomic, strong) UILabel *line;
//关闭按钮
@property (nonatomic, strong) UIButton *closeButton, *leftBtn, *rightBtn;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSIndexPath *indexpath;

@end

@implementation NetAlter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化各种控件
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_backgroundView];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5;
        [self addSubview:_contentView];
        
        _title = [[UILabel alloc] init];
        _title.font = [UIFont boldSystemFontOfSize:13];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        _title.text = @"请选择门锁所关联的门锁";
        [self.contentView addSubview:_title];
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.font = [UIFont systemFontOfSize:13];
        _subTitle.textColor = [UIColor grayColor];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        _subTitle.hidden =YES;
        [self.contentView addSubview:_subTitle];
        
        _line = [[UILabel alloc] init];
        _line.backgroundColor = RGBColor(239, 240, 241);

        [self.contentView addSubview:_line];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.hidden = YES;
        [self.contentView addSubview:_closeButton];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightBtn];
        
        //添加布局约束
        [self initUI];
    }
    return self;
}

- (void)rightClick {
    if (self.rightBlock) {
        self.rightBlock(self.indexpath);
        [self dismiss];
    }
}

- (void)initUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(100);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(tableViewHeight);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(20);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(20);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(@1);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-55);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(@(140));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right);
        make.width.mas_equalTo(@(140));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark pop和dismiss

- (void)pop {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    //动画效果入场
    self.contentView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.contentView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.contentView.alpha = 1;
    }];
}

- (void)dismiss {
    //动画效果出场
    [UIView animateWithDuration:.35 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.contentView]) {
        [self dismiss];
    }
}

#pragma mark tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"%ld", indexPath.row];
    NetCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[NetCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SizeHeight(55);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexpath = indexPath;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
         NetCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath: index];
        if (indexPath.row == index.row) {
            cell.logoImage.image = [UIImage imageNamed:@"icon_xz_pre"];
        }else {
            cell.logoImage.image = [UIImage imageNamed:@"icon_xz"];
        }
       

    }
}


@end
