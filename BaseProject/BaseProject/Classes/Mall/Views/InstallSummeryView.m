//
//  InstallSummeryView.m
//  BaseProject
//
//  Created by LeoGeng on 16/12/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "InstallSummeryView.h"
#import "InstallCell.h"
#import <Masonry/Masonry.h>

@interface InstallSummeryView()<UITableViewDataSource>
@property(retain,atomic) UITableView *tb;
@property(retain,atomic)  UIButton *btnUnRequire;
@property(retain,atomic)  UIButton *btnRequire;
@property(retain,atomic)  UILabel *lblTips;
@property(retain,atomic)  UIView *blueBorder;
@property(assign,atomic)  BOOL showRequire;
@property(retain,atomic)  NSArray *datasource;
@property(retain,atomic)  UILabel *lblNoInstall;
@end

@implementation InstallSummeryView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubViews];
    }
    return self;
}

-(void) addSubViews{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCBOLD(SizeWidth(15));
    lblTitle.textColor = RGBColor(51,51,51);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"安装区域说明";
    [self addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(SizeHeight(23));
        make.width.equalTo(self);
        make.height.equalTo(@(SizeHeight(17)));
    }];
    
    _btnUnRequire = [[UIButton alloc]init];
    [_btnUnRequire setTitle:@"自行安装区域" forState:UIControlStateNormal];
    [_btnUnRequire setTitleColor:RGBColor(100,141,221) forState:UIControlStateNormal] ;
    _btnUnRequire.titleLabel.font = PingFangSCBOLD(13);
    _btnUnRequire.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnUnRequire addTarget:self action:@selector(tapUnRequire) forControlEvents:UIControlEventTouchUpInside];
    [_btnUnRequire setSelected:YES];
    [self addSubview:_btnUnRequire];
    
    [_btnUnRequire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SizeWidth(94/2));
        make.top.equalTo(self).offset(SizeHeight(120/2));
        make.height.equalTo(@(SizeHeight(50)));
        make.width.equalTo(@(SizeWidth(100)));
    }];
    
    _btnRequire = [[UIButton alloc]init];
    [_btnRequire setTitle:@"商家安装区域" forState:UIControlStateNormal];
    [_btnRequire setTitleColor:RGBColor(153,153,153) forState:UIControlStateNormal] ;
    _btnRequire.titleLabel.font = PingFangSCBOLD(13);
    _btnRequire.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnRequire addTarget:self action:@selector(tapRequire) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnRequire];
    
    [_btnRequire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_btnUnRequire);
        make.right.equalTo(self).offset(-SizeWidth(94/2));
        make.height.equalTo(_btnUnRequire);
        make.width.equalTo(_btnUnRequire);
    }];
    
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = RGBColor(153,153,153);
    [self addSubview:border];
    
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SizeWidth(57/2));
        make.right.equalTo(self.mas_right).offset(-SizeWidth(57/2));
        make.bottom.equalTo(self).offset(SizeHeight(213/2));
        make.height.equalTo(@1);
    }];
    
    _blueBorder = [[UIView alloc] init];
    _blueBorder.backgroundColor = RGBColor(100,141,221);
    [self addSubview:_blueBorder];
    _blueBorder.frame = CGRectMake(0, 0, SizeWidth(228/2), SizeHeight(1.5));
    _blueBorder.center = CGPointMake(SizeWidth(228/4 + 40), SizeHeight(213/2));
    
    _lblTips = [UILabel new];
    _lblTips.font = PingFangSCMedium(SizeWidth(13));
    _lblTips.textColor = RGBColor(153,153,153);
    _lblTips.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_lblTips];
    
    [_lblTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(_blueBorder).offset(SizeHeight(20));
        make.width.equalTo(self);
        make.height.equalTo(@(SizeHeight(15)));
    }];
    
    _tb = [[UITableView alloc] init];
    [_tb registerClass:[InstallCell class] forCellReuseIdentifier:@"cell"];
    _tb.dataSource = self;
    _tb.hidden = YES;
    _tb.rowHeight = SizeHeight(70);
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tb];
    
    [_tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SizeWidth(70/2));
        make.right.equalTo(self).offset(-SizeWidth(70/2));
        make.top.equalTo(_blueBorder).offset(SizeHeight(20));
        make.bottom.equalTo(self);
    }];
    
    _lblNoInstall = [UILabel new];
    _lblNoInstall.font = PingFangSCMedium(SizeWidth(12));
    _lblNoInstall.textColor = RGBColor(204,204,204);
    _lblNoInstall.textAlignment = NSTextAlignmentCenter;
    _lblNoInstall.text = @"暂无安装区域";
    _lblNoInstall.hidden = YES;
    [self addSubview:_lblNoInstall];
    
    [_lblNoInstall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(self).offset(SizeHeight(530/2));
        make.width.equalTo(self);
        make.height.equalTo(@(SizeHeight(15)));
    }];
}

-(void) tapUnRequire{
    _showRequire = NO;
    [_btnUnRequire setTitleColor:RGBColor(100,141,221) forState:UIControlStateNormal] ;
    [_btnRequire setTitleColor:RGBColor(153,153,153) forState:UIControlStateNormal];
    [self addConstraintsForHightlight:_btnUnRequire];
    [self loadData];
}

-(void) tapRequire{
    _showRequire = YES;
    [_btnRequire setTitleColor:RGBColor(100,141,221) forState:UIControlStateNormal] ;
    [_btnUnRequire setTitleColor:RGBColor(153,153,153) forState:UIControlStateNormal];
    [self addConstraintsForHightlight:_btnRequire];
    [self loadData];
}

-(void) loadData{
    _datasource = _showRequire ? self.require:self.unRequire;
    if(_showRequire){
        if (_require == nil || _require.count == 0) {
            _tb.hidden = YES;
            _lblNoInstall.hidden = NO;
            return;
        }else{
            _tb.hidden = NO;
            _lblNoInstall.hidden = YES;
        }
    }else{
        if (_unRequire == nil || _unRequire.count == 0) {
            _tb.hidden = YES;
            _lblNoInstall.hidden = NO;
            return;
        }else{
            _tb.hidden = NO;
            _lblNoInstall.hidden = YES;
        }
    }
    
    [_tb reloadData];
}


-(void) addConstraintsForHightlight:(UIView *) center{
    _blueBorder.center = CGPointMake(center.center.x, SizeHeight(213/2));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasource.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InstallCell *cell = (InstallCell *) [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.value = _datasource[indexPath.row];
    
    return  cell;
}


@end
