//
//  signViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/27.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "signViewController.h"

@interface signViewController ()

@property (strong, nonatomic) IBOutlet UIView *signView;

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *seqIntegralLabel;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@property (weak, nonatomic) IBOutlet UIButton *quedingBnt;


- (IBAction)quedingBtn:(UIButton *)sender;

@end

@implementation signViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FrameSize MLBFrameSize:self.view];
    
//    [self addAnimotion];
    
    [self initUI];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addAnimotion];
}

-(void)initUI
{
    self.quedingBnt.layer.cornerRadius = 4;
    self.quedingBnt.layer.masksToBounds = YES;
    
    self.signView.layer.cornerRadius = 4;
    self.signView.layer.masksToBounds = YES;
    
    self.integralLabel.text = [NSString stringWithFormat:@"+%@",_score];
    self.seqIntegralLabel.text = [NSString stringWithFormat:@"连续签到%@次",_sign_times];
    
    self.integralLabel.hidden = !_isShow;
    self.seqIntegralLabel.hidden = !_isShow;
    
}

-(void)addAnimotion
{
    // 设定为缩放
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    CAKeyframeAnimation* animation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation1.delegate = self;
//    animation.delegate = self;
    
    animation1.duration = 0.5;
    
    animation1.keyTimes = @[
                            [NSNumber numberWithFloat:0.0],
                            [NSNumber numberWithFloat:0.7],
                            [NSNumber numberWithFloat:1.0],
                            ];
    animation1.values = @[
                          [NSNumber numberWithFloat:0.3],
                          [NSNumber numberWithFloat:1.3],
                          [NSNumber numberWithFloat:1.0],
                          ];
    
//    // 动画选项设定
//    animation.duration = 5; // 动画持续时间
//    animation.repeatCount = 1; // 重复次数
//    animation.autoreverses = YES; // 动画结束时执行逆动画
//    
    // 缩放倍数
//    animation.fromValue = [NSNumber numberWithFloat:0.3]; // 开始时的倍率
//    animation.byValue = [NSNumber numberWithFloat:1.2];
//    animation.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
    
    // 添加动画
    [_signView.layer addAnimation:animation1 forKey:@"scale-layer"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"gpweofp");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"完成");
}

- (IBAction)quedingBtn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
@end
