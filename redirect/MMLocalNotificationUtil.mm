//
//  MMLocalNotificationUtil.m
//  MicroMessenger
//
//  Created by alantao on 12/8/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "MMLocalNotificationUtil.h"

#import <MMCommon/ExtensionCenter.h>

@implementation MMLocalNotificationUtil

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MMLocalNotificationUtil.mm
 * Method Name: cancelAllNotReservedLocalNotifications
 * Returning Type: void
 */ 
+ (void)cancelAllNotReservedLocalNotifications
{
    UIApplication* app = [UIApplication sharedApplication];
    
    if (app.scheduledLocalNotifications.count <= 0) // the 'if' part
    {
        [app cancelAllLocalNotifications];
        //the return stmt
        return;
    }
    
    NSArray* arrScheduled = [NSArray arrayWithArray:app.scheduledLocalNotifications];
    NSMutableArray* arrReserved = [[NSMutableArray alloc] init];
    
    for (UILocalNotification* notification in arrScheduled) {
        BOOL isReserved = NO;
        SAFECALL_EXTENSION(MMLocalNotificationExt,
                           @selector(askScheduledLocalNotification:isReserved:),
                           askScheduledLocalNotification:notification isReserved:isReserved);
        
        if (isReserved) // the 'if' part
        {
            [arrReserved addObject:notification];
        }
    }
    
    [app cancelAllLocalNotifications];
    
    if (arrReserved.count > 0) // the 'if' part
    {
        app.scheduledLocalNotifications = [NSArray arrayWithArray:arrReserved];
    }
}

@end
