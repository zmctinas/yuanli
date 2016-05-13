//
//  helpCenterViewController.m
//  yuanli
//
//  Created by daimangkeji on 16/5/4.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "helpCenterViewController.h"

@interface helpCenterViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation helpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助中心";
    
    [FrameSize MLBFrameSize:self.view];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGHEAD,@"helpCenter/helpCenter.html"]];
//    NSURL* url = [NSURL URLWithString:@"http://www.taobao.com"];
    
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
