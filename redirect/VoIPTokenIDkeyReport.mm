//
//  VoIPTokenIDkeyReport.m
//  MicroMessenger
//
//  Created by yukiyylin on 16/1/15.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "VoIPTokenIDkeyReport.h"
#import "VoIPPushDef.h"
#import "IDKeyReport.h"

#define PUSH_KIT_ID                             305

@implementation VoIPTokenIDkeyReport

#pragma mark - private

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: reportId:Key:
 * Returning Type: void
 */ 
+(void) reportId:(int) tempId Key:(int) tempKey
{
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @"push kit report{ id:%d, key:%d }", tempId, tempKey);
    LOG_FEATURE_EXT_IDKEY(tempId, tempKey, 1, false);
}

#pragma mark - public

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: registerPushKit
 * Returning Type: void
 */ 
+(void) registerPushKit
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:0];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenCallbackNotVoipType
 * Returning Type: void
 */ 
+(void) tokenCallbackNotVoipType
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:1];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenCallbackTokenNotVoipType
 * Returning Type: void
 */ 
+(void) tokenCallbackTokenNotVoipType
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:2];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenCallbackTokenTypeOk
 * Returning Type: void
 */ 
+(void) tokenCallbackTokenTypeOk
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:3];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenCallbackTokenInvaildate
 * Returning Type: void
 */ 
+(void) tokenCallbackTokenInvaildate
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:4];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: pushReceiveContentEmpty
 * Returning Type: void
 */ 
+(void) pushReceiveContentEmpty
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:5];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: pushReceiveCmdTypeError
 * Returning Type: void
 */ 
+(void) pushReceiveCmdTypeError
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:6];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: pushReceiveCmdEmpty
 * Returning Type: void
 */ 
+(void) pushReceiveCmdEmpty
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:7];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: pushReceiveBroadcast
 * Returning Type: void
 */ 
+(void) pushReceiveBroadcast
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:8];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterTokenEmpty
 * Returning Type: void
 */ 
+(void) tokenRegisterTokenEmpty
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:9];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCertAppStore
 * Returning Type: void
 */ 
+(void) tokenRegisterCertAppStore
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:10];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCertWC
 * Returning Type: void
 */ 
+(void) tokenRegisterCertWC
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:11];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterSettingAppStore
 * Returning Type: void
 */ 
+(void) tokenRegisterSettingAppStore
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:12];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterSettingSandbox
 * Returning Type: void
 */ 
+(void) tokenRegisterSettingSandbox
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:13];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCgiCreateError
 * Returning Type: void
 */ 
+(void) tokenRegisterCgiCreateError
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:14];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCgiSent
 * Returning Type: void
 */ 
+(void) tokenRegisterCgiSent
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:15];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCgiCallbackEmpty
 * Returning Type: void
 */ 
+(void) tokenRegisterCgiCallbackEmpty
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:16];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCgiConnectTimeout
 * Returning Type: void
 */ 
+(void) tokenRegisterCgiConnectTimeout
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:17];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCgiResponseEmpty
 * Returning Type: void
 */ 
+(void) tokenRegisterCgiResponseEmpty
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:18];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCgiResponseError
 * Returning Type: void
 */ 
+(void) tokenRegisterCgiResponseError
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:19];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCgiResponseOk
 * Returning Type: void
 */ 
+(void) tokenRegisterCgiResponseOk
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:20];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterUsingCacheToken
 * Returning Type: void
 */ 
+(void) tokenRegisterUsingCacheToken
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:21];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenIDkeyReport.mm
 * Method Name: tokenRegisterCacheTokenNil
 * Returning Type: void
 */ 
+(void) tokenRegisterCacheTokenNil
{
    [VoIPTokenIDkeyReport reportId:PUSH_KIT_ID Key:22];
}

@end
