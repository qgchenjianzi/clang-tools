//
//  MicroMessengerAppDelegate+MMCommonAdapter.m
//  MicroMessenger
//
//  Created by alantao on 3/31/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "MicroMessengerAppDelegate+MMCommonAdapter.h"
#import "MMLanguageMgr.h"
#import "iConsole.h"
#import "AppUtil.h"
#import "LogStat.h"
#import "IDKeyReport.h"

#define placeHoldErrorCode 0

@interface MicroMessengerAppDelegate () 

@end

@implementation MicroMessengerAppDelegate (MMCommonAdapter)

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate+MMCommonAdapter.mm
 * Method Name: setupMMCommonAdapter
 * Returning Type: void
 */ 
- (void)setupMMCommonAdapter
{
    [MMCommonAdapter SetupWithDelegate:self];
}

#pragma mark - MMCommonAdapterDelegate

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate+MMCommonAdapter.mm
 * Method Name: IsChinese
 * Returning Type: BOOL
 */ 
- (BOOL)IsChinese
{
    if ([[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString:MM_LANGUAGE_CHS])
    // the 'if' part
    {
        //the return stmt
        return YES;
    }
    
    //the return stmt
    return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate+MMCommonAdapter.mm
 * Method Name: ShouldLog:
 * Returning Type: BOOL
 */ 
- (BOOL)ShouldLog:(int)level
{
    return [iConsole shouldLog:level];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate+MMCommonAdapter.mm
 * Method Name: LogWithinCommon:module:file:line:funcName:message:
 * Returning Type: void
 */ 
- (void)LogWithinCommon:(TLogLevel)log_level module:(const char*)module file:(const char*)file line:(int)line funcName:(const char*)funcName message:(NSString*)message
{
    //warning TODO: juanmao 这里errorCode的需要继续进行改造
    [iConsole logWithLevel:log_level module:module errorCode:placeHoldErrorCode file:file line:line func:funcName message:message];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate+MMCommonAdapter.mm
 * Method Name: NetworkLogOutput:
 * Returning Type: void
 */ 
- (void)NetworkLogOutput:(NSString*)strLog
{
    //the func--->MMInfo() begin called!
    MMInfo(@"[Network]%@", strLog);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate+MMCommonAdapter.mm
 * Method Name: LogFeatureExt:logExt:isReportNow:isImportant:
 * Returning Type: void
 */ 
- (void)LogFeatureExt:(UInt32)logid logExt:(NSString *)logExt isReportNow:(bool)isReportNow isImportant:(bool)isImportant
{
    //the func--->mm_log_feature_ext() begin called!
    mm_log_feature_ext(logid, logExt, isReportNow, isImportant);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate+MMCommonAdapter.mm
 * Method Name: LogFeatureIdKey:key:value:isKeyLog:
 * Returning Type: void
 */ 
- (void)LogFeatureIdKey:(uint32_t)logid key:(uint32_t)key value:(uint32_t)value isKeyLog:(bool)isKeyLog
{
    //the func--->LOG_FEATURE_EXT_IDKEY() begin called!
    LOG_FEATURE_EXT_IDKEY(logid, key, value, isKeyLog);
}

@end
