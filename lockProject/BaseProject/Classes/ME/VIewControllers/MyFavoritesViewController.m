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
#import "FindModel.h"
#import <MJExtension.h>
#import "NODataView.h"
@interface MyFavoritesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, retain) NODataView *nodataView;

@end

@implementation MyFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self createDate];
}

- (void)createDate {
    [HttpRequest postPath:@"Users/getCollectList" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSArray *data = datadic[@"data"];
            
            if (IsNULL(data)) {
                [self.view addSubview:self.nodataView];
            }else {
                [self.view addSubview:self.noUseTableView];
                self.dataArr = [FindModel mj_objectArrayWithKeyValuesArray:data];
            }
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)resetFather {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"我的收藏";
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%lu", indexPath.row];
    
    FindCellTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FindCellTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        FindModel *find = [FindModel new];
        find = self.dataArr[indexPath.row];
        
        if ([find.type intValue] == 1 ) {
            [cell videoType];
        }
        [cell update:find];
    }
    
    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return SizeHeight(304);
    FindModel *find = [FindModel new];
    find = self.dataArr[indexPath.row];
    if (self.dataArr.count == 0) {
        return 0;
    }
    if ([find.type intValue] == 1 ) {
        return SizeHeight(304);
    }else {
        return SizeHeight(129);
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FindModel *find = [[FindModel alloc] init];
    find = self.dataArr[indexPath.row];
    FindDetailViewController * detial = [[FindDetailViewController alloc] init];
    NSString *str = [NSString stringWithFormat:@"http://116.62.142.20/Info/detail/id/%@", find.info_id];
    detial.urlStr = str;
    /*
     http://116.62.142.20/Info/detail/id/4
     */
    [self.navigationController pushViewController:detial animated:YES];
    
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

- (NODataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[NODataView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(65), kScreenH/2, SizeWidth(130), SizeHeight(110)) withimage:@"icon_qx" andtitle:@"暂无内容"];
        _nodataView.clickBlock = ^{
        };
    }
    return _nodataView;
}

@end
