  //
//  headDateView.m
//  yuanli
//
//  Created by 代忙 on 16/3/11.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "headDateView.h"

@implementation headDateView
{
    NSMutableArray* dateArr;
    UILabel* line;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(void)addItemWithBlock:(dateBtnBlock)btnBlock
{
    _touchDateBtn = btnBlock;
    [self initUI];
}

-(void)initUI
{
    dateArr = [NSMutableArray array];
    self.userInteractionEnabled = YES;
    UILabel* bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#d82b2b"];
    [self addSubview:bottomLine];
    _dateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    _dateScrollView.userInteractionEnabled = YES;
    _dateScrollView.showsHorizontalScrollIndicator = NO;
    _dateScrollView.delegate = self;
    
    [self addSubview:_dateScrollView];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    static int d = 0;
//    d++;
//    NSLog(@"%d",d);
    for (int i = 0 ; i< 14; i++) {
        NSString* curentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-i*24*60*60]];
        
        NSArray* time = [curentDateStr componentsSeparatedByString:@"-"];
        NSString* day = [time lastObject];
        
        [dateArr addObject:day];
    }
    dateArr = (NSMutableArray*) [[dateArr reverseObjectEnumerator]allObjects];
    
    for (int i = 0 ;i<dateArr.count ; i++) {
        NSString* str = dateArr[i];
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(5+(10+25)*i, 5, 25, 25);
        
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"circleRed"] forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.dateScrollView addSubview:btn];
        if (i == dateArr.count - 1) {
            btn.selected = YES;
        }
        
    }
    
    self.dateScrollView.contentSize = CGSizeMake(dateArr.count*HEIGHT((10+25)), 0);
    [FrameSize MLBFrameSize:self.dateScrollView];
    
    self.dateScrollView.contentOffset = CGPointMake(self.dateScrollView.contentSize.width-SCREEN_WIDTH, 0);
    
    UIButton* btn = (UIButton*)[self viewWithTag:13];
//    line = [[UILabel alloc]initWithFrame:CGRectMake(5, self.frame.size.height-2, 25*[FrameSize proportionWidth],2)];
//    line.center = CGPointMake(btn.center.x, line.center.y);
//    line.backgroundColor = [UIColor colorWithHexString:@"#d82b2b"];
//    [_dateScrollView addSubview:line];
}

-(void)touchBtn:(UIButton*)btn
{
    btn.selected = YES;
    for (UIButton* button in _dateScrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag != btn.tag) {
                button.selected = NO;
            }
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = line.center;
        center.x = btn.center.x;
        line.center = center;
    }];
    
    if (self.touchDateBtn) {
        self.touchDateBtn(btn.tag);
    }
    
}

@end
