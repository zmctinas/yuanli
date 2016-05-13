//
//  integralTableViewCell.m
//  yuanli
//
//  Created by daimangkeji on 16/5/12.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "integralTableViewCell.h"

@implementation integralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [FrameSize MLBFrameSize:self];
    
//    [self huahua];
    
    for (int i = 0; i<self.layer.sublayers.count; i++) {
        CALayer* layer = self.layer.sublayers[i];
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
            
        }
    }
    [self huahuafromPoint:CGPointMake(CGRectGetMidX(self.pointImageView.frame), 0) toPoint:CGPointMake(CGRectGetMidX(self.pointImageView.frame), CGRectGetMinY(self.pointImageView.frame)+2) tag:@"1"];
    [self huahuafromPoint:CGPointMake(CGRectGetMidX(self.pointImageView.frame), CGRectGetMaxY(self.pointImageView.frame)-2) toPoint:CGPointMake(CGRectGetMidX(self.pointImageView.frame), CGRectGetMaxY(self.frame)+12) tag:@"2"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(integralModel *)model
{
    _model = model;
    
    _dayLabel.text = model.day;
    _scoreLabel.text = [NSString stringWithFormat:@"+%@",model.score];
    _yearLabel.text = model.year;
    
    
    
    
    
    if (_model.isEnd) {
        _pointImageView.image = [UIImage imageNamed:@"timepointbegin"];
        for (int i = 0; i<self.layer.sublayers.count; i++) {
            CALayer* layer = self.layer.sublayers[i];
            if ([layer.name isEqualToString:@"2"]) {
                [layer removeFromSuperlayer];
                
            }
        }
    }else
    {
        
        _pointImageView.image = [UIImage imageNamed:@"timepoint"];
        
    }
    
}

-(void)huahuafromPoint:(CGPoint)Fpoint toPoint:(CGPoint)Tpoint tag:(NSString*)tag
{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.name = tag;
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor cyanColor] CGColor]];
    
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
    CGPathMoveToPoint(path, NULL, Fpoint.x, Fpoint.y);
    CGPathAddLineToPoint(path, NULL,Tpoint.x,Tpoint.y);
    //CGRectGetMaxY(self.frame)
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self layer] addSublayer:shapeLayer];
}

@end
