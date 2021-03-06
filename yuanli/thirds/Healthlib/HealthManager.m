//
//  HealthManager.m
//  zoubao
//
//  Created by 李聪 on 15/4/20.
//  Copyright (c) 2015年 李聪. All rights reserved.
//

#import "HealthManager.h"
#import <UIKit/UIDevice.h>
#import "HKHealthStore+AAPLExtensions.h"

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
@implementation HealthManager

+(id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

/*!
 *  @author Lcong, 15-04-20 17:04:44
 *
 *  @brief  检查是否支持获取健康数据
 */
- (void)getPermissions:(void(^)(BOOL success))Handle
{
    if(HKVersion >= 8.0)
    {
        if ([HKHealthStore isHealthDataAvailable]) {
            
            if(self.healthStore == nil)
                self.healthStore = [[HKHealthStore alloc] init];
            
            /*
             组装需要读写的数据类型
             */
            NSSet *writeDataTypes = [self dataTypesToWrite];
            NSSet *readDataTypes = [self dataTypesRead];
            
            /*
             注册需要读写的数据类型，也可以在“健康”APP中重新修改
             */
            [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                if (!success) {
                    NSLog(@"%@\n\n%@",error, [error userInfo]);
                    return ;
                }
                else
                {
                    Handle(YES);
                }
            }];
        }
    }
}


/*!
 *  @author Lcong, 15-04-20 16:04:42
 *
 *  @brief  写权限
 *
 *  @return 集合
 */
- (NSSet *)dataTypesToWrite
{
    //    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    //    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    //    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    //    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    //
    //    return [NSSet setWithObjects:heightType, temperatureType, weightType,activeEnergyType,nil];
    
    return [NSSet setWithObjects:nil];
    
}


/*!
 *  @author Lcong, 15-04-20 16:04:03
 *
 *  @brief  读权限
 *
 *  @return 集合
 */
- (NSSet *)dataTypesRead
{
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
//    return [NSSet setWithObjects:heightType, temperatureType,birthdayType,sexType,weightType,stepCountType, activeEnergyType,nil];
    
        return [NSSet setWithObjects:stepCountType,nil];
    
}

/*!
 *  @author Lcong, 15-04-20 17:04:02
 *
 *  @brief  实时获取当天步数
 */
- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler
{
    if(HKVersion < 8.0)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:@"CustomHealthErrorDomain" code:0 userInfo:userInfo];
        handler(0,aError);
    }
    else
    {
        [self getPermissions:^(BOOL success) {
            if(success)
            {
                HKSampleType *sampleType =
                [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
                
                HKObserverQuery *query =
                [[HKObserverQuery alloc]
                 initWithSampleType:sampleType
                 predicate:nil
                 updateHandler:^(HKObserverQuery *query,
                                 HKObserverQueryCompletionHandler completionHandler,
                                 NSError *error) {
                     if (error) {
                         
                         // Perform Proper Error Handling Here...
                         NSLog(@"*** An error occured while setting up the stepCount observer. %@ ***",
                                  error.localizedDescription);
                         handler(0,error);
//                         abort();
                     }
                     [self getStepCount:[HealthManager predicateForSamplesToday] completionHandler:^(double value, NSError *error) {
                         handler(value,error);
                     }];
                 }];
                [self.healthStore executeQuery:query];
            }
        }];
    }
    
//    HKUnit *stepType = [[HKUnit countUnit ]unitDividedByUnit:[HKUnit countUnit]];
//    HKStatisticsQuery* min = [[HKStatisticsQuery alloc ]initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error)
//    {
//        MYLog(@"%f" , [[result sumQuantity] doubleValueForUnit:stepType]);
//    }];
}

/*!
 *  @author Lcong, 15-04-20 17:04:03
 *
 *  @brief  获取步数
 *
 *  @param predicate 时间段
 */
- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler
{
    
    if(HKVersion < 8.0)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:@"CustomHealthErrorDomain" code:0 userInfo:userInfo];
        handler(0,aError);
    }
    else
    {
        [self getPermissions:^(BOOL success) {
            if(success)
            {
                HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
                
                [self.healthStore aapl_mostRecentQuantitySampleOfType:stepType predicate:predicate completion:^(NSArray *results, NSError *error) {
                    if(error)
                    {
                        handler(0,error);
                    }
                    else
                    {
                        NSInteger totleSteps = 0;
                        for(HKQuantitySample *quantitySample in results)
                        {
                            HKQuantity *quantity = quantitySample.quantity;
                            HKUnit *heightUnit = [HKUnit countUnit];
                            double usersHeight = [quantity doubleValueForUnit:heightUnit];
                            totleSteps += usersHeight;
                        }
                        NSLog(@"当天行走步数 = %ld",(long)totleSteps);
                        handler(totleSteps,error);
                    }
                }];
                
            }
        }];
    }
}

/*!
 *  @author Lcong, 15-04-20 17:04:10
 *
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday {
    if(HKVersion >= 8.0)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *now = [NSDate date];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
        [components setHour:0];
        [components setMinute:0];
        [components setSecond: 0];
        
        NSDate *startDate = [calendar dateFromComponents:components];
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
        return predicate;
    }
    else
        return nil;
}

/*!
 *  @author Lcong, 15-04-20 17:04:38
 *
 *  @brief  获取卡路里
 */
- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler
{
    
    if(HKVersion < 8.0)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:@"CustomHealthErrorDomain" code:0 userInfo:userInfo];
        handler(0,aError);
    }
    else
    {
        [self getPermissions:^(BOOL success) {
            if(success)
            {
                HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
                    NSLog(@"health = %@",result);
                    HKQuantity *sum = [result sumQuantity];
                    
                    double value = [sum doubleValueForUnit:[HKUnit kilocalorieUnit]];
                    NSLog(@"%@卡路里 ---> %.2lf",sum,value);
                    if(handler)
                    {
                        handler(value,error);
                    }
                }];
                [self.healthStore executeQuery:query];
            }
        }];
        
    }
}


@end
