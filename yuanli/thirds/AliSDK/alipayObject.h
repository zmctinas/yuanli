//
//  alipayObject.h
//  yinyuehe
//
//  Created by dukai on 15/8/24.
//  Copyright (c) 2015年 dukai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^alipyResult)(NSDictionary *dic);

@interface alipayObject : NSObject

@property(nonatomic,strong)alipyResult block_success;

+(void)alipaySDKShare:(NSURL *)url;
+(void)alipay:(float)amount order:(NSString *)orderNum block:(alipyResult)result;

@end
