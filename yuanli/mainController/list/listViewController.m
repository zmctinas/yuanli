//
//  listViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/7.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "listViewController.h"
#import "listModel.h"
#import "listTableViewCell.h"
#import "listHeadView.h"

#import "BillboardViewController.h"

@interface listViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)UISegmentedControl* titleView;
@property(strong,nonatomic)UIBarButtonItem* rightItem;

@end

@implementation listViewController
{
    NSMutableArray* _tableSource;
    NSMutableDictionary* messageDic;
    NSDictionary* my_info;
    NSInteger pages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"排行榜";
    
    _tableSource = [NSMutableArray array];
    messageDic = [NSMutableDictionary dictionary];
//    self.navigationItem.titleView = self.titleView;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    pages = 1;
    
    
    [FrameSize MLBFrameSize:self.view];
    
    [self registerCell];
    [self addFresh];
    [self requestData];
    
//    [self.view addSubview:self.titleView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 25, 25);
        [btn setBackgroundImage:[UIImage imageNamed:@"arrowshare"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchRightItem:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return  _rightItem;
}

-(UISegmentedControl*)titleView
{
    if (_titleView == nil) {
        _titleView = [[UISegmentedControl alloc]initWithItems:@[@"今日",@"本周"]];
        _titleView.frame = CGRectMake(0, 0, 100, 30);
        _titleView.selectedSegmentIndex = 0;
        _titleView.tintColor = [UIColor colorWithHexString:@"#ffa45b"];
    }
    return _titleView;
}

#pragma mark - private

-(void)loadMoreData
{
    [self requestData];
}

-(void)addFresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 禁止自动加载
    footer.automaticallyRefresh = NO;
    
    // 设置footer
    self.tableView.mj_footer = footer;
}

-(void)touchRightItem:(UIButton*)btn
{
    
    BillboardViewController* billboard = [[BillboardViewController alloc]init];
    billboard.messageDic = my_info;
    billboard.modalPresentationStyle = UIModalPresentationOverFullScreen;
    billboard.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:billboard animated:NO completion:^{
//        [billboard addAnimotion];
    }];
    
//    NSArray* imageArray = @[[UIImage imageNamed:@"1024@2x.png"]];
////    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.daimang.com/Public/yuanli/share.php?user_id=%@&date=%@",UID,curentDateStr]]
//                                          title:@"分享标题"
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
////        要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//    
//        [ShareSDK showShareActionSheet:nil
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
                       
//                   }
//         ];}
}

-(void)requestData
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* curentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary* dic = @{@"service":LIST_IF,
                          @"user_id":UID,
                          @"date"   :curentDateStr,
                          @"pages"  :[NSNumber numberWithInteger:pages],
                          };
    
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSDictionary* dic = requestDic[@"data"];
        
        if ([dic[@"code"] isEqualToNumber:@1]) {
            
            NSDictionary* data = dic[@"data"];
            NSArray* order = data[@"order"];
            if (order.count) {
                pages++;
            }
            for (NSDictionary* dic in order) {
                listModel* model = [[listModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_tableSource addObject:model];
            }
            my_info = data[@"my_info"];
            [self.tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)registerCell
{
    UINib* listcell = [UINib nibWithNibName:@"listTableViewCell" bundle:nil];
    [_tableView registerNib:listcell forCellReuseIdentifier:@"listCell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    listTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    listModel* model = _tableSource[indexPath.row];
    cell.tag = indexPath.row;
    cell.listModel = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(80);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT(160);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    listHeadView* headView = [[NSBundle mainBundle]loadNibNamed:@"listHeadView" owner:self options:0][0];
    if (my_info) {
        headView.messageDic = my_info;
    }
    
    return headView;
}

@end
