//
//  withdrawalRecordViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/18.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "withdrawalRecordViewController.h"
#import "withdrawalTableViewCell.h"
#import "withdrawalModel.h"

@interface withdrawalRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _tableSource;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)UIBarButtonItem* leftItem;

@end

@implementation withdrawalRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableSource = [NSMutableArray array];
    self.title = @"领取记录";
    _tableView.tableFooterView = [[UIView alloc]init];
    [FrameSize MLBFrameSize:self.view];
    [self registercell];
    [self requestMessage];
    
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
        [btn setImage:[UIImage imageNamed:@"arrowleftwhite"] forState:UIControlStateNormal];
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

-(void)requestMessage
{
    
    NSDictionary* dic = @{@"service":Takecash_IF,
                          
                          @"user_id":UID,
                          @"pages":@"1",
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        NSArray* data = requestDic[@"data"][@"data"];
        for (NSDictionary* dic in data) {
            withdrawalModel* model = [[withdrawalModel alloc]init];
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

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"withdrawalTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"drawalcell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    withdrawalTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"drawalcell" forIndexPath:indexPath];
    cell.model = _tableSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140*[FrameSize proportionWidth];
}

#pragma mark - UITableViewDelegate
@end
