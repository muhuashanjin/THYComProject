//
//  BaseAPIManager.m
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "BaseAPIManager.h"

@interface BaseAPIManager () <CTAPIManagerValidator>

@property(nonatomic,copy)NSString *metName;
@property(nonatomic,copy)NSString *serType;
@property(nonatomic,assign)CTAPIManagerRequestType reqType;

@end

@implementation BaseAPIManager

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static BaseAPIManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BaseAPIManager alloc] init];
        sharedInstance.validator = sharedInstance;

    });
    return sharedInstance;
}

#pragma mark - CTAPIManager
- (BOOL)shouldCache
{
    return YES;
}

#pragma mark - CTAPIManagerValidator
- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}

@end
