//
//  WXMainViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/4.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "WXMainViewController.h"
#import <HealthKit/HealthKit.h>
#import "WXLoginViewController.h"
#import "listViewController.h"
#import "headDateView.h"
#import "DACircularProgressView.h"
#import "activityViewController.h"
#import "signViewController.h"
#import "sideViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "productListViewController.h"

#import "setMessageViewController.h"


#import "signInViewController.h"

#define stepLenth 50


@interface WXMainViewController ()
{
    NSInteger taskStepNum;//任务步数
    BOOL isToday;//是否是今天
    BOOL isFirstLog;//是否是初次加载
    BOOL isHealthKit;//是否使用healthkit
    NSInteger baseLine;//是否添加步数基准线
    //向量计步
    CMMotionManager *motionManager;
    CADisplayLink *displayLink;
    BOOL valiadCountStep; // 用于控制开关步数的控制
    
    NSTimer* timer;//healthkit记步计时器；
    
    NSInteger currentStepNum;
}




@property (weak, nonatomic) IBOutlet UIView *productBackView;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;

- (IBAction)sexButton:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet headDateView *dateView;

@property (strong, nonatomic) IBOutlet UILabel *lengLabel;
@property (strong, nonatomic) IBOutlet UILabel *hotLabel;
@property (strong, nonatomic) IBOutlet UILabel *stepNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskLabel;
@property (strong, nonatomic) IBOutlet UIImageView *maiwanImage;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImage;
@property (strong, nonatomic) IBOutlet UILabel *airLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel;
@property (strong, nonatomic) IBOutlet DACircularProgressView *processView;
@property(strong,nonatomic)CMStepCounter* stepCounter;
@property (strong, nonatomic) IBOutlet UIButton *gobuyBtn;
@property (strong, nonatomic) IBOutlet UILabel *dateTitleLabel;


- (IBAction)leftMenuBtn:(UIButton *)sender;
- (IBAction)listBtn:(UIButton *)sender;
- (IBAction)gobuyBtn:(UIButton *)sender;


@end

@implementation WXMainViewController

