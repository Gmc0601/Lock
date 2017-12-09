//
//  AddGateWayViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AddGateWayViewController.h"



@interface AddGateWayViewController (){
    
}

@property (weak, nonatomic) IBOutlet UILabel *WifiLab;
@property (weak, nonatomic) IBOutlet UITextField *WIFIText;
@property (weak, nonatomic) IBOutlet UIButton *pwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;



#if SIMULATOR_TEST
@property (nonatomic, strong) HFSmartLink * smtlk;

@property (nonatomic) BOOL isconnecting, showPWD;
#else
#endif



@end

@implementation AddGateWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.titleLab.text = @"添加网管";
}
//  显示密文
- (IBAction)showPwdClick:(id)sender {
}
//  开始匹配
- (IBAction)startClick:(id)sender {
    
    NSString * ssidStr= self.WifiLab.text;
    NSString * pswdStr = self.WIFIText.text;
    
#if SIMULATOR_TEST
    NSLog(@"%@<><><>%@", ssidStr, pswdStr);
    
    if(!self.isconnecting){
        self.isconnecting = true;
        [self.smtlk startWithSSID:ssidStr Key:pswdStr withV3x:true
                processblock: ^(NSInteger pro) {
                    //                    self.progress.progress = (float)(pro)/100.0;
                    NSLog(@"%ld", pro);
                } successBlock:^(HFSmartLinkDeviceInfo *dev) {
                    [self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
                } failBlock:^(NSString *failmsg) {
                    [self  showAlertWithMsg:failmsg title:@"error"];
                } endBlock:^(NSDictionary *deviceDic) {
                    self.isconnecting  = false;
                    [self.startBtn setTitle:@"connect" forState:UIControlStateNormal];
                    NSLog(@"finish");
                }];
        [self.startBtn setTitle:@"connecting" forState:UIControlStateNormal];
    }else{
        [self.smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            if(isOk){
                self.isconnecting  = false;
                [self.startBtn setTitle:@"1connect" forState:UIControlStateNormal];
                [self showAlertWithMsg:stopMsg title:@"OK"];
            }else{
                [self showAlertWithMsg:stopMsg title:@"error"];
            }
        }];
    }
#else
#endif
    
   
    
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

@end
