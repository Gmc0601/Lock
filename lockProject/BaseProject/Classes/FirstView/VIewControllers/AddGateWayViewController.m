//
//  AddGateWayViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AddGateWayViewController.h"
#import "ConnectionAlter.h"
#import "CommenAlter.h"
#import "AddLockViewController.h"
#import "FeailView.h"
#import "AddDeviceViewController.h"

@interface AddGateWayViewController (){
    
}

@property (weak, nonatomic) IBOutlet UILabel *WifiLab;
@property (weak, nonatomic) IBOutlet UITextField *WIFIText;
@property (weak, nonatomic) IBOutlet UIButton *pwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (nonatomic, retain) ConnectionAlter *alter;

#if SIMULATOR_TEST
@property (nonatomic, strong) HFSmartLink * smtlk;
@property (nonatomic) BOOL isconnecting, showPWD;
#else
#endif



@end

@implementation AddGateWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.startBtn setTitleColor:MainBlue forState:UIControlStateNormal];
    self.startBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.pwdBtn setImage:[UIImage imageNamed:@"srma_icon_camm"] forState:UIControlStateSelected];
    [self.pwdBtn setImage:[UIImage imageNamed:@"srma_icon_camm_pre"] forState:UIControlStateNormal];
    self.WIFIText.clearButtonMode = UITextFieldViewModeAlways;
    [self resetFather];
    [self showWifiSsid];
    [self linkSmart];
    
}

- (void)linkSmart {
#if SIMULATOR_TEST
   self.smtlk = [HFSmartLink shareInstence];
    self.smtlk.isConfigOneDevice = NO;
    self.smtlk.waitTimers = 30;
    self.isconnecting=false;
#else
#endif
    
    
    
}

- (void)showWifiSsid
{
    
#if SIMULATOR_TEST
    BOOL wifiOK= FALSE;
    NSDictionary *ifs;
    NSString *ssid;
    UIAlertView *alert;
    if (!wifiOK)
    {
        ifs = [self fetchSSIDInfo];
        ssid = [ifs objectForKey:@"SSID"];
        if (ssid!= nil)
        {
            wifiOK= TRUE;
            self.WifiLab.text = ssid;
        }
        else
        {
            self.WifiLab.text = @"手机未连接WIFI";
        }
    }
#else
#endif
    
    
}
- (id)fetchSSIDInfo {
#if SIMULATOR_TEST
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
#else
    return nil;
#endif
    

}

- (void)resetFather {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"添加网关";
}
//  显示密文
- (IBAction)showPwdClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.WIFIText.secureTextEntry = !sender.selected;
}
//  开始匹配
- (IBAction)startClick:(id)sender {
    
    NSString * ssidStr= self.WifiLab.text;
    NSString * pswdStr = self.WIFIText.text;
    
    if (self.WIFIText.text.length < 8 ) {
        [ConfigModel mbProgressHUD:@"请输入正确wifi密码" andView:nil];
        return;
    }
    
#if SIMULATOR_TEST
    NSLog(@"%@<><><>%@", ssidStr, pswdStr);
    WeakSelf(weak);
    if(!self.isconnecting){
        self.isconnecting = true;
        [self.smtlk startWithSSID:ssidStr Key:pswdStr withV3x:true
                processblock: ^(NSInteger pro) {
                    //                    self.progress.progress = (float)(pro)/100.0;
                } successBlock:^(HFSmartLinkDeviceInfo *dev) {
                    
                    //  连接成功
                    NSString *mac_address = [self hanleNums:dev.mac];
                    NSDictionary *dic = @{
//                                          @"name" : self.WifiLab.text,
                                          @"mac_address" : mac_address
                                          };
                    [HttpRequest postPath:@"GateWay/add" params:dic resultBlock:^(id responseObject, NSError *error) {
                        if([error isEqual:[NSNull null]] || error == nil){
                            NSLog(@"success");
                        }
                        NSDictionary *datadic = responseObject;
                        if ([datadic[@"success"] intValue] == 1) {
                        
                            NSDictionary *msg = datadic[@"msg"];
                            
                            NSString *gateId = msg[@"gateway_id"];
                            
                             [self.startBtn setTitle:@"已连接" forState:UIControlStateNormal];
                            [weak.alter dismiss];
                            [weak.startBtn setTitle:@"匹配成功" forState:UIControlStateNormal];
                            CommenAlter *finsh = [[CommenAlter alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH) title:@"网关匹配成功" info:@"是否要继续匹配智能锁？" leftBtn:@"暂不匹配" right:@"立即匹配"];
                            finsh.leftBlock = ^{
                                [finsh dismiss];
                                
                                for (UIViewController *controller in self.navigationController.viewControllers) {
                                    if ([controller isKindOfClass:[AddDeviceViewController class]]) {
                                        [weak.navigationController popToViewController:controller animated:YES];
                                    }
                                }
                                
                            };
                            
                            finsh.rightBlock = ^{
                              //  跳转匹配锁
                                [finsh dismiss];
                                AddLockViewController *vc = [[AddLockViewController alloc] init];
                                vc.netId = gateId;
                                [self.navigationController pushViewController:vc animated:YES];
                            };
                            [finsh pop];
                            
                        }else {
                            NSString *str = datadic[@"msg"];
                            [ConfigModel mbProgressHUD:str andView:nil];
                        }
                    }];  
                    
                } failBlock:^(NSString *failmsg) {
//                    [self  showAlertWithMsg:failmsg title:@"error"];
                    //  连接失败
                } endBlock:^(NSDictionary *deviceDic) {
                    //   连接完成
                    self.isconnecting  = false;
//                    [self.startBtn setTitle:@"已连接" forState:UIControlStateNormal];
                    NSLog(@"finish");
                }];
        //  弹出动画
        [self.alter pop];
//        self.startBtn.userInteractionEnabled = NO;
    }else{
        //  连接状态
        
//        [self.smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
//            if(isOk){
//                self.isconnecting  = false;
//                [self.startBtn setTitle:@"1connect" forState:UIControlStateNormal];
//                [self showAlertWithMsg:stopMsg title:@"OK"];
//            }else{
//                [self showAlertWithMsg:stopMsg title:@"error"];
//            }
//        }];
        
    }
#else
#endif
    
}


- (NSString *)hanleNums:(NSString *)numbers{
    NSString *str = [numbers substringWithRange:NSMakeRange(numbers.length%2, numbers.length-numbers.length%2)];
    NSString *strs = [numbers substringWithRange:NSMakeRange(0, numbers.length%2)];
    for (int  i =0; i < str.length; i+=2) {
        NSString *sss = [str substringWithRange:NSMakeRange(i, 2)];
        strs = [strs stringByAppendingString:[NSString stringWithFormat:@",%@",sss]];
    }
    if ([[strs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@","]) {
        strs = [strs substringWithRange:NSMakeRange(1, strs.length-1)];
        return strs;
    }
    return nil;
}

-(void)showAlertWithMsg:(NSString *)msg
                  title:(NSString*)title{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alert show];
}


//  空白点击 
- (IBAction)tapview:(id)sender {
    [self.WIFIText resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (ConnectionAlter *)alter {
    if (!_alter) {
        _alter = [[ConnectionAlter alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH) lock:NO];
    }
    //  错误提示
    _alter.failBloc = ^{
        FeailView *view = [[FeailView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
        [view pop];
    };
    return _alter;
}



@end