-(void)dealloc
{
    [timer invalidate];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"今天";
    
    [self getTotalDay];
    
    isHealthKit = NO;
    [self dealwithData];
    
//    [CrazyAutoLayout layoutOfSuperView:self.view];
    
    [FrameSize MLBFrameSize:self.view];
    
    UIScrollView* scroll = (UIScrollView*)[self.view viewWithTag:230103];
    if (scroll) {
        scroll.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    
    [self addtimeBtn];
    
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.gobuyBtn.layer.cornerRadius = 10;
    self.gobuyBtn.layer.masksToBounds = YES;
    
    _processView.progressTintColor = [UIColor colorWithHexString:@"#d82b2b"];
    _processView.trackTintColor = [UIColor colorWithHexString:@"#eeeeee"];
    
//    [_processView setProgress:0.3 animated:YES initialDelay:10];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self initUI];
    
//
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
    
    if ([USERDefaults boolForKey:@"isLogin"]) {
        if (!isFirstLog) {
            [self getActivityMessage];
            [self getTaskStep];
//
            [self getWeatherMessage];
            [self signIn];
            isFirstLog = YES;
        }
        [self initMainView];
        if (![USERDefaults boolForKey:@"isFirstShow"]) {
//            [self showMessage];
            
            [USERDefaults setBool:YES forKey:@"isFirstShow"];
            [USERDefaults synchronize];

        }else
        {
            
        }
        
    }else
    {
        isFirstLog = NO;
        WXLoginViewController* login = [[WXLoginViewController alloc]init];
        
        [self.navigationController pushViewController:login animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 向量

- (void)startDisplayLink
{
    [displayLink invalidate];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
    [displayLink setFrameInterval:60];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    displayLink.paused = YES;
}

- (void)stopDisplayLink
{
    
}

- (void)onDisplayLink:(id)sender
{
    displayLink.paused = YES;
    valiadCountStep = YES;
}

- (void)startDeviceMotion
{
    [motionManager stopMagnetometerUpdates];
    motionManager = [[CMMotionManager alloc] init];
    motionManager.showsDeviceMovementDisplay = YES;
    motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
}

- (void)startUpdateAccelerometer
{
    /* 设置采样的频率，单位是秒 */
    NSTimeInterval updateInterval = 0.05; // 每秒采样20次
    
    //    CGSize size = [self superview].frame.size;
    //	__block CGRect f = [self frame];
    __block int stepCount = 0; // 步数
    //在block中，只能使用weakSelf。
    /* 判断是否加速度传感器可用，如果可用则继续 */
    if ([motionManager isAccelerometerAvailable] == YES) {
        /* 给采样频率赋值，单位是秒 */
        [motionManager setAccelerometerUpdateInterval:updateInterval];
        
        [motionManager startAccelerometerUpdates];
        //        CMAccelerometerData *newestAccel = motionManager.accelerometerData;
        //        CGFloat sqrtValue =sqrt(newestAccel.acceleration.x*newestAccel.acceleration.x+newestAccel.acceleration.y*newestAccel.acceleration.y+newestAccel.acceleration.z*newestAccel.acceleration.z);
        //        NSLog(@"%f",sqrtValue);
        
        //        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(update) userInfo:nil repeats:YES];
        
        /* 加速度传感器开始采样，每次采样结果在block中处理 */
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             
             CGFloat sqrtValue =sqrt(accelerometerData.acceleration.x*accelerometerData.acceleration.x+accelerometerData.acceleration.y*accelerometerData.acceleration.y+accelerometerData.acceleration.z*accelerometerData.acceleration.z);
             
             //             if (switchBtn.isOn)
             //             {
             
             //                 self.xCureV.inputData = sqrtValue;
             
             // 走路产生的震动率
             if (sqrtValue > 1.552188 && valiadCountStep)
             {
                 displayLink.paused = NO;
                 
                 stepCount +=1;
                 NSLog(@"%d",stepCount);
                 valiadCountStep = NO;
                 
                 [self sportTeatment:stepCount];
             }
             //             }
             //             else
             //                 self.xCureV.userInteractionEnabled = NO;
             
         }];
    }
    
}

#pragma mark - private

-(void)initUI
{
    self.productBackView.layer.borderWidth = 3;
    self.productBackView.layer.borderColor = [UIColor colorWithHexString:@"#d82b2b"].CGColor;
    self.productBackView.layer.cornerRadius = 8;
    self.productBackView.layer.masksToBounds = YES;
    
    self.gobuyBtn.layer.borderWidth = 2;
    self.gobuyBtn.layer.borderColor = [UIColor colorWithHexString:@"#d82b2b"].CGColor;
    self.gobuyBtn.layer.cornerRadius = 4;
    self.gobuyBtn.layer.masksToBounds = YES;
}

-(void)getTotalDay
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* curentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [USERDefaults setObject:curentDateStr forKey:@"NowDate"];
    [USERDefaults synchronize];
}

-(void)initMainView
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM dd"];
    NSString* curentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",curentDateStr);
    NSLog(@"%@",[USERDefaults objectForKey:@"NowDate"]);
    if (![curentDateStr isEqualToString:[USERDefaults objectForKey:@"NowDate"]]) {
    
        [self addtimeBtn];
        [USERDefaults setObject:curentDateStr forKey:@"NowDate"];
        [USERDefaults setObject:@"0" forKey:@"toDayStepNum"];
        [USERDefaults synchronize];
        [self dealwithData];
        
        _lengLabel.text = @"0.0";
        _hotLabel.text = @"0.0";
        _stepNumLabel.text = @"0";
        
        [_processView setProgress:0.0 animated:YES];
        
    }
}

-(void)setCountStepifNeed
{
    if (![USERDefaults boolForKey:@"useHealth"]) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [USERDefaults setBool:YES forKey:@"useHealth"];
            [USERDefaults synchronize];
            [self setCountStep];
        }];
        UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"停止使用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"将要使用iPhone官方自带的‘健康’模块计步" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else
    {
        [self setCountStep];
    }
}

//-(void)dayDidChange
//{
//    [self initMainView];
//}
//
//-(void)enterForGround:(NSNotification*)userinfo
//{
//    [self initMainView];
//}

-(void)addtimeBtn
{
    for (UIView* view in self.dateView.subviews) {
        [view removeFromSuperview];
    }
    __block WXMainViewController* weakSelf = self;
    [self.dateView addItemWithBlock:^(NSInteger btnTag) {
        [weakSelf touchItem:btnTag];
    }];
}

