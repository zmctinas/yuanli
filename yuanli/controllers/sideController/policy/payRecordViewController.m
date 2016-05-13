//
//  payRecordViewController.m
//  yuanli
//
//  Created by daimangkeji on 16/5/10.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "payRecordViewController.h"
#import "policyRecordViewController.h"

@interface payRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _tableSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation payRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买记录";
    _tableSource = [NSMutableArray array];
    
    [self registercell];
    [self requestMessage];
    
    [FrameSize MLBFrameSize:self.view];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)registercell
{
//    UINib* nib = []
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listcell"];
}

-(void)requestMessage
{
    NSDictionary* dic = @{@"service":TradeList_IF,
                          
                          @"user_id":UID,
                          
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSDictionary* data = requestDic[@"data"];
        NSNumber* code = data[@"code"];
        if ([code isEqualToNumber:@1]) {
            NSArray* arr = data[@"data"];
            [_tableSource addObjectsFromArray:arr];
            [_tableView reloadData];
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"listcell" forIndexPath:indexPath];
    
    NSDictionary* dic = _tableSource[indexPath.row];
    
    cell.textLabel.text = dic[@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = _tableSource[indexPath.row];
    policyRecordViewController* policy = [[policyRecordViewController alloc]init];
    policy.title = dic[@"title"];
    policy.listID = dic[@"id"];
    [self.navigationController pushViewController:policy animated:YES];
    
}


@end
