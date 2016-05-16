//
//  processView.m
//  环形渐变进度条
//
//  Created by daimangkeji on 16/4/15.
//  Copyright © 2016年 daimangkeji. All rights reserved.
//

#import "processView.h"

@implementation processView
{
    CAShapeLayer* _trackLayer;
    CAShapeLayer* _progressLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)initView
{
    _trackLayer = [CAShapeLayer layer];//创建一个track shape layer
    _trackLayer.frame = self.bounds;
//    _trackLayer.cen = self.center;
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = [[UIColor clearColor] CGColor];
    _trackLayer.strokeColor = [[UIColor grayColor] CGColor];//指定path的渲染颜色
    _trackLayer.opacity = 0.25; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
    _trackLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _trackLayer.lineWidth = PROGRESS_LINE_WIDTH;//线的宽度
    NSLog(@"%@",NSStringFromCGPoint(self.center));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(self.bounds.size.width-PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(-90) endAngle:degreesToRadians(270) clockwise:YES];//上面说明过了用来构建圆形
    _trackLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor = [[UIColor cyanColor] CGColor];
    
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0 ;
    [self.layer addSublayer:_progressLayer];
    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = self.bounds;
//    CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor orangeColor] CGColor],(id)[[UIColor yellowColor] CGColor],(id)[[UIColor redColor] CGColor], nil]];
    [gradientLayer1 setLocations:@[@0.1,@0.7,@1 ]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0)];
    [gradientLayer1 setEndPoint:CGPointMake(0, 1)];
    [gradientLayer addSublayer:gradientLayer1];
    
//    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
//    [gradientLayer2 setLocations:@[@0.1,@0.9,@1]];
//    gradientLayer2.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
//    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor yellowColor] CGColor],(id)[[UIColor redColor] CGColor], nil]];
//    [gradientLayer2 setStartPoint:CGPointMake(0, 0)];
//    [gradientLayer2 setEndPoint:CGPointMake(1, 1)];
//    [gradientLayer addSublayer:gradientLayer2];
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
////    [_progressLayer setMask:gradientLayer];
    [self.layer addSublayer:gradientLayer];
////
}



-(void)setPercent:(NSInteger)percent animated:(BOOL)animated
{
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:1];
    _progressLayer.strokeEnd = percent/10.0;
    [CATransaction commit];
    
//    _percent = percent;
}

@end
