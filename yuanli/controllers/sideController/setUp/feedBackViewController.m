//
//  feedBackViewController.m
//  yuanli
//
//  Created by 王晓伟 on 16/3/24.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "feedBackViewController.h"

@interface feedBackViewController ()<UITextViewDelegate>
@property(strong,nonatomic)UIBarButtonItem* rightItem;
@property (weak, nonatomic) IBOutlet UITextView *feedBackView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation feedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"反馈";
    
    
    [FrameSize MLBFrameSize:self.view];
    UIScrollView* scroll = (UIScrollView*)[self.view viewWithTag:230103];
    if (scroll) {
        scroll.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    _feedBackView.contentInset = UIEdgeInsetsMake(-CGRectGetHeight(_feedBackView.frame)/3, 0, 0, 0);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)tijiaoBtn:(UIButton*)button
{
    if (![_feedBackView.text isEqualToString:@"请描述你的问题"]) {
        [self feedBack];
    }else
    {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入要反馈的内容" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
    }
}

#pragma mark - getter

-(void)feedBack
{
    NSDictionary* dic = @{@"service":BACK_IF,
                          @"user_id":UID,
                          @"content":self.feedBackView.text,
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"data"][@"msg"]);
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:requestDic[@"data"][@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}

-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#f86d6d"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tijiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请描述你的问题"]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请描述你的问题";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%@",NSStringFromRange(range));
    _numLabel.text = [NSString stringWithFormat:@"%ld/240",240-range.location-1];
    if ([_numLabel.text integerValue] <=0) {
        return NO;
    }
    return YES;
}

@end
