//
//  LockhistoryViewController.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "LockhistoryViewController.h"
#import "NODataView.h"
#import "LockHistory.h"
#import <YYKit.h>
#import "HIstoryTableViewCell.h"
#import "CommenAlter.h"

@implementation HistoryModel

@end

@interface LockhistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NODataView *nodataView;

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, retain) NSArray *dataArr, *timeArr;

@end

@implementation LockhistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self createView];
}

- (void)createView {
    NSDictionary *dic;
    if (self.lock_id) {
        dic = @{
                @"lock_id" : self.lock_id
                };
        
    }else {
        dic = nil;
    }
    
    [LockHistory getlockHistory:dic CallBack:^(NSString *error, NSArray *findArr, NSArray *dateArr) {
        if (!error) {
            self.dataArr = findArr;
            self.timeArr = dateArr;
            [self.view addSubview:self.noUseTableView];
            [self.noUseTableView reloadData];
        }else {
            [self.view addSubview:self.nodataView];
        }
    }];
    
    
    
}

- (void)resetFather {
    self.titleLab.text = @"开锁记录";
    [self.rightBar setTitle:@"清空" forState:UIControlStateNormal];
}

- (void)more:(UIButton *)sender {
    
    CommenAlter *finsh = [[CommenAlter alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH) title:@"是否清空开锁记录" info:nil leftBtn:@"取消" right:@"确定"];
    
    finsh.leftBlock = ^{
        [finsh dismiss];
    };
    
    finsh.rightBlock = ^{
        //  跳转匹配锁
        [self del];
    };
    [finsh pop];
}

- (void)del {
    NSDictionary *dic;
    if (self.lock_id) {
        dic = @{
                @"lock_id" : self.lock_id
                };
        
    }else {
        dic = nil;
    }
    
    [HttpRequest postPath:@"Lock/clearLog" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            [self.noUseTableView removeFromSuperview];
            [self.view addSubview:self.nodataView];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NODataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[NODataView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(65), kScreenH/2, SizeWidth(130), SizeHeight(110)) withimage:@"icon_qx" andtitle:@"暂无记录"];
        _nodataView.clickBlock = ^{
        };
    }
    return _nodataView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.timeArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId = [NSString stringWithFormat:@"%lu%lu", indexPath.section, indexPath.row];
    
    HIstoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HIstoryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    LockHistory *model = self.dataArr[indexPath.section][indexPath.row];
    cell.model = model;
    
    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(95);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SizeHeight(45);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(45))];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *dateLab = [[UILabel alloc] initWithFrame:FRAME(15, 9, kScreenW - 30, SizeHeight(20))];
    dateLab.font = [UIFont boldSystemFontOfSize:14];
    dateLab.text = self.timeArr[section];
    [headerView addSubview:dateLab];
    return headerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStyleGrouped];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
    }
    return _noUseTableView;
}



@end
