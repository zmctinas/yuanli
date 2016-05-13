//
//  lineView.m
//  yuanli
//
//  Created by daimangkeji on 16/5/12.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "lineView.h"
#import <QuartzCore/QuartzCore.h>

@implementation lineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self huahua];
    }
    return self;
}

-(void)huahua
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
//    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithHexString:@"#ff6600"] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:2.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
//    [shapeLayer setLineDashPattern:
//     [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
//      [NSNumber numberWithInt:1],nil]];
    
    // Setup the path
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, 0, 89);
//    CGPathAddLineToPoint(path, NULL, 320,89);
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    // 0,10代表初始坐标的x，y
    // 320,10代表初始坐标的x，y
    CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame)/2, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(self.frame)/2,self.frame.size.height);
    //CGRectGetMaxY(self.frame)
    [shapeLayer setPath:path];
    CGPathRelease(path);
    NSLog(@"%@   %f  %f",NSStringFromCGRect(self.frame),CGRectGetWidth(self.frame)/2, self.frame.origin.x);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self layer] addSublayer:shapeLayer];
}


@end
