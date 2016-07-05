//
//  FunctionSwitchUtil.mm
//  MicroMessenger
//
//  Created by isalin on 14-8-13.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "FunctionSwitchUtil.h"
#import "mmsync.pb.h"
#import "NewSyncService.h"
#import "AccountStorageMgr.h"
#import "StatusCode.h"
#import "mmprotodef.h"
#import "SettingUtil.h"
#import "Setting.h"

@implementation FunctionSwitchUtil

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//FunctionSwitchUtil.mm
 * Method Name: convertType:
 * Returning Type: UInt32
 */ 
+ (UInt32) convertType:(UInt32)uiPluginConfigType
{
	switch (uiPluginConfigType) {
		case PLUGIN_CONFIG_QQOFFLINE:
			return MM_FUNCTIONSWITCH_QQMSG;
			break;
		case PLUGIN_CONFIG_QQPROMOTETOME:
			return MM_FUNCTIONSWITCH_QQ_PROMOTE_TOME_CLOSE;
			break;
		case PLUGIN_CONFIG_PROMOTETOME:
			return MM_FUNCTIONSWITCH_PROMOTE_TOME_CLOSE;
			break;
		case PLUGIN_CONFIG_FLOATBOTTLE:
			return MM_FUNCTIONSWITCH_BOTTLE_OPEN;
			break;
		case PLUGIN_CONFIG_WEIXINONLINE:
			return MM_FUNCTIONSWITCH_WEIXIN_ONLINE_OPEN;
			break;
		case PLUGIN_CONFIG_MEDIANOTE:
			return MM_FUNCTIONSWITCH_MEDIANOTE_OPEN;
			break;
		case PLUGIN_CONFIG_BOTTLE_MAINFRAME:
			return MM_FUNCTIONSWITCH_BOTTLE_CHART_OPEN;
			break;
		case PLUGIN_CONFIG_FACEBOOK_FRIEND:
			return MM_FUNCTIONSWITCH_RECFBFRIEND_OPEN;
            break;
        case PLUGIN_CONFIG_READER_APP_TENCENT_NEWS:
            return MM_FUNCTIONSWITCH_NEWSAPP_TXNEWS_CLOSE;
            break;
        case PLUGIN_CONFIG_ALBUM_NOT_ALLOW_STRANGER_VISIT_OPEN:
            return MM_FUNCTIONSWITCH_ALBUM_NOT_FOR_STRANGER;
            break;
        case PLUGIN_CONFIG_ALLOW_FIND_ME_BY_CONTACT_NAME:
            return MM_FUNCTIONSWITCH_USERNAME_SEARCH_CLOSE;
            break;
        case PLUGIN_CONFIG_WEBONLINE_PUSH:
            return MM_FUNCTIONSWITCH_WEBONLINE_PUSH_OPEN;
            break;
        case PLUGIN_CONFIG_SAFEDEVICE:
            return MM_FUNCTIONSWITCH_SAFEDEVICE_OPEN;
            break;
        case PLUGIN_CONFIG_AUTOADD:
            return MM_FUNCTIONSWITCH_AUTOADD_OPEN;
            break;
        case PLUGIN_CONFIG_LINKEDIN_PROFILE:
            return MM_FUNCTIONSWITCH_SHOW_LINKEDIN_PROFILE_OPEN;
            break;
		case PRAVITE_CONFIG_PUSHTOQQFRIEND:
			return MM_FUNCTIONSWITCH_QQ_PROMOTE_CLOSE;
			break;
		case PRAVITE_CONFIG_ALLOWFINDMEBYQQ:
			return MM_FUNCTIONSWITCH_QQ_SEARCH_CLOSE;
			break;
		case PRAVITE_CONFIG_CONTACTVERIFY:
			return MM_FUNCTIONSWITCH_VERIFY_USER;
			break;
		case PRAVITE_CONFIG_ALLOWFINDMEBYPHONE:
			return MM_FUNCTIONSWITCH_MOBILE_SEARCH_CLOSE;
			break;
		case PRAVITE_CONFIG_ADDCONTACTBYREPLY:
			return MM_FUNCTIONSWITCH_ADD_CONTACT_CLOSE;
			break;
		case PRAVITE_CONFIG_PUSH_DETAIL:
			return MM_FUNCTIONSWITCH_APNS_TIPS_CLOSE;
			break;
		case PRAVITE_CONFIG_CANSYNC_ADDRESSBOOK:
			return MM_FUNCTIONSWITCH_UPLOADMCONTACT_CLOSE;
			break;
        case PRAVITE_CONFIG_FIND_ME_BY_CONTACT_NAME:
			return PRAVITE_CONFIG_FIND_ME_BY_CONTACT_NAME;
			break;
        case PRAVITE_CONFIG_FIND_ME_BY_GOOGLE:
			return MM_FUNCTIONSWITCH_GOOGLE_CONTACT_SEARCH_CLOSE;
			break;
        case PRAVITE_CONFIG_GOOGLE_PROMOTETOME:
			return MM_FUNCTIONSWITCH_GOOGLE_CONTACT_PROMOTE_CLOSE;
			break;
        case PRAVITE_CONFIG_BIND_WATCH:
            return MM_FUNCTIONSWITCH_IS_BIND_WATCH;
            break;
        case PRAVITE_CONFIG_PUSH_SINGLE_CHAT_ONLY:
            return MM_FUNCTIONSWITCH_PUSH_SINGLE_CHAT_ONLY;
            break;
        case PRAVITE_CONFIG_PUSH_WATCH_CONTACT_ONLY:
            return MM_FUNCTIONSWITCH_PUSH_WATCH_CONTACT_ONLY;
            break;
        case PRAVITE_CONFIG_PUSH_ALL:
            return MM_FUNCTIONSWITCH_PUSH_ALL;
            break;
		case PLUGIN_CONFIG_PUSHMAIL:
		case PLUGIN_CONFIG_PRIVATEMSG:
		default:
			return 0;
			break;
	}
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//FunctionSwitchUtil.mm
 * Method Name: addSwitchOplog:SwitchValue:sync:
 * Returning Type: BOOL
 */ 
+(BOOL) addSwitchOplog:(UInt32)uiFunctionId SwitchValue:(UInt32)uiSwitchValue sync:(BOOL)bSync
{
	FunctionSwitch* oFunctionSwitch = [[FunctionSwitch alloc] init];
	oFunctionSwitch.functionId = uiFunctionId;
	oFunctionSwitch.switchValue = uiSwitchValue;
	
	BOOL bRet = [GET_SERVICE(NewSyncService) InsertOplog:MM_SYNCCMD_FUNCTIONSWITCH Oplog:[oFunctionSwitch serializedData] Sync:bSync];
    //the return stmt
    return bRet;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//FunctionSwitchUtil.mm
 * Method Name: setPluginSwitch:statusBit:setOpen:sync:
 * Returning Type: void
 */ 
+(void) setPluginSwitch:(UInt32)uiFunctionId statusBit:(UInt32)uiStatusBit setOpen:(BOOL)bOpen sync:(BOOL)bSync
{
    [FunctionSwitchUtil addSwitchOplog:[FunctionSwitchUtil convertType:uiFunctionId] SwitchValue:bOpen?MM_FUNCTIONSWITCH_OPEN:MM_FUNCTIONSWITCH_CLOSE sync:bSync];
    
	MMDebug(@"Before setPluginSwitch: m_uiPluginSwitch = %u",[SettingUtil getMainSetting].m_uiPluginSwitch);
	if(bOpen) // the 'if' part
	{
		[SettingUtil getMainSetting].m_uiPluginSwitch |= uiStatusBit;
	} else // the 'else' part
	{
		[SettingUtil getMainSetting].m_uiPluginSwitch &= ~uiStatusBit;
	}
    
    MMDebug(@"setPluginSwitch: m_uiPluginSwitch = %u, uiConfigType = %u, uiStatusBit = %u", [SettingUtil getMainSetting].m_uiStatus, (uint32_t)uiFunctionId, (uint32_t)uiStatusBit);
	[GET_SERVICE(AccountStorageMgr) MainThreadSaveSetting];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//FunctionSwitchUtil.mm
 * Method Name: setStatusSwitch:statusBit:setOpen:sync:
 * Returning Type: void
 */ 
+(void) setStatusSwitch:(UInt32)uiFunctionId statusBit:(UInt32)uiStatusBit setOpen:(BOOL)bOpen sync:(BOOL)bSync
{
    [FunctionSwitchUtil addSwitchOplog:[FunctionSwitchUtil convertType:uiFunctionId] SwitchValue:bOpen?MM_FUNCTIONSWITCH_OPEN:MM_FUNCTIONSWITCH_CLOSE sync:bSync];
    
	MMDebug(@"Before setStatusSwitch: m_uiStatus = %u", [SettingUtil getMainSetting].m_uiStatus);
	if(bOpen) // the 'if' part
	{
		[SettingUtil getMainSetting].m_uiStatus |= uiStatusBit;
	} else // the 'else' part
	{
		[SettingUtil getMainSetting].m_uiStatus &= ~uiStatusBit;
	}
    MMDebug(@"setStatusSwitch: m_uiStatus = %u, uiConfigType = %u, uiStatusBit = %u", [SettingUtil getMainSetting].m_uiStatus, (uint32_t)uiFunctionId, (uint32_t)uiStatusBit);
	[GET_SERVICE(AccountStorageMgr) MainThreadSaveSetting];
}
@end