-(void)dealwithData
{
    NSInteger count = [[USERDefaults objectForKey:@"toDayStepNum"] integerValue];
    
    baseLine = count/stepLenth;
}

-(void)touchItem:(NSInteger)btnTag
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSInteger deviation = 13-btnTag;
    NSString* curentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-deviation*24*60*60]];
    if (deviation == 0) {
        self.dateTitleLabel.text = @"今天";
        isToday = YES;
        //            [self showMessage];
        if (isHealthKit) {
            [timer setFireDate:[NSDate distantPast]];
            [self healthStepMethod];
        }else
        {
            [motionManager startAccelerometerUpdates];
            [self refreshToday:currentStepNum];
        }
        
    }else
    {
        if (isHealthKit) {
            [timer setFireDate:[NSDate distantFuture]];
            
        }else
        {
            [motionManager stopAccelerometerUpdates];
            
        }
        isToday = NO;
        NSArray* time = [curentDateStr componentsSeparatedByString:@"-"];
        NSString* day = [time lastObject];
        self.dateTitleLabel.text = [NSString stringWithFormat:@"%@日",day];
        [self getSportMessage:curentDateStr];
    }
}

-(void)addNotifition
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearData:) name:@"clearData" object:nil];
}

-(void)clearData:(NSNotification*)userInfo
{
    [USERDefaults setObject:@"0" forKey:@"WXStepCount"];
    [USERDefaults setObject:@"0" forKey:@"toDayStepNum"];
    [USERDefaults synchronize];
    [self setCountStep];
}

-(void)showMessage
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    _lengLabel.text = [NSString stringWithFormat:@"%@",[userdefaults objectForKey:@"distance"]];
    _hotLabel.text = [NSString stringWithFormat:@"%@",[userdefaults objectForKey:@"calorie"]];
    
    _stepNumLabel.text = [NSString stringWithFormat:@"%@",[userdefaults objectForKey:@"toDayStepNum"]];
    
    if (taskStepNum) {
        [_processView setProgress:0.0 animated:YES];
        [self.processView setProgress:_stepNumLabel.text.floatValue/taskStepNum animated:YES];
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
        for (NSString* str in [requestDic[@"data"][@"data"] allKeys]) {
            NSLog(@"%@  %@",str,[requestDic[@"data"][@"data"]objectForKey:str]);
        }
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)setCountStep
{
//    if ([CMStepCounter isStepCountingAvailable]) {
//        [self.stepCounter stopStepCountingUpdates];
//        self.stepCounter = [[CMStepCounter alloc]init];
//        [self.stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue currentQueue] updateOn:5 withHandler:^(NSInteger numberOfSteps, NSDate * _Nonnull timestamp, NSError * _Nullable error) {
//            
//            [self sportTeatment:numberOfSteps];
//            
//        }];
//    }else
    [self addSprotNum:1];
    BOOL enableUseHealthKit = [USERDefaults boolForKey:@"enableUseHealthKit"];
    if (enableUseHealthKit) {
        
        if([HKHealthStore isHealthDataAvailable])
        {
            
            isHealthKit = YES;
            [self healthStepMethod];
            [timer invalidate];
            timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(healthStepMethod) userInfo:nil repeats:YES];
            
        }
    }else
    {
        valiadCountStep = YES;
        [self startDeviceMotion];
        [self startUpdateAccelerometer];
        [self startDisplayLink];
    }
}

-(void)healthStepMethod
{
    [[HealthManager shareInstance] getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
        
        NSLog(@"当天行走步数 = %.2f",value);
//        [self sportTeatment:(NSInteger)value];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stepNumLabel.text = [NSString stringWithFormat:@"%ld",(long)value];
            [self refreshToday:value];
        });
        
        NSInteger totalCount = (NSInteger)value;
        
        if (baseLine<(totalCount/stepLenth)) {
            baseLine = totalCount/stepLenth;
            [self addSprotNum:totalCount];
        }
    }];
}

