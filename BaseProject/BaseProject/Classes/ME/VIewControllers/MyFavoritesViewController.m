//
//  MyFavoritesViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MyFavoritesViewController.h"
#import "FindCellTableViewCell.h"
#import "FindDetailViewController.h"
@interface MyFavoritesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;

@end

@implementation MyFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self.view addSubview:self.noUseTableView];
}

- (void)resetFather {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"我的收藏";
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%lu", indexPath.row];
    
    FindCellTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FindCellTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    if (indexPath.row == 3) {
        [cell videoType];
    }
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        return SizeHeight(304);
    }else {
        return SizeHeight(129);
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[FindDetailViewController new] animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64 - SizeHeight(50)) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  0)];
            view;
        });
    }
    return _noUseTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
