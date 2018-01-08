//
//  AddLockViewController.m
//  BaseProject
//
//  Created by cc on 2018/1/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AddLockViewController.h"
#import "NetAlter.h"
#import "ConnectionAlter.h"
#import "CommenAlter.h"

@interface AddLockViewController ()

@property (nonatomic, retain) NSMutableArray *dataArr;

@property (nonatomic, retain) ConnectionAlter *alter;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic,retain) NSDictionary *dic;

@end

@implementation AddLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    
    [HttpRequest postPath:@"GateWay/getlist" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSArray *data = datadic[@"data"];
            
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    NetModel *model = [[NetModel alloc] init];
                    model.name = dic[@"name"];
                    model.gateway_id = dic[@"gateway_id"];
                    [self.dataArr addObject:model];
                }
            }
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}
- (void)resetFather {
    self.titleLab.text = @"添加智能锁";
    self.rightBar.hidden = YES;
    
}

- (void)back:(UIButton *)sender {
    if (!self.netId) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//  匹配锁
- (IBAction)connectLock:(id)sender {
    
    if (!self.netId) {
        NetAlter *view = [[NetAlter alloc] initWithFrame:self.view.bounds];
        //传入数据
        WeakSelf(weak);
        view.dataArray = self.dataArr;
        __block NetModel *mod = [[NetModel alloc] init];
        view.rightBlock = ^(NSIndexPath *index) {
            [self.alter pop];
            mod = self.dataArr[index.row];
            self.dic = @{
                         @"gateway_id" : mod.gateway_id
                         };
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weak selector:@selector(addLcok) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            
        };
        
        [view pop];
    }else {
        [self.alter pop];
        self.dic = @{
                     @"gateway_id" : self.netId
                     };
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addLcok) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    
}

- (void)addLcok {
    [HttpRequest postPath:@"Lock/add" params:self.dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            
            
            [self.timer invalidate];
            [self.alter dismiss];
            
            CommenAlter *finsh = [[CommenAlter alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH) title:@"智能锁添加成功" info:@"" leftBtn:@"知道了" right:nil];
            
            finsh.leftBlock = ^{
                [finsh dismiss];
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            
            finsh.rightBlock = ^{
                //  跳转匹配锁
            };
            [finsh pop];
            
        }else {

        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (ConnectionAlter *)alter {
    if (!_alter) {
        _alter = [[ConnectionAlter alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH) lock:YES];
    }
    return _alter;
}

@end