-(void)sportTeatment:(NSInteger)numberOfSteps
{
    self.stepNumLabel.text = [NSString stringWithFormat:@"%ld",(long)numberOfSteps+[[USERDefaults objectForKey:@"toDayStepNum"] integerValue]];
    currentStepNum = numberOfSteps+[[USERDefaults objectForKey:@"toDayStepNum"] integerValue];
    
    NSInteger totalCount = [[USERDefaults objectForKey:@"toDayStepNum"] integerValue]+numberOfSteps;
    
    if (baseLine<(totalCount/stepLenth)) {
        baseLine = totalCount/stepLenth;
        [self addSprotNum:totalCount];
    }
    
    NSLog(@"%ld",(long)totalCount);
}

-(void)addSprotNum:(NSInteger)value
{
    CGFloat length = [[USERDefaults objectForKey:@"height"] floatValue];
    CGFloat weight = [[USERDefaults objectForKey:@"weight"] floatValue];
    CGFloat step_length = 0.45* length;
    CGFloat distance,calories;
//    NSInteger value = self.stepNumLabel.text.integerValue;
    if (value % 2 == 0) {
        distance =(value/2) * 3 * step_length * 0.01;
    } else {
        distance =((value/2) * 3 + 1) * step_length * 0.01;
    }
    if (distance != 0.0) {
        // 体重、距离
        // 跑步热量（kcal）＝体重（kg）×距离（公里）×1.036
        calories = (float) (weight * distance * 0.001);
        //速度velocity
    } else {
        calories = 0.0f;
    }
    
    NSDictionary* dic = @{@"service":ADDSPORT_IF,
                          
                          @"user_id":UID,
                          @"step_num":[NSNumber numberWithInteger:value],
                          @"calorie":[NSNumber numberWithFloat:calories],
                          @"distance":[NSNumber numberWithFloat:distance/1000.0],
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            [USERDefaults setObject:[NSNumber numberWithInteger:value] forKey:@"WXStepCount"];
            
            [USERDefaults synchronize];
            
        }
        NSDictionary* dic = requestDic[@"data"][@"data"];
        if (dic) {
            NSLog(@"%@",NSStringFromClass([dic[@"profit"] class]));
            _profitLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"profit"] floatValue]];
        }
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)getTaskStep
{
    NSDictionary* dic = @{@"service":GetTaskStep_IF,
                          
                          @"user_id":UID,
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"msg"]);
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            if ([requestDic[@"data"][@"data"][@"task"]count]>0) {
                
                
                if (![[requestDic[@"data"][@"data"][@"task"] firstObject] isKindOfClass:[NSNull class]]) {
                    taskStepNum = [[requestDic[@"data"][@"data"][@"task"] firstObject] integerValue];
                    self.taskLabel.text = [NSString stringWithFormat:@"目标%@步",[requestDic[@"data"][@"data"][@"task"] firstObject]];
                }
                
                
            }
            
            [self firstSportMessage];
            
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)getActivityMessage
{
    NSDictionary* dic = @{@"service":ACTIVITY_IF,
                          
                          @"big":[NSNumber numberWithInt:1],
                          
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        if ([requestDic[@"data"][@"code"]isEqualToNumber:@1 ]) {
            NSDictionary* data = requestDic[@"data"][@"data"];
            _tipsLabel.text = data[@"tips"];
            //参加活动领取奖金
            NSString* attStr = @"参加活动领取奖金";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attStr];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8b8b8b"] range:NSMakeRange(0, 6)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffa45e"] range:NSMakeRange(6,2)];
            
            _titleLabel.attributedText = str;
        }else
        {
            _tipsLabel.text = @"敬请期待";
            //参加活动领取奖金
            NSString* attStr = @"参加活动领取奖金";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attStr];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8b8b8b"] range:NSMakeRange(0, 6)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffa45e"] range:NSMakeRange(6,2)];
            
            _titleLabel.attributedText = str;
        }
        
        
        
        
//        self.interestLabel.attributedText = str;
        
        
    } Falsed:^(NSError *error) {
        
    }];
}

