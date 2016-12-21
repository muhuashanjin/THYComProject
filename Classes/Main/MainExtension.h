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
    
    kTaskMsg_Main_TestToExtension,
    kTaskMsg_Main_TestToVC,
    
    kTaskMsg_Main_Count
}taskMsg_Main;

#define kURL_Main_TestLogin @"" kBaseUrl "/bdCustomerLogin.json?username=13062717779&wechat=wx_qiakrtest9"

@end
