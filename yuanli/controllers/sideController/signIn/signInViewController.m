//
//  signInViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/22.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "signInViewController.h"
#import "signView.h"
#import "dateItem.h"

@interface signInViewController ()
{
    NSMutableArray* _tableSource;
    signView* siView;
    NSInteger beginDay;
}

@property (strong, nonatomic) IBOutlet UIView *backView;


@end

@implementation signInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签到";
    _tableSource = [NSMutableArray array];
    
    siView = [[NSBundle mainBundle]loadNibNamed:@"signView" owner:self options:nil][0];
    siView.frame = CGRectMake(10, 0, 300, 380);
    [self.backView addSubview:siView];
    
    CellDateModel *cellDateModel = [DateTools dateToCell:3];
    
    siView.dateLabel.text = [NSString stringWithFormat:@"%ld年%ld月",cellDateModel.year,cellDateModel.month];
    
    beginDay = cellDateModel.beginWeekDay-1;
    NSLog(@"%ld",(long)beginDay);
    
    for (int i = 0; i<cellDateModel.dateModelArray.count+cellDateModel.beginWeekDay-1; i++) {
        if (i<cellDateModel.beginWeekDay-1) {
            dateItem* item = [[dateItem alloc]initWithFrame:CGRectMake(8+(32+10)*(i%7), (0+50)*(i/7), 32, 50) andDateString:@"" andLunarDay:@"" andItemStatus:WXSignInUnSign];
            item.tag = i+10;
            [siView.datelistView addSubview:item];
        }else
        {
            DateModel* model = cellDateModel.dateModelArray[i-(cellDateModel.beginWeekDay-1)];
            dateItem* item = [[dateItem alloc]initWithFrame:CGRectMake(8+(32+10)*(i%7), (0+50)*(i/7), 32, 50) andDateString:[NSString stringWithFormat:@"%ld",model.day] andLunarDay:model.lunarDay andItemStatus:WXSignInUnSign];
            item.tag = i+10;
            [siView.datelistView addSubview:item];
        }
    }
    
    [FrameSize MLBFrameSize:self.view];
    
    UIScrollView* scroll = (UIScrollView*)[self.view viewWithTag:230103];
    if (scroll) {
        scroll.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    
    [self getSignInMessage];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getSignInMessage
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* curentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary* dic = @{@"service":GETSIGN_IF,
                          @"user_id":UID,
                          @"date":curentDateStr,
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"data"][@"msg"]);
        
        _tableSource = requestDic[@"data"][@"data"];
        
        for (NSDictionary* dic in _tableSource) {
            NSString* date = dic[@"date"];
            dateItem* item = (dateItem*)[siView.datelistView viewWithTag:[date integerValue]+10-1 + beginDay];
            item.ItemSatus = WXSignInSigned;
        }
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd"];
        NSString* curentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        
        dateItem* item = (dateItem*)[siView.datelistView viewWithTag:[curentDateStr integerValue]+10-1 + beginDay];
        item.ItemSatus = WXSignInSigning;
        
    } Falsed:^(NSError *error) {
        
    }];
}

@end
