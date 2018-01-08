//
//  PayTool.m
//  SimpleLife
//
//  Created by cc on 17/5/4.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "PayManager.h"
#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "XMLDictionary.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "WXApi.h"

#define Alipay_APPID  @"2017122201065706"


#define Alipay_KEY @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCdRfcz+EELqTL2ucLOML4NTLS1/VaSv436fIFOROD1CF6F1P5jez0jR0DGDReel9musOqfn2ggTp8xa2dHqLsChW9R6Pc0DM/+/A15rbufrcmcyX0CDJArc9rUBQoGg6EQgslX7I31NbABzhTCp1BIyGE4haj8Cv1Mu6iK4Jj585WJ1CJ8cb+XzNV4Jd4jAK2AgWrWn6Bu4TBxHmpx8DyjH9Um1ZK2Q02QYzdILkuUylAyk4yrtO4ZmNFLQ96QZrUb/dpMYOyPzP64Nt8GveE1Ec8vZRd2ZbCFpfZ8gXTolLJNpo5AgLIE2lHFh7OvOwLD/4Pxevxd0c1Cz7onsfCvAgMBAAECggEAbgbZp6EBGIBZqCRTNd8Bxton/r3qiCW81UWvTKuBWctuHWDiS4SXRAwAM85K/OetIbqhmeRye0+lrXQ/P/G6S0xAkeRStTZVeUSqxLqXbWGuj6KicwGJBu05ZWTVG7OQxbVJ2Nokgiz6InkjKv7Ueua8pUdU7mddyAXtJqN0QkBcnnDC59bbyHQmW7SwryDDg71U5qwthKOhg0e54veSgaKppDQxbMY5+isU4jWLcPKUgYwhemCJPPJbowjx1ZY9TfEzS/xc3QRvrTkAqLVxSdyQwBg1oKwX3SIgO8uK22g4W7FZZXyf+eMP3cCFwdDWz5dVa/GkJDq9vknYc08dWQKBgQDmnBKAz50KQ9vwfjSqs9TJgZ4bDNYHERn8jHOQmXdWeSi9wlOypXJ4/mnbJHOMB7vhIa28dINS4bdqRWq0xg2oreAdCVTuTEbQVuOoRwD1Lw1Dx0zWIcNQ4M28tNS7rrcbB8YnAuJ68XvvsBHZooQkfe3L7IAk+zxOKmTYc6E6WwKBgQCultiq1ZkBbJ7iZcV36XFp0E4mNSF3Xn9hdgcw0nvwgOT86/h9FK0JHs65QqSn9p5onFfc2poMd3ZrHnUSxabT9QdQf7x+2zXuOiWoixLKlPrMQA+aLTi5boFwSAqrLCsxPV5vQQYcdizGU4Ze4V2txFzVjgtc0kcjGzYpzBlrPQKBgQCbK7V/mzNuLs8VebZyjmLF3EPIq9BwHN/BgbhZOgqE0y3I0bOD57OpGnecD2D4flO7XvAKeNPMtzi1d1Qfo4yZTbYZk6fkWMrlcTHqjyxjzm88hiR7iWhlSX7mVT83so5ez9JTeatvUoI0e+Lm8GW+MEYMC20GdU7Uwc3tn5CDNQKBgHl7mTP2AMtO65eZPThdBX+dZGONoMXQyU3ltMcyDu+goLWk9HkEhArOlwWt66i8ICmmcDTLH1oBXjLXNJtlUNo3q2lGGMEkg3hKmZ2Xd/HijEjHYpPjV48f541bc6D70OooS6eaVUhEqo8t21f19RtOgVJPznQ+FSXGb3/R9vX5AoGBAM+8Zyvb2jIxL7Bk9OiN8Ucd4heeZ8Ja2lzHk3haJbhaxKV3N2OVyurwxf8LmnlypU9Hl10MVeQI8CtkBZw2keEXxBJdZBoHWXYMmtste0+43nfMYaeqOwMX8tueAbWtWxBGgFA2J7mCam55iIRxn9QxnNV+umAeDSO1H2cqnKmE"

