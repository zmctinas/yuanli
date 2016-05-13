//
//  easyflyRegular.h
//  easyflyDemo
//
//  Created by dukai on 15/5/30.
//  Copyright (c) 2015年 杜凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface easyflyRegular : NSObject


+(BOOL)validateNumber:(NSString *)number; //数字验证
+(BOOL)validatePhone:(NSString *)phoneNum; //手机验证
+(BOOL)validateEmail:(NSString *)email;   //邮箱验证
+(BOOL)validateCarNo:(NSString *)carNo;   //车牌号验证
+(BOOL)validateUserName:(NSString *)name; //用户名
+(BOOL)validatePassword:(NSString *)passWord; //密码
+(BOOL)validateNickname:(NSString *)nickname; //昵称
+(BOOL)validateIdentityCard: (NSString *)identityCard; //身份证号

//网络是否OK
+ (BOOL) checkNetWorkIsOk;

//判断是否是wifi连接
+(BOOL) checkIsWifi;

//判断是否是移动网络连接
+ (BOOL) checkIsMoveNet;

@end
