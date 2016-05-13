//
//  scoreRuleViewController.m
//  yuanli
//
//  Created by daimangkeji on 16/5/13.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "scoreRuleViewController.h"

@interface scoreRuleViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation scoreRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分规则";
    
    [FrameSize MLBFrameSize:self.view];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGHEAD,@"scoreRule/scoreRule.html"]];
//    NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSLog(@"%@",url);
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
//

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    NSLog(@"clientheight  =  %f",clientheight);
    
    webView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, clientheight+20);
    
}

@end