//今天第一次获取运动数据
-(void)firstSportMessage
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* curentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary* dic = @{@"service":SPORT_IF,
                          @"user_id":UID,
                          @"date":curentDateStr,
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"data"][@"msg"]);
        
        if ([requestDic[@"data"][@"code"]isEqualToNumber:@1]) {
            
            NSDictionary* dic = requestDic[@"data"][@"data"];
            [USERDefaults setObject:dic[@"distance"] forKey:@"distance"];
            [USERDefaults setObject:dic[@"calorie"] forKey:@"calorie"];
            if ([dic[@"step_num"] integerValue]>[[USERDefaults objectForKey:@"toDayStepNum"] integerValue]) {
                [USERDefaults setObject:dic[@"step_num"] forKey:@"toDayStepNum"];
                
            }
            
            [USERDefaults synchronize];
            
            [self setCountStepifNeed];
            [self showMessage];
            
        }else if ([requestDic[@"data"][@"code"]isEqualToNumber:@0])
        {
            NSDictionary* dic = @{
                                  @"calorie":@"0.0",
                                  @"distance":@"0.0",
                                  @"step_num":@"0",
                                  
                                  };
            [self refreshSportUI:dic];
            [self setCountStepifNeed];
        }
        
        
    } Falsed:^(NSError *error) {
        
    }];
}


//获取一运动数据
-(void)getSportMessage:(NSString*)dateString
{
    
    NSDictionary* dic = @{@"service":SPORT_IF,
                          @"user_id":UID,
                          @"date":dateString,
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Hud:NO Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        NSLog(@"%@",requestDic[@"data"][@"msg"]);
        
        if ([requestDic[@"data"][@"code"]isEqualToNumber:@1]) {
            if (isToday) {
                [self refreshTodayUI:requestDic[@"data"][@"data"]];
            }else
            {
                [self refreshSportUI:requestDic[@"data"][@"data"] ];
            }
            
        }else if ([requestDic[@"data"][@"code"]isEqualToNumber:@0])
        {
            NSDictionary* dic = @{
                                  @"calorie":@"0.0",
                                  @"distance":@"0.0",
                                  @"step_num":@"0",
                                  
                                  };
            
            if (isToday) {
                [self refreshTodayUI:dic];
            }else
            {
                [self refreshSportUI:dic];
            }
        }
        
        
    } Falsed:^(NSError *error) {
        
    }];
}

-(void)refreshToday:(NSInteger)value
{
    CGFloat length = [[USERDefaults objectForKey:@"height"] floatValue];
    CGFloat weight = [[USERDefaults objectForKey:@"weight"] floatValue];
    CGFloat step_length = 0.45* length;
    CGFloat distance,calories;
    //    NSInteger value = self.stepNumLabel.text.integerValue;
    if (value % 2 == 0) {
        distance =(value/2) * 3 * step_length * 0.01;
    } else {
        distance =((value/2) * 3 + 1) * step_length * 0.01;
    }
    if (distance != 0.0) {
        // 体重、距离
        // 跑步热量（kcal）＝体重（kg）×距离（公里）×1.036
        calories = (float) (weight * distance * 0.001);
        //速度velocity
    } else {
        calories = 0.0f;
    }
    
    NSDictionary* dic = @{
                          @"step_num":[NSString stringWithFormat:@"%ld",value],
                          @"calorie":[NSString stringWithFormat:@"%.2f",calories],
                          @"distance":[NSString stringWithFormat:@"%.2f",distance/1000.0],
                          
                          };
    [self refreshSportUI:dic];
}

-(void)refreshTodayUI:(NSDictionary*)dic
{
    _lengLabel.text = dic[@"distance"];
    _hotLabel.text = dic[@"calorie"];
    _stepNumLabel.text = [[USERDefaults objectForKey:@"WXStepCount"] integerValue]>0?[USERDefaults objectForKey:@"WXStepCount"]:@"0";
    if (taskStepNum) {
        [_processView setProgress:0.0 animated:NO];
        [self.processView setProgress:_stepNumLabel.text.floatValue/taskStepNum animated:YES];
    }
}

-(void)refreshSportUI:(NSDictionary*)dic
{
    _lengLabel.text = dic[@"distance"];
    _hotLabel.text = dic[@"calorie"];
    _stepNumLabel.text = dic[@"step_num"];
    if (taskStepNum) {
        [_processView setProgress:0.0 animated:NO];
        [self.processView setProgress:_stepNumLabel.text.floatValue/taskStepNum animated:YES];
    }
}

