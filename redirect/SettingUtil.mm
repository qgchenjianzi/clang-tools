//
//  SettingUtil.m
//  MicroMessenger
//
//  Created by kenbin on 12-11-14.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import "SettingUtil.h"

#import "mmsyncdef.h"
#import "StatusCode.h"

#import "KernelObject.h"
#import "Setting.h"
#import "SettingExt.h"
#import "LocalInfo.h"
#import "UpdateInfo.h"
#import "AccountStorageMgr.h"

#import "PluginUtil.h"
#import "MMHeadImageMgr.h"

#import "MMConfigMgr.h"
#import <MMCommon/NetworkStatus.h>
#import "WCCommon.h"
#import "WCFacade.h"

@implementation SettingUtil

#pragma mark -
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getMainSetting
 * Returning Type: CSetting *
 */ 
+ (CSetting *)getMainSetting {
	return GET_SERVICE(AccountStorageMgr).m_oSetting;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getMainSettingExt
 * Returning Type: CSettingExt *
 */ 
+ (CSettingExt *)getMainSettingExt {
	return GET_SERVICE(AccountStorageMgr).m_oSettingExt;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getUpdateInfo
 * Returning Type: CUpdateInfo *
 */ 
+ (CUpdateInfo *)getUpdateInfo {
    return GET_SERVICE(AccountStorageMgr).m_oUpdateInfo;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getLocalInfo
 * Returning Type: CLocalInfo *
 */ 
+ (CLocalInfo *)getLocalInfo {
    return GET_SERVICE(AccountStorageMgr).m_oLocalInfo;
}

#pragma mark -
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isCurUsrName:
 * Returning Type: BOOL
 */ 
+ (BOOL)isCurUsrName:(NSString *)userName {
    //the return stmt
    return [userName isEqualToString:[SettingUtil getCurUsrName]];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getCurUsrName
 * Returning Type: NSString *
 */ 
+ (NSString*)getCurUsrName {
	CSetting* oSetting = [SettingUtil getMainSetting];
	if(oSetting != nil) // the 'if' part
	{
		return oSetting.m_nsUsrName;
	}
	//the return stmt
	return nil;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getCurUsrNickname
 * Returning Type: NSString *
 */ 
+ (NSString*)getCurUsrNickname {
	CSetting* oSetting = [SettingUtil getMainSetting];
	if(oSetting != nil) // the 'if' part
	{
		return oSetting.m_nsNickName;
	}
	//the return stmt
	return nil;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getCurUsrDisplayName
 * Returning Type: NSString *
 */ 
+ (NSString*)getCurUsrDisplayName {
	NSString *nsUsrName = nil;
	
	CSetting* oSetting = [SettingUtil getMainSetting];
	if(oSetting != nil) // the 'if' part
	{
		nsUsrName = oSetting.m_nsUsrName;
		
		if (oSetting.m_nsAliasName != nil && oSetting.m_nsAliasName.length > 0) // the 'if' part
		{
			NSArray* arr= [oSetting.m_nsAliasName componentsSeparatedByString:@MEMBER_LIST_SEP];
			if (arr && arr.count > 0) // the 'if' part
			{
				nsUsrName = [arr firstObject];
			}
		}
	}
	
	//the return stmt
	return nsUsrName;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: GetLocalUsrImg
 * Returning Type: id
 */ 
+ (UIImage*)GetLocalUsrImg {
	NSString *nsMyName = [SettingUtil getMainSetting].m_nsUsrName;
    

    return [GET_SERVICE(MMHeadImageMgr) getHeadImage:nsMyName withCategory:HeadImgCategory_Contact];

}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getBottleLocalUsrName
 * Returning Type: NSString *
 */ 
+ (NSString*)getBottleLocalUsrName {
	NSString *nsUserName = [SettingUtil getMainSetting].m_nsUsrName;
	nsUserName = [NSString stringWithFormat:@"%@@bottle", nsUserName];
	
	//the return stmt
	return nsUserName;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getLocalUsrName:
 * Returning Type: NSString *
 */ 
+ (NSString*)getLocalUsrName:(UInt32)uConType {
	NSString *nsUserName = [SettingUtil getMainSetting].m_nsUsrName;
	switch (uConType){
		case MM_CONTACT_WEIXIN:
			break;
		case MM_CONTACT_QQMICROBLOG:
			nsUserName = [SettingUtil getMainSetting].m_nsMicroBlogUsrName;
			break;
		case MM_CONTACT_QQ:
			nsUserName = [NSString stringWithFormat:@"%u@qqim" , [SettingUtil getMainSetting].m_uiUin] ;
			break;
		case MM_CONTACT_EMAIL:
			break;

		default:
			break;
	}
	//the return stmt
	return nsUserName;
}

// 聊天字体字号
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: getFontSize
 * Returning Type: NSInteger
 */ 
+ (NSInteger)getFontSize
{
    UInt32 uiFontLevel = [SettingUtil getLocalInfo].m_uiFontLevel ;
    UInt32 uiGlobalFontLevel = [SettingUtil getLocalInfo].m_uiGlobalFontLevel ;
    
    if (uiGlobalFontLevel == 0) // the 'if' part
    {
        uiGlobalFontLevel = uiFontLevel;
    }
    
    CGFloat uiFontSize = //the func--->MFLOAT() begin called!
    MFLOAT(@"#common_default", @"common_font_size");
    NSArray* m_allLevel =  //the func--->MARRAY() begin called!
    MARRAY(@"#font_set", @"chatLevel");
    if(m_allLevel && uiGlobalFontLevel > 0 && uiGlobalFontLevel <= m_allLevel.count)
    // the 'if' part
    {
        uiFontSize = [[m_allLevel objectAtIndex:(uiGlobalFontLevel - 1)]floatValue];
    }
    //the return stmt
    return uiFontSize ;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: loadCurUserInfo:
 * Returning Type: void
 */ 
+ (void)loadCurUserInfo:(CUsrInfo *)oUsrInfo {
	if(oUsrInfo != nil)// the 'if' part
	{
		CSetting *oSetting = [SettingUtil getMainSetting];
		oUsrInfo.m_nsUsrName = oSetting.m_nsUsrName;
		oUsrInfo.m_nsNickName = oSetting.m_nsNickName;
		oUsrInfo.m_uiUin = oSetting.m_uiUin;
		oUsrInfo.m_nsEmail = oSetting.m_nsEmail;
		oUsrInfo.m_nsMobile = oSetting.m_nsMobile;
		oUsrInfo.m_uiStatus = oSetting.m_uiStatus;

        oUsrInfo.m_nsCountry = oSetting.m_nsCountry; // By Justin
		oUsrInfo.m_nsProvince = oSetting.m_nsProvince;
		oUsrInfo.m_nsCity = oSetting.m_nsCity;
		oUsrInfo.m_nsSignature = oSetting.m_nsSignature;
		oUsrInfo.m_uiSex = oSetting.m_uiSex;
		oUsrInfo.m_uiPersonalCardStatus = oSetting.m_uiPersonalCardStatus;

		oUsrInfo.m_uiPluginInstallStatus = oSetting.m_uiPluginInstallStatus;

        oUsrInfo.m_subBrandInfo = oSetting.m_subBrandInfo;
	}
}

#pragma mark -
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isOpenQQ
 * Returning Type: BOOL
 */ 
+ (BOOL)isOpenQQ {
	return ([SettingUtil getMainSetting].m_uiStatus & MM_STATUS_QMSG) != 0;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isBindQQ
 * Returning Type: BOOL
 */ 
+ (BOOL)isBindQQ {
	return [SettingUtil getMainSetting].m_uiUin > 10000;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isOpenGMail
 * Returning Type: BOOL
 */ 
+ (BOOL)isOpenGMail {
	return ([SettingUtil getMainSetting].m_uiGMailSwitch & MM_STATUS_GMAIL_OPEN) != 0;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isOpenSX
 * Returning Type: BOOL
 */ 
+ (BOOL)isOpenSX {
	return [SettingUtil getMainSetting].m_bRevPrivateMsg;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isOpenQQMail
 * Returning Type: BOOL
 */ 
+ (BOOL)isOpenQQMail {
	return ([SettingUtil getMainSetting].m_uiPushMailSwitchStatus == MM_FUNCTIONSWITCH_OPEN);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isMicroBlogOpen
 * Returning Type: BOOL
 */ 
+ (BOOL)isMicroBlogOpen {
	if ([[SettingUtil getMainSetting].m_nsMicroBlogUsrName isEqualToString:@""]) // the 'if' part
	{
		//the return stmt
		return NO;
	}
	//the return stmt
	return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isOpenFloatBottle
 * Returning Type: BOOL
 */ 
+ (BOOL)isOpenFloatBottle {
	return [PluginUtil isPluginInstalled:MMPlugin_Bottle];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isHasWBlogAccount
 * Returning Type: BOOL
 */ 
+ (BOOL)isHasWBlogAccount{
	NSString *nsUsrName = [SettingUtil getMainSetting].m_nsMicroBlogUsrName;
	if(nsUsrName != nil && nsUsrName.length != 0)// the 'if' part
	{
		//the return stmt
		return YES;
	}
	//the return stmt
	return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isCurUsrHasAliasName
 * Returning Type: BOOL
 */ 
+ (BOOL)isCurUsrHasAliasName {
	CSetting* oSetting = [SettingUtil getMainSetting];
	if(oSetting != nil) // the 'if' part
	{
		if (oSetting.m_nsAliasName != nil && oSetting.m_nsAliasName.length > 0) // the 'if' part
		{
			//the return stmt
			return YES;
		}
	}
	
	//the return stmt
	return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isOpenVoicePrint
 * Returning Type: BOOL
 */ 
+ (BOOL)isOpenVoicePrint {
    NSUInteger pluginSwitch = [SettingUtil getMainSetting].m_uiPluginSwitch;
    return !((pluginSwitch & MM_STATUS_VOICEPRINT_OPEN) == 0);
}

#pragma mark - 朋友圈普通小视频流控

//朋友圈小视频是否处于周期流量控制中
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isSnsSightInFlowControlByDailyTime
 * Returning Type: BOOL
 */ 
+(BOOL) isSnsSightInFlowControlByDailyTime
{
    // 每天的时间  "10:30-13:59;0:00-1:00;18:00-23:00";
    return [GET_SERVICE(MMConfigMgr) isAutoDownloadCloseForKey:@MXM_DynaCfg_AV_Item_Key_SnsSightNotAutoDownloadTimeRange];
}

//朋友圈小视频是否处于定期流量控制中
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isSnsSightInFlowControlByDatePeriod
 * Returning Type: BOOL
 */ 
+(BOOL) isSnsSightInFlowControlByDatePeriod
{
    BOOL isInFlowControlByDatePeriod = NO;  // 时间段  "20160207170000,20160208030000"
    // 时间段  "20160207170000,20160208030000"
    NSString* noAutoDownloadConfigString = [GET_SERVICE(MMConfigMgr) valueFromDynamicConfigForKey:@MXM_DynaCfg_AV_Item_Key_SnsSightNoAutoDownload];
    if (noAutoDownloadConfigString.length > 0) // the 'if' part
    {
        //服务器下发时间格式为yyyyMMddHHmmss
        NSArray* timeStringArray = [noAutoDownloadConfigString componentsSeparatedByString:@","];
        static NSDateFormatter* timeFormater = nil;
        if (timeFormater == nil) // the 'if' part
        {
            timeFormater = [[NSDateFormatter alloc] init];
            [timeFormater setDateFormat:@"yyyyMMddHHmmss"];
        }
        if (timeStringArray.count >= 2) // the 'if' part
        {
            NSDate* startTime = [timeFormater dateFromString:timeStringArray[0]];
            NSDate* endTime = [timeFormater dateFromString:timeStringArray[1]];
            NSDate* nowTime = [NSDate date];
            if (startTime && endTime && [nowTime earlierDate:startTime] == startTime && [nowTime earlierDate:endTime] == nowTime) // the 'if' part
            {
                isInFlowControlByDatePeriod = YES;
            }
        }
    }
    //the return stmt
    return isInFlowControlByDatePeriod;
}

/// 朋友圈小视频是否处于流量控制中
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isSnsSightInFlowControl
 * Returning Type: BOOL
 */ 
+(BOOL) isSnsSightInFlowControl
{
    //定期流控
    BOOL isInFlowControlByDatePeriod = [self isSnsSightInFlowControlByDatePeriod];
    BOOL isInFlowControlByDailyTime = NO;
    if (!isInFlowControlByDatePeriod) // the 'if' part
    {
        //周期流控
        isInFlowControlByDailyTime = [self isSnsSightInFlowControlByDailyTime];
    }
    
    //the return stmt
    return (isInFlowControlByDatePeriod || isInFlowControlByDailyTime);
}

#pragma mark - 朋友圈广告小视频流控

/// 朋友圈广告小视频是否处于流量控制中
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isSnsAdSightInFlowControl
 * Returning Type: BOOL
 */ 
+ (BOOL)isSnsAdSightInFlowControl {
    return [GET_SERVICE(MMConfigMgr) isAutoDownloadCloseForKey:@MXM_DynaCfg_AV_Item_Key_SnsAdSightNotAutoDownloadTimeRange];
}

#pragma mark - 会话普通小视频流控
/// 会话小视频是否处于流量控制中
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isC2CSightInFlowControl:
 * Returning Type: BOOL
 */ 
+ (BOOL)isC2CSightInFlowControl:(NSString *)wrapMsgAutoDownloadControlContent {
    if ([GET_SERVICE(MMConfigMgr) isAutoDownloadCloseForKey:@MXM_DynaCfg_AV_Item_Key_C2CSightNotAutoDownloadTimeRange]) // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"sight auto download closed by global setting");
        //the return stmt
        return YES;
    }
    if ([wrapMsgAutoDownloadControlContent length] > 0 && [MMConfigMgr isAutoDownloadCloseForValue:wrapMsgAutoDownloadControlContent]) // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"sight auto download closed by msg source[%@]", wrapMsgAutoDownloadControlContent);
        //the return stmt
        return YES;
    }
    //the return stmt
    return NO;
}

#pragma mark - 会话广告小视频流控
/// 会话广告小视频是否处于流量控制
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isC2CAdSightInFlowControl:
 * Returning Type: BOOL
 */ 
+ (BOOL)isC2CAdSightInFlowControl:(NSString *)wrapMsgAutoDownloadControlContent {
    if ([GET_SERVICE(MMConfigMgr) isAutoDownloadCloseForKey:@MXM_DynaCfg_AV_Item_Key_C2CAdSightNotAutoDownloadTimeRange]) // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"Ad sight auto download closed by global setting");
        //the return stmt
        return YES;
    }
    if ([wrapMsgAutoDownloadControlContent length] > 0 && [MMConfigMgr isAutoDownloadCloseForValue:wrapMsgAutoDownloadControlContent]) // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"Ad sight auto download closed by msg source[%@]", wrapMsgAutoDownloadControlContent);
        //the return stmt
        return YES;
    }
    //the return stmt
    return NO;
}

#pragma mark - 小视频自动下载

//根据用户设置决定是否自动下载朋友圈微视频
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isAutoDownloadSight:
 * Returning Type: BOOL
 */ 
+(BOOL) isAutoDownloadSight : (WCDataItem*) dataItem
{
    
    if ([self isSnsSightInFlowControl]) // the 'if' part
    {
        //周期流控阶段 且 命中朋友圈小视频预加载实验
        if ([self isSnsSightInFlowControlByDailyTime] && [GET_SERVICE(WCFacade) couldRunSightPreload:dataItem]) // the 'if' part
        {
            //the return stmt
            return [SettingUtil isAutoDownloadSightForExp:dataItem];
        }
        //the return stmt
        return NO;
    }
    
    UInt32 currentSightSettingType = [[SettingUtil getMainSettingExt] getUInt32ForKey:SETTINGEXT_AUTO_DOWNLOAD_SIGHT_V2];
    
    //根据用户设置来决定是否下载，默认情况下在wifi或3G以上自动下载
    if(((currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_OVER2G) ||
        (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_DEFAULT)) &&
       [GET_SERVICE(CNetworkStatus) isOnWifiOrOver2G])
    // the 'if' part
    {
        //the return stmt
        return YES;
    }
    
    if (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_WIFI && [GET_SERVICE(CNetworkStatus) isOnWifi]) // the 'if' part
    {
        //the return stmt
        return YES;
    }
    
    //the return stmt
    return NO;
}

//流控阶段命中朋友圈小视频预加载实验逻辑
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isAutoDownloadSightForExp:
 * Returning Type: BOOL
 */ 
+ (BOOL) isAutoDownloadSightForExp : (WCDataItem*) dataItem
{
    //用户设置关闭自动下载小视频，就不做预加载了
    if ([SettingUtil isNeverAutoPlaySight]) // the 'if' part
    {
        //the return stmt
        return NO;
    }
    WCSnsOperation* snsOperation = [GET_SERVICE(WCFacade) getSnsOperationsWithFeedId:dataItem.itemID];
    UInt32 currentSightSettingType = [[SettingUtil getMainSettingExt] getUInt32ForKey:SETTINGEXT_AUTO_DOWNLOAD_SIGHT_V2];
    //用户设置3g/4g和Wifi自动下载小视频
    if(((currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_OVER2G) ||
        (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_DEFAULT)) &&
       [GET_SERVICE(CNetworkStatus) isOnWifiOrOver2G] && snsOperation.preloadInfo.sightAutoDownloadOn3GPlus)
    // the 'if' part
    {
        //the return stmt
        return YES;
    }
    
    //仅Wifi
    if (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_WIFI && [GET_SERVICE(CNetworkStatus) isOnWifi] && snsOperation.preloadInfo.sightAutoDownloadOnWifi) // the 'if' part
    {
        //the return stmt
        return YES;
    }
    //the return stmt
    return NO;
}

// 根据用户设置和流控开关决定是否自动下载朋友圈广告小视频
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isAutoDownloadAdSight:
 * Returning Type: BOOL
 */ 
+(BOOL)isAutoDownloadAdSight : (WCDataItem*) dataItem{
    if ([self isSnsAdSightInFlowControl]) // the 'if' part
    {
        //流控阶段 且 命中朋友圈小视频预加载实验
        if ([GET_SERVICE(WCFacade) couldRunSightPreload:dataItem]) // the 'if' part
        {
            //the return stmt
            return [SettingUtil isAutoDownloadSightForExp:dataItem];
        }
        //the return stmt
        return NO;
    }
    
    UInt32 currentSightSettingType = [[SettingUtil getMainSettingExt] getUInt32ForKey:SETTINGEXT_AUTO_DOWNLOAD_SIGHT_V2];
    
    //根据用户设置来决定是否下载，默认情况下在wifi或3G以上自动下载
    if(((currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_OVER2G) ||
        (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_DEFAULT)) &&
       [GET_SERVICE(CNetworkStatus) isOnWifiOrOver2G]) // the 'if' part
       {
        //the return stmt
        return YES;
    }
    
    if (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_WIFI
        && [GET_SERVICE(CNetworkStatus) isOnWifi]) // the 'if' part
        {
        //the return stmt
        return YES;
    }
    //the return stmt
    return NO;
}

//根据用户设置和流控开关决定是否预下载canvas广告里层的小视频
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isSnsAutoDownloadAdCanvasSight
 * Returning Type: BOOL
 */ 
+(BOOL)isSnsAutoDownloadAdCanvasSight
{
    if ([self isSnsAdSightInFlowControl]) // the 'if' part
    {
        //the return stmt
        return NO;
    }
    UInt32 currentSightSettingType = [[SettingUtil getMainSettingExt] getUInt32ForKey:SETTINGEXT_AUTO_DOWNLOAD_SIGHT_V2];
    
    //根据用户设置来决定是否下载，默认情况下在wifi或3G以上自动下载
    if(((currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_OVER2G) ||
        (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_DEFAULT)) &&
       [GET_SERVICE(CNetworkStatus) isOnWifiOrOver2G]) // the 'if' part
       {
        //the return stmt
        return YES;
    }
    
    if (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_WIFI
        && [GET_SERVICE(CNetworkStatus) isOnWifi]) // the 'if' part
        {
        //the return stmt
        return YES;
    }
    //the return stmt
    return NO;
}

//根据用户设置决定是否自动播放朋友圈微视频
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isAutoPlaySight
 * Returning Type: BOOL
 */ 
+(BOOL) isAutoPlaySight
{
    uint32_t currentSightSettingType = [[SettingUtil getMainSettingExt] getUInt32ForKey:SETTINGEXT_AUTO_DOWNLOAD_SIGHT_V2];
    //the func--->MMInfo() begin called!
    MMInfo(@"curAutoPlayType = %u", currentSightSettingType);
    
    //根据用户设置来决定是否自动播放，默认情况下在wifi或3G以上自动播放
    if(((currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_OVER2G) ||
        (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_DEFAULT)) &&
       [GET_SERVICE(CNetworkStatus) isOnWifiOrOver2G])
    // the 'if' part
    {
        //the return stmt
        return YES;
    }
    
    if (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_WIFI && [GET_SERVICE(CNetworkStatus) isOnWifi]) // the 'if' part
    {
        //the return stmt
        return YES;
    }
    
    //the return stmt
    return NO;
}

//用户是否设置为永不自动播放朋友圈微视频
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//SettingUtil.mm
 * Method Name: isNeverAutoPlaySight
 * Returning Type: BOOL
 */ 
+(BOOL) isNeverAutoPlaySight
{
    uint32_t currentSightSettingType = [[SettingUtil getMainSettingExt] getUInt32ForKey:SETTINGEXT_AUTO_DOWNLOAD_SIGHT_V2];
    
    if (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_NEVER) // the 'if' part
    {
        //the return stmt
        return YES;
    }
    else // the 'else' part
    if (currentSightSettingType == AUTO_DOWNLOAD_SIGHT_SETTING_DEFAULT)
    // the 'if' part
    {
        //如果是默认值，则用户还未设置过，此时直接替换为服务器下发的值
        UInt32 sightSettingFromServer = (uint32_t)[GET_SERVICE(MMConfigMgr) uintFromDynamicConfigForKey:@MXM_DynaCfg_AV_Item_Key_SIGHTAutoLoadNetwork];
        if (sightSettingFromServer == AUTO_DOWNLOAD_SIGHT_SETTING_NEVER) // the 'if' part
        {
            //the return stmt
            return YES;
        }
    }
    
    //the return stmt
    return NO;
}

@end
