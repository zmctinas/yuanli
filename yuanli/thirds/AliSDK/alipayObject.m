//
//  alipayObject.m
//  yinyuehe
//
//  Created by dukai on 15/8/24.
//  Copyright (c) 2015年 dukai. All rights reserved.
//

#import "alipayObject.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"
@implementation alipayObject

#pragma mark -
#pragma mark   ==============产生订单信息==============

+(void)alipaySDKShare:(NSURL *)url{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
}


+(void)alipay:(float)amount order:(NSString *)orderNum block:(alipyResult)result{
    
    
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088711404436433";
    NSString *seller = @"hangzhoudaimang@163.com";
    NSString*privateKey=@"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMyIo72RYxMd1Sz7MrvFcgb2e7aC5PSeVt6Y/2F2H0UcS6wJXIvUHIRF7oiGf0VcoqaAgYldpFAaWh9XTQ/Ej9I8Lrsl6AtpAv31igjCtXrwtVUob5ocYsZcOAiFu/V16lcvls3xGLbqF18piKVP4B93AaCACrE8soWGDeJMQdkZAgMBAAECgYEAuq3cBSG1c7U+5JdBbvB/aqt9rs85easrTnAGZ0YQtFtnFdZViapHfNL3K9TWRNCQA7g2gtHdLt9eckyUIVgeiviW4GrDcS8SMDCd7jso1pc/EcKHo9iieZdyTm46VcGCrVHLjPGhnBJE83JPN0CkDj6/LxeWdzfkbRhFxBXjOIECQQD7vvn0M8IxfavHjSVPg2d6pi4trk1vIIE1SvnRkWEVULEth6f+6EovpR4UReub8cfwBW8AJ3mIcLbXqPHziS+tAkEAz/1tts5tXJ7mdC85R+Nax3zqgf2Q4Nz7zinfsTfzIfEzbW1GWPqT4V70HlKJbWuOZjrkmwPIig9RlqemlOGMnQJAavLtOYOrol7jVXlvOmJ22bIzuBBusSE8AyoBC7kZZ3bKbq9M/YwtyCP7rV0vBScoa53DVGtwxDguVVxevbmwWQJBALn9iVfYvqj9m104QYPMhogvZ1F4206Jrk8M2PET9EJc+70V47t70DPQAoL/Ec+cR8mZToZkWrdCvZX4M5mdHG0CQQCczfCNnzyYZaxPLKVMkDZWdp9mNHTvmyLaWV2V3b3ULjqQ3GWWGJOcp2O2+zDabr3bS7ig3umN9g8g43Giy8xa";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
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
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.out_trade_no = orderNum; //订单ID（由商家自行制定）
    //order.productDescription = @"124";//UID;
    order.productName = @"原力支付"; //商品标题
    order.productDescription = @"商品支付"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
    order.notifyURL =  @"http://api.daimang.com/Public/pay/aliwap/notify.php"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"ylalipay";//[UIApplication crazy_bundleName];
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            //6001
            
            result(resultDic);
            
            
        }];
    }
}
@end