//商户API密钥，填写相应参数
#define WXpaySignKey      @"5F93F3E9A16369A43D79949A2D0CADEE"
//支付结果回调页面
#define NOTIFY_URL      @"http://www.lingyuetec.com/MicroService/alipaycallback"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

#define WEChat_Sign @"https://api.mch.weixin.qq.com/pay/unifiedorder"


@interface PayManager ()

@property (nonatomic, copy) NSString *task_num;


@property (nonatomic, assign) PayType payType;


@end



static PayManager *payManager = nil;

@implementation PayManager


+ (PayManager *)manager
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payManager = [[self alloc] init];
    });
    return payManager;
}



//
//- (void)payByWeChatWithPrice:(NSString *)price order_num:(NSString *)order_num
//{
//    self.task_num = order_num;
//    if(![WXApi isWXAppInstalled])
//    {
//        [AlertView toastBottomAlert:@"您还未安装微信"];
//        return;
//    }
//    
//    NSDictionary *dict = [self sendPayWithPrice:price order_num:order_num];
//    if(dict == nil){
//        [SVProgressHUD showErrorWithStatus:@"提交订单失败"];
//    }else{
//        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
//        PayReq* req             = [[PayReq alloc] init];
//        req.openID              = WX_APP_ID;
//        req.partnerId           = WX_MCH_ID;
//        req.prepayId            = [dict objectForKey:@"prepayid"];//////
//        req.nonceStr            = [dict objectForKey:@"noncestr"];
//        req.timeStamp           = stamp.intValue;
//        req.package             = [dict objectForKey:@"package"];
//        req.sign                = [dict objectForKey:@"sign"];
//        [WXApi sendReq:req];
//    }
//}
//
//
//- (NSDictionary *)sendPayWithPrice:(NSString *)price order_num:(NSString *)order_num{
//    
//    NSString * order_price = [NSString stringWithFormat:@"%.f", [price floatValue]*100];
//    //随机串
//    NSString *noncestr   = [[NSString stringWithFormat:@"%d",rand()/10000] md5String];
//    //商户订单号 (唯一性)
//    
//    
//    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
//    
//    [packageParams setObject: WX_APP_ID              forKey:@"appid"];//开放平台appid
//    [packageParams setObject: WX_MCH_ID              forKey:@"mch_id"];      //商户号
//    [packageParams setObject: @"搜天下-app充值"        forKey:@"body"];        //订单描述，展示给用户
//    [packageParams setObject: noncestr               forKey:@"nonce_str"];   //随机串
//    [packageParams setObject: @"APP"                 forKey:@"trade_type"];  //支付类型，固定为APP
//    [packageParams setObject: NOTIFY_URL             forKey:@"notify_url"];  //支付结果异步通知
//    [packageParams setObject: order_num              forKey:@"out_trade_no"];//商户订单号
//    [packageParams setObject: [NSString getIPAddress]    forKey:@"spbill_create_ip"];//发器支付的机器ip
//    [packageParams setObject:order_price                 forKey:@"total_fee"];       //订单金额，单位为分
//    NSData *res = [self httpSend:WEChat_Sign method:@"POST" data:[self genPackage:packageParams]];
//    
//    NSDictionary *resultDic = [NSDictionary dictionaryWithXMLData:res];
//    
//    if (![resultDic[@"return_code"] isEqualToString:@"FAIL"]) {
//        NSMutableDictionary *signParams = [@{} mutableCopy];
//        // 第二次签名参数列表
//        time_t now;
//        time(&now);
//        
//        NSString *timeStamp = [NSString stringWithFormat:@"%ld",now];
//        
//        [signParams setObject: WX_APP_ID           forKey:@"appid"];
//        [signParams setObject: WX_MCH_ID           forKey:@"partnerid"];
//        [signParams setObject: noncestr            forKey:@"noncestr"];
//        [signParams setObject: @"Sign=WXPay"       forKey:@"package"];
//        [signParams setObject: timeStamp           forKey:@"timestamp"];
//        [signParams setObject: resultDic[@"prepay_id"]     forKey:@"prepayid"];
//        
//        // 生成签名
//        NSString *sign = [self createMD5Sign:signParams];
//        [signParams setObject:sign                 forKey:@"sign"];
//        return signParams;
//    }else{
//        return nil;
//    }
//    
//}
//
//
//- (NSData *) httpSend:(NSString *)url method:(NSString *)method data:(NSString *)data
//{
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
//    //设置提交方式
//    [request setHTTPMethod:method];
//    //设置数据类型
//    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
//    //设置编码
//    [request setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
//    //如果是POST
//    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSError *error;
//    //将请求的url数据放到NSData对象中
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//    return response;
//}
//
//
//
//-(NSString *)genPackage:(NSDictionary *)packageParams
//{
//    NSString *sign;
//    NSMutableString *reqPars=[NSMutableString string];
//    //生成签名
//    sign        =  [self createMD5Sign:packageParams];
//    //生成xml的package
//    NSArray *keys = [packageParams allKeys];
//    [reqPars appendString:@"<xml>\n"];
//    for (NSString *categoryId in keys) {
//        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
//    }
//    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
//    
//    return [NSString stringWithString:reqPars];
//}
//
//
//
//// 创建package签名
//- (NSString *)createMD5Sign:(NSDictionary *)dict
//{
//    NSMutableString *contentString = [NSMutableString string];
//    NSArray *keys = [dict allKeys];
//    //按字母顺序排序
//    NSArray *sortArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//    // 拼接字符串
//    for (NSString *key in sortArray) {
//        if (![dict[key] isEqualToString:@""] &&
//            ![key isEqualToString:@"sign"] &&
//            ![key isEqualToString:@"key"])
//        {
//            [contentString appendString:key];
//            [contentString appendString:@"="];
//            [contentString appendString:dict[key]];
//            [contentString appendString:@"&"];      //样式类似于
//        }
//    }
//    // 添加key 商户API密钥
//    [contentString appendFormat:@"key=%@",WXpaySignKey];
//    // 得到MD5加密后的 sign 签名
//    NSString *md5Sign = [contentString md5String];
//    
//    return md5Sign;
//}
//
//
//#pragma mark -   微信返回结果
//-(void) onResp:(BaseResp*)resp{
//    
//    if ([resp isKindOfClass:[PayResp class]])
//    {
//        PayResp*response=(PayResp*)resp;
//        
//        if (response.errCode == WXSuccess) {
//            
//        }else{
//            [AlertView toastBottomAlert:@"支付失败"];
//        }
//    }
//}


