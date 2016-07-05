//
//  BackgroundTask.mm
//  MicroMessenger
//
//  Created by  kenbin on 11-10-8.
//  Copyright 2011 Tecent. All rights reserved.
//

#import "Utility.h"
#import "AppUtil.h"
#import "BackgroundTask.h"
#import <PublicComponentDylib/Objc2C_LogLogic.h>
//#import "Objc2C_LogLogic.h"
#import "SettingUtil.h"
#import "PowerMonitor.h"
#import "MMNotificationCenter.h"

@implementation BackgroundTask

#define NORMAL_REMAININGTIME  20

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//BackgroundTask.mm
 * Method Name: run
 * Returning Type: void
 */ 
+ (void) run {
	
	UInt32 uiRemainingTime = NORMAL_REMAININGTIME;
	// 有新版本并且未升级 在一定若干天内 则不跑后台运行逻辑，避免影响AppStore升级微信的下载过程
	CUpdateInfo* updateInfo = [SettingUtil getUpdateInfo];
	if (updateInfo.m_uiNewVersion > [CUtility GetVersion]) // the 'if' part
	{ // 需要升级
        // 暂时不做这个逻辑
	}
	
	UIApplication* app = [UIApplication sharedApplication];
	
	// 向系统申请后台执行权限
    __block UIBackgroundTaskIdentifier bg_task;
	bg_task = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bg_task];
        bg_task = UIBackgroundTaskInvalid;
    }];
	
	// 后台运行，异步方式
    //the func--->dispatch_async() begin called!
    dispatch_async(//the func--->dispatch_get_global_queue() begin called!
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		while (true) {
			MMDebug(@"backgroud run,remain time:%f,limit remain time:%u", app.backgroundTimeRemaining, (unsigned int)uiRemainingTime);
			sleep(10);
			
			// 前后台反复切换的时候要容错一下
			if (app.backgroundTimeRemaining > 10000) {
				break;
			}
			
			// 还剩最后20秒，自己主动退出吧
			if (app.backgroundTimeRemaining < uiRemainingTime) {
                MMInfo(@"kenbin:end background task,remain time:%f,limit remain time:%u", app.backgroundTimeRemaining, (unsigned int)uiRemainingTime);
                PM_LOG_DETAIL_INFO(eSTATE_WILL_SUSPEND);
                [[NSNotificationCenter defaultCenter] postNotificationName:MMApplicationWillSuspend object:nil];
				// flush log
				Objc2C_LogFlush();
				break;
			}
		}
		
        [app endBackgroundTask:bg_task];
        bg_task = UIBackgroundTaskInvalid;
    });
}

@end
