//
//  weixinObject.m
//  ocCrazy
//
//  Created by dukai on 16/1/7.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import "weixinObject.h"

static weixinObject *weixin = nil;
@implementation weixinObject

+(weixinObject *)weixin{
    if (weixin == nil) {
        weixin = [[weixinObject alloc]init];
        [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    }
    
    return weixin;
}

+(void)weixinPay:(float)amount order:(NSString *)orderNum block:(weixinPayResult)result{
    if (result) {
        weixin.weixinBlock = result;
    }
    [weixin sendPay_demo:amount orderNum:orderNum];
    
}

+(void)getOpenid:(weixingetOpenidResult)openid
{
    if (openid) {
        weixin.openidBlock = openid;
    }
    //构造SendAuthReq结构体
    [weixinObject weixin];
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)sendPay_demo:(float)price orderNum:(NSString *)orderNum
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:price orderNum:orderNum];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        if ([WXApi isWXAppInstalled]) {
            if ([WXApi sendReq:req]) {
                NSLog(@"微信跳转成功");
            }
        }else{
//            [JKAlert showMessage:@"没有安装微信"];
        }
        
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    NSLog(@"%@",[resp class]);
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                self.weixinBlock(YES);
                
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                self.weixinBlock(NO);
                
                break;
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]])
    {
        
        /*https://api.weixin.qq.com/sns/oauth2/access_token?
         appid=APPID&
         
         
         secret=SECRET&code=CODE&grant_type=authorization_code*/
        
        SendAuthResp* authResp = (SendAuthResp*)resp;
        
        NSDictionary* dic = @{
                              @"appid":APP_ID,
                              @"secret":APP_SECRET,
                              @"code":authResp.code,
                              @"grant_type":@"authorization_code",
                              };
        NSLog(@"%@",dic);
        self.openidBlock(@{@"code":authResp.code});
//        AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//        [manager GET:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
//            NSLog(@"%@",downloadProgress);
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            self.openidBlock((NSDictionary*)responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            
//        }];
        
    }
    
}
@end
