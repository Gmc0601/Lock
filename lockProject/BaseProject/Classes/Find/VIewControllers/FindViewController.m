//
//  FindViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FindViewController.h"
#import "FindCellTableViewCell.h"
#import "FindDetailViewController.h"
#import "FindModel.h"
#import "NODataView.h"
#import "TBRefresh.h"

@interface FindViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int backNum, page;
}

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, retain) NSMutableArray *dataArr;

@property (nonatomic, retain) NODataView *nodataView;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    backNum = 0;
    page = 0;
    [self resetFather];
    [self createdate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setbadgeLab) name:HaveMessage object:nil];
}
- (void)setbadgeLab {
    [self.rightBar setBadge];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![ConfigModel getBoolObjectforKey:HaveMessage]) {
        [self.rightBar hideBadge];
    }
}

- (void)createdate {

    NSLog(@"....%d", page);
    WeakSelf(weak);
    NSDictionary *dic = @{
                          @"page" : @(page)
                          };
    
    [FindModel findListWithdic:dic CallBack:^(NSString *error, NSArray *findArr) {
        [self.noUseTableView.header endHeadRefresh];
        [self.noUseTableView.footer endFooterRefreshing];
        if (!error) {
            
            backNum = findArr.count;
            [self.dataArr addObjectsFromArray:findArr];
            if (IsNULL(findArr)) {
                [weak.view addSubview:self.nodataView];
            }else {
                [weak.view addSubview:self.noUseTableView];
                [weak.noUseTableView reloadData];
            }
        }
    }];
    
    
}

- (void)resetFather {
    /*
     http://116.62.142.20/Info/detail/id/4 
     */
    self.titleLab.text = @"发现";
    [self.rightBar setTitle:@"" forState:UIControlStateNormal];
    [self.rightBar setImage:[UIImage imageNamed:@"nav_icon_xx"] forState:UIControlStateNormal];
}

- (void)more:(UIButton *)sender {
    UnloginReturn
    JumpHistory
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%lu", (long)indexPath.row];
    
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
    if (self.dataArr.count == 0) {
        return 0;
    }
    FindModel *find = [FindModel new];
    find = self.dataArr[indexPath.row];
    
    if ([find.type intValue] == 1 ) {
        return SizeHeight(304);
    }else {
        return SizeHeight(129);
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindModel *find = [[FindModel alloc] init];
    find = self.dataArr[indexPath.row];
    FindDetailViewController * detial = [[FindDetailViewController alloc] init];
    NSString *str ;
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        str = [NSString stringWithFormat:@"http://116.62.142.20/Info/detail/id/%@/user_token/%@", find.info_id, [ConfigModel getStringforKey:UserToken]];
    }else {
        str = [NSString stringWithFormat:@"http://116.62.142.20/Info/detail/id/%@", find.info_id];
    }
    
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
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WeakSelf(weak);
        [_noUseTableView addRefreshHeaderWithBlock:^{
            [weak.dataArr removeAllObjects];
            page = 0; backNum = 0;
            [weak.noUseTableView.footer ResetNomoreData];
            [weak createdate];
        }];
        
        [_noUseTableView addRefreshFootWithBlock:^{
            if (backNum == 10) {
                page += 1;
                [weak createdate];
                
            }else {
                [weak.noUseTableView.footer NoMoreData];
            }
        }];
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
}

- (NSMutableArray *)dataArr {
    if (!_dataArr ) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
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
