//
//  FirstViewController.m
//  BaseProject
//
//  Created by cc on 2017/11/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FirstViewController.h"
#import <UIImage+GIF.h>
#import <YYKit.h>
#import "AddGateWayViewController.h"
#import "AddDeviceViewController.h"
#import "LoginViewController.h"
#import "NODataView.h"
#import "JHCustomMenu.h"
#import "LockModel.h"
#import "CCButton.h"
#import "LrdPasswordAlertView.h"
#import "ConnectionAlter.h"
#import "LockhistoryViewController.h"
#import "MemberViewController.h"
#import "OpenView.h"
#import "JXCircleView.h"
#import "UILabel+Width.h"

@interface FirstViewController ()<JHCustomMenuDelegate, CAAnimationDelegate>{
    int num;
}

@property (nonatomic, retain) NODataView *nodataView;
@property (nonatomic, strong) JHCustomMenu *menu;
@property (nonatomic, retain) UIImageView *logo;
@property (nonatomic, retain) NSArray *dateArr, *nameArr;
@property (nonatomic, retain) UIButton *openBtn;
@property (nonatomic, retain) CCButton *leftBtn, *rightBtn;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIView *moreView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockOpen) name:@"LockOpen" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setbadgeLab) name:HaveMessage object:nil];
}
- (void)setbadgeLab {
    [self.rightBar setBadge];
}

- (void)viewWillAppear:(BOOL)animated {
    if (![ConfigModel getBoolObjectforKey:HaveMessage]) {
        [self.rightBar hideBadge];
    }
    self.leftBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
    [self createDate];
}

