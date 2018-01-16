//
//  MeViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MeViewController.h"
#import "MeHeadView.h"
#import "MyFavoritesViewController.h"
#import "DeviceCommandViewController.h"
#import "UserInfoViewController.h"
#import "MyOrderViewController.h"
#import "LoginViewController.h"
#import "TBNavigationController.h"
#import "OrderModel.h"

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSString *phone;
}

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSArray *titleArr;
@property (nonatomic, retain) MeHeadView *head;
@property (nonatomic, retain) UILabel *phoneLab;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, 100)];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    
    [self.view addSubview:self.noUseTableView];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.noUseTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.noUseTableView.scrollIndicatorInsets = self.noUseTableView.contentInset;
    

    
}


-(void)viewWillAppear:(BOOL)animated {
    if (![ConfigModel getBoolObjectforKey:IsLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.homeBlocl = ^{
            self.tabBarController.selectedIndex = 0;
        };
        TBNavigationController *na = [[TBNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:na animated:YES completion:nil];
        return;
    }
    [self getData];
}

- (void)getData {
    WeakSelf(weak);
    [HttpRequest postPath:@"Users/userInfo" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSDictionary *data = datadic[@"data"];
            if (IsNULL(data)) {
                return ;
            }
            NSString *phone = data[@"phone"];
            
            
            
            NSString *nick_name = [NSString stringWithFormat:@"%@",data[@"nick_name"]];
            NSString *head_imgurl = data[@"head_imgurl"];
            NSString *user_token = data[@"user_token"];
            [ConfigModel saveBoolObject:YES forKey:IsLogin];
            [ConfigModel saveString:user_token forKey:UserToken];
            [ConfigModel saveString:phone forKey:User_phone];
            [ConfigModel saveString:nick_name forKey:User_nickname];
            [ConfigModel saveString:head_imgurl forKey:User_headimage];
            if ([data[@"status"] intValue] == 0) {
                [ConfigModel saveBoolObject:YES forKey:User_State];
            }else {
                [ConfigModel saveBoolObject:NO forKey:User_State];
            }
            [weak.noUseTableView reloadData];
            [self.head update];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    [HttpRequest postPath:@"Public/kefudianhua" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSString *data = datadic[@"data"];
            phone = data;
            
            [weak.noUseTableView reloadData];
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}

- (void)resetFather {
    self.navigationController.navigationBar.hidden = YES;
    self.navigationView.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    UIImageView *logo;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        if (indexPath.row == 2) {
            logo = [[UIImageView alloc] initWithFrame:FRAME(kScreenW - 35, SizeHeight(12), 20, 20)];
            logo.backgroundColor = [UIColor clearColor];
            logo.image = [UIImage imageNamed:@"wd_icon_dh"];
            [cell.contentView addSubview:logo];
            [cell.contentView addSubview:self.phoneLab];
        }
    }
    self.phoneLab.text = phone;
    cell.textLabel.text = self.titleArr[indexPath.row];
    if (indexPath.row < 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(55);
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[MyFavoritesViewController new] animated:YES];
    }
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[DeviceCommandViewController new] animated:YES];
    }
    if (indexPath.row == 2) {
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
         NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(325))];
            MeHeadView *head = [[MeHeadView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(315))];
            WeakSelf(weak);
            head.messageBlock = ^{
            //  消息点击
                UnloginReturn
                JumpHistory
            };
            
            head.headImgBlock = ^{
              // 头像点击
                
                [weak.navigationController pushViewController:[UserInfoViewController new] animated:YES];
            };
            
            head.orderBlock = ^(int num) {
                NSString *status  = nil;
              //  订单 点击 num 0 - 3
                if (num == 0) {
                    status = @"0";
                }else if(num == 1){
                    status = @"1";
                }else if(num==2){
                    status = @"2";
                }
                MyOrderViewController *newVC = [MyOrderViewController new];
                newVC.status = status;
                [self.navigationController pushViewController:newVC animated:YES];
                
            };
            self.head = head;
            [view addSubview:head];
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

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"我的收藏", @"设备管理", @"联系客服"];
    }
    return _titleArr;
}

- (UILabel *)phoneLab {
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2, SizeHeight(12), kScreenW/2 - 40, 20)];
        _phoneLab.font = [UIFont systemFontOfSize:13];
        _phoneLab.textColor = UIColorFromHex(0x666666);
        _phoneLab.textAlignment = NSTextAlignmentRight;
    }
    return _phoneLab;
}


@end
