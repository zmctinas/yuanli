
//
//  integralViewController.m
//  yuanli
//
//  Created by daimangkeji on 16/5/12.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "integralViewController.h"
#import "integralTableViewCell.h"
#import "HTTPRequest.h"
#import "integralModel.h"
#import "inteheadView.h"
#import "scoreRuleViewController.h"

@interface integralViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _tableSource;
    inteheadView* headView;
}

@property(strong,nonatomic)UIBarButtonItem* rightItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation integralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分";
    _tableSource = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [self registerCell];
    
    [FrameSize MLBFrameSize:self.view];
    
    headView = [[NSBundle mainBundle]loadNibNamed:@"inteheadView" owner:self options:nil][0];
    headView.frame = CGRectMake(0, 0, headView.frame.size.width*[FrameSize proportionWidth], headView.frame.size.height*[FrameSize proportionWidth]);
    [FrameSize MLBFrameSize:headView];
    self.tableView.tableHeaderView = headView;
    
    
    
    [self requestMessage];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarButtonItem*)rightItem
{
    if (!_rightItem) {
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn setTitle:@"规则" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn addTarget:self action:@selector(touchRrghtItem:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}

#pragma mark - private

-(void)refreshUI:(NSDictionary*)dic
{
    headView.nameLabel.text = dic[@"title_name"];
    headView.integralLabel.text = [NSString stringWithFormat:@"积分%@",dic[@"score_points"]];
    [headView.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGHEAD,dic[@"actor_url"]]] placeholderImage:[UIImage imageNamed:@""]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",IMGHEAD,dic[@"actor_url"]]);
}

-(void)touchRrghtItem:(UIButton*)sender
{
    scoreRuleViewController* rule = [[scoreRuleViewController alloc]init];
    [self.navigationController pushViewController:rule animated:YES];
}

-(void)requestMessage
{
    NSDictionary* dic = @{
                          @"service":GETSCORE_IF,
                          @"user_id":UID,
                          @"pages":@"1",
                          
                          };
    
    [HTTPRequest  requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        
        NSLog(@"%@",requestDic);
        
        NSDictionary* data = requestDic[@"data"];
        NSNumber* code = data[@"code"];
        if ([code isEqualToNumber:@1]) {
            NSDictionary* reqDic = data[@"data"];
            NSArray* list = reqDic[@"list"];
            NSDictionary* info = reqDic[@"info"];
            [self refreshUI:info];
            NSString* totalYear = @"";
            for (NSDictionary* dic in list) {
                
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate* date = [dateFormatter dateFromString:dic[@"date"]];
//                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date  timeIntervalSince1970]];
                
                NSDateFormatter* yearFormatter = [[NSDateFormatter alloc]init];
                [yearFormatter setDateFormat:@"yyyy"];
                NSString* year = [yearFormatter stringFromDate:date];
                
                NSDateFormatter* dayFormatter = [[NSDateFormatter alloc]init];
                [dayFormatter setDateFormat:@"MM.dd"];
                NSString* day = [dayFormatter stringFromDate:date];
                integralModel* model = [[integralModel alloc]init];
                if (![totalYear isEqualToString:year]) {
                    model.year = year;
                    totalYear = year;
                }
                model.day = day;
                model.score = dic[@"score"];
                [_tableSource addObject:model];
            }
            
            integralModel* model = [_tableSource lastObject];
            model.isEnd = YES;
            
            [_tableView reloadData];
        NSLog(@"%@",requestDic[@"msg"]);
        }
    } Falsed:^(NSError *error) {
        
    }];
    
}



-(void)registerCell
{
    UINib* nib = [UINib nibWithNibName:@"integralTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"integralcell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    integralTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"integralcell" forIndexPath:indexPath];
    cell.model = _tableSource[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43*[FrameSize proportionWidth];
}

@end
