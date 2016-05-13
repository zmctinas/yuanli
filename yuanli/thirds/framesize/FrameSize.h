//
//  FrameSize.h
//  Test
//
//  Created by Ricky on 15/5/18.
//  Copyright (c) 2015年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, screenIphone){
    screenIphone4s = 0, //iphone4s
    screenIphone5 = 1, //iphone5 iphone5s
    screenIphone6 = 2, //iphone6
    screenIphone6plus = 3, // iphone6 plus
    screenIphones = 4 //通用屏幕
};
//屏幕高度
#define ScreenHEIGHT ([[UIScreen mainScreen] bounds].size.height)
//屏幕宽度
#define ScreenWIDTH ([[UIScreen mainScreen] bounds].size.width)

//iphone4s
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
//iphone6 PLUS
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

@protocol FrameSizeDelegate <NSObject>

-(void)viewAdaptive;

@end

@interface FrameSize : NSObject

//初始化标准屏幕
+(void)setScreen:(screenIphone)screen;

//适配view以及view下所有控件无代理
+(void)MLBFrameSize:(UIView *)myView;

//获取当前屏幕和标准视图宽比例
+(CGFloat)proportionWidth;
//获取当前字体比例增幅大小
+(CGFloat)proportionFont:(float)fontSize;
@end
