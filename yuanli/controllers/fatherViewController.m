//
//  fatherViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/7/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "fatherViewController.h"

@interface fatherViewController ()

@end

@implementation fatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 25, 30)];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -HEIGHT(15), 0, 0);
//    backBtn.backgroundColor = [UIColor blackColor];
    [backBtn setImage:[UIImage imageNamed:@"arrowleftwhite"] forState:UIControlStateNormal];
    UIBarButtonItem* im = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = im;
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    self.returnKeyHandler = nil;
}

-(void)backBtn:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
