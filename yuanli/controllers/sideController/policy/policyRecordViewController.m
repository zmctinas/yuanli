//
//  policyRecordViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/18.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "policyRecordViewController.h"
#import "policyTableViewCell.h"
#import "policyDetailViewController.h"
#import "policyModel.h"

@interface policyRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* _tableSource;
}
@property(strong,nonatomic)UIBarButtonItem* leftItem;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation policyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"活动记录";
    _tableSource = [NSMutableArray array];
    
    [FrameSize MLBFrameSize:self.view];
    
//    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width , 15)];
    
    [self registercell];
    
    [self requestMessage];
    
    _tableView.tableFooterView = [[UIView alloc]init];
    
    if (_isRootPush) {
        self.navigationItem.leftBarButtonItem = self.leftItem;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

-(UIBarButtonItem*)leftItem
{
    
    if (_leftItem == nil) {
        
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn setImage:[UIImage imageNamed:@"top_btn_fanhui.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _leftItem;
}

#pragma mark - private

-(void)backBtn:(UIButton*)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)registercell
{
    UINib* policy = [UINib nibWithNibName:@"policyTableViewCell" bundle:nil];
    [_tableView registerNib:policy forCellReuseIdentifier:@"policycell"];
}

-(void)requestMessage
{
    
    NSDictionary* dic = @{@"service":TradeUpList_IF,
                          
                          @"user_id":UID,
                          @"id":_listID,
                          @"pages":@"1",
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        NSArray* data = requestDic[@"data"][@"data"];
        for (NSDictionary* dic in data) {
            policyModel* model = [[policyModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        [_tableView reloadData];
//        for (NSString* str in [requestDic[@"data"][@"data"] allKeys]) {
//            NSLog(@"%@  %@",str,[requestDic[@"data"][@"data"]objectForKey:str]);
//        }
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
    
    policyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"policycell" forIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.policyModel = _tableSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FrameSize proportionWidth]*80;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    policyModel* model = _tableSource[indexPath.row];
    policyDetailViewController* detail = [[policyDetailViewController alloc]init];
    detail.tradeNo = model.out_trade_no;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
