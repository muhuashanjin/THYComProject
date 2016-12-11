//
//  BaseAPIManager.h
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import "CTAPIBaseManager.h"

@interface BaseAPIManager : CTAPIBaseManager<CTAPIManager>

+ (instancetype)sharedInstance;

@end
