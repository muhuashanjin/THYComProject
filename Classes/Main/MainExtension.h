//
//  MainExtension.h
//  THYComProject
//
//  Created by thy on 16/12/8.
//  Copyright © 2016年 thy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainExtension : NSObject <ExtensionHandle>

typedef enum {
    kTaskMsg_Main_Base = MsgBaseOfExtension(kExtID_Main),
    kTaskMsg_Main_TestToNetWork,
    kTaskMsg_Main_TestToVC,
    kTaskMsg_Main_TestToExtension,
    
    kTaskMsg_Main_Count
}taskMsg_Main;

#define kURL_Main_TestToNetWork @"" kBaseUrl "/appConfig.json?1=ios_5.0.5_Simulator&did=A181F658-5E22-46F5-9187-06B303228720&bundle=com.yiguo.qiakr.q"

@end
