//
//  setUpViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/7.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "setUpViewController.h"
#import "personViewController.h"
#import "feedBackViewController.h"
#import "asMeViewController.h"
#import "helpCenterViewController.h"

@interface setUpViewController ()


- (IBAction)messageBtn:(UIButton *)sender;
- (IBAction)notifiBtn:(UIButton *)sender;
- (IBAction)feedBackBtn:(UIButton *)sender;

- (IBAction)asWeBtn:(UIButton *)sender;
- (IBAction)logOutBtn:(UIButton *)sender;

- (IBAction)helpCenterBtn:(UIButton *)sender;

@end

@implementation setUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
//    [CrazyAutoLayout layoutOfSuperView:self.view];
    [FrameSize MLBFrameSize:self.view];
    UIScrollView* scroll = (UIScrollView*)[self.view viewWithTag:230103];
    if (scroll) {
        scroll.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)messageBtn:(UIButton *)sender {
    
    personViewController* person = [[personViewController alloc]init];
    [self.navigationController pushViewController:person animated:YES];
    
}

- (IBAction)notifiBtn:(UIButton *)sender {
}

- (IBAction)feedBackBtn:(UIButton *)sender {
    
    feedBackViewController* feedBack = [[feedBackViewController alloc]init];
    [self.navigationController pushViewController:feedBack animated:YES];
    
}

- (IBAction)asWeBtn:(UIButton *)sender {
    
    asMeViewController* me = [[asMeViewController alloc]init];
    [self.navigationController pushViewController:me animated:YES];
    
}

- (IBAction)logOutBtn:(UIButton *)sender {
    
    NSDictionary* dic = @{@"service":LOGOUT_IF,
                          @"user_id":UID
                          };
    
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        
        NSLog(@"%@",requestDic[@"data"]);
        
        if ([requestDic[@"data"] isKindOfClass:[NSString class]]) {
            if ([requestDic[@"data"]isEqualToString:@"退出成功"] ) {
                [USERDefaults setBool:NO forKey:@"isLogin"];
                [USERDefaults setBool:NO forKey:@"isFirstShow"];
                [USERDefaults setObject:@"" forKey:@"NowDate"];
                [USERDefaults synchronize];
                [self.navigationController popToRootViewControllerAnimated:YES];
                return ;
            }
        }
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            [USERDefaults setBool:NO forKey:@"isLogin"];
            [USERDefaults setBool:NO forKey:@"isFirstShow"];
            [USERDefaults setObject:@"" forKey:@"NowDate"];
            [USERDefaults synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            [USERDefaults setBool:NO forKey:@"isLogin"];
            [USERDefaults setBool:NO forKey:@"isFirstShow"];
            [USERDefaults setObject:@"" forKey:@"NowDate"];
            [USERDefaults synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"%@",requestDic[@"data"][@"msg"]);
        }
        
        
        
    } Falsed:^(NSError *error) {
        
    }];

    
}
- (IBAction)helpCenterBtn:(UIButton *)sender {
    
    helpCenterViewController* help = [[helpCenterViewController alloc]init];
    [self.navigationController pushViewController:help animated:YES];
    
}
@end