- (void)payByAlipay:(OrderResult *) model
{
  
   
    
  
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = Alipay_APPID;
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = Alipay_KEY;
    NSString *rsaPrivateKey = @"";
    
      self.task_num = model.order_sn; ///// task_num
    
    
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"2.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    order.notify_url = NOTIFY_URL;
    // NOTE: 商品数据
    order.biz_content = [BizContent new];

    order.biz_content.body = model.subject;
    order.biz_content.subject = model.subject;
    order.biz_content.out_trade_no = model.order_sn; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%@", model.total_amount]; //商品价格
    
    //将商品信息拼接成字符串  
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types

        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"qijia-alipay" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            [self alipayResult:resultDic];
        }];
    }
}



#pragma mark - 支付宝  支付结果回调
- (void)alipayResult:(NSDictionary *)resultDic
{
        NSLog(@"result = %@",resultDic);
    NSLog(@">>>>%@", self.task_num);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
    [ConfigModel saveString:self.task_num forKey:@"paymoney"];
    if ([resultDic[@"resultStatus"] intValue] == 9000) {
//        [[NSNotificationCenter  defaultCenter] postNotificationName:HavePay object:@{@"action_title":@"2",
//                                                                                     @"task_num":self.task_num}];
        
    }
    
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
}







@end








