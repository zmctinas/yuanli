//
//  sideViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/4.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "sideViewController.h"
#import "setUpViewController.h"
#import "myPolicyViewController.h"
#import "signInViewController.h"
#import "integralViewController.h"


@interface sideViewController ()
{
    UIScrollView* scroll;
}

@property (weak, nonatomic) IBOutlet UIImageView *junxianView;
@property (strong, nonatomic) IBOutlet UILabel *taskStepNumLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sexLabel;



- (IBAction)orderBtn:(UIButton *)sender;
- (IBAction)integralBtn:(UIButton *)sender;
- (IBAction)signInBtn:(UIButton *)sender;
- (IBAction)setUpBtn:(UIButton *)sender;
- (IBAction)backBtn:(UIButton *)sender;




@end

@implementation sideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
//    [CrazyAutoLayout layoutOfSuperView:self.view];
    [FrameSize MLBFrameSize:self.view];
    
//    scroll = (UIScrollView*)[self.view viewWithTag:230103];
//    if (scroll) {
//        scroll.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
//    }
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height/2;
    self.iconView.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showMessage];
}

#pragma mark - private

-(void)showMessage
{
    if ([USERDefaults boolForKey:@"isLogin"]) {
        self.heightLabel.text = [NSString stringWithFormat:@"%ldcm",[[USERDefaults objectForKey:@"height"] integerValue]];
        self.weightLabel.text = [NSString stringWithFormat:@"%ldkg",[[USERDefaults objectForKey:@"weight"] integerValue]];
        self.taskStepNumLabel.text = [NSString stringWithFormat:@"%ld步",_stepNum];
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGHEAD,[USERDefaults objectForKey:@"PHOTO"]]] placeholderImage:[UIImage imageNamed:@"caidanlan_icon_moren.png"]];
        self.nickNameLabel.text = [USERDefaults objectForKey:@"userName"];
        NSLog(@"%@",[USERDefaults objectForKey:@"userName"]);
        self.sexLabel.text = [NSString stringWithFormat:@"性别:%@",[[USERDefaults objectForKey:@"SEX"] integerValue]==1?@"男":@"女"];
        
        NSString* title_url = [USERDefaults objectForKey:@"title_url"];
        NSString* title_name = [USERDefaults objectForKey:@"title_name"];
        if (title_url) {
            [_junxianView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGHEAD,title_url]] placeholderImage:[UIImage imageNamed:@""]];
        }
        if (title_name) {
            _sexLabel.text = title_name;
        }
    }
    
}

#pragma mark - xib

- (IBAction)orderBtn:(UIButton *)sender {
    
    myPolicyViewController* policy = [[myPolicyViewController alloc]init];
    [self.navigationController pushViewController:policy animated:YES];
    
}

- (IBAction)integralBtn:(UIButton *)sender {
    
//    [JKToast showWithText:@"敬请期待"];
    
//    [self.view makeToast:@"敬请期待"];
    integralViewController* integral = [[integralViewController alloc]init];
    [self.navigationController pushViewController:integral animated:YES];
    
}

- (IBAction)signInBtn:(UIButton *)sender {
    
    signInViewController* sign = [[signInViewController alloc]init];
    [self.navigationController pushViewController:sign animated:YES];
    
}

- (IBAction)setUpBtn:(UIButton *)sender {
    
    
    setUpViewController* setup = [[setUpViewController alloc]init];
    [self.drawer.navigationController pushViewController:setup animated:YES];
    
}

- (IBAction)backBtn:(UIButton *)sender {
    
    [self.drawer close];
    
}
@end
