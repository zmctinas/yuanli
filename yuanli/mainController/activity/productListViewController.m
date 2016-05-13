//
//  productListViewController.m
//  yuanli
//
//  Created by daimangkeji on 16/5/9.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "productListViewController.h"
#import "productListTableViewCell.h"
#import "productModel.h"
#import "activityViewController.h"

@interface productListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _tableSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation productListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableSource = [NSMutableArray array];
    self.title = @"原力健身卡";
    
    [self registercell];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    
    [FrameSize MLBFrameSize:self.view];
    
    [self getActivityMessage];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"productListTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"productcell"];
}

//获取产品信息
-(void)getActivityMessage
{
    NSDictionary* dic = @{@"service":ACTIVITY_IF,
                          
                          @"big":[NSNumber numberWithInt:0],
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        
        NSDictionary* data = requestDic[@"data"];
        
        NSNumber* code = data[@"code"];
        
        if ([code isEqualToNumber:@1]) {
            NSArray* arr = data[@"data"];
            for (NSDictionary* dic in arr) {
                productModel* model = [[productModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_tableSource addObject:model];
            }
            
            [_tableView reloadData];

        }else
        {
            
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
    
    productListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"productcell" forIndexPath:indexPath];
    
    cell.model = _tableSource[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(200);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    activityViewController* activity = [[activityViewController alloc]init];
    
    activity.model = _tableSource[indexPath.row];
    
    [self.navigationController pushViewController:activity animated:YES];
}


@end
