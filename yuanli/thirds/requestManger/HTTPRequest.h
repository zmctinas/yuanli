//
//  HTTPRequest.h
//  O2O
//
//  Created by wangxiaowei on 15/5/30.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "WXprogress.h"

#define uploadTimeOut  10  //上传图片的超时时间

typedef enum {
    WXHTTPRequestGet,
    WXHTTPRequestPost,
}WXHTTPRequestType;
@class HTTPRequest;
@protocol HTTPRequestDataDelegate <NSObject>

typedef void (^FinishBolck)(NSURLResponse *response, NSDictionary* requestDic);

typedef void (^FalseBolck)(NSError *error);

typedef void (^Progress)(NSProgress * downloadProgress);
typedef void (^success)(NSDictionary *dic,NSString *url,NSString *Json);
typedef void (^fail)(NSError *error,NSString *url);

-(void)request:(HTTPRequest* )request getMessage:(NSDictionary*)requestDic;

@end

@interface HTTPRequest : NSObject
{
    HTTPRequest* reaf;
}
@property(nonatomic,strong)FinishBolck finishBlock;
@property(nonatomic,strong)FalseBolck falseBolck;
@property(nonatomic,strong)Progress block_Progress;
@property(nonatomic,strong)success block_success;
@property(nonatomic,strong)fail block_fail;

@property(assign,nonatomic)NSInteger tag;

@property(assign,nonatomic)id<HTTPRequestDataDelegate> delegate;

@property(strong,nonatomic)NSString* urlStr;

@property(strong,nonatomic)NSDictionary* argument;

@property(strong,nonatomic)NSMutableArray* parameter;



+(void)requestWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument andType:(WXHTTPRequestType)type Finished:(FinishBolck)finishBlock Falsed:(FalseBolck)falseBolck;

+(void)requestWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument andType:(WXHTTPRequestType)type Hud:(BOOL)Hud Finished:(FinishBolck)finishBlock Falsed:(FalseBolck)falseBolck;

+(void)requestandCacheWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument  Finished:(FinishBolck)finishBlock Falsed:(FalseBolck)falseBolck;

+(HTTPRequest *)CrazyHttpFileUpload:(NSString *)headUrl imageDic:(NSDictionary *)imageDic Argument:(NSDictionary *)argument HUD:(BOOL)hud block:(success)success fail:(fail)fail;


//- (instancetype)initWithtag:(NSInteger)tag andDelegate:(id<HTTPRequestDataDelegate>)delegate;
//
//-(void)requestWitUrl:(NSString*)urlStr andArgument:(NSDictionary*)argument andType:(WXHTTPRequestType)type;

@end
