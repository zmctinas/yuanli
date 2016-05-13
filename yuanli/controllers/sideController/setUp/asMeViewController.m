//
//  asMeViewController.m
//  yuanli
//
//  Created by 王晓伟 on 16/3/24.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "asMeViewController.h"

@interface asMeViewController ()

@end

@implementation asMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    [FrameSize MLBFrameSize:self.view];
    UIScrollView* scroll = (UIScrollView*)[self.view viewWithTag:230103];
    if (scroll) {
        scroll.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
