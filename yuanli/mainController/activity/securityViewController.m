//
//  securityViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/16.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "securityViewController.h"

@interface securityViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation securityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"安全保障";
    
    
    [FrameSize MLBFrameSize:self.view];
    self.automaticallyAdjustsScrollViewInsets = NO;
    for (int i = 0 ; i<3; i++) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot_%d.png",i+1]];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*3, 0);
    
//    self.pageController
    
//    [FrameSize MLBFrameSize:self.view];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger offset = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.pageController.currentPage = offset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

@end
