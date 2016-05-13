//
//  actRulesViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/16.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "actRulesViewController.h"

@interface actRulesViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation actRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动规则";
    
    [FrameSize MLBFrameSize:self.view];
    
    [self requestMessage];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)requestMessage
{
    
    NSDictionary* dic = @{@"service":RULE_IF,
                          
                          
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            NSArray* data = requestDic[@"data"][@"data"];
            NSString* content = @"";
            for (NSDictionary* dic in data) {
                NSString* rule = [NSString stringWithFormat:@"%@.%@",dic[@"rule_id"],dic[@"content"]];
                NSLog(@"%@",rule);
                content = [content stringByAppendingFormat:@"%@\n",rule];
            }
            self.textView.text = content;
        }
        
        
        
    } Falsed:^(NSError *error) {
        
    }];
}

@end
