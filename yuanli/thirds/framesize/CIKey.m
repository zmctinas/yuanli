//
//  CIKey.m
//  CIKit
//
//  Created by Ricky on 15/7/17.
//  Copyright (c) 2015年 Ricky. All rights reserved.
//

#import "CIKey.h"
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation CIKey

+(BOOL)isCIKey{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if (![[identifier substringToIndex:12] isEqualToString:@"com.longcai."]) {
        return YES;
    }else{
        return NO;
    }
}

+(void)isCIKeyNetWork:(id)obj action:(SEL)sel{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([[identifier substringToIndex:12] isEqualToString:@"com.longcai."]) {
        SuppressPerformSelectorLeakWarning([obj performSelector:sel];);
    }else{
        exit(0);
    }
}

@end
