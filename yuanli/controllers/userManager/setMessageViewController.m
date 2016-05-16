//
//  setMessageViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/4.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "setMessageViewController.h"

@interface setMessageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger sex;
    UIImage* headImage;
}

@property(strong,nonatomic) UIImagePickerController* imagePicker;

@property (strong, nonatomic) IBOutlet UIImageView *iconView;

@property(strong,nonatomic)UIBarButtonItem* rightItem;
@property (strong, nonatomic) IBOutlet UITextField *nickName;
@property (strong, nonatomic) IBOutlet UITextField *heightLabel;
@property (strong, nonatomic) IBOutlet UITextField *weightLabel;

@property (strong, nonatomic) IBOutlet UIButton *manBtn;
@property (strong, nonatomic) IBOutlet UIButton *womanBtn;


- (IBAction)sexBtn:(UIButton *)sender;
- (IBAction)zhuceBtn:(UIButton *)sender;

- (IBAction)backBtn:(UIButton *)sender;



@end

@implementation setMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    sex = 1;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.manBtn.selected = YES;

//    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    
    [FrameSize MLBFrameSize:self.view];
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height/2;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconView.layer.borderWidth = 2;
    
    [self addheadImageAction];
    
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

#pragma mark - pirvate

-(void)changephoto:(UIImage*)image
{
    _iconView.image = image;
    headImage = image;
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

-(void)addheadImageAction
{
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = _iconView.frame.size.width/2;
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 2;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchHeadImage:)];
    [_iconView addGestureRecognizer:tap];
}

-(void)touchRightItem:(UIButton*)button
{
    if (self.nickName.text.length>0) {
        if (self.heightLabel.text.length>0&&self.weightLabel.text.length>0) {
            
            
            if (headImage) {
                NSDictionary* dic = @{@"service":REGISTER_IF,
                                      @"user_name":self.nickName.text,
                                      @"phone_number":self.mobile,
                                      @"password":[MyMD5 md32:self.password],
                                      @"height":[NSNumber numberWithFloat:[self.heightLabel.text floatValue]],
                                      @"weight":[NSNumber numberWithFloat:[self.weightLabel.text floatValue]],
                                      
                                      @"sex":[NSNumber numberWithInteger:sex],
                                      @"photo":@"photo",
                                      };
                NSMutableDictionary* messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                if (RegistrationID) {
                    [messageDic setObject:@"registration_id" forKey:RegistrationID];
                }
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
                [manager POST:HEADURL parameters:messageDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSData *imageData= UIImageJPEGRepresentation(headImage, 0.3);
                    NSLog(@"%@",headImage);
                    [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.jpg"  mimeType:@"image/jpg"];
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    NSLog(@"%@",uploadProgress);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"%@",dic);
                    NSLog(@"%@",dic[@"data"][@"msg"]);
                    NSDictionary* data = dic[@"data"][@"data"];
                    
                    if ([dic[@"data"][@"code"] isEqualToNumber:@1]) {
                        [USERDefaults setObject:data[@"photo"] forKey:@"PHOTO"];
                        [USERDefaults setObject:self.password forKey:@"PSD"];
                        [USERDefaults setObject:self.mobile forKey:@"Mobile"];
                        [USERDefaults setObject:data[@"user_id"] forKey:@"UID"];
                        [USERDefaults setObject:data[@"sex"] forKey:@"SEX"];
                        [USERDefaults setObject:data[@"user_name"] forKey:@"userName"];
                        [USERDefaults setObject:data[@"height"] forKey:@"height"];
                        [USERDefaults setObject:data[@"weight"] forKey:@"weight"];
                        [USERDefaults setBool:YES forKey:@"isLogin"];
                        [USERDefaults synchronize];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else if([dic[@"data"][@"code"] isEqualToNumber:@0])
                    {
                        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            UIViewController* viewcontroller = self.navigationController.viewControllers[1];
                            [self.navigationController popToViewController:viewcontroller animated:YES];
                        }];
                        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:action];
                        [self presentViewController:alertController animated:YES completion:^{
                            
                        }];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
            }
            else{
                NSDictionary* dic = @{@"service":REGISTER_IF,
                                      @"user_name":self.nickName.text,
                                      @"phone_number":self.mobile,
                                      @"password":[MyMD5 md32:self.password],
                                      @"height":[NSNumber numberWithFloat:[self.heightLabel.text floatValue]],
                                      @"weight":[NSNumber numberWithFloat:[self.weightLabel.text floatValue]],
                                      
                                      @"sex":[NSNumber numberWithInteger:sex],
                                      };
                NSMutableDictionary* messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                if (RegistrationID) {
                    [messageDic setObject:@"registration_id" forKey:RegistrationID];
                }
                
                [HTTPRequest requestWitUrl:@"" andArgument:messageDic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
                    NSLog(@"%@",requestDic);
                    NSDictionary* dic = requestDic[@"data"];
                    if ([dic[@"code"] isEqualToNumber:@1]) {
                        NSLog(@"登陆成功");
                        NSDictionary* data = dic[@"data"];
                        
                        [USERDefaults setObject:self.password forKey:@"PSD"];
                        [USERDefaults setObject:self.mobile forKey:@"Mobile"];
                        [USERDefaults setObject:data[@"user_id"] forKey:@"UID"];
                        [USERDefaults setObject:data[@"sex"] forKey:@"SEX"];
                        [USERDefaults setObject:data[@"user_name"] forKey:@"userName"];
                        [USERDefaults setObject:data[@"height"] forKey:@"height"];
                        [USERDefaults setObject:data[@"weight"] forKey:@"weight"];
                        [USERDefaults setBool:YES forKey:@"isLogin"];
                        [USERDefaults setObject:@"0" forKey:@"WXStepCount"];
                        [USERDefaults setObject:@"0" forKey:@"toDayStepNum"];
                        [USERDefaults synchronize];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }else if([dic[@"code"] isEqualToNumber:@0])
                    {
                        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            UIViewController* viewcontroller = self.navigationController.viewControllers[1];
                            [self.navigationController popToViewController:viewcontroller animated:YES];
                            }];
                        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:action];
                        [self presentViewController:alertController animated:YES completion:^{
                            
                        }];
                    }
                    
                    NSLog(@"%@",requestDic[@"msg"]);
                    
                } Falsed:^(NSError *error) {
                    
                }];
            }
            
        }else
        {
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入身高以及体重" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
    }else
    {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入昵称" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - getter

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchRightItem:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}

- (IBAction)sexBtn:(UIButton *)sender {
    
    sender.selected = YES;
    if (sender.tag == self.manBtn.tag) {
        sex = 1;
        self.womanBtn.selected = NO;
    }else
    {
        self.manBtn.selected = NO;
        sex = 0;
    }
    
}

- (IBAction)zhuceBtn:(UIButton *)sender {
    
    [self touchRightItem:nil];
    
}

- (IBAction)backBtn:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *orgImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(changephoto:) withObject:orgImage afterDelay:0.1];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

@end
