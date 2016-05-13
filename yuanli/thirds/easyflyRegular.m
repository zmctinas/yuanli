//
//  easyflyRegular.m
//  easyflyDemo
//
//  Created by dukai on 15/5/30.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import "easyflyRegular.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
@implementation easyflyRegular

//数字验证
+(BOOL)validateNumber:(NSString *)number{
    
    NSString *emailRegex = @"^[0-9]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:number];
}
//手机验证
+ (BOOL)validatePhone:(NSString *)phoneNum
{
    NSString *regex = @"1[0-9]{10}";//  ^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    return isMatch;
}
//邮箱验证
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}
//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
        //判断位数
        if ([identityCard length] != 15 && [identityCard length] != 18) {
            return NO;
        }
        NSString *carid = identityCard;
        long lSumQT =0;
        //加权因子
        int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
        //校验码
        unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
        //将15位身份证号转换成18位
        NSMutableString *mString = [NSMutableString stringWithString:identityCard];
        if ([identityCard length] == 15) {
            [mString insertString:@"19" atIndex:6];
            long p = 0;
            const char *pid = [mString UTF8String];
            for (int i=0; i<=16; i++)
            {
                p += (pid[i]-48) * R[i];
            }
            int o = p%11;
            NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
            [mString insertString:string_content atIndex:[mString length]];
            carid = mString;
            
        }
        //判断地区码
        NSString * sProvince = [carid substringToIndex:2];
        
        if (![self areaCode:sProvince]) {
            
            return NO;
        }
        //判断年月日是否有效
        //年份
        int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
        //月份
        int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
        //日
        int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
        
        NSTimeZone *localZone = [NSTimeZone localTimeZone];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]  ;
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeZone:localZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
        if (date == nil) {
            
            return NO;
        }
        
        const char *PaperId  = [carid UTF8String];
        
        //检验长度
        if( 18 != strlen(PaperId)) return -1;
        //校验数字
        for (int i=0; i<18; i++)
        {
            if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
            {
                return NO;
            }
        }
        //验证最末的校验码
        for (int i=0; i<=16; i++)
        {
            lSumQT += (PaperId[i]-48) * R[i];
        }
        if (sChecker[lSumQT%11] != PaperId[17] )
        {
            return NO;
        }
        
        return YES;
}
+(BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init] ;
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
    }
    return YES;
}
+(NSString *)getStringWithRange:(NSString *)str Value1:(int)value1 Value2:(int )value2;
{
    return [str substringWithRange:NSMakeRange(value1, value2)];
}


#pragma mark 检查网络状态
+ (BOOL) checkNetWorkIsOk{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    // = flags & kSCNetworkReachabilityFlagsIsWWAN;
    //    BOOL nonWifi = kSCNetworkReachabilityFlagsTransientConnection;
    //    BOOL moveNet = kSCNetworkReachabilityFlagsIsWWAN;
    
    return (isReachable && !needsConnection) ? YES : NO;
}

#pragma mark -xujb
#pragma mark 是否是wifi连接
+(BOOL)checkIsWifi{
    return kSCNetworkReachabilityFlagsTransientConnection;
}


#pragma mark -xujb
#pragma mark 是否是移动网络连接
+(BOOL)checkIsMoveNet{
    //    return kSCNetworkReachabilityFlagsIsWWAN;
    return YES;
}




@end
