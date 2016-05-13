
//
//  WXprogress.m
//  yuanli
//
//  Created by 代忙 on 16/3/29.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "WXprogress.h"
#import "AppDelegate.h"

static WXprogress* process = nil;
@implementation WXprogress
{
    UIImageView* imageView;
    NSInteger nums;
}


+(instancetype)shareProcess
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        process = [[WXprogress alloc]init];
    });
    return process;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenHEIGHT);
        [self setUp];
        nums = 0;
    }
    return self;
}




-(void)setUp
{
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHEIGHT)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self addSubview:view];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.center = self.center;
    NSMutableArray* imageSources = [NSMutableArray array];
    for (int i = 0; i<40; i++) {
        NSString* imageStr = [NSString stringWithFormat:@"a_000%.2d",i];
        UIImage* image = [UIImage imageNamed:imageStr];
        [imageSources addObject:image];
    }
    imageView.animationImages = imageSources;
    imageView.animationRepeatCount = -1;
    imageView.animationDuration = 2;
    [self addSubview:imageView];
    
    
    
}

-(void)showProgress
{
    if (nums == 0) {
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        UIWindow* windows = delegate.window;
        [windows addSubview:self];
        
        [imageView startAnimating];
        nums++;
    }else
    {
        nums++;
    }
    
}

-(void)dismissProgress
{
    if (nums == 1) {
        [imageView stopAnimating];
        [self removeFromSuperview];
        nums--;
    }else
    {
        nums--;
    }
    
    
}


@end
