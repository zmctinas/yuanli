//
//  FrameSize.m
//  Test
//
//  Created by Ricky on 15/5/18.
//  Copyright (c) 2015年 Ricky. All rights reserved.
//

#import "FrameSize.h"
#import "CIKey.h"

@implementation FrameSize

+(void)frames:(UIView *)myView{
//    if ([CIKey isCIKey]) {
//        return;
//    }
  
    CGFloat widthRate = [self proportionWidth];
    
    for (UIView *view in myView.subviews) {
        
        if(view.frame.size.height !=1){
            
            if([view isKindOfClass:[UISwitch class]]){
               view.frame = CGRectMake(view.frame.origin.x * widthRate, (view.superview.frame.size.height - view.frame.size.height)/2, view.frame.size.width, view.frame.size.height);
                continue;
            }
            
            view.frame = CGRectMake(view.frame.origin.x * widthRate, view.frame.origin.y * widthRate, view.frame.size.width * widthRate, view.frame.size.height * widthRate);
            
            if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UITextView class]]){
                UILabel *label = (UILabel *)view;
                
                CGFloat fontSize = [self proportionFont:label.font.pointSize];
                
                label.font = [UIFont fontWithName:label.font.fontName size:(fontSize + (iPhone5?0.3:iPhone4s?0.3:0))];
            }
            
            if ([view isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scroll = (UIScrollView *)view;
                
                [scroll setContentSize:CGSizeMake(scroll.contentSize.width * widthRate, scroll.contentSize.height * widthRate)];
            }
            
            if (view.subviews.count > 0) {
                [self frames:view];
            }
            
        }else{
             view.frame = CGRectMake(view.frame.origin.x * widthRate, view.frame.origin.y * widthRate, view.frame.size.width * widthRate, 1);
        }
    }
}

+(void)frameSizeFor4s:(UIView *)myView{
    if (![myView isKindOfClass:[UITableViewCell class]]&&![myView isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWIDTH, ScreenHEIGHT)];
        
        for (UIView *view in myView.subviews) {
            NSLog(@"%@",NSStringFromCGRect(view.frame));
            [scroll addSubview:view];
        }
        [scroll setContentSize:CGSizeMake(0, 568 )];
        scroll.showsVerticalScrollIndicator = NO;
        scroll.tag = 230103;
        [myView addSubview:scroll];

    }
}

+(void)MLBFrameSizeFor4s:(UIView *)myView{
    [self frames:myView];
    [self frameSizeFor4s:myView];
}

+(void)MLBFrameSize:(UIView *)myView{
    if (ScreenHEIGHT == 480)
    [self MLBFrameSizeFor4s:myView];
    else
    [self frames:myView];
}

+(void)setScreen:(screenIphone)screen{
    switch (screen) {
        case screenIphone4s:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",320.0] forKey:@"DefaultWidth"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",480.0] forKey:@"DefaultHigh"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)screen] forKey:@"screenIphone"];
            break;
        case screenIphone5:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",320.0] forKey:@"DefaultWidth"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",568.0] forKey:@"DefaultHigh"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)screen] forKey:@"screenIphone"];
            break;
        case screenIphone6:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",375.0] forKey:@"DefaultWidth"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",667.0] forKey:@"DefaultHigh"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)screen] forKey:@"screenIphone"];
            break;
        case screenIphone6plus:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",414.0] forKey:@"DefaultWidth"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",736.0] forKey:@"DefaultHigh"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)screen] forKey:@"screenIphone"];
            break;
        case screenIphones:
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",720.0] forKey:@"DefaultWidth"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",1280.0] forKey:@"DefaultHigh"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)screen] forKey:@"screenIphone"];
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(CGFloat)proportionWidth{
    CGFloat Width = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultWidth"] floatValue];
    CGFloat width = ScreenWIDTH/Width;
    return width;
}

+(CGFloat)proportionFont:(float)fontSize{
    
    CGFloat widthRate = [self proportionWidth];
    fontSize = widthRate*fontSize;
    fontSize = floor(fontSize);
  //  fontSize = (widthRate ==1?0:widthRate>0?fontSize:-fontSize);
    return fontSize;
    
}
@end