- (void)createDate {
    
    
    [HttpRequest getPath:@"something" params:nil resultBlock:^(id responseObject, NSError *error) {
        
    }];
    
//   UnloginReturn
    if (![ConfigModel getBoolObjectforKey:IsLogin]) {
        self.titleLab.text = @"暂无门锁";
        
        [self removeView];
        
        [self.view addSubview:self.nodataView];
        return;
    }
    [LockModel getlockCallBack:^(NSString *error, NSArray *findArr, NSArray *nameArr) {
        if (!error) {
            self.dateArr = findArr;
            self.nameArr = nameArr;
            if (self.dateArr.count == 0) {
                self.titleLab.text = @"暂无门锁";
                [self removeView];
                [self.view addSubview:self.nodataView];
            }else {
                [self.nodataView removeFromSuperview];
                num = 0;
                
                self.titleLab.size = CGSizeMake([self.titleLab getWidthWithTitle:self.nameArr[0] font:[UIFont systemFontOfSize:18]], 30);
                [self.titleLab setLeft:(kScreenW - [self.titleLab getWidthWithTitle:self.nameArr[0] font:[UIFont systemFontOfSize:18]])/2];
                self.titleLab.text = self.nameArr[0];
                [self.logo setLeft:self.titleLab.right + SizeWidth(5)];
                [self.navigationView addSubview:self.logo];
                UIButton *btn = [[UIButton alloc] initWithFrame:self.titleLab.frame];
                btn.backgroundColor = [UIColor clearColor];
                [btn addTarget:self action:@selector(showSchoolList:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:btn];
                [self createView];
            }
        }
    }];

    [HttpRequest postPath:@"Public/kefudianhua" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            NSString *data = datadic[@"data"];
            [ConfigModel saveString:data forKey:@"phone"];
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}

- (void)resetFather {
    self.line.hidden = YES;
    [self.rightBar setTitle:@"" forState:UIControlStateNormal];
    [self.leftBar setImage:[UIImage imageNamed:@"nav_icon_zj"] forState:UIControlStateNormal];
    [self.rightBar setImage:[UIImage imageNamed:@"nav_icon_xx"] forState:UIControlStateNormal];
}

- (void)showSchoolList:(id)barButtonItem
{
    UnloginReturn
    __weak __typeof(self) weakSelf = self;
    if (!self.menu) {
        self.logo.image = [UIImage imageNamed:@"list_ic_2_1"];
        self.menu = [[JHCustomMenu alloc] initWithDataArr:self.nameArr origin:CGPointMake(self.view.frame.size.width/2 - 62, 64) width:125 rowHeight:44];
        _menu.delegate = self;
        _menu.dismiss = ^() {
            weakSelf.menu = nil;
            weakSelf.logo.image = [UIImage imageNamed:@"list_ic_2_0"];
        };
        [self.view addSubview:_menu];
    } else {
        self.logo.image = [UIImage imageNamed:@"list_ic_2_0"];
        [_menu dismissWithCompletion:^(JHCustomMenu *object) {
            weakSelf.menu = nil;
        }];
    }
}

- (void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    num = (int)indexPath.row;
    self.logo.image = [UIImage imageNamed:@"list_ic_2_0"];
    self.titleLab.text = self.nameArr[indexPath.row];
}

- (void)createView {
    [self.view addSubview:self.moreView];
    [self.view addSubview:self.openBtn];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    
}

- (void)removeView {
    [self.moreView removeFromSuperview];
    [self.openBtn removeFromSuperview];
    [self.leftBtn removeFromSuperview];
    [self.rightBtn removeFromSuperview];
}

- (CAAnimationGroup *)addGroupAnimation{
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation1.fromValue = @1;
    animation1.toValue = @7;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @1;
    animation2.toValue = @0;
    
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[animation1,animation2];
    groupAnima.duration = 4;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    groupAnima.repeatCount = 1;
    
    groupAnima.delegate = self;
    return groupAnima;
}
    

- (void)openlock {
    
    __weak typeof(self) weakSelf = self;
    self.openBtn.userInteractionEnabled = NO;
    LrdPasswordAlertView *testView = [[LrdPasswordAlertView alloc] initWithFrame:self.view.bounds];
    LockModel *model = [[LockModel alloc] init];
    model = self.dateArr[num];
    testView.block = ^(NSString *text){
        [ConfigModel saveBoolObject:YES forKey:SelfOpen];
        NSDictionary *dic = @{
                              @"lock_id" : model.lock_id,
                              @"pwd" : text
                              };
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(animationAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [HttpRequest postPath:@"Lock/remoteUnlock" params:dic resultBlock:^(id responseObject, NSError *error) {
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            
            NSDictionary *datadic = responseObject;
            if ([datadic[@"success"] intValue] == 1) {
                
                [self.openBtn setImage:[UIImage imageNamed:@"组7"] forState:UIControlStateNormal];
//                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(animationAction) userInfo:nil repeats:YES];
//                 [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
                
            }else {
                 self.openBtn.userInteractionEnabled = YES;
                NSString *str = datadic[@"msg"];
                [ConfigModel mbProgressHUD:str andView:nil];
                 [self.timer invalidate];
            }
        }];
    };
    [testView pop];
}

- (void)animationAction {
    int i = 0;
    i++;
    if (i == 15) {
        self.openBtn.userInteractionEnabled = YES;
        [self.timer invalidate];
    }
    
    JXCircleView *circleView1 = [[JXCircleView alloc]init];
    circleView1.frame = FRAME(0, 0, self.openBtn.frame.size.width, self.openBtn.frame.size.height);
    circleView1.backgroundColor = [UIColor clearColor];
    
    [circleView1.layer addAnimation:[self addGroupAnimation] forKey:@"groupAnimation2"];
    [self.moreView addSubview:circleView1];
}

- (void)lockOpen {
    [ConfigModel saveBoolObject:NO forKey:SelfOpen];
    self.openBtn.userInteractionEnabled = YES;
    [self.timer invalidate];
    [self.openBtn setImage:[UIImage imageNamed:@"sy_icon_msgb"] forState:UIControlStateNormal];
    OpenView *view = [[OpenView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
    [view pop];
}

- (void)back:(UIButton *)sender {
    UnloginReturn
    [self.navigationController pushViewController:[AddDeviceViewController new] animated:YES];
    
}

- (void)more:(UIButton *)sender {
    UnloginReturn
    JumpHistory
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NODataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[NODataView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(65), kScreenH/2, SizeWidth(130), SizeHeight(110)) withimage:@"椭圆4" andtitle:@"暂无设备 点击添加"];
        WeakSelf(weak);
        _nodataView.clickBlock = ^{
            UnloginReturn
            [weak.navigationController pushViewController:[AddDeviceViewController new] animated:YES];
        };
    }
    return _nodataView;
}

- (UIImageView *)logo {
    if (!_logo) {
        _logo = [[UIImageView alloc] initWithFrame:FRAME(kScreenW/2 + 35, 35, 10, 10)];
        _logo.backgroundColor = [UIColor clearColor];
        _logo.image = [UIImage imageNamed:@"list_ic_2_0"];
    }
    return _logo;
}

- (CCButton *)leftBtn {
    if (!_leftBtn ) {
        _leftBtn = [[CCButton alloc] init];
        _leftBtn.frame = FRAME(SizeWidth(75), self.navigationView.bottom + SizeHeight(20), SizeWidth(63), SizeHeight(90));
        _leftBtn.pic.frame = FRAME(0, 0, SizeWidth(63), SizeWidth(63));
        _leftBtn.title.frame = FRAME(0, _leftBtn.pic.bottom + 3, SizeWidth(63), SizeHeight(13));
        _leftBtn.btn.size = CGSizeMake(_leftBtn.size.width, _leftBtn.size.height);
        _leftBtn.backgroundColor = [UIColor clearColor];
        [_leftBtn setPic:@"sy_icon_ksjl-1" title:@"开锁记录"];
        WeakSelf(weak);
        _leftBtn.cliclBlock = ^{
            //  开锁记录
            LockModel *model = [[LockModel alloc] init];
            model = self.dateArr[num];
            LockhistoryViewController *vc = [[LockhistoryViewController alloc] init];
            vc.lock_id = model.lock_id;
            [weak.navigationController pushViewController:vc animated:YES];
        };
    }
    return _leftBtn;
}
- (CCButton *)rightBtn {
    if (!_rightBtn ) {
        _rightBtn = [[CCButton alloc] init];
        _rightBtn.frame = FRAME(SizeWidth(234), self.navigationView.bottom + SizeHeight(20), SizeWidth(63), SizeHeight(90));
        _rightBtn.pic.frame = FRAME(0, 0, SizeWidth(63), SizeWidth(63));
        _rightBtn.title.frame = FRAME(0, _rightBtn.pic.bottom + 3, SizeWidth(63), SizeHeight(13));
        _rightBtn.btn.size = CGSizeMake(_rightBtn.size.width, _rightBtn.size.height);
        _rightBtn.backgroundColor = [UIColor clearColor];
        [_rightBtn setPic:@"sy_icon_cygl-1" title:@"成员管理"];
        WeakSelf(weak);
        _rightBtn.cliclBlock = ^{
            //  开锁记录
            LockModel *model = [[LockModel alloc] init];
            model = self.dateArr[num];
            MemberViewController *vc = [[MemberViewController alloc] init];
            vc.lockId = model.lock_id;
            vc.lockName = model.lock_name;
            [weak.navigationController pushViewController:vc animated:YES];
        };
    }
    return _rightBtn;
}
- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"sy_icon_msgb"];
        _openBtn.size = image.size;
        _openBtn.centerX = self.view.centerX;
        _openBtn.centerY = self.view.centerY + 20;
        [_openBtn setImage:image forState:UIControlStateNormal];
        [_openBtn addTarget:self action:@selector(openlock) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}


- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] init];
        UIImage *image = [UIImage imageNamed:@"sy_icon_msgb"];
        _moreView.size = image.size;
        _moreView.centerX = self.view.centerX;
        _moreView.centerY = self.view.centerY + 20;
    }
    return _moreView;
}

- (NSArray *)dateArr {
    if (!_dateArr) {
        _dateArr = [NSArray new];
    }
    return _dateArr;
}

- (NSArray *)nameArr {
    if (!_nameArr) {
        _nameArr = [NSArray new];
    }
    return _nameArr;
}

@end
