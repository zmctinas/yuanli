//
//  HTTPRequest.m
//  O2O
//
//  Created by wangxiaowei on 15/5/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "HTTPRequest.h"


static HTTPRequest * request = nil;

@implementation HTTPRequest
{
    AFHTTPSessionManager* _manager;
}


+(HTTPRequest *)share{
    
    request =[[HTTPRequest alloc]init];
    
    return request;
}

- (instancetype)initWithtag:(NSInteger)tag andDelegate:(id<HTTPRequestDataDelegate>)delegate
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        _parameter = [[NSMutableArray alloc]init];
        _delegate = delegate;
        _tag = tag;
        
    }
    return self;
}

+(void)requestWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument andType:(WXHTTPRequestType)type Hud:(BOOL)Hud Finished:(FinishBolck)finishBlock Falsed:(FalseBolck)falseBolck
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //    NSMutableArray* _parameter = [[NSMutableArray alloc]init];
    //    NSString* _urlStr = [NSString stringWithFormat:@"%@%@",HEADURL,urlStr];
    WXprogress * process;
    if (Hud) {
        WXprogress * process = [WXprogress shareProcess];
        [process showProgress ];
    }
    
    if (type == WXHTTPRequestGet) {
        [manager GET:HEADURL parameters:argument progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",task.response.URL);
            if (process) {
                [process dismissProgress];
            }
            
            finishBlock(nil,(NSDictionary*)responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.description);
            //            NSLog(@"%@",operation.response.URL);
            //            NSLog ( @"operation: %@" , operation. responseString );
            falseBolck(error);
            if (process) {
                [process dismissProgress];
            }
            
        }];
        
    }else
    {
        
        [manager POST:HEADURL parameters:argument progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finishBlock(nil,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

+(void)requestWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument andType:(WXHTTPRequestType)type Finished:(FinishBolck)finishBlock Falsed:(FalseBolck)falseBolck
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    NSMutableArray* _parameter = [[NSMutableArray alloc]init];
//    NSString* _urlStr = [NSString stringWithFormat:@"%@%@",HEADURL,urlStr];
    WXprogress * process = [WXprogress shareProcess];
    [process showProgress ];
    if (type == WXHTTPRequestGet) {
        [manager GET:HEADURL parameters:argument progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",task.response.URL);
            
            [process dismissProgress];
            finishBlock(nil,(NSDictionary*)responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.description);
//            NSLog(@"%@",operation.response.URL);
//            NSLog ( @"operation: %@" , operation. responseString );
            falseBolck(error);
            [process dismissProgress];
        }];
        
    }else
    {
        
        [manager POST:HEADURL parameters:argument progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finishBlock(nil,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

+(void)requestandCacheWitUrl:(NSString *)urlStr andArgument:(NSDictionary *)argument Finished:(FinishBolck)finishBlock Falsed:(FalseBolck)falseBolck
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* url = [NSString stringWithFormat:@"%@%@",HEADURL,argument[@"service"]];
    TMCache * cache =[TMCache sharedCache];
    cache.diskCache.ageLimit = 60*60;
    cache.memoryCache.ageLimit =60*60;
    [[TMCache sharedCache]objectForKey:url block:^(TMCache *cache, NSString *key, id object) {
        NSDictionary * dic = (NSDictionary *)object;
        if (dic.allKeys >0) {
            finishBlock(nil,dic);
            
        }else
        {
            
            WXprogress * process = [WXprogress shareProcess];
            [process showProgress ];
            [manager GET:HEADURL parameters:argument progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //            NSLog(@"%@",operation.response.URL);
                
                            [process dismissProgress];
                [[TMCache sharedCache]setObject:(NSDictionary*)responseObject forKey:url];
                finishBlock(nil,(NSDictionary*)responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error.description);
                //            NSLog(@"%@",operation.response.URL);
                //            NSLog ( @"operation: %@" , operation. responseString );
                falseBolck(error);
                            [process dismissProgress];
            }];
        }
    }];
    
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        _parameter = [[NSMutableArray alloc]init];
//        _process = [[WXProcess alloc]init];
    }
    return self;
}

//文件流上传
+(HTTPRequest *)CrazyHttpFileUpload:(NSString *)headUrl imageDic:(NSDictionary *)imageDic Argument:(NSDictionary *)argument HUD:(BOOL)hud block:(success)success fail:(fail)fail{
    
    
    HTTPRequest * network = [HTTPRequest share];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:headUrl parameters:argument constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i<imageDic.allKeys.count; i++) {
            NSString *key = imageDic.allKeys[i];
            UIImage *image = imageDic[key];
            NSData *imageData= UIImageJPEGRepresentation(image, 100);
            [formData appendPartWithFileData:imageData name:key fileName:key mimeType:@"image/jpeg"];
        }
        
    } error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    configuration.timeoutIntervalForResource = -1;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (network.finishBlock) {
            network.block_Progress(uploadProgress);
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            
            fail(error,[response.URL absoluteString]);
            
        } else {
            
            success(responseObject,[response.URL absoluteString],@"");
            
        }
    }];
    
    [uploadTask resume];
    
    return network;
    
}

-(void)dealloc
{
//    _manager.
}




@end
