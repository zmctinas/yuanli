//
//  AppDelegate.m
//  yuanli
//
//  Created by 代忙 on 16/3/3.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "AppDelegate.h"
#import "sideViewController.h"
#import "WXMainViewController.h"
#import "JPUSHService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "sys/utsname.h"

#define JPushKey @"df3158eaca4d2aae416a5942"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)initWindows
{
    
    
    WXMainViewController* mainViewController = [[WXMainViewController alloc]init];
    sideViewController* sideVC = [[sideViewController alloc]init];
    ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithLeftViewController:sideVC centerViewController:mainViewController];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headbg"] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setTitleTextAttributes:
    
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:drawer];
    
//    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
//                                                NSForegroundColorAttributeName:[UIColor greenColor]}];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor],
       NSBackgroundColorAttributeName:[UIColor colorWithHexString:@"#d82b2b"]}];
    
    
    nav.navigationBar.backgroundColor = [UIColor colorWithHexString:@"#d82b2b"];
    
    nav.navigationBar.barTintColor = [UIColor colorWithHexString:@"#d82b2b"];
//    UITabBarController* tab = [[UITabBarController alloc]init];
//    tab.viewControllers = @[nav];
    self.window.rootViewController = nav;
    
}

- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //CLog(@"%@",deviceString);
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    //CLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
}


-(void)reloadViewController
{
    [self initWindows];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [FrameSize setScreen:screenIphone5];
    
    [self.window makeKeyAndVisible];
    
    [self initWindows];
    
    NSString* deviceVersion = [self deviceVersion];
    if ([deviceVersion isEqualToString:@"iPhone 5"]||[deviceVersion isEqualToString:@"iPhone 4s"]) {
        [USERDefaults setBool:NO forKey:@"enableUseHealthKit"];
        [USERDefaults synchronize];
    }else
    {
        [USERDefaults setBool:YES forKey:@"enableUseHealthKit"];
        [USERDefaults synchronize];
    }
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadViewController) name:@"test" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadViewController) name:UIApplicationWillEnterForegroundNotification object:nil];
    //NSCalendarDayChangedNotification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadViewController) name:NSCalendarDayChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLoginNotifition:) name:kJPFNetworkDidLoginNotification object:nil];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey     channel:@"App Store"
                 apsForProduction:NO];
    
    [ShareSDK registerApp:SHAREAppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformTypeQQ)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2807394786"
                                           appSecret:@"18805796b8229e13367671ef11218d22"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx964effae12754653"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105094606"
                                      appKey:@"UBUQZCRSldncz0b8"
                                    authType:SSDKAuthTypeBoth];
                 break;
             
             
             default:
                 break;
         }
     }];
    
    //向微信注册 需要放在最后
    [weixinObject weixin];
    
//    NSDictionary *localNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"%@",userInfo);
    if ([userInfo[@"content"][@"msg"]isEqualToString:@"dataClear"]||[userInfo[@"content"][@"status"] integerValue]==2) {
        [self clearData];
    }
    if ([userInfo[@"msg"] isEqualToString:@"loginOut"]) {
        [USERDefaults setBool:NO forKey:@"isLogin"];
        [USERDefaults setBool:NO forKey:@"isFirstShow"];
        [USERDefaults setObject:[USERDefaults objectForKey:@"WXStepCount"] forKey:@"toDayStepNum"];
        
        [USERDefaults synchronize];
        
        
        [self initWindows];
    }
}

-(void)didLoginNotifition:(NSNotification*)userinfo
{
    
    [[NSUserDefaults standardUserDefaults]setObject:[JPUSHService registrationID] forKey:@"RegistrationID"];
    NSLog(@"registrationID == %@",[JPUSHService registrationID]);
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [application registerForRemoteNotifications];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)
                                                 (UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"%@",userInfo);
    if ([userInfo[@"msg"] isEqualToString:@"loginOut"]) {
        [USERDefaults setBool:NO forKey:@"isLogin"];
        [USERDefaults setBool:NO forKey:@"isFirstShow"];
        [USERDefaults setObject:[USERDefaults objectForKey:@"WXStepCount"] forKey:@"toDayStepNum"];
        
        [USERDefaults synchronize];
        
        
        [self initWindows];
//        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        
//        
//        [alertController addAction:cancelAction];
//        [[(UINavigationController*)self.window.rootViewController visibleViewController]
//         presentViewController:alertController animated:YES completion:^{
//            
//        }];
    }
    if ([userInfo[@"content"][@"msg"]isEqualToString:@"dataClear"]||[userInfo[@"content"][@"status"] integerValue]==2) {
        [self clearData];
    }
    switch (application.applicationState) {
        case UIApplicationStateActive:
        {
            
        }
            break;
        case UIApplicationStateInactive:
        {
            
        }
            break;
        case UIApplicationStateBackground:
        {
            
        }
            break;
            
        default:
            break;
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)clearData
{
    
    [USERDefaults setObject:@"0" forKey:@"WXStepCount"];
    [USERDefaults setObject:@"0" forKey:@"toDayStepNum"];
    [USERDefaults synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clearData" object:nil userInfo:@{}];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@",error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [USERDefaults setBool:NO forKey:@"isFirstShow"];
    [USERDefaults setObject:[USERDefaults objectForKey:@"WXStepCount"] forKey:@"toDayStepNum"];
    
    [USERDefaults synchronize];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [alipayObject alipaySDKShare:url];
//    return   [WXApi handleOpenURL:url delegate:[weixinObject weixin]];
    return [WXApi handleOpenURL:url delegate:[weixinObject weixin]];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    [alipayObject alipaySDKShare:url];
//    return [WXApi handleOpenURL:url delegate:[weixinObject weixin]];
    return [WXApi handleOpenURL:url delegate:[weixinObject weixin]];;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    [WXApi handleOpenURL:url delegate:[weixinObject weixin]];
    return YES;
}

@end
