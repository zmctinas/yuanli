//
//  personViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/14.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "personViewController.h"

@interface personViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger sex;
    UIImage* headImage;
    
}

@property(strong,nonatomic)UIBarButtonItem* rightItem;
@property(strong,nonatomic) UIImagePickerController* imagePicker;

@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *heightLabel;
@property (strong, nonatomic) IBOutlet UITextField *weightLabel;
@property (strong, nonatomic) IBOutlet UITextField *nickNameLabel;

- (IBAction)sexBtn:(UIButton *)sender;
- (IBAction)saveBtn:(UIButton *)sender;
- (IBAction)goBackBtn:(UIButton *)sender;


@end

@implementation personViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"个人资料";
//    self.navigationItem.rightBarButtonItem = self.rightItem;
    
//    [CrazyAutoLayout layoutOfSuperView:self.view];
    [FrameSize MLBFrameSize:self.view];
    
    UIScrollView* scroll = (UIScrollView*)[self.view viewWithTag:230103];
    if (scroll) {
        scroll.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height/2;
    self.iconView.layer.masksToBounds = YES;
    
    [self addheadImageAction];
    [self getuserMessage];
    
    [self setUpUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - private

-(void)setUpUI
{
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width/2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.masksToBounds = YES;
}

-(void)touchRightItem:(UIButton*)sender
{
    if (self.nickNameLabel.text.length>0) {
        if (self.heightLabel.text.length>0&&self.weightLabel.text.length>0) {
            if (headImage) {
                NSDictionary* dic = @{@"service":UpDateUserInfo_IF,
                                      
                                      @"user_id":UID,
                                      @"user_name":self.nickNameLabel.text,
                                      @"height":self.heightLabel.text,
                                      @"weight":self.weightLabel.text,
                                      @"sex":[NSNumber numberWithInteger:sex],
                                      @"photo":@"photo",
                                      };
                //    NSDictionary* imageDic = @{@"headImage":headImage};
                //
                //    [HTTPRequest CrazyHttpFileUpload:HEADURL imageDic:imageDic Argument:dic  HUD:NO block:^(NSDictionary *dic, NSString *url, NSString *Json) {
                //
                //        NSLog(@"%@",dic);
                //        NSLog(@"%@",dic[@"msg"]);
                //
                //    } fail:^(NSError *error, NSString *url) {
                //        NSLog(@"%@",error.localizedDescription);
                //        NSLog(@"%@",error.localizedFailureReason);
                //        NSLog(@"%@",url);
                //    }];
                
                AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/json"];
                [manager POST:HEADURL parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSData *imageData= UIImageJPEGRepresentation(headImage, 0.3);
                    NSLog(@"%@",headImage);
                    [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.jpg"  mimeType:@"image/jpg"];
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    NSLog(@"%@",uploadProgress);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"%@",dic);
                    NSLog(@"%@",dic[@"msg"]);
                    NSLog(@"%@",dic[@"data"][@"msg"]);
                    NSDictionary* data = dic[@"data"][@"data"];
                    
                    if ([dic[@"data"][@"code"] isEqualToNumber:@1]) {
                        [USERDefaults setObject:data[@"photo"] forKey:@"PHOTO"];
                        [USERDefaults setObject:self.nickNameLabel.text forKey:@"userName"];
                        [USERDefaults setObject:self.heightLabel.text forKey:@"height"];
                        [USERDefaults setObject:self.weightLabel.text forKey:@"weight"];
                        [USERDefaults setObject:[NSNumber numberWithInteger:sex] forKey:@"SEX"];
                        [USERDefaults synchronize];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
            }else
            {
                
                NSDictionary* dic = @{@"service":UpDateUserInfo_IF,
                                      
                                      @"user_id":UID,
                                      @"user_name":self.nickNameLabel.text,
                                      @"height":self.heightLabel.text,
                                      @"weight":self.weightLabel.text,
                                      @"sex":[NSNumber numberWithInteger:sex],
                                      
                                      };
                [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
                    NSLog(@"%@",requestDic);
                    NSLog(@"%@",requestDic[@"data"][@"msg"]);
                    NSDictionary* data = requestDic[@"data"][@"data"];
                    NSLog(@"%@",data);
                    //            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    //            NSLog(@"%@",dic);
                    //            NSLog(@"%@",dic[@"msg"]);
                    //            NSLog(@"%@",dic[@"data"][@"msg"]);
                    //            NSDictionary* data = dic[@"data"][@"data"];
                    //            [USERDefaults setObject:data[@"photo"] forKey:@"PHOTO"];
                    if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
                        [USERDefaults setObject:self.nickNameLabel.text forKey:@"userName"];
                        [USERDefaults setObject:self.heightLabel.text forKey:@"height"];
                        [USERDefaults setObject:self.weightLabel.text forKey:@"weight"];
                        [USERDefaults setObject:[NSNumber numberWithInteger:sex] forKey:@"SEX"];
                        [USERDefaults synchronize];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                } Falsed:^(NSError *error) {
                    
                }];
                
            }
        }else
        {
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"身高体重不可为空" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
    }else
    {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"昵称不可为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
    
    
}

-(void)getuserMessage
{
    NSDictionary* dic = @{@"service":GetUserInfo_IF,
                          
                          @"user_id":UID,
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        NSDictionary* data = requestDic[@"data"][@"data"];
        [USERDefaults setObject:[data[@"ali_pay"] isKindOfClass:[NSString class]]?data[@"ali_pay"]:@"" forKey:@"ali_pay"];
        [USERDefaults setObject:[data[@"wei_pay"] isKindOfClass:[NSString class]]?data[@"wei_pay"]:@"" forKey:@"wei_pay"];
        [USERDefaults synchronize];
        _nickNameLabel.text = data[@"user_name"];
        _heightLabel.text = [NSString stringWithFormat:@"%ld",[data[@"height"] integerValue]];
        _weightLabel.text = [NSString stringWithFormat:@"%ld",[data[@"weight"] integerValue]];
        UIButton* btn;
        if ([data[@"sex"] integerValue]) {
            btn = (UIButton*)[self.view viewWithTag:11];
        }else
        {
            btn = (UIButton*)[self.view viewWithTag:10];
        }
        sex = [data[@"sex"] integerValue];
        [self sexBtn:btn];
        
        [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGHEAD,data[@"photo"]]] placeholderImage:[UIImage imageNamed:@"caidanlan_icon_moren.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            headImage = image;
        }];
        if ([data[@"photo"] isKindOfClass:[NSString class]]) {
            [USERDefaults setObject:data[@"photo"] forKey:@"PHOTO"];
            [USERDefaults synchronize];
        }
        
        
        
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)changephoto:(UIImage*)image
{
    _iconView.image = image;
    headImage = image;
}

-(void)addheadImageAction
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchHeadImage:)];
    [_iconView addGestureRecognizer:tap];
}

-(void)touchHeadImage:(UITapGestureRecognizer*)tap
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"请选择方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
    
}

#pragma mark - getter

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 40, 20);
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchRightItem:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return  _rightItem;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(changephoto:) withObject:orgImage afterDelay:0.1];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)sexBtn:(UIButton *)sender {
    
    sender.selected = YES;
    sex = sender.tag - 10;
    UIButton* btn;
    if (sender.tag == 11) {
        btn = (UIButton*)[self.view viewWithTag:10];
    }else
    {
        btn = (UIButton*)[self.view viewWithTag:11];
    }
    btn.selected = NO;
    
}

- (IBAction)saveBtn:(UIButton *)sender {
    
    [self touchRightItem:nil];
    
}

- (IBAction)goBackBtn:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