-(void)signIn
{
    NSDictionary* dic = @{@"service":SIGNIN_IF,
                          @"user_id":UID,
                          };
    [HTTPRequest requestWitUrl:@"" andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        
        if ([requestDic[@"data"][@"code"] isEqualToNumber:@1]) {
            
            NSDictionary* dic = requestDic[@"data"][@"data"];
            NSArray* jump = dic[@"jump"];
            NSNumber*  score = dic[@"score"];
            NSString* sign_times = dic[@"sign_times"];
            NSString* title_name = dic[@"title_name"];
            NSString* title_url = dic[@"title_url"];
            [USERDefaults setObject:title_name forKey:@"title_name"];
            [USERDefaults setObject:title_url forKey:@"title_url"];
            [USERDefaults synchronize];
            
            signViewController* sign = [[signViewController alloc]init];
            sign.sign_times = sign_times;
            sign.score = score;
            sign.isShow = [jump containsObject:sign_times];
            sign.modalPresentationStyle = UIModalPresentationOverFullScreen;
            sign.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:sign animated:YES completion:^{
                
            }];
        }
        
        NSString* msg = requestDic[@"data"][@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            
        }
        NSLog(@"%@",msg);
        
    } Falsed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



-(void)getWeatherMessage
{
    NSDictionary* dic = @{@"service":WEATHER_IF,
                          @"city":@"杭州",
                          };
    [HTTPRequest requestandCacheWitUrl:@"" andArgument:dic Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        NSLog(@"%@",requestDic);
        
        self.airLabel.text = requestDic[@"data"][@"data"][@"pm25"];
        self.airLabel.adjustsFontSizeToFitWidth = YES;
        [self.weatherImage sd_setImageWithURL:[NSURL URLWithString:requestDic[@"data"][@"data"][@"dayPictureUrl"]] placeholderImage:[UIImage imageNamed:@""]];
        NSString* shishi = [[requestDic[@"data"][@"data"][@"date"] componentsSeparatedByString:@"："] lastObject];
        NSMutableString* string = [NSMutableString stringWithString:shishi] ;
        [string deleteCharactersInRange:NSMakeRange(shishi.length - 1, 1)];
        self.weatherLabel.text = [NSString stringWithFormat:@"%@",string];
        
        for (NSString* str in [requestDic[@"data"][@"data"] allKeys]) {
            NSLog(@"%@",[requestDic[@"data"][@"data"]objectForKey:str]);
        }
        
    } Falsed:^(NSError *error) {
        
    }];
}

#pragma mark - xib

- (IBAction)leftMenuBtn:(UIButton *)sender {
    
    sideViewController* sied = (sideViewController*)self.drawer.leftViewController;
    sied.stepNum = taskStepNum;
    
    [self.drawer open];
    
    
}

- (IBAction)loginBtn:(UIButton *)sender {
    
//    WXLoginViewController* login = [[WXLoginViewController alloc]init];
//    [self.navigationController pushViewController:login animated:YES];
    
}

- (IBAction)listBtn:(UIButton *)sender {
    
    listViewController* list = [[listViewController alloc]init];
    [self.navigationController pushViewController:list animated:YES];
    
}

- (IBAction)gobuyBtn:(UIButton *)sender {
    
    productListViewController* activity = [[productListViewController alloc]init];
    [self.navigationController pushViewController:activity animated:YES];
    
}

#pragma mark ----------------ICSDrawerControllerPresenting--------------------
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
}
- (IBAction)zhifuBtn:(UIButton *)sender {
    
    signViewController* sign = [[signViewController alloc]init];
    sign.modalPresentationStyle = UIModalPresentationOverFullScreen;
    sign.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:sign animated:YES completion:^{
        
    }];
    
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[NSDate date]];
//    NSLog(@"timeSp:%@",timeSp); //时间戳的值
//    
////    [alipayObject alipay:0.01 order:timeSp block:^(NSDictionary *dic) {
////        
////    }];
//    [weixinObject weixinPay:0.01 order:timeSp block:^(BOOL payRet) {
//        
//    }];
    
}
- (IBAction)sexButton:(UIButton *)sender { 
    
//    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//       
//    }];
//    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"领取" message:@"领取信息已提交，请注意查收\n(预计72小时内到账，节假日顺延)" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:action];
//    [self presentViewController:alertController animated:YES completion:^{
//        
//    }];
    
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"test" object:nil userInfo:@{}];
    
    signViewController* sign = [[signViewController alloc]init];
//    [self.navigationController pushViewController:sign animated:YES];
    sign.modalPresentationStyle = UIModalPresentationOverFullScreen;
    sign.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:sign animated:YES completion:^{
        
    }];
    
}
@end
