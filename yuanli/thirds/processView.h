//
//  processView.h
//  环形渐变进度条
//
//  Created by daimangkeji on 16/4/15.
//  Copyright © 2016年 daimangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define  PROGREESS_WIDTH 90 //圆直径
#define PROGRESS_LINE_WIDTH 10 //弧线的宽度

@interface processView : UIView


-(void)setPercent:(NSInteger)percent animated:(BOOL)animated;


@end
