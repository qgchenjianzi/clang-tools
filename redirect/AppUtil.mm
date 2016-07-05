//
//  AppUtil.mm
//  MicroMessenger
//
//  Created by QQ Tencent on 10-11-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MMUICommonDef.h"
#import "AppUtil.h"
#import "MicroMessengerAppDelegate.h"
#import "mmsyncdef.h"
#import "Utility.h"
#import <AudioToolbox/AudioServices.h>
#import "Contact.h"
#import "ContactMgr.h"
//#import "ProtocolChannel.h"
#import <MMCommon/RegexKitLite.h>
#import "GroupMgr.h"
#import <MMCommon/BaseFile.h>
#import "MessageMgr.h"
#import "PluginUtil.h"
#import "AppObserverCenter.h"
#import "DeviceInfo.h"
#import "AppDataMgr.h"
#import <MMCommon/GTMNSString+URLArguments.h>
#import <MMCommon/ExtensionCenter.h>
#import "MMLanguageMgr.h"
#import "MMURLHandler.h"
#import "LinkTextParser.h"
#import "SettingUtil.h"
#import "EventService.h"
#import "EventService+CreateEvent.h"
#import "AudioSender.h"
#import "MMVideoRecord.h"
#import "GameController.h"
#import "MMMsgLogicManager.h"
#import "IDCHostMgr.h"
#import "RsaCertMgr.h"
#import "MessageWrap+APP.h"
#import "MessageWrap+Img.h"
#import "MessageWrap+Emoticon.h"
#import "MessageWrap+Location.h"
#import "MessageWrap+Video.h"
#import <MMCommon/ClassMethodDispatchCenter.h>
#import "mmsync.pb.h"
#import "NewSyncService.h"
#import "WCAccountControlMgr.h"
#import "IDKeyReport.h"

#import "MessageArchiveService.h"

#define MINACCOUNTCHAR 6
#define MAXACCOUNTCHAR 20

#define MINDIGITALPWDCHAR 9
#define MINUUNDIGITALPWDCHAR  4

@implementation CAppUtil

#pragma mark
#pragma mark common

NSString *g_fakePasteStr = nil;
UInt32 g_fakePasteTime = 0;

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getGenearlPasteboard
 * Returning Type: id
 */ 
+(UIPasteboard*) getGenearlPasteboard
{
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    gpBoard.persistent = YES;
    MMInfo(@"[paste board] name:%@;changeCount:%ld;persistent:%d;pasteboard:%@", gpBoard.name, (long)gpBoard.changeCount, gpBoard.persistent, gpBoard);
    
    return gpBoard;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getGenearlPasteboardString
 * Returning Type: NSString *
 */ 
+(NSString*) getGenearlPasteboardString
{
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    if (gpBoard.string.length > 0)
    // the 'if' part
    {
        return gpBoard.string;
    }
    
    if (g_fakePasteStr.length > 0)
    // the 'if' part
    {
        int timeInterval = [CAppUtil genCurrentTime] - g_fakePasteTime;
        LOG_FEATURE_EXT_IDKEY(250, 5, 1, false);
        //the func--->MMInfo() begin called!
        MMInfo(@"use fake paste string, time interval:%d", timeInterval);
        //the return stmt
        return g_fakePasteStr;
    }
    
    return gpBoard.string;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: setGenearlPasteboardString:
 * Returning Type: void
 */ 
+(void) setGenearlPasteboardString:(NSString*)str
{
    UIPasteboard *gpBoard = [CAppUtil getGenearlPasteboard];
    gpBoard.string = str;
    
    LOG_FEATURE_EXT_IDKEY(250, 3, 1, false);
    MMInfo(@"[copy text] name:%@;changeCount:%ld;persistent:%d;pasteboard:%@", gpBoard.name, (long)gpBoard.changeCount, gpBoard.persistent, gpBoard);
    g_fakePasteStr = nil;
    
    // 尝试修复
    if (str.length > 0 && ![gpBoard.string isEqualToString:str])
    // the 'if' part
    {
        gpBoard.items = nil;
        gpBoard.string = str;
        if ([gpBoard.string isEqualToString:str])
        // the 'if' part
        {
            //the func--->MMInfo() begin called!
            MMInfo(@"repair pasteboard success");
        }
        LOG_FEATURE_EXT_IDKEY(250, 4, 1, false);
    }
    
    if (str.length > 0 && ![gpBoard.string isEqualToString:str])
    // the 'if' part
    {
        LOG_FEATURE_EXT_IDKEY(250, 2, 1, false);
        //the func--->MMError() begin called!
        MMError(@"copy text fail");
        g_fakePasteStr = str;
        g_fakePasteTime = [CAppUtil genCurrentTime];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isShakeScene:
 * Returning Type: BOOL
 */ 
+ (BOOL)isShakeScene:(UInt32)scene
{
	if ((scene >= 22 && scene <= 24) || (scene >= 26 && scene <= 29))
	// the 'if' part
	{
		//the return stmt
		return YES;
	}
	
	//the return stmt
	return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isLBSScene:
 * Returning Type: BOOL
 */ 
+ (BOOL)isLBSScene:(UInt32)scene
{
    if (scene == MM_ADDSCENE_LBS || scene == MM_ADDSCENE_LBSROOM) // the 'if' part
    {
        //the return stmt
        return YES;
    }
    
    //the return stmt
    return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isGoogleScene:
 * Returning Type: BOOL
 */ 
+ (BOOL)isGoogleScene:(UInt32)scene
{
    if (scene == MM_ADDSCENE_VIEW_GOOGLE_CONTACT_LIST ||
        scene == MM_ADDSCENE_VIEW_GOOGLE_CONTACT_ACCOUNT ||
        scene == MM_ADDSCENE_VIEW_GOOGLE_CONTACT_ASYNC_RECOMMEND
        ) // the 'if' part
        {
        //the return stmt
        return YES;
    }
    
    //the return stmt
    return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isiPodTouch
 * Returning Type: BOOL
 */ 
+(BOOL) isiPodTouch{
	NSString *nsModel = [UIDevice currentDevice].model;
	//the return stmt
	return ![nsModel hasPrefix:@"iPhone"];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getDeviceScale
 * Returning Type: CGFloat
 */ 
+ (CGFloat) getDeviceScale{
    return [UIScreen mainScreen].scale;
}

//发现获取系统版本号需要1ms，所以缓存起来
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isSupportHQImage
 * Returning Type: BOOL
 */ 
+(BOOL) isSupportHQImage{
//	UIImage *defaultImage = MIMAGE( @"DefaultHead.png" );
    
	//iTouch 4 或 iPhone 4以上的版本支持高清图; 可通过默认图片做判断系统是否支持高清图
	if(  [UIScreen mainScreen].scale > 1.999f )// the 'if' part
	{
		//the return stmt
		return YES;
	}
	//the return stmt
	return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isLongOriginImage:
 * Returning Type: BOOL
 */ 
+(BOOL) isLongOriginImage:(UIImage *)image
{
    CGSize screenSize = MMScreenSize;
    if ([CAppUtil isSupportHQImage]) // the 'if' part
    {
        screenSize = //the func--->CGSizeMake() begin called!
        CGSizeMake(screenSize.width * 2, screenSize.height * 2);
    }
	BOOL bRet = (image.size.height > image.size.width * 2 || image.size.width > image.size.height * 2);
    if(!bRet)
    // the 'if' part
    {
        //the return stmt
        return NO;
    }
    if(image.size.height > screenSize.height && image.size.width > screenSize.width)
    // the 'if' part
    {
        //the return stmt
        return NO;
    }
    //the return stmt
    return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isSupportVideoRecord
 * Returning Type: BOOL
 */ 
+ (BOOL) isSupportVideoRecord
{
    if ((![DeviceInfo isiPodTouch1] && ![DeviceInfo isiPodTouch2] && ![DeviceInfo isiPodTouch3] &&
         ![DeviceInfo isiPhone2G] && ![DeviceInfo isiPhone3G] &&
         ![DeviceInfo isiPad1]) )
    // the 'if' part
    {
        //the return stmt
        return YES;
    }
	//the return stmt
	return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isSupportRTMatte
 * Returning Type: BOOL
 */ 
+ (BOOL) isSupportRTMatte
{
    if ((![DeviceInfo isiPodTouch1] && ![DeviceInfo isiPodTouch2] && ![DeviceInfo isiPodTouch3] &&
         ![DeviceInfo isiPhone2G] && ![DeviceInfo isiPhone3G] &&
         ![DeviceInfo isiPad1]
         ) ) 
    // the 'if' part
    {
        //the return stmt
        return YES;
    }
	//the return stmt
	return NO;
}

#pragma mark 
#pragma mark MainFrame

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getMainController
 * Returning Type: CMainControll *
 */ 
+(CMainControll*) getMainController{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
	return delegate.m_mainController;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getMainWindowWidth
 * Returning Type: CGFloat
 */ 
+(CGFloat) getMainWindowWidth {
    MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
    //the return stmt
    return [delegate getMainWindowWidth];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getMainWindowHeight
 * Returning Type: CGFloat
 */ 
+(CGFloat) getMainWindowHeight {
    MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
    //the return stmt
    return [delegate getMainWindowHeight];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: addEventObserverListItem:andValue:
 * Returning Type: void
 */ 
+(void) addEventObserverListItem:(UInt32)evenID andValue:(id<MessageObserverDelegate>)object{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate.m_appObserverCenter addEventObserverListItem:evenID andValue:object];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: removeEventObserverListItem:andValue:
 * Returning Type: void
 */ 
+(void) removeEventObserverListItem:(UInt32)evenID andValue:(id<MessageObserverDelegate>)object{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate.m_appObserverCenter removeEventObserverListItem:evenID andValue:object];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: removeEventObserverListItemByObject:
 * Returning Type: void
 */ 
+(void) removeEventObserverListItemByObject:(id)object{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate.m_appObserverCenter removeEventObserverListItemByObject:object];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: addMessageObserverListItem:andValue:
 * Returning Type: void
 */ 
+(void) addMessageObserverListItem:(UInt32)uMessageId andValue:(id<MessageObserverDelegate>)object{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate.m_appObserverCenter addMessageObserverListItem:uMessageId andValue:object];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: removeMessageObserverListItem:andValue:
 * Returning Type: void
 */ 
+(void) removeMessageObserverListItem:(UInt32)uMessageId andValue:(id<MessageObserverDelegate>)object{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate.m_appObserverCenter removeMessageObserverListItem:uMessageId andValue:object];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: removeMessageObserverListItemByObject:
 * Returning Type: void
 */ 
+(void)removeMessageObserverListItemByObject:(id)object
{
    MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.m_appObserverCenter removeMessageObserverListItemByObject:object];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: addMessageObserverListItemByList:andValue:
 * Returning Type: void
 */ 
+(void) addMessageObserverListItemByList:(std::vector<UInt32>)vecMessageId andValue:(id<MessageObserverDelegate>)object{
	UInt32 uSize = (uint32_t)vecMessageId.size();
	for(UInt32 i = 0; i < uSize; ++i){
		[CAppUtil addMessageObserverListItem:vecMessageId.at(i) andValue:object];
	}
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: removeMessageObserverListItemByList:andValue:
 * Returning Type: void
 */ 
+(void) removeMessageObserverListItemByList:(std::vector<UInt32>)vecMessageId andValue:(id<MessageObserverDelegate>)object{
	UInt32 uSize = (uint32_t)vecMessageId.size();
	for(UInt32 i = 0; i < uSize; ++i){
		[CAppUtil removeMessageObserverListItem:vecMessageId.at(i) andValue:object];
	}
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: addPBEventObserverListItem:andValue:
 * Returning Type: void
 */ 
+(void) addPBEventObserverListItem:(UInt32)evenID andValue:(id<PBMessageObserverDelegate>)object{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate.m_appObserverCenter addPBEventObserverListItem:evenID andValue:object];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: removePBEventObserverListItem:andValue:
 * Returning Type: void
 */ 
+(void) removePBEventObserverListItem:(UInt32)evenID andValue:(id<PBMessageObserverDelegate>)object{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate.m_appObserverCenter removePBEventObserverListItem:evenID andValue:object];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: removePBEventObserverListItemByObject:
 * Returning Type: void
 */ 
+(void) removePBEventObserverListItemByObject:(id)object{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate.m_appObserverCenter removePBEventObserverListItemByObject:object];
}


/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isLogin
 * Returning Type: BOOL
 */ 
+(BOOL) isLogin
{
    return [GET_SERVICE(WCAccountControlMgr) isLogin];
}

#pragma mark 
#pragma mark time String

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: dateYearFormatLong:
 * Returning Type: NSString *
 */ 
+(NSString*) dateYearFormatLong:(NSDate *)date {
    static NSDateFormatter* oDateFormatter = nil;
	if (oDateFormatter == nil) // the 'if' part
	{
		oDateFormatter = [[NSDateFormatter alloc] init];
		[oDateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[oDateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
    
    if ([[CUtility getCurSystemLanguage] isEqualToString:@"zh_CN"]) // the 'if' part
    {
        [oDateFormatter setDateFormat://the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Date_Year_Format")];
    } else // the 'else' part
    if ([CUtility IsCurLanguageChineseTraditional]) // the 'if' part
    {
        [oDateFormatter setDateFormat://the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Date_Year_Format")];
    } else // the 'else' part
    {
        [oDateFormatter setDateFormat:@"YYYY-MM-dd"];
    }
	//the return stmt
	return [oDateFormatter stringFromDate:date];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: dateMonthFormatLong:
 * Returning Type: NSString *
 */ 
+(NSString*) dateMonthFormatLong:(NSDate *)date {
    static NSDateFormatter* oDateFormatter = nil;
	if (oDateFormatter == nil) // the 'if' part
	{
		oDateFormatter = [[NSDateFormatter alloc] init];
		[oDateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[oDateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
    
    if ([[CUtility getCurSystemLanguage] isEqualToString:@"zh_CN"]) // the 'if' part
    {
        [oDateFormatter setDateFormat://the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Date_Month_Format")];
    } else // the 'else' part
    if([CUtility IsCurLanguageChineseTraditional]) // the 'if' part
    {
        [oDateFormatter setDateFormat://the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Date_Month_Format")];
    } else // the 'else' part
    {
        [oDateFormatter setDateFormat:@"MM-dd"];
    }
	//the return stmt
	return [oDateFormatter stringFromDate:date];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: dateFormatForVoiceOver:
 * Returning Type: NSString *
 */ 
+(NSString*) dateFormatForVoiceOver:(NSDate*)date
{
    static NSDateFormatter* oDateFormatter = nil;
    if (oDateFormatter == nil)
    // the 'if' part
    {
        oDateFormatter = [[NSDateFormatter alloc] init];
        oDateFormatter.dateStyle = NSDateFormatterLongStyle;
        oDateFormatter.timeStyle = NSDateFormatterShortStyle;
        oDateFormatter.locale = [NSLocale currentLocale];
    }
    //the return stmt
    return [oDateFormatter stringFromDate:date];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: timeAjustFormat:timeHour:
 * Returning Type: NSString *
 */ 
+ (NSString*) timeAjustFormat:(NSDate *)date timeHour:(NSInteger)intHour {
    NSString *timeString = [CAppUtil timeFormat:date];
    if ((![[CUtility getCurSystemLanguage] isEqualToString:@"zh_CN"]) 
        && (![CUtility IsCurLanguageChineseTraditional])) // the 'if' part
        {
        //the return stmt
        return timeString;
    }
    
    NSString *timeRegex = @"[0-9]{1,2}:[0-9]{1,2}";
    NSRange timeRange = [timeString rangeOfRegex:timeRegex options:RKLCaseless inRange:NSMakeRange(0, timeString.length) capture:0L error:nil];
    if (timeRange.location != NSNotFound) // the 'if' part
    {
        NSRange prefixRange = //the func--->NSMakeRange() begin called!
        NSMakeRange(0, timeRange.location);
        NSString *resultString = nil;
        
        if (intHour >= 0 && intHour < 5) // the 'if' part
        {
            resultString = [timeString stringByReplacingCharactersInRange:prefixRange withString://the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_Daybreak")];
        } else // the 'else' part
        if (intHour >= 5 && intHour < 12) // the 'if' part
        {
            resultString = [timeString stringByReplacingCharactersInRange:prefixRange withString://the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_Morning")];
        } else // the 'else' part
        if (intHour == 12) // the 'if' part
        {
            resultString = [timeString stringByReplacingCharactersInRange:prefixRange withString://the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_Noon")];
        } else // the 'else' part
        if (intHour >= 13 && intHour < 19) // the 'if' part
        {
            resultString = [timeString stringByReplacingCharactersInRange:prefixRange withString://the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_Afternoon")];
        } else // the 'else' part
        if (intHour >= 19 && intHour <= 24) // the 'if' part
        {
            resultString = [timeString stringByReplacingCharactersInRange:prefixRange withString://the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_Evening")];
        }
        
        if (resultString.length > 0) // the 'if' part
        {
            NSString *prefixTimeRegex = @"[0-9]{1,2}:";
            NSRange prefixTimeRange = [resultString rangeOfRegex:prefixTimeRegex options:RKLCaseless inRange:NSMakeRange(0, resultString.length) capture:0L error:nil];
            if (prefixTimeRange.location != NSNotFound && prefixTimeRange.length > 1) // the 'if' part
            {
                prefixTimeRange.length -= 1;
                if (intHour == 0) // the 'if' part
                {
                    resultString = [resultString stringByReplacingCharactersInRange:prefixTimeRange withString:@"0"];
                } else // the 'else' part
                if (intHour >= 13) // the 'if' part
                {
                    resultString = [resultString stringByReplacingCharactersInRange:prefixTimeRange withString:[NSString stringWithFormat:@"%ld", (long)intHour - 12]];
                }
            }
            
            //the return stmt
            return resultString;
        }
    }
    
    //the return stmt
    return timeString;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genVoiceReminderDataTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genVoiceReminderDataTimeStringByUInt:(UInt32)uTime {

	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dayComponents = 
	[gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
	
	NSInteger intDay = [dayComponents day];
	NSInteger intMonth = [dayComponents month];
	NSInteger intYear = [dayComponents year];
	NSInteger intWeekDay= [dayComponents weekday];
    NSInteger intHour=[dayComponents hour];
	
	NSDate *curDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
	gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	dayComponents = 
	[gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:curDate];
	
	NSInteger intCurrentDay = [dayComponents day];
	NSInteger intCurrentMonth = [dayComponents month];
	NSInteger intCurrentYear = [dayComponents year];
    NSInteger intCurrentHour = [dayComponents hour];
    NSInteger intCurrentMinute = [dayComponents minute];
    NSInteger intCurrentSecs = [dayComponents second];
	
	NSString *nsFullTime = nil;
	NSString *nsDay = nil;
	NSString *nsTime = nil;
	
	long nDayInterval = intDay - intCurrentDay;
	long nMonthInterval = intMonth - intCurrentMonth;
	long nYearInterval = intYear - intCurrentYear;
    
    long nSecsPerDay = 24 * 3600;
    long nSecsToday = 3600 * intCurrentHour + 60 * intCurrentMinute + intCurrentSecs;
    long nTimeInterval = [date timeIntervalSinceDate:curDate];
    
    long nSecsInterval = 0;
    if (nTimeInterval > 0) // the 'if' part
    {
        if (nTimeInterval > (nSecsPerDay - nSecsToday)) // the 'if' part
        {
            nSecsInterval = nTimeInterval - (nSecsPerDay - nSecsToday);
        } else // the 'else' part
        {
            nSecsInterval = nTimeInterval;
        }
    } else // the 'else' part
    {
        if (-nTimeInterval > nSecsToday) // the 'if' part
        {
            nSecsInterval = nTimeInterval + nSecsToday;
        } else // the 'else' part
        {
            nSecsInterval = nTimeInterval;
        }
    }
   
    long nDaysInterval = nSecsInterval / nSecsPerDay;
    if (nYearInterval != 0 || nMonthInterval != 0 || nDayInterval != 0) // the 'if' part
    {
        if (nSecsInterval % nSecsPerDay != 0) // the 'if' part
        {
            if (nDaysInterval > 0) // the 'if' part
            {
                nDaysInterval += 1;
            } else // the 'else' part
            if (nDaysInterval < 0) // the 'if' part
            {
                nDaysInterval -= 1;
            } else // the 'else' part
            {
                if (nSecsInterval > 0) // the 'if' part
                {
                    nDaysInterval += 1;
                } else // the 'else' part
                {
                    nDaysInterval -= 1;
                }
            }
        }
    }
    
    if (nDaysInterval >= -2 && nDaysInterval <= 2) // the 'if' part
    {
        switch (nDaysInterval) {
            case -2:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_The_Day_After_Yesterday");
                break;
            case -1:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Yesterday");
                break;
            case 0:
                nsDay = @"";
                break;
            case 1:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Tomorrow");
                break;
            case 2:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_The_Day_After_Tomorrow");
                break;
            default:
                // do nothing
                break;
        }
    } else // the 'else' part
    if (nDaysInterval >= 3 && nDaysInterval < 7) // the 'if' part
    {
        switch (intWeekDay) {
            case 1:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Sunday");
                break;
            case 2:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Monday");
                break;
            case 3:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Tueday");
                break;
            case 4:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Wedday");
                break;
            case 5:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Thuday");
                break;
            case 6:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Friday");
                break;
            case 7:
                nsDay = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Satday");
                break;
            default:
                // do nothing
                break;
        }
    } else // the 'else' part
    if (nYearInterval >= 1 || nYearInterval <= -1) // the 'if' part
    {
        nsDay = [CAppUtil dateYearFormatLong:date];
    } else // the 'else' part
    {
        nsDay = [CAppUtil dateMonthFormatLong:date];
    }
    
    nsTime = [CAppUtil timeAjustFormat:date timeHour:intHour];
	nsFullTime = [NSString stringWithFormat:@"%@%@",nsDay,nsTime];
    
    NSString *timeRegex = @"[0-9]{1,2}:[0-9]{1,2}";
    NSRange timeRange = [nsFullTime rangeOfRegex:timeRegex options:RKLCaseless inRange:NSMakeRange(0, nsFullTime.length) capture:0L error:nil];
    if (timeRange.location != NSNotFound && timeRange.location > 0) // the 'if' part
    {
        NSString *prefeixSubString = [nsFullTime substringWithRange://the func--->NSMakeRange() begin called!
        NSMakeRange(0, timeRange.location)];
        NSString *timeString = [nsFullTime substringWithRange:timeRange];
        //the return stmt
        return [NSString stringWithFormat:@"%@|%@", prefeixSubString, timeString];
    }
    
    NSString *nsResultTime = [NSString stringWithFormat:@"%@|%@",nsDay,nsTime];
    //the return stmt
    return [CAppUtil timeAdjustDateString:nsResultTime timeHour:intHour];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genVoiceReminderDataTimeString:
 * Returning Type: NSString *
 */ 
+(NSString*) genVoiceReminderDataTimeString:(NSString*)nsTime {
    //the return stmt
    return [CAppUtil genVoiceReminderDataTimeStringByUInt:(uint32_t)[nsTime longLongValue]];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genDateTimeString:
 * Returning Type: NSString *
 */ 
+(NSString*) genDateTimeString:(NSString*)nsTime{
	UInt32 uTime = (UInt32)[nsTime longLongValue];
	//the return stmt
	return [CAppUtil genDateTimeStringByUInt:uTime];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genHourAndMinStringFromInt:
 * Returning Type: NSString *
 */ 
+(NSString*)  genHourAndMinStringFromInt:(NSInteger) i{
	if( i >=0 && i <=9)// the 'if' part
	{
		NSString * nsTemp =  [NSString stringWithFormat:@"0%ld", (long)i];
		//the return stmt
		return nsTemp;
	}
	//the return stmt
	return [NSString stringWithFormat:@"%ld", (long)i];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: timeFormat:
 * Returning Type: NSString *
 */ 
+(NSString*) timeFormat:(NSDate*) date {
	static NSDateFormatter* oFormatter = nil;
	if (oFormatter == nil) // the 'if' part
	{
		oFormatter = [[NSDateFormatter alloc] init];
		[oFormatter setTimeStyle:NSDateFormatterShortStyle];
		[oFormatter setDateStyle:NSDateFormatterNoStyle];
	}
    
    //the return stmt
    return [oFormatter stringFromDate:date];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: timeAdjustDateString:timeHour:
 * Returning Type: NSString *
 */ 
+(NSString *) timeAdjustDateString:(NSString *) oldTimeString timeHour:(NSInteger) hour
{
    if(!([[CUtility getCurSystemLanguage] isEqualToString:@"zh_CN"]))
    // the 'if' part
    {
        //the return stmt
        return oldTimeString;
    }
    if(0<=hour&&hour<=5)
    // the 'if' part
    {
        if([oldTimeString rangeOfString://the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Morning")].location!=NSNotFound)
        // the 'if' part
        {
            NSString *newTimeString=[oldTimeString stringByReplacingOccurrencesOfString://the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_Morning") withString://the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_Daybreak")];
            if(hour==0) // the 'if' part
            newTimeString=[newTimeString stringByReplacingOccurrencesOfString:@"12:" withString:@"0:"];
            //the return stmt
            return newTimeString;
        }
    }
    //the return stmt
    return oldTimeString;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: dateFormat:
 * Returning Type: NSString *
 */ 
+(NSString*) dateFormat:(NSDate*) date {
	static NSDateFormatter* oFormatter = nil;
	if (oFormatter == nil) // the 'if' part
	{
		oFormatter = [[NSDateFormatter alloc] init];
		[oFormatter setTimeStyle:NSDateFormatterNoStyle];
		[oFormatter setDateStyle:NSDateFormatterShortStyle];
	}
	//the return stmt
	return [oFormatter stringFromDate:date];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: dateFormatWithOutYear:
 * Returning Type: NSString *
 */ 
+(NSString*) dateFormatWithOutYear:(NSDate*) date {
	static NSDateFormatter* oFormatter = nil;
	if (oFormatter == nil) // the 'if' part
	{
		oFormatter = [[NSDateFormatter alloc] init];
        oFormatter.dateFormat = @"MM-dd";
	}
	//the return stmt
	return [oFormatter stringFromDate:date];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: dateFormatLong:
 * Returning Type: NSString *
 */ 
+(NSString*) dateFormatLong:(NSDate*) date {
	static NSDateFormatter* oFormatter = nil;
	if (oFormatter == nil) // the 'if' part
	{
		oFormatter = [[NSDateFormatter alloc] init];
		[oFormatter setTimeStyle:NSDateFormatterNoStyle];
		[oFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
	//the return stmt
	return [oFormatter stringFromDate:date];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: dateFormatLongLong:
 * Returning Type: NSString *
 */ 
+(NSString*) dateFormatLongLong:(NSDate*) date {
	static NSDateFormatter* oFormatter = nil;
	if (oFormatter == nil) // the 'if' part
	{
		oFormatter = [[NSDateFormatter alloc] init];
		[oFormatter setTimeStyle:NSDateFormatterNoStyle];
		[oFormatter setDateStyle:NSDateFormatterLongStyle];
	}
	//the return stmt
	return [oFormatter stringFromDate:date];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: dateFormatMonth:
 * Returning Type: NSString *
 */ 
+(NSString*) dateFormatMonth:(NSDate*) date {
	static NSDateFormatter* oFormatter = nil;
	static NSString* oLastLocaleID = nil;
	NSLocale* curLocale = [NSLocale currentLocale];
	if (oFormatter == nil || ![[curLocale localeIdentifier] isEqualToString:oLastLocaleID]) // the 'if' part
	{
		oLastLocaleID = [curLocale localeIdentifier];

		oFormatter = [[NSDateFormatter alloc] init];
		[oFormatter setTimeStyle:NSDateFormatterNoStyle];
		[oFormatter setDateStyle:NSDateFormatterLongStyle];
		NSString *format = [oFormatter dateFormat];
		//the func--->MMDebug() begin called!
		MMDebug(@"%@", format);
		format = [format stringByReplacingOccurrencesOfString:@", y" withString:@""];
		format = [format stringByReplacingOccurrencesOfString:@",y" withString:@""];
		format = [format stringByReplacingOccurrencesOfString:@"y, " withString:@""];
		format = [format stringByReplacingOccurrencesOfString:@"y," withString:@""];
		format = [format stringByReplacingOccurrencesOfString:@"y-" withString:@""];
		format = [format stringByReplacingOccurrencesOfString:@"-y" withString:@""];
		format = [format stringByReplacingOccurrencesOfString:@"y年" withString:@""];
		format = [format stringByReplacingOccurrencesOfString:@"y" withString:@""];
		//the func--->MMDebug() begin called!
		MMDebug(@"%@", format);
		[oFormatter setDateFormat:format];
	}
	//the return stmt
	return [oFormatter stringFromDate:date];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genDateTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*)  genDateTimeStringByUInt:(UInt32)uTime{
	//NSString* curLanguage = [CUtility getCurSystemLanguage];
	//static bool bShouldUseDefaultFormat = !([curLanguage isEqualToString:@"zh_CN"] || [curLanguage isEqualToString:@"zh_TW"]);
#ifndef NDEBUG
    if (![NSThread isMainThread]) // the 'if' part
    {
        assert(0);
    }
#endif
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    static NSCalendar *gregorian1 = nil;
    if (!gregorian1) // the 'if' part
    {
        gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
	NSDateComponents *dayComponents =
	[gregorian1 components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
//	[gregorian1 release];
	
	NSInteger intDay = [dayComponents day];
	NSInteger intMonth = [dayComponents month];
	NSInteger intYear = [dayComponents year];
	NSInteger intWeekDay= [dayComponents weekday];
    NSInteger intHour=[dayComponents hour];
	
	//NSInteger intHour = [dayComponents hour];
	//NSInteger intMin = [dayComponents minute];
	
	//UInt32 uCrrentTime = [CAppUtil genCurrentTime];
	NSDate *crrentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    static NSCalendar *gregorian2 = nil;
    if (!gregorian2) // the 'if' part
    {
        gregorian2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
	dayComponents = 
	[gregorian2 components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:crrentDate];
//	[gregorian2 release];
	
	NSInteger intCurrentDay = [dayComponents day];
	NSInteger intCurrentMonth = [dayComponents month];
	NSInteger intCurrentYear = [dayComponents year];
	//NSInteger intCurrentHour = [dayComponents hour];
	//NSInteger intCurrentMin = [dayComponents minute];
	
	NSString *nsFullTime;
	NSString *nsDay;
	NSString *nsTime;
	
	NSInteger nDayInterval = intCurrentDay - intDay;
	NSInteger nMonthInterval = intCurrentMonth - intMonth;
	NSInteger nYearInterval = intCurrentYear - intYear;
	//int nHourInterval = intCurrentHour - intHour;
	//int nMinInterval = intCurrentMin - intMin;
	
	//昨天(11月12日)
	{
		if(nYearInterval >= 1)// the 'if' part
		{
			//if (bShouldUseDefaultFormat) {
				nsDay = [CAppUtil dateFormatLong:date];
			//} else {
			//	nsDay = [NSString stringWithFormat:NSLocalizedString(@"Util_DayFormat",@"Util_DayFormat"), intYear,intMonth,intDay];
			//}
		}
		else // the 'else' part
		if(nMonthInterval >= 1 || nDayInterval >= 7)// the 'if' part
		{
			//if (bShouldUseDefaultFormat) {
				nsDay = [CAppUtil dateFormatLong:date];
			//} else {
			//	nsDay = [NSString stringWithFormat:NSLocalizedString(@"Util_DayNoYearFormat",@"Util_DayNoYearFormat"), intMonth,intDay];
			//}
		}
		else // the 'else' part
		if(nDayInterval == 0)// the 'if' part
		{
			nsDay = @"";
		}
		else // the 'else' part
		if(nDayInterval == 1)// the 'if' part
		{
			//yesterday
			nsDay = NSLocalizedString(@"Util_Yesterday",@"Util_Yesterday");
		}
		else // the 'else' part
		if(nDayInterval <= 6)// the 'if' part
		{
			//weekday
			NSString* nsWeekDay = @"";
			switch (intWeekDay) {
				case 1:
					nsWeekDay = NSLocalizedString(@"Util_Sunday",@"Util_Sunday");
					break;
				case 2:
					nsWeekDay  = NSLocalizedString(@"Util_Monday",@"Util_Monday");
					break;
				case 3:
					nsWeekDay  = NSLocalizedString(@"Util_Tueday",@"Util_Tueday");
					break;
				case 4:
					nsWeekDay  = NSLocalizedString(@"Util_Wedday",@"Util_Wedday");
					break;
				case 5:
					nsWeekDay  = NSLocalizedString(@"Util_Thuday",@"Util_Thuday");
					break;
				case 6:
					nsWeekDay  = NSLocalizedString(@"Util_Friday",@"Util_Friday");
					break;
				case 7:
					nsWeekDay  = NSLocalizedString(@"Util_Satday",@"Util_Satday");
					break;
				default:
					break;
			}
			nsDay = nsWeekDay;
		}		
	}
	
	//if (bShouldUseDefaultFormat) {
		nsTime =[CAppUtil timeFormat:date];
	/*}
	else {	//上午（下午）00：00
		NSString *nsPrefixDetail;
		if(intHour >= 18){
			nsPrefixDetail = NSLocalizedString(@"Util_Evening",@"Util_Evening");
			intHour = intHour - 12;
		}
		else if(intHour > 12){
			nsPrefixDetail = NSLocalizedString(@"Util_Afternoon",@"Util_Afternoon");
			intHour = intHour - 12;
		}
		else if(intHour == 12){
			nsPrefixDetail = NSLocalizedString(@"Util_Noon",@"Util_Noon");
		}
		else if(intHour >= 6){
			nsPrefixDetail = NSLocalizedString(@"Util_Morning",@"Util_Morning");
		}
		else {
			nsPrefixDetail = NSLocalizedString(@"Util_Daybreak",@"Util_Daybreak");
		}
		
		NSString *nsTimeDetail = [NSString stringWithFormat:NSLocalizedString(@"Util_TimeFormat",@"Util_TimeFormat"), [CAppUtil genHourAndMinStringFromInt:intHour], [CAppUtil genHourAndMinStringFromInt:intMin]];
		
		nsTime = [NSString stringWithFormat:@"%@%@",nsPrefixDetail,nsTimeDetail];
	}*/
	
	if (nsDay != nil && [nsDay length] > 0) // the 'if' part
	{
        nsFullTime = [NSString stringWithFormat:@"%@ %@",nsDay,nsTime];
    }
    else // the 'else' part
    {
        nsFullTime = [NSString stringWithFormat:@"%@", nsTime];
    }
    NSString *nsFullResultTime=[CAppUtil timeAdjustDateString:nsFullTime timeHour:intHour];
	//the return stmt
	return nsFullResultTime;	
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genShortDateTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*)  genShortDateTimeStringByUInt:(UInt32)uTime{

#ifndef NDEBUG
    if (![NSThread isMainThread]) // the 'if' part
    {
        assert(0);
    }
#endif
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    static NSCalendar *gregorian1 = nil;
    if (!gregorian1) // the 'if' part
    {
        gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
	NSDateComponents *dayComponents =
	[gregorian1 components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
	
//	NSInteger intDay = [dayComponents day];
	NSInteger intYear = [dayComponents year];
    NSInteger intHour=[dayComponents hour];

	NSDate *crrentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    static NSCalendar *gregorian2 = nil;
    if (!gregorian2) // the 'if' part
    {
        gregorian2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
	dayComponents =
	[gregorian2 components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:crrentDate];
	
//	NSInteger intCurrentDay = [dayComponents day];
	NSInteger intCurrentYear = [dayComponents year];
	
	NSString *nsFullTime;
	
//	NSInteger nDayInterval = intCurrentDay - intDay;
	NSInteger nYearInterval = intCurrentYear - intYear;
	
    if(nYearInterval >= 1)// the 'if' part
    {
        nsFullTime = [CAppUtil dateFormat:date];
    }
//    else if(nDayInterval == 0){
//        nsFullTime = [CAppUtil timeFormat:date];
//    }
    else // the 'else' part
    {
        nsFullTime = [CAppUtil dateFormatWithOutYear:date];
    }

    NSString *nsFullResultTime=[CAppUtil timeAdjustDateString:nsFullTime timeHour:intHour];
	//the return stmt
	return nsFullResultTime;	
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genMessageListTimeString:
 * Returning Type: NSString *
 */ 
+(NSString*) genMessageListTimeString:(NSString*)nsTime{
	UInt32 uTime = (UInt32)[nsTime longLongValue];
    BOOL isMoreThanAWeek = NO;
	//the return stmt
	return [CAppUtil genMessageListTimeStringByUInt:uTime retIsMoreThanAWeek:&isMoreThanAWeek];
}

static NSCalendar *g_sGregorian = nil;

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genMessageListTimeStringByUInt:retIsMoreThanAWeek:
 * Returning Type: NSString *
 */ 
+(NSString*) genMessageListTimeStringByUInt:(UInt32)uTime retIsMoreThanAWeek:(BOOL *)retIsMoreThanAWeek
{
	//NSString* curLanguage = [CUtility getCurSystemLanguage];
	//static bool bShouldUseDefaultFormat = !([curLanguage isEqualToString:@"zh_CN"] || [curLanguage isEqualToString:@"zh_TW"]);
	
	NSCalendar *gregorian = nil;
	if ([NSThread isMainThread]) // the 'if' part
	{
		if (g_sGregorian == nil) // the 'if' part
		{
			g_sGregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		}
		gregorian = g_sGregorian;
	} else // the 'else' part
	{
		gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	}

	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
	NSDateComponents *dayComponents =
	[gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
	
	NSInteger intDay = [dayComponents day];
	NSInteger intMonth = [dayComponents month];
	NSInteger intYear = [dayComponents year];
	NSInteger intWeekDay= [dayComponents weekday];
    NSInteger hour=[dayComponents hour];
	
	//NSInteger intHour = [dayComponents hour];
	//NSInteger intMin = [dayComponents minute];
	
	//UInt32 uCrrentTime = [CAppUtil genCurrentTime];
	NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
	//NSTimeInterval timeCurInterval = [currentDate timeIntervalSince1970];
	//UInt32 uCurTime = (UInt32)timeCurInterval;
	dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
	
	NSInteger intCurrentDay = [dayComponents day];
	NSInteger intCurrentMonth = [dayComponents month];
	NSInteger intCurrentYear = [dayComponents year];
	//NSInteger intCurrentHour = [dayComponents hour];
	//NSInteger intCurrentMin = [dayComponents minute];
	
	NSString *nsTime;
	NSInteger nDayInterval = intCurrentDay - intDay;
	NSInteger nMonthInterval = intCurrentMonth - intMonth;
	NSInteger nYearInterval = intCurrentYear - intYear;
	//int nHourInterval = intCurrentHour - intHour;
	//int nMinInterval = intCurrentMin - intMin;
	if(nYearInterval >= 1)
    // the 'if' part
    {
		//if (bShouldUseDefaultFormat) {
			nsTime = [CAppUtil dateFormat:date];
        *retIsMoreThanAWeek = YES;
		//} else {
		//	nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_DayFormat",@"Util_DayFormat"), intYear,intMonth,intDay];
		//}
	}
	else // the 'else' part
	if(nMonthInterval >= 1 || nDayInterval >= 7)// the 'if' part
	{
		//if (bShouldUseDefaultFormat) {
			nsTime = [CAppUtil dateFormat:date];
        *retIsMoreThanAWeek = YES;
		//} else {
		//	nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_DayNoYearFormat",@"Util_DayNoYearFormat"), intMonth,intDay];
		//}
	}
	else // the 'else' part
	if(nDayInterval == 0)
    // the 'if' part
    {
		//today
		//if (bShouldUseDefaultFormat) {
			nsTime = [CAppUtil timeFormat:date];
        *retIsMoreThanAWeek = NO;
		/*} else {
			if(uCurTime <= uTime  || 
			   uCurTime - uTime < 60){
				nsTime = NSLocalizedString(@"Util_DuringOneMin",@"Util_DuringOneMin");
			}
			else if(nHourInterval == 1 && nMinInterval < 0 || 
					nHourInterval == 0 && nMinInterval >= 0){
				if(nMinInterval == 0){
					nMinInterval = 1;
				}
				else if(nMinInterval < 0){
					nMinInterval = nMinInterval + 60;
				}
				
				nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeMinFormat",@"Util_BeforeMinFormat"),nMinInterval];
			} else {
				NSString *nsPrefixDetail;
				if(intHour >= 18){
					nsPrefixDetail = NSLocalizedString(@"Util_Evening",@"Util_Evening");
					intHour = intHour - 12;
				}
				else if(intHour > 12){
					nsPrefixDetail = NSLocalizedString(@"Util_Afternoon",@"Util_Afternoon");
					intHour = intHour - 12;
				}
				else if(intHour == 12){
					nsPrefixDetail = NSLocalizedString(@"Util_Noon",@"Util_Noon");
				}
				else if(intHour >= 6){
					nsPrefixDetail = NSLocalizedString(@"Util_Morning",@"Util_Morning");
				}
				else {
					nsPrefixDetail = NSLocalizedString(@"Util_Daybreak",@"Util_Daybreak");
				}
				
				NSString *nsTimeDetail = [NSString stringWithFormat:NSLocalizedString(@"Util_TimeFormat",@"Util_TimeFormat"), [CAppUtil genHourAndMinStringFromInt:intHour], [CAppUtil genHourAndMinStringFromInt:intMin]];
				nsTime = [NSString stringWithFormat:@"%@%@",nsPrefixDetail,nsTimeDetail];
			}
		}*/
	}
	else // the 'else' part
	if(nDayInterval == 1)// the 'if' part
	{
		//yesterday
		nsTime = NSLocalizedString(@"Util_Yesterday",@"Util_Yesterday");
        *retIsMoreThanAWeek = NO;
	}
	else // the 'else' part
	if(nDayInterval <= 6)// the 'if' part
	{
		//weekday
		NSString* nsWeekDay = @"";
		switch (intWeekDay) {
			case 1:
				nsWeekDay = NSLocalizedString(@"Util_Sunday",@"Util_Sunday");
				break;
			case 2:
				nsWeekDay  = NSLocalizedString(@"Util_Monday",@"Util_Monday");
				break;
			case 3:
				nsWeekDay  = NSLocalizedString(@"Util_Tueday",@"Util_Tueday");
				break;
			case 4:
				nsWeekDay  = NSLocalizedString(@"Util_Wedday",@"Util_Wedday");
				break;
			case 5:
				nsWeekDay  = NSLocalizedString(@"Util_Thuday",@"Util_Thuday");
				break;
			case 6:
				nsWeekDay  = NSLocalizedString(@"Util_Friday",@"Util_Friday");
				break;
			case 7:
				nsWeekDay  = NSLocalizedString(@"Util_Satday",@"Util_Satday");
				break;
			default:
				break;
		}
		nsTime = nsWeekDay;
        *retIsMoreThanAWeek = NO;
	}
	
	//return @"2010年12月30日";
	//return @"晚上12:07";
    NSString *nsResultTime=[CAppUtil timeAdjustDateString:nsTime timeHour:hour];
	//the return stmt
	return nsResultTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genMessageListTimeStringOfFullYearByUInt:retIsMoreThanAWeek:
 * Returning Type: NSString *
 */ 
+(NSString*) genMessageListTimeStringOfFullYearByUInt:(UInt32)uTime retIsMoreThanAWeek:(BOOL *)retIsMoreThanAWeek
{
    NSCalendar *gregorian = nil;
    if ([NSThread isMainThread]) // the 'if' part
    {
        if (g_sGregorian == nil) // the 'if' part
        {
            g_sGregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        }
        gregorian = g_sGregorian;
    } else // the 'else' part
    {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    NSDateComponents *dayComponents =
    [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
    
    NSInteger intDay = [dayComponents day];
    NSInteger intMonth = [dayComponents month];
    NSInteger intYear = [dayComponents year];
    NSInteger intWeekDay= [dayComponents weekday];
    NSInteger hour=[dayComponents hour];
    
    //NSInteger intHour = [dayComponents hour];
    //NSInteger intMin = [dayComponents minute];
    
    //UInt32 uCrrentTime = [CAppUtil genCurrentTime];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    //NSTimeInterval timeCurInterval = [currentDate timeIntervalSince1970];
    //UInt32 uCurTime = (UInt32)timeCurInterval;
    dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
    
    NSInteger intCurrentDay = [dayComponents day];
    NSInteger intCurrentMonth = [dayComponents month];
    NSInteger intCurrentYear = [dayComponents year];
    //NSInteger intCurrentHour = [dayComponents hour];
    //NSInteger intCurrentMin = [dayComponents minute];
    
    NSString *nsTime;
    NSInteger nDayInterval = intCurrentDay - intDay;
    NSInteger nMonthInterval = intCurrentMonth - intMonth;
    NSInteger nYearInterval = intCurrentYear - intYear;
    //int nHourInterval = intCurrentHour - intHour;
    //int nMinInterval = intCurrentMin - intMin;
    if(nYearInterval >= 1)
    // the 'if' part
    {
        nsTime = [NSString stringWithFormat:@"%lu/%lu/%lu", (long)intYear,(long)intMonth,(long)intDay];
    }
    else // the 'else' part
    if(nMonthInterval >= 1 || nDayInterval >= 7)// the 'if' part
    {
        nsTime = [CAppUtil dateFormat:date];
        *retIsMoreThanAWeek = YES;
    }
    else // the 'else' part
    if(nDayInterval == 0)
    // the 'if' part
    {
        //today
        nsTime = [CAppUtil timeFormat:date];
        *retIsMoreThanAWeek = NO;
    }
    else // the 'else' part
    if(nDayInterval == 1)// the 'if' part
    {
        //yesterday
        nsTime = NSLocalizedString(@"Util_Yesterday",@"Util_Yesterday");
        *retIsMoreThanAWeek = NO;
    }
    else // the 'else' part
    if(nDayInterval <= 6)// the 'if' part
    {
        //weekday
        NSString* nsWeekDay = @"";
        switch (intWeekDay) {
            case 1:
                nsWeekDay = NSLocalizedString(@"Util_Sunday",@"Util_Sunday");
                break;
            case 2:
                nsWeekDay  = NSLocalizedString(@"Util_Monday",@"Util_Monday");
                break;
            case 3:
                nsWeekDay  = NSLocalizedString(@"Util_Tueday",@"Util_Tueday");
                break;
            case 4:
                nsWeekDay  = NSLocalizedString(@"Util_Wedday",@"Util_Wedday");
                break;
            case 5:
                nsWeekDay  = NSLocalizedString(@"Util_Thuday",@"Util_Thuday");
                break;
            case 6:
                nsWeekDay  = NSLocalizedString(@"Util_Friday",@"Util_Friday");
                break;
            case 7:
                nsWeekDay  = NSLocalizedString(@"Util_Satday",@"Util_Satday");
                break;
            default:
                break;
        }
        nsTime = nsWeekDay;
        *retIsMoreThanAWeek = NO;
    }
    
    //return @"2010年12月30日";
    //return @"晚上12:07";
    NSString *nsResultTime=[CAppUtil timeAdjustDateString:nsTime timeHour:hour];
    //the return stmt
    return nsResultTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genWCTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genWCTimeStringByUInt:(UInt32)uTime {
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dayComponents = 
	[gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
	
	NSInteger intDay = [dayComponents day];
	NSInteger intMonth = [dayComponents month];
	NSInteger intYear = [dayComponents year];
	
	NSInteger intHour = [dayComponents hour];
	NSInteger intMin = [dayComponents minute];
	
	//UInt32 uCrrentTime = [CAppUtil genCurrentTime];
	NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
	//NSTimeInterval timeCurInterval = [currentDate timeIntervalSince1970];
	//UInt32 uCurTime = (UInt32)timeCurInterval;
	gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
	
	NSInteger intCurrentDay = [dayComponents day];
	NSInteger intCurrentMonth = [dayComponents month];
	NSInteger intCurrentYear = [dayComponents year];
	NSInteger intCurrentHour = [dayComponents hour];
	NSInteger intCurrentMin = [dayComponents minute];
	
	NSString *nsTime;
	NSInteger nDayInterval = intCurrentDay - intDay;
	NSInteger nMonthInterval = intCurrentMonth - intMonth;
	NSInteger nYearInterval = intCurrentYear - intYear;
	NSInteger nHourInterval = intCurrentHour - intHour;
	NSInteger nMinInterval = MAX(1, intCurrentMin - intMin);
	
	if(nYearInterval >= 1)// the 'if' part
	{
		nsTime = [NSString stringWithFormat:@"%@ %@", [CAppUtil dateFormatLongLong:date], [CAppUtil timeFormat:date]];
	} else // the 'else' part
	if(nMonthInterval > 0 || nDayInterval > 1)// the 'if' part
	{
		nsTime = [NSString stringWithFormat:@"%@ %@", [CAppUtil dateFormatMonth:date], [CAppUtil timeFormat:date]];
	} else // the 'else' part
	if (nDayInterval == 1) // the 'if' part
	{
		nsTime = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Util_Yesterday",@"Util_Yesterday"), [CAppUtil timeFormat:date]];
	} else// the 'else' part
	{
		//today
		/*if(uCurTime <= uTime  || 
		   uCurTime - uTime < 60*1){
			nsTime = LOCALSTR(@"Util_JustNow");
		}*/
		if (nHourInterval < 1) // the 'if' part
		{
            if (nMinInterval == 1) // the 'if' part
            {
                nsTime = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_BeforeOneMin");
            } else // the 'else' part
            {
                nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeMinFormat",@"Util_BeforeMinFormat"),nMinInterval];
            }
		} else // the 'else' part
		{
			nsTime = [CAppUtil timeFormat:date];
		}
	}
    NSString *nsResultTime=[CAppUtil timeAdjustDateString:nsTime timeHour:(int)intHour];
    
	//the return stmt
	return nsResultTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genWCTimeShortStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genWCTimeShortStringByUInt:(UInt32)uTime {
	UInt32 today = [[NSDate date] timeIntervalSince1970];
	if (uTime > today) // the 'if' part
	{
		uTime = today;
	}

	NSString *nsTime = @"";
	UInt32 diff = today - uTime;
    if (diff < 2 * 60) // the 'if' part
    {
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_BeforeOneMin");
    } else // the 'else' part
    if (diff < 60 * 60) // the 'if' part
    {
		nsTime = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
		LOCALSTR(@"Util_BeforeMinFormat"), diff / 60];
    } else // the 'else' part
    if (diff < 2 * 60 * 60) // the 'if' part
    {
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_BeforeOneHour");
    } else // the 'else' part
    if (diff < 24 * 60 * 60) // the 'if' part
    {
		nsTime = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
		LOCALSTR(@"Util_BeforeHourFormat"), diff / (60*60)];
	} else // the 'else' part
	{
		UInt32 dayDiff = (UInt32)ABS([CAppUtil daysBetweenFrom:[NSDate dateWithTimeIntervalSince1970:uTime] To:[NSDate date]]);

		if (dayDiff <= 1) // the 'if' part
		{
			nsTime = //the func--->LOCALSTR() begin called!
			LOCALSTR(@"Util_Yesterday");
		} else // the 'else' part
		{
			nsTime = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
			LOCALSTR(@"Util_BeforeDayFormat"), dayDiff];
		}
	}
	
	//the return stmt
	return nsTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genYoTitleShortStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genYoTitleShortStringByUInt:(UInt32)uTime {
    UInt32 today = [[NSDate date] timeIntervalSince1970];
    if (uTime > today) // the 'if' part
    {
        uTime = today;
    }
    
    NSString *title = @"";
    UInt32 diff = today - uTime;
    if (diff < 60) // the 'if' part
    {
        title = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Yo_MESSAGE_DESCRIPTION_NOW");
    }
    else // the 'else' part
    if (diff < 2 * 60) // the 'if' part
    {
        title = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Yo_MESSAGE_DESCRIPTION_AFTER");
    } else // the 'else' part
    if (diff < 60 * 60) // the 'if' part
    {
        title = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Yo_MESSAGE_DESCRIPTION_AFTER");
    } else // the 'else' part
    if (diff < 2 * 60 * 60) // the 'if' part
    {
        title = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Yo_MESSAGE_DESCRIPTION_AFTER");
    } else // the 'else' part
    if (diff < 24 * 60 * 60) // the 'if' part
    {
        title = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Yo_MESSAGE_DESCRIPTION_AFTER");
    } else // the 'else' part
    {
        UInt32 dayDiff = (UInt32)ABS([CAppUtil daysBetweenFrom:[NSDate dateWithTimeIntervalSince1970:uTime] To:[NSDate date]]);
        
        if (dayDiff <= 1) // the 'if' part
        {
            title = //the func--->LOCALSTR() begin called!
            LOCALSTR(@"Yo_MESSAGE_DESCRIPTION_NOW");
                         } else // the 'else' part
                         {
            title = //the func--->LOCALSTR() begin called!
            LOCALSTR(@"Yo_MESSAGE_DESCRIPTION_AFTER");
        }
    }
    
    //the return stmt
    return title;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genYoTimeShortStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genYoTimeShortStringByUInt:(UInt32)uTime {
    UInt32 today = [[NSDate date] timeIntervalSince1970];
    if (uTime > today) // the 'if' part
    {
        uTime = today;
    }
    
    NSString *nsTime = @"";
    UInt32 diff = today - uTime;
    if (diff < 60) // the 'if' part
    {
        nsTime = nil;
    } else // the 'else' part
    if (diff < 2*60) // the 'if' part
    {
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_BeforeOneMin");
    } else // the 'else' part
    if (diff < 60 * 60) // the 'if' part
    {
        nsTime = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
        LOCALSTR(@"Yo_BeforeMinFormat"), diff / 60];
    } else // the 'else' part
    if (diff < 2 * 60 * 60) // the 'if' part
    {
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_BeforeOneHour");
    } else // the 'else' part
    if (diff < 24 * 60 * 60) // the 'if' part
    {
        nsTime = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_BeforeHourFormat"), diff / (60*60)];
    } else // the 'else' part
    {
        UInt32 dayDiff = (UInt32)ABS([CAppUtil daysBetweenFrom:[NSDate dateWithTimeIntervalSince1970:uTime] To:[NSDate date]]);
        
        if (dayDiff <= 1) // the 'if' part
        {
             nsTime = //the func--->LOCALSTR() begin called!
             LOCALSTR(@"Util_Yesterday");
            
        } else // the 'else' part
        {
             nsTime = //the func--->LOCALSTR() begin called!
             LOCALSTR(@"Util_BeforeDayFormat");
        }
    }
    
    //the return stmt
    return nsTime;
}


/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genFavCellTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genFavCellTimeStringByUInt:(UInt32)uTime
{
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dayComponents =
	[gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date];
    
	NSInteger intDay = [dayComponents day];
	NSInteger intMonth = [dayComponents month];
	NSInteger intYear = [dayComponents year];
    //当前时间
	NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
	gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:currentDate];
    
	NSInteger intCurrentDay = [dayComponents day];
	NSInteger intCurrentMonth = [dayComponents month];
	NSInteger intCurrentYear = [dayComponents year];
    
	NSString *nsTime = @"";
	NSInteger nDayInterval = intCurrentDay - intDay;
	NSInteger nMonthInterval = intCurrentMonth - intMonth;
	NSInteger nYearInterval = intCurrentYear - intYear;
    
    if(nYearInterval >= 1)// the 'if' part
    {
        //超过一年 显示：N年N月N日
        if(!([[CUtility getCurSystemLanguage] isEqualToString:@"zh_CN"] || [CUtility IsCurLanguageChineseTraditional]))// the 'if' part
        {
            nsTime = [NSString stringWithFormat:@"%ld/%ld/%ld",(long)intMonth, (long)intDay, (long)intYear];
        }else// the 'else' part
        {
            nsTime = [CAppUtil dateFormat:date];
        }
    }else // the 'else' part
    if(nMonthInterval >= 1)// the 'if' part
    {
        //一月以外 显示：N年N月N日
        if(!([[CUtility getCurSystemLanguage] isEqualToString:@"zh_CN"] || [CUtility IsCurLanguageChineseTraditional]))// the 'if' part
        {
            nsTime = [NSString stringWithFormat:@"%ld/%ld/%ld",(long)intMonth, (long)intDay, (long)intYear];
        }else// the 'else' part
        {
            nsTime = [CAppUtil dateFormat:date];
        }
        
    }else // the 'else' part
    if(nDayInterval >= 2)// the 'if' part
    {
        //一天以外 显示：N天前
        nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeDayFormat",@"Util_BeforeDayFormat"),nDayInterval];
    }else // the 'else' part
    if(nDayInterval == 1)// the 'if' part
    {
        //一天以外 显示：N天前
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Yesterday");
    }else// the 'else' part
    {
        //显示：今天
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Today");
    }
	//the return stmt
	return nsTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genFavDetailSrcTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genFavDetailSrcTimeStringByUInt:(UInt32)uTime
{
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dayComponents = [gregorian components:NSYearCalendarUnit fromDate:date];
    
	NSInteger intYear = [dayComponents year];
    
	NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
	gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:currentDate];
    
    NSString *nsDay = [CAppUtil dateFormatWithOutYear:date];
	NSInteger intCurrentYear = [dayComponents year];
    if (intYear < intCurrentYear) // the 'if' part
    {
        nsDay = [CAppUtil dateFormatLong:date];
    }
    
    NSString *nsTime = [CAppUtil timeFormat:date];
    NSString *nsTimeDetail = [NSString stringWithFormat:@"%@ %@", nsDay, nsTime];
    //the return stmt
    return nsTimeDetail;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genFavRecordSubTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genFavRecordSubTimeStringByUInt:(UInt32)uTime
{
    
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    
//    NSString *nsDay = [CAppUtil dateFormatLong:date];
//    NSString *nsTime = [CAppUtil timeFormat:date];
//    NSString *nsTimeDetail = [NSString stringWithFormat:@"%@ %@", nsDay, nsTime];
//    return nsTimeDetail;
    
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dayComponents =
	[gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:date];
    
	NSInteger intDay = [dayComponents day];
	NSInteger intMonth = [dayComponents month];
	NSInteger intYear = [dayComponents year];
//    NSInteger intHour = [dayComponents hour];
//    NSInteger intMinute = [dayComponents minute];
    
    NSString *nsOldTime = [CAppUtil timeFormat:date];
    
    NSString * nsTime = [CAppUtil timeAdjustDateString:nsOldTime timeHour:([dayComponents hour])];

    NSString *nsTimeDetail = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
    LOCALSTR(@"Fav_Record_SubItem_Time"), intYear, intMonth, intDay, nsTime];
    //TODO 海外版的顺序
    //the return stmt
    return nsTimeDetail;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genScanHistoryCellTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genScanHistoryCellTimeStringByUInt:(NSTimeInterval)uTime
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents =
    [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date];
    
    NSInteger intDay = [dayComponents day];
    NSInteger intMonth = [dayComponents month];
    NSInteger intYear = [dayComponents year];
    NSInteger intHour = [dayComponents hour];
    NSInteger intMinite = [dayComponents minute];
    
    //当前时间
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:currentDate];
    
    NSInteger intCurrentDay = [dayComponents day];
    NSInteger intCurrentMonth = [dayComponents month];
    NSInteger intCurrentYear = [dayComponents year];
    
    NSString *nsTime = @"";
    NSInteger nDayInterval = intCurrentDay - intDay;
    NSInteger nMonthInterval = intCurrentMonth - intMonth;
    NSInteger nYearInterval = intCurrentYear - intYear;
    
    if(nYearInterval >= 1)// the 'if' part
    {
        //超过一年 显示：N年N月N日
        if(!([[CUtility getCurSystemLanguage] isEqualToString:@"zh_CN"] || [CUtility IsCurLanguageChineseTraditional]))// the 'if' part
        {
            nsTime = [NSString stringWithFormat:@"%ld/%ld/%ld",(long)intMonth, (long)intDay, (long)intYear];
        }else// the 'else' part
        {
            nsTime = [CAppUtil dateFormat:date];
        }
    }else // the 'else' part
    if(nMonthInterval >= 1)// the 'if' part
    {
        //一月以外 显示：N年N月N日
        if(!([[CUtility getCurSystemLanguage] isEqualToString:@"zh_CN"] || [CUtility IsCurLanguageChineseTraditional]))// the 'if' part
        {
            nsTime = [NSString stringWithFormat:@"%ld/%ld/%ld",(long)intMonth, (long)intDay, (long)intYear];
        }else// the 'else' part
        {
            nsTime = [CAppUtil dateFormat:date];
        }
        
    }else // the 'else' part
    if(nDayInterval >= 2)// the 'if' part
    {
        //一天以外 显示：N天前
        nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeDayFormat",@"Util_BeforeDayFormat"),nDayInterval];
    }else // the 'else' part
    if(nDayInterval == 1)// the 'if' part
    {
        //一天 显示：昨天
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Yesterday");
    }else// the 'else' part
    {
        //今天 显示：小时:分钟
        nsTime = [NSString stringWithFormat:@"%02ld:%02ld",intHour,intMinite];
    }
    //the return stmt
    return nsTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genImgMsgCreatTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genImgMsgCreatTimeStringByUInt:(UInt32)uTime
{
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dayComponents =
	[gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:date];

    
	NSInteger intMonth = [dayComponents month];
	NSInteger intDay = [dayComponents day];
//	NSInteger intHour = [dayComponents hour];
//    NSInteger intMinute = [dayComponents minute];
    
	NSString *nsTime = @"";
    nsTime = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
    LOCALSTR(@"ImgInfo_Time"), intMonth, intDay, [CAppUtil timeFormat:date]];
	//the return stmt
	return nsTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genCurrentTime
 * Returning Type: UInt32
 */ 
+(UInt32) genCurrentTime{
	NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
	UInt32 uTime = (UInt32)timeInterval;
	//the return stmt
	return uTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genImgMsgTimeForFastBrowse:
 * Returning Type: NSString *
 */ 
+(NSString*) genImgMsgTimeForFastBrowse:(UInt32)uTime
{
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dayComponents =
    [gregorian components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekOfMonthCalendarUnit ) fromDate:date];
    
    NSInteger intYear = [dayComponents year];
	NSInteger intMonth = [dayComponents month];
	NSInteger intWeek = [dayComponents weekOfMonth];

    //当前时间
	NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
	gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	dayComponents =
    [gregorian components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekOfMonthCalendarUnit ) fromDate:currentDate];
    
	NSInteger intCurrentYear = [dayComponents year];
	NSInteger intCurrentMonth = [dayComponents month];
	NSInteger intCurrentWeek = [dayComponents weekOfMonth];

	NSInteger nYearInterval = intCurrentYear - intYear;
	NSInteger nMonthInterval = intCurrentMonth - intMonth;
	NSInteger nWeekInterval = intCurrentWeek - intWeek;
    
	NSString *nsTime = @"";
    if (nYearInterval >= 1 || nMonthInterval >= 1) // the 'if' part
    {
        nsTime = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
        LOCALSTR(@"ImgTime_ForFastBrowse_Year_Month"), (int)intYear, (int)intMonth];
    } else // the 'else' part
    if(nWeekInterval >= 1)// the 'if' part
    {
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"ImgTime_ForFastBrowse_ThisMonth");
    } else // the 'else' part
    {
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"ImgTime_ForFastBrowse_ThisWeek");
    }
    
	//the return stmt
	return nsTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genFTSSearchShowTime:
 * Returning Type: NSString *
 */ 
+(NSString*) genFTSSearchShowTime:(UInt32)uTime {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dayComponents =
	[gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date];
    
	NSInteger intDay = [dayComponents day];
	NSInteger intMonth = [dayComponents month];
	NSInteger intYear = [dayComponents year];
    //当前时间
	NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
	gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:currentDate];
    
	NSInteger intCurrentDay = [dayComponents day];
	NSInteger intCurrentMonth = [dayComponents month];
	NSInteger intCurrentYear = [dayComponents year];
    
	NSString *nsTime = @"";
	NSInteger nDayInterval = intCurrentDay - intDay;
	NSInteger nMonthInterval = intCurrentMonth - intMonth;
	NSInteger nYearInterval = intCurrentYear - intYear;
    
    if ((nYearInterval >= 1) || (nMonthInterval >= 1) || (nDayInterval > 7)) // the 'if' part
    {
        //超过一年 显示：N年N月N日
        if (!([[CUtility getCurSystemLanguage] isEqualToString:@"zh_CN"] || [CUtility IsCurLanguageChineseTraditional]))// the 'if' part
        {
            nsTime = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)intMonth, (long)intDay, (long)intYear];
        } else// the 'else' part
        {
            nsTime = [CAppUtil dateFormat:date];
        }
    } else // the 'else' part
    if(nDayInterval >= 1)// the 'if' part
    {
        //一天以外 显示：N天前
        nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeDayFormat",@"Util_BeforeDayFormat"),nDayInterval];
    } else // the 'else' part
    {
        //显示：今天
        UInt32 curTime = [CAppUtil genCurrentTime];
        if (curTime > uTime) // the 'if' part
        {
            UInt32 hours = (curTime - uTime)/3600;
            if (hours > 23) // the 'if' part
            {
                nsTime = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Today");
            } else // the 'else' part
            if (hours > 1) // the 'if' part
            {
                nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeHourFormat", @"Util_BeforeHourFormat"), hours];
            } else // the 'else' part
            if (hours == 1) // the 'if' part
            {
               nsTime = //the func--->LOCALSTR() begin called!
               LOCALSTR(@"Util_BeforeOneHour");
            } else // the 'else' part
            {
               UInt32 mins = (curTime - uTime)/60;
                if (mins > 1) // the 'if' part
                {
                   nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeMinFormat", @"Util_BeforeMinFormat"), mins];
                } else // the 'else' part
                if (mins == 1) // the 'if' part
                {
                    nsTime = //the func--->LOCALSTR() begin called!
                    LOCALSTR(@"Util_BeforeOneMin");
                } else // the 'else' part
                {
                    nsTime = //the func--->LOCALSTR() begin called!
                    LOCALSTR(@"Util_DuringOneMin");
                }
            }
        } else // the 'else' part
        {
            nsTime = //the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_Today");
        }
    }
	//the return stmt
	return nsTime;
}

// 显示年份统一为4位数字
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genFTSSearchFullShowTime:
 * Returning Type: NSString *
 */ 
+(NSString*) genFTSSearchFullShowTime:(UInt32)uTime{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents =
    [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date];
    
    NSInteger intDay = [dayComponents day];
    NSInteger intMonth = [dayComponents month];
    NSInteger intYear = [dayComponents year];
    //当前时间
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:currentDate];
    
    NSInteger intCurrentDay = [dayComponents day];
    NSInteger intCurrentMonth = [dayComponents month];
    NSInteger intCurrentYear = [dayComponents year];
    
    NSString *nsTime = @"";
    NSInteger nDayInterval = intCurrentDay - intDay;
    NSInteger nMonthInterval = intCurrentMonth - intMonth;
    NSInteger nYearInterval = intCurrentYear - intYear;
    
    if ((nYearInterval >= 1) || (nMonthInterval >= 1) || (nDayInterval > 7)) // the 'if' part
    {
        //超过一年 显示：yyyy/mm/dd
        nsTime = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)intYear, (long)intMonth, (long)intDay];
    } else // the 'else' part
    if(nDayInterval >= 1)// the 'if' part
    {
        //一天以外 显示：N天前
        nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeDayFormat",@"Util_BeforeDayFormat"),nDayInterval];
    } else // the 'else' part
    {
        //显示：今天
        UInt32 curTime = [CAppUtil genCurrentTime];
        if (curTime > uTime) // the 'if' part
        {
            UInt32 hours = (curTime - uTime)/3600;
            if (hours > 23) // the 'if' part
            {
                nsTime = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_Today");
            } else // the 'else' part
            if (hours > 1) // the 'if' part
            {
                nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeHourFormat", @"Util_BeforeHourFormat"), hours];
            } else // the 'else' part
            if (hours == 1) // the 'if' part
            {
                nsTime = //the func--->LOCALSTR() begin called!
                LOCALSTR(@"Util_BeforeOneHour");
            } else // the 'else' part
            {
                UInt32 mins = (curTime - uTime)/60;
                if (mins > 1) // the 'if' part
                {
                    nsTime = [NSString stringWithFormat:NSLocalizedString(@"Util_BeforeMinFormat", @"Util_BeforeMinFormat"), mins];
                } else // the 'else' part
                if (mins == 1) // the 'if' part
                {
                    nsTime = //the func--->LOCALSTR() begin called!
                    LOCALSTR(@"Util_BeforeOneMin");
                } else // the 'else' part
                {
                    nsTime = //the func--->LOCALSTR() begin called!
                    LOCALSTR(@"Util_DuringOneMin");
                }
            }
        } else // the 'else' part
        {
            nsTime = //the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_Today");
        }
    }
    //the return stmt
    return nsTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genReceivedRedEnvelopesShowTime:
 * Returning Type: NSString *
 */ 
+(NSString*) genReceivedRedEnvelopesShowTime:(UInt32)uTime {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents =
    [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date];
    
    NSInteger intDay = [dayComponents day];
    NSInteger intMonth = [dayComponents month];
    NSInteger intYear = [dayComponents year];
    //当前时间
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:currentDate];
    
    NSInteger intCurrentDay = [dayComponents day];
    NSInteger intCurrentMonth = [dayComponents month];
    NSInteger intCurrentYear = [dayComponents year];
    
    NSString *nsTime = @"";
    NSInteger nDayInterval = intCurrentDay - intDay;
    NSInteger nMonthInterval = intCurrentMonth - intMonth;
    NSInteger nYearInterval = intCurrentYear - intYear;
    
    if (nYearInterval != 0) // the 'if' part
    {
        //超过一年 显示：N年N月N日
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
        nsTime = [formatter stringFromDate:date];
    } else // the 'else' part
    if((nMonthInterval != 0) || (nDayInterval != 0))// the 'if' part
    {
        //一天以外 显示：N月N日
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
        nsTime = [formatter stringFromDate:date];
    } else // the 'else' part
    {
        //显示：今天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        nsTime = [formatter stringFromDate:date];
    }
    //the return stmt
    return nsTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genShakeTvHistoryShowTime:
 * Returning Type: NSString *
 */ 
+(NSString*) genShakeTvHistoryShowTime:(UInt32)uTime
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents =
    [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date];
    
    NSInteger intDay = [dayComponents day];
    NSInteger intMonth = [dayComponents month];
    NSInteger intYear = [dayComponents year];
    //当前时间
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:currentDate];
    
    NSInteger intCurrentDay = [dayComponents day];
    
    NSString *nsTime = @"";
    NSInteger nDayInterval = intCurrentDay - intDay;
  
    if (nDayInterval == 0)
    // the 'if' part
    {
        //今天 时:分
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        nsTime = [formatter stringFromDate:date];
    } else // the 'else' part
    if (nDayInterval == 1)
    // the 'if' part
    {
        //昨天
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Yesterday");
        
    } else // the 'else' part
    {
        nsTime = [NSString stringWithFormat:@"%lu/%lu/%lu", (long)intYear,(long)intMonth,(long)intDay];
    }
    //the return stmt
    return nsTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genNearbyTimeStringByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genNearbyTimeStringByUInt:(UInt32)uTime
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:uTime];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents =
    [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date];
    
  //  NSInteger intDay = [dayComponents day];
    NSInteger intMonth = [dayComponents month];
    NSInteger intYear = [dayComponents year];
    //当前时间
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    dayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:currentDate];
  
  //  NSInteger intCurrentDay = [dayComponents day];
    NSInteger intCurrentMonth = [dayComponents month];
    NSInteger intCurrentYear = [dayComponents year];
    
    NSString *nsTime = @"";
  //  NSInteger nDayInterval = intCurrentDay - intDay;
    //自然月、年
    NSInteger nMonthInterval = intCurrentMonth - intMonth;
    NSInteger nYearInterval = intCurrentYear - intYear;
    //总天数
    NSInteger nDayDiff = (uTime - [[NSDate date] timeIntervalSince1970]) / (24*60*60);
    
    if (nDayDiff <= 30) // the 'if' part
    {
        nsTime = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"Util_Recently");
    }
    else // the 'else' part
    if (nYearInterval > 0)
    // the 'if' part
    {
        nsTime = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
        LOCALSTR(@"WCNearby_Sns_kBeforeYear"),nYearInterval];
    } else // the 'else' part
    if (nMonthInterval > 0)
    // the 'if' part
    {
        nsTime = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
        LOCALSTR(@"WCNearby_Sns_kBeforeMonth"),nMonthInterval];
    }
    //the return stmt
    return nsTime;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: genWCTimelineVideoTimeFormatByUInt:
 * Returning Type: NSString *
 */ 
+(NSString*) genWCTimelineVideoTimeFormatByUInt:(UInt32)uTime
{
    NSString *title = nil;
    if (uTime > 0) // the 'if' part
    {
        int mins = uTime/60;
        int secs = uTime%60;
        BOOL isChinese = [[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString:MM_LANGUAGE_CHS];
        if (isChinese) // the 'if' part
        {
            NSString *timeTip = nil;
            if (uTime <= 60) // the 'if' part
            {
                timeTip = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
                LOCALSTR(@"Album_Video_Time_Seconds_Format"), uTime];
            } else // the 'else' part
            if (uTime%60 == 0) // the 'if' part
            {
                timeTip = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
                LOCALSTR(@"Album_Video_Time_Miniutes_Format"), mins];
            } else // the 'else' part
            {
                timeTip = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
                LOCALSTR(@"Album_Video_Time_MiniuteAndSecond_Format"), mins, secs];
            }
            title = [NSString stringWithFormat://the func--->LOCALSTR() begin called!
            LOCALSTR(@"WC_Play_Whole_Video_Tip_Format"), timeTip];
        } else // the 'else' part
        {
            if (mins > 0) // the 'if' part
            {
                title = [NSString stringWithFormat:@"%@ %d'%d''", //the func--->LOCALSTR() begin called!
                LOCALSTR(@"WC_Play_Whole_Video_Tip"), mins, secs];
            } else // the 'else' part
            {
                title = [NSString stringWithFormat:@"%@ %d''", //the func--->LOCALSTR() begin called!
                LOCALSTR(@"WC_Play_Whole_Video_Tip"), secs];
            }
        }
    } else // the 'else' part
    {
        title = //the func--->LOCALSTR() begin called!
        LOCALSTR(@"WC_Play_Whole_Video_Tip");
    }
    
    //the return stmt
    return title;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: daysBetweenFrom:To:
 * Returning Type: NSInteger
 */ 
+(NSInteger) daysBetweenFrom:(NSDate*)oStartDate To:(NSDate*)oEndDate {
//	NSCalendar *calendar=[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//	NSDateComponents* components = [calendar components:NSDayCalendarUnit fromDate:oStartDate toDate:oEndDate options:0];
//	int dayDiff = [components day];
//	int start = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:oStartDate];
//	int end = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:oEndDate];
//	int dayDiff = end - start;
//	return dayDiff;
    NSDate *fromDate;
    NSDate *toDate;
	
    NSCalendar *calendar = [NSCalendar currentCalendar];
	
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
				 interval:NULL forDate:oStartDate];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
				 interval:NULL forDate:oEndDate];
	
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
											   fromDate:fromDate toDate:toDate options:0];
	
    //the return stmt
    return [difference day];
}

#pragma mark 
#pragma mark contact & userInfo

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: calStringLen:
 * Returning Type: UInt32
 */ 
+(UInt32) calStringLen:(NSString*)nsString{
	if(nsString == nil)// the 'if' part
	{
		//the return stmt
		return 0;
	}
	
	UInt32 uTempLen = 0;
	UInt32 uRealLen = 0;
	UInt32 uLen = (UInt32)nsString.length;
	for (UInt32 i = 0; i < uLen; ++i) {
		unichar uniC = [nsString characterAtIndex:i];
		if(uniC <= 0x7f)// the 'if' part
		{
			uTempLen += 1;
		}
		else // the 'else' part
		{
			uTempLen += 2;
		}
	}
	
	if(uTempLen % 2 != 0)// the 'if' part
	{
		uRealLen = (uTempLen + 1)/2;
	}
	else // the 'else' part
	{
		uRealLen = uTempLen/2;
	}
	
	//the return stmt
	return uRealLen;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: cutTextView:orTextField:withLimitLen:
 * Returning Type: void
 */ 
+(void) cutTextView:(UITextView*)textView orTextField:(UITextField*)textField withLimitLen:(UInt32)limit
{
    id<UITextInput> textInput;
    NSString *currentText;
    if (textView != nil)
    // the 'if' part
    {
        textInput = textView;
        currentText = textView.text;
    }
    else // the 'else' part
    if (textField != nil)
    // the 'if' part
    {
        textInput = textField;
        currentText = textField.text;
    }
    else
    // the 'else' part
    {
        //the return stmt
        return;
    }
    
    if (currentText.length <= limit) // the 'if' part
    //the return stmt
    return;
    if (textInput.markedTextRange != nil && !textInput.markedTextRange.isEmpty)
    // the 'if' part
    {
        //the return stmt
        return;
    }
    
    UITextRange *selRange = textInput.selectedTextRange;
    UITextPosition *selStartPos = selRange.start;
    NSInteger curPos = [textInput offsetFromPosition:textInput.beginningOfDocument toPosition:selStartPos];
    
    // 光标位置在结尾，直接切结尾
    if (curPos == currentText.length)
    // the 'if' part
    {
        UInt32 uTempLen = 0;
        NSInteger uLen = currentText.length;
        UInt32 cutLen;
        for (cutLen = 0; cutLen < uLen; ++cutLen) {
            unichar uniC = [currentText characterAtIndex:cutLen];
            
            if(uniC <= 0x7f)// the 'if' part
            {
                uTempLen += 1;
            }
            else // the 'else' part
            {
                uTempLen += 2;
            }
            
            if (uTempLen > limit * 2) // the 'if' part
            {
                break;
            }
        }
        if (cutLen < uLen)
        // the 'if' part
        {
            NSString *newText = [currentText substringToIndex:cutLen];
            if (textView != nil) textView.text = newText;
            else textField.text = newText;
        }
    }
    // 光标位置在中间，先从光标位置开始往前切。
    else // the 'else' part
    if ([CAppUtil calStringLen:currentText] > limit)
    // the 'if' part
    {
        // 计算exceedLen
        UInt32 uTempLen = 0;
        UInt32 uLen = (UInt32)currentText.length;
        for (UInt32 i = 0; i < uLen; ++i) {
            unichar uniC = [currentText characterAtIndex:i];
            if(uniC <= 0x7f)// the 'if' part
            {
                uTempLen += 1;
            }
            else // the 'else' part
            {
                uTempLen += 2;
            }
        }
        int exceedLen = uTempLen - limit * 2;
        
        // 计算cutBegin
        NSInteger cutBegin = curPos;
        while (exceedLen > 0 && cutBegin > 0)
        {
            unichar uniC = [currentText characterAtIndex:cutBegin];
            if(uniC <= 0x7f)// the 'if' part
            {
                exceedLen -= 1;
            }
            else // the 'else' part
            {
                exceedLen -= 2;
            }
            --cutBegin;
        }
        
        if (exceedLen <= 0)
        // the 'if' part
        {
            // 切中间留两头，然后恢复光标位置
            if (cutBegin < curPos)
            // the 'if' part
            {
                NSString *newText = [NSString stringWithFormat:@"%@%@", [currentText substringToIndex:cutBegin], [currentText substringFromIndex:curPos]];
                if (textView != nil) textView.text = newText;
                else textField.text = newText;
                
                UITextPosition *start = [textInput positionFromPosition:[textInput beginningOfDocument] offset:cutBegin];
                [textInput setSelectedTextRange:[textInput textRangeFromPosition:start toPosition:start]];
            }
        }
        // 如果切完开头还不够，再切结尾。切两头留中间。（正常情况下不会出现这个，保险起见加上）
        else
        // the 'else' part
        {
            NSString *str = [currentText substringFromIndex:curPos];
            UInt32 len = [CAppUtil calStringLen:str maxLen:limit * 2];
            NSString *newText = [str substringToIndex:len];
            if (textView != nil) textView.text = newText;
            else textField.text = newText;
        }
    }
}

// limit: 中文算1个，英文算0.5个
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: cutTextField:withLimitLen:
 * Returning Type: void
 */ 
+(void) cutTextField:(UITextField*)textField withLimitLen:(UInt32)limit
{
    [CAppUtil cutTextView:nil orTextField:textField withLimitLen:limit];
}
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: cutTextView:withLimitLen:
 * Returning Type: void
 */ 
+(void) cutTextView:(UITextView*)textView withLimitLen:(UInt32)limit
{
    [CAppUtil cutTextView:textView orTextField:nil withLimitLen:limit];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: calStringLen:maxLen:
 * Returning Type: UInt32
 */ 
+(UInt32) calStringLen:(NSString*)nsString maxLen:(UInt32)maxLen{
    if(nsString == nil)// the 'if' part
    {
        //the return stmt
        return 0;
    }
    
    UInt32 uTempLen = 0;
    UInt32 uRealLen = 0;
    NSInteger uLen = nsString.length;
    UInt32 i;
    for (i = 0; i < uLen; ++i) {
        unichar uniC = [nsString characterAtIndex:i];
        
        if(uniC <= 0x7f)// the 'if' part
        {
            uTempLen += 1;
        }
        else // the 'else' part
        {
            uTempLen += 2;
        }
        
        if (uTempLen > maxLen) // the 'if' part
        {
            //the return stmt
            return i;
        }

    }
    
    if(uTempLen % 2 != 0)// the 'if' part
    {
        uRealLen = (uTempLen + 1)/2;
    }
    else // the 'else' part
    {
        uRealLen = uTempLen/2;
    }
    
    //the return stmt
    return uRealLen;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: uploadUpdateStatOpLog:
 * Returning Type: BOOL
 */ 
+(BOOL) uploadUpdateStatOpLog:(UInt32)uiOpCode{
	
    UpdateStatOpLog* oUpdateStatOplog = [[UpdateStatOpLog alloc] init];
    oUpdateStatOplog.opCode = uiOpCode;
    
    BOOL bRet = [GET_SERVICE(NewSyncService) InsertOplog:MM_SYNCCMD_UPDATESTAT Oplog:[oUpdateStatOplog serializedData] Sync:YES];
	//the return stmt
	return bRet;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getLastLoginName
 * Returning Type: NSString *
 */ 
+(NSString *)getLastLoginName{
	
	if([SettingUtil getLocalInfo] == nil)// the 'if' part
	{
		//the return stmt
		return nil;
	}
	
	if([SettingUtil getLocalInfo].m_nsLastLoginName != nil && [SettingUtil getLocalInfo].m_nsLastLoginName.length != 0 )// the 'if' part
	{
		return [SettingUtil getLocalInfo].m_nsLastLoginName;
	}
	
	return [SettingUtil getLocalInfo].m_nsCurUsrName;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: saveLastLoginName:
 * Returning Type: void
 */ 
+(void) saveLastLoginName:(NSString *)nsLastLoginName{
	
	[SettingUtil getLocalInfo].m_nsLastLoginName = nsLastLoginName;
	
    [GET_SERVICE(AccountStorageMgr) SaveLocalInfo:YES];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getLastUserName
 * Returning Type: NSString *
 */ 
+(NSString *)getLastUserName{
	
	if([SettingUtil getLocalInfo] == nil)// the 'if' part
	{
		//the return stmt
		return nil;
	}
	
	if([SettingUtil getLocalInfo].m_nsLastUserName != nil && [SettingUtil getLocalInfo].m_nsLastUserName.length != 0 )// the 'if' part
	{
		return [SettingUtil getLocalInfo].m_nsLastUserName;
	}
	
	return [SettingUtil getLocalInfo].m_nsCurUsrName;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: saveLastUserName:
 * Returning Type: void
 */ 
+(void) saveLastUserName:(NSString *)nsLastUserName{
	
	[SettingUtil getLocalInfo].m_nsLastUserName = nsLastUserName;
	
    [GET_SERVICE(AccountStorageMgr) SaveLocalInfo:YES];
}

#define MESSAGEARCHIVEREMIND (3 * 30 * 24 * 3600)

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: updateMessageArchiveContactsMsg
 * Returning Type: void
 */ 
+(void) updateMessageArchiveContactsMsg
{
    if ([SettingUtil getMainSettingExt].m_bIsMessageArchiveReminderOn) // the 'if' part
    {
        CMessageMgr *messageMgr = GET_SERVICE(CMessageMgr);
        if ([GET_SERVICE(MessageArchiveService) messageArchivedState] == MessageArchivedState_NotArchivied) // the 'if' part
        {
            //the return stmt
            return;
        }

        //你已经%u天没有备份通讯录了
        int64_t timeInterval = -[[NSDate dateWithTimeIntervalSince1970:[GET_SERVICE(MessageArchiveService) lastArchivedTime]] timeIntervalSinceNow];
        if (timeInterval > MESSAGEARCHIVEREMIND) // the 'if' part
        {
            CMessageWrap * messageWrap = [messageMgr GetLastMsg:[PluginUtil getPluginUserName:MMPlugin_MessageArchiveHelper]];
            if (messageWrap == nil) // the 'if' part
            {
                CMessageWrap * oMessageWrap = [[CMessageWrap alloc] initWithMsgType:MM_DATA_TEXT];
                oMessageWrap.m_nsFromUsr = [PluginUtil getPluginUserName:MMPlugin_MessageArchiveHelper];
                oMessageWrap.m_nsContent = [NSString stringWithFormat:LOCALSTR(@"Archive_RemindMsg"), timeInterval / 24 / 3600];
                oMessageWrap.m_nsToUsr = [SettingUtil getMainSetting].m_nsUsrName;
                oMessageWrap.m_uiCreateTime = [GET_SERVICE(MMNewSessionMgr) GenSendMsgTime];
                [messageMgr AddPimMsg:[PluginUtil getPluginUserName:MMPlugin_MessageArchiveHelper] MsgWrap:oMessageWrap];
            } else // the 'else' part
            {
                int64_t lastRemindTimeInterval = -[[NSDate dateWithTimeIntervalSince1970:messageWrap.m_uiCreateTime] timeIntervalSinceNow];
                if (lastRemindTimeInterval > MESSAGEARCHIVEREMIND) // the 'if' part
                {
                    messageWrap.m_nsContent = [NSString stringWithFormat:LOCALSTR(@"Archive_RemindMsg"), timeInterval / 24 / 3600];
                    messageWrap.m_uiCreateTime = [GET_SERVICE(MMNewSessionMgr) GenSendMsgTime];
                    [messageMgr AddPimMsg:[PluginUtil getPluginUserName:MMPlugin_MessageArchiveHelper] MsgWrap:messageWrap];
                }
            }
        }
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: checkSavePhoto:
 * Returning Type: BOOL
 */ 
+(BOOL) checkSavePhoto:(UIImage *)image{
	
	UInt32 uiImageSourceType = [SettingUtil getMainSettingExt].m_uiImageSourceType;
	
	if(image == nil)// the 'if' part
	{
		//the return stmt
		return NO;
	}
//	新版本去掉“拍照自动保存至手机相册”入口，并默认打开,下面的判断条件将m_bSavePhotoWhenTake去掉  maiyuetong
//	if(![SettingUtil getMainSettingExt].m_bSavePhotoWhenTake || uiImageSourceType != EImageSourceType_CameraTake){
//		return NO;
//	}
    if (uiImageSourceType != EImageSourceType_CameraTake) // the 'if' part
    {
        //the return stmt
        return NO;
    }
	
	//the func--->UIImageWriteToSavedPhotosAlbum() begin called!
	UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	
	//the return stmt
	return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isChinaPhoneUser
 * Returning Type: BOOL
 */ 
+(BOOL) isChinaPhoneUser {
    //the return stmt
    return [[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] isEqualToString:@"CN"];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isSimpleChinaLanguageUser
 * Returning Type: BOOL
 */ 
+(BOOL) isSimpleChinaLanguageUser {
    return [[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString:MM_LANGUAGE_CHS];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isChinaLanguageUser
 * Returning Type: BOOL
 */ 
+(BOOL) isChinaLanguageUser {
    return [[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString:MM_LANGUAGE_CHS] || [GET_SERVICE(MMLanguageMgr) curLanguageIsChineseTraditional];
    
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isChinaPhoneAndSimpleCHSUser
 * Returning Type: BOOL
 */ 
+(BOOL) isChinaPhoneAndSimpleCHSUser{
    //the return stmt
    return [CAppUtil isChinaPhoneUser] && [CAppUtil isSimpleChinaLanguageUser];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isChinaPhoneOrSimpleCHSUser
 * Returning Type: BOOL
 */ 
+(BOOL) isChinaPhoneOrSimpleCHSUser{
    //the return stmt
    return [CAppUtil isChinaPhoneUser] || [CAppUtil isSimpleChinaLanguageUser];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: UrlFromTypeToString:
 * Returning Type: NSString *
 */ 
+(NSString*) UrlFromTypeToString:(URL_From_Type)from {
	switch (from) {
		case URL_From_Type_Unknow:
			return @"";
		case URL_From_Type_Message:
			return @"message";
		case URL_From_Type_Homepage:
			return @"homepage";
		case URL_From_Type_Timeline:
			return @"timeline";
        case URL_From_Type_Shake:
            return @"shake";
        case URL_From_Type_SingleMessage:
            return @"singlemessage";
        case URL_From_Type_GroupMessage:
            return @"groupmessage";
        case URL_From_Type_GameMessageCenter:
            return @"gamemessgaecenter";
		default:
			return @"";
	}
}

static NSSet *g_appWhiteList = [NSSet setWithObjects:
                                @"qqnews",
                                @"qqnewshd",
                                @"qqmail",
                                @"whatsapp",
                                @"wxcphonebook",
                                @"mttbrowser",
                                @"mqqapi",
                                @"mqzonev2",
                                @"qqpim",   // 同步助手
                                @"qqmusic",
                                @"tenvideo2",   // 腾讯视频
                                @"tenvideohd",
                                @"qnreading",   // 天天快报
                                @"weread",      // 微信阅读
                                @"fbauth",
                                // 以下是各种地图
                                @"sosomap",
                                @"comgooglemaps",
                                @"iosamap",
                                @"baidumap",
                                @"sgmap",
                                // 以下是游戏
                                @"wx18df700cb9d0652e",  // 热血传奇
                                @"wxaa1f775bc35f9c95",  // 拳皇98 终极之战-OL
                                @"wx21d9c743f261c238",  // 全民突击
                                @"wx47a71dd8a1875943",  // 全民飞机大战
                                @"wx369f9a611589ad83",  // 天天德州
                                @"wxff0c162f46730409",  // 全民超神
                                @"wxd477edab60670232",  // 天天爱消除
                                @"wx76fc280041c16519",  // 斗地主
                                @"wx95a3a4d7c627e07d",  // 英雄战迹
                                @"wx15f5f4874ca259f4",  // 天天酷跑
                                
                                // 第二批加的jsapi
                                @"qqstock",
                                @"openApp.jdMobile",
                                @"wxe3384655cdb13ab6",
                                @"qmkege",
                                @"mqzonex",
                                @"txvp",
                                @"sybapp",
                                @"wx5a4a8ac0fd48303a",
                                @"qqsports",
                                @"qqcar",
                                @"tencentedu",
                                @"wemusic",
                                @"qqmap",
                                @"mqq",
                                @"webank",
                                @"wxwork",
                                
                                // 以下是微信自己，肯定能调用（SDK用的除外），如果名额不够就不走系统判断，直接YES
                                @"weixin",
                                @"fb290293790992170",
                                @"wechat",
                                @"QQ41C152CF",
                                
                                // 以下不占白名单名额
                                @"http",
                                @"https",
                                // 以下是系统应用，不占名额
                                @"tel",
                                @"sms",
                                nil];

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: canOpenURL:
 * Returning Type: BOOL
 */ 
+(BOOL) canOpenURL:(NSURL*)url
{
    if (![DeviceInfo isiOS9plus])
    // the 'if' part
    {
        MM_TRY {
            return [[UIApplication sharedApplication] canOpenURL:url];
        } MM_CATCH({
            MMWarning(@"catch an exception");
            return NO;
        });
    }
    
    // iOS9下要先检查白名单
    NSString *scheme = [url absoluteString];
    NSRange range = [scheme rangeOfString:@"://"];
    if (range.location != NSNotFound)
    // the 'if' part
    {
        scheme = [scheme substringToIndex:range.location];
    }
    if (scheme.length == 0)
    // the 'if' part
    {
        //the return stmt
        return NO;
    }
    
    //the func--->MMInfo() begin called!
    MMInfo(@"will check canOpenURL with scheme: %@", scheme);
    //the func--->LOG_FEATURE_EXT() begin called!
    LOG_FEATURE_EXT(12704, scheme);
    // 不再需要根据cydia这个scheme来判断是否越狱，默认返回NO
    if ([scheme isEqualToString:@"cydia"])
    // the 'if' part
    {
        //the return stmt
        return NO;
    }
    if ([g_appWhiteList containsObject:scheme])
    // the 'if' part
    {
        MM_TRY {
            return [[UIApplication sharedApplication] canOpenURL:url];
        } MM_CATCH({
            MMWarning(@"catch an exception");
            return NO;
        });
    }
    //the func--->MMInfo() begin called!
    MMInfo(@"fail to check canOpenURL with scheme: %@. return YES", scheme);
    //the return stmt
    return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getSecureUrl:from:isAppInstalled:
 * Returning Type: NSString *
 */ 
+(NSString*) getSecureUrl:(NSString*)nsUrl from:(URL_From_Type)from isAppInstalled:(BOOL)isAppInstalled {
	if ([nsUrl length] <= 0) // the 'if' part
	{
		//the return stmt
		return nil;
	}
    
    if (![MMURLHandler containsHTTPString:nsUrl]) // the 'if' part
    {
        //the return stmt
        return nsUrl;
    }
 
	//the func--->MMDebug() begin called!
	MMDebug(@"[secure_url][raw]%@",nsUrl);
    
    NSString *beforeSharp = nil;
    NSString *afterSharp = nil;
    
    NSRange range = [nsUrl rangeOfString:@"#"];
    if (range.location != NSNotFound) // the 'if' part
    {
        beforeSharp = [nsUrl substringToIndex:range.location];
        afterSharp = [nsUrl substringFromIndex:range.location+range.length];
    }
    
    if (!afterSharp) // the 'if' part
    {
        NSRange qmRange = [nsUrl rangeOfString:@"?"];
        if (qmRange.location != NSNotFound) // the 'if' part
        {
            NSString *beforeQM = [nsUrl substringToIndex:qmRange.location + 1];
            NSString *afterQM = [nsUrl substringFromIndex:qmRange.location + qmRange.length];
            NSArray *aryString = [afterQM componentsSeparatedByString:@"&"];
            BOOL flag = NO;
            for(int i = 0;i < aryString.count;i++){
                NSString *str = [aryString objectAtIndex:i];
                if ([str hasPrefix:@"from="] || [str hasPrefix:@"isappinstalled="]) // the 'if' part
                {
                    continue;
                }
                
                if (!flag) // the 'if' part
                {
                    flag = YES;
                    beforeQM = [NSString stringWithFormat:@"%@%@", beforeQM, str];
                }else// the 'else' part
                {
                    beforeQM = [NSString stringWithFormat:@"%@&%@", beforeQM, str];
                }
            }
            
            if (flag) // the 'if' part
            {
                //the return stmt
                return [NSString stringWithFormat:@"%@&from=%@&isappinstalled=%@", beforeQM, [CAppUtil UrlFromTypeToString:from], (isAppInstalled ? @"1" : @"0")];
            }else// the 'else' part
            {
                //the return stmt
                return [NSString stringWithFormat:@"%@from=%@&isappinstalled=%@", beforeQM, [CAppUtil UrlFromTypeToString:from], (isAppInstalled ? @"1" : @"0")];
            }
        }else// the 'else' part
        {
            //the return stmt
            return [NSString stringWithFormat:@"%@?from=%@&isappinstalled=%@", nsUrl, [CAppUtil UrlFromTypeToString:from], (isAppInstalled ? @"1" : @"0")];
        }
    }
    
    NSRange qmRange = [beforeSharp rangeOfString:@"?"];
    if (qmRange.location != NSNotFound) // the 'if' part
    {
        NSString *beforeQM = [beforeSharp substringToIndex:qmRange.location + 1];
        NSString *afterQM = [beforeSharp substringFromIndex:qmRange.location + qmRange.length];
        NSArray *aryString = [afterQM componentsSeparatedByString:@"&"];
        BOOL flag = NO;
        for(int i = 0;i < aryString.count;i++){
            NSString *str = [aryString objectAtIndex:i];
            if ([str hasPrefix:@"from="] || [str hasPrefix:@"isappinstalled="]) // the 'if' part
            {
                continue;
            }
            
            if (!flag) // the 'if' part
            {
                flag = YES;
                beforeQM = [NSString stringWithFormat:@"%@%@", beforeQM, str];
            }else// the 'else' part
            {
                beforeQM = [NSString stringWithFormat:@"%@&%@", beforeQM, str];
            }
        }
        
        if (flag) // the 'if' part
        {
            //the return stmt
            return [NSString stringWithFormat:@"%@&from=%@&isappinstalled=%@#%@", beforeQM, [CAppUtil UrlFromTypeToString:from], (isAppInstalled ? @"1" : @"0"), afterSharp];
        }else// the 'else' part
        {
            //the return stmt
            return [NSString stringWithFormat:@"%@from=%@&isappinstalled=%@#%@", beforeQM, [CAppUtil UrlFromTypeToString:from], (isAppInstalled ? @"1" : @"0"), afterSharp];
        }
        
    }else// the 'else' part
    {
        //the return stmt
        return [NSString stringWithFormat:@"%@?from=%@&isappinstalled=%@#%@", beforeSharp, [CAppUtil UrlFromTypeToString:from], (isAppInstalled ? @"1" : @"0"), afterSharp];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getOriginUrlFromSecureUrl:
 * Returning Type: NSString *
 */ 
+(NSString*) getOriginUrlFromSecureUrl:(NSString*)nsSecureUrl {
    if ([nsSecureUrl length] <= 0) // the 'if' part
    {
        //the return stmt
        return nil;
    }
    
    NSString* prefixUrl = @"http://rd.wechatapp.com/r?url=";
    NSRange prefixRange = [nsSecureUrl rangeOfString:prefixUrl];
    if (prefixRange.length <= 0 || prefixRange.location != 0) // the 'if' part
    {
        //the return stmt
        return nil;
    }
    
    NSString* suffixUrl = @"&version=";
    NSRange suffixRange = [nsSecureUrl rangeOfString:suffixUrl];
    if (suffixRange.length <= 0 || suffixRange.location < (prefixRange.location + prefixRange.length)) // the 'if' part
    {
        //the return stmt
        return nil;
    }
    
    NSRange originRange;
    originRange.location = prefixRange.location + prefixRange.length;
    originRange.length = suffixRange.location - (prefixRange.location + prefixRange.length);
    NSString* originUrl = [nsSecureUrl substringWithRange:originRange];
    
    //the return stmt
    return [originUrl gtm_stringByUnescapingFromURLArgument];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getDeviceType
 * Returning Type: NSString *
 */ 
+(NSString *) getDeviceType
{
    // alantao, g_vecSystemInfo不包含结束符，可能引起读越界，需要加上长度
    NSString* nsDeviceType = [[NSString alloc] initWithBytes:(void*)&(g_vecSystemInfo[0])
                                                       length:g_vecSystemInfo.size()
                                                     encoding:NSUTF8StringEncoding];
    //the return stmt
    return nsDeviceType;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getAppInstallUrl:from:
 * Returning Type: NSString *
 */ 
+(NSString*) getAppInstallUrl:(NSString*)nsAppID from:(URL_From_Type)from {
	if ([nsAppID length] <= 0) // the 'if' part
	{
		//the return stmt
		return nil;
	}
    
    NSString* nsDeviceType = [CAppUtil getDeviceType];
    NSString* nsEncodeDeviceType = [nsDeviceType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* nsLang = [GET_SERVICE(MMLanguageMgr) getCurLanguage];
	NSString* installUrl = [NSString stringWithFormat:@"http://rd.wechatapp.com/app/store/?appid=%@&version=%x&lang=%@&devicetype=%@&from=%@",
							nsAppID,
							(uint32_t)[CUtility GetVersion],
							nsLang,
							nsEncodeDeviceType,
							[CAppUtil UrlFromTypeToString:from]];

	//the return stmt
	return installUrl;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getAppFromUrl:from:
 * Returning Type: NSString *
 */ 
+(NSString*) getAppFromUrl:(NSString*)nsAppID from:(URL_From_Type)from {
	if ([nsAppID length] <= 0) // the 'if' part
	{
		//the return stmt
		return nil;
	}
	
    NSString* nsDeviceType = [CAppUtil getDeviceType];
    NSString* nsEncodeDeviceType = [nsDeviceType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* nsLang = [GET_SERVICE(MMLanguageMgr) getCurLanguage];
	NSString* fromUrl = [NSString stringWithFormat:@"http://rd.wechatapp.com/app/source/?appid=%@&version=%x&lang=%@&devicetype=%@&from=%@",
						 nsAppID,
						 (uint32_t)[CUtility GetVersion],
						 nsLang,
						 nsEncodeDeviceType,
						 [CAppUtil UrlFromTypeToString:from]];
	
	//the return stmt
	return fromUrl;
	
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getAppNameByMsg:
 * Returning Type: NSString *
 */ 
+ (NSString *)getAppNameByMsg:(CMessageWrap *)oMsgWrap{
	
	if([oMsgWrap.m_nsAppID length] == 0)// the 'if' part
	{
		//the return stmt
		return nil;
	}
	
	AppRegisterInfo * info = [GET_SERVICE(AppDataMgr) getAppRegisterInfo:oMsgWrap.m_nsAppID];
	
    NSString *appName = [CAppUtil getCurrentLanguageAppName:info];
	if([appName length] > 0)// the 'if' part
	{
		//the return stmt
		return appName;
	}
	
	return oMsgWrap.m_nsAppName;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getAppNameById:
 * Returning Type: NSString *
 */ 
+(NSString*) getAppNameById:(NSString*)nsAppID{
	
	if([nsAppID length] == 0)// the 'if' part
	{
		//the return stmt
		return nil;
	}
	
	AppRegisterInfo * info = [GET_SERVICE(AppDataMgr) getAppRegisterInfo:nsAppID];
	
	return [CAppUtil getCurrentLanguageAppName:info];	
}

//NSLog(@"%d",versionCompare(@"1.2.4.5",@"1.2.5.0"));
//NSLog(@"%d",versionCompare(@"1.3",@"1.3"));
//NSLog(@"%d",versionCompare(@"1.4",@"1.3"));	
//NSLog(@"%d",versionCompare(@"2",@"1.3"));
//NSLog(@"%d",versionCompare(@"",@"1.3"));
//NSLog(@"%d",versionCompare(@"",@""));	
//NSLog(@"%d",versionCompare(@"1.10",@"1.9"));
//2012-05-15 17:44:30.654 Untitled[38075:60b] -1
//2012-05-15 17:44:30.656 Untitled[38075:60b] 0
//2012-05-15 17:44:30.657 Untitled[38075:60b] 1
//2012-05-15 17:44:30.657 Untitled[38075:60b] 1
//2012-05-15 17:44:30.658 Untitled[38075:60b] -1
//2012-05-15 17:44:30.659 Untitled[38075:60b] 0
//2012-05-15 17:44:30.659 Untitled[38075:60b] 1
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: VersionCompare:vs:
 * Returning Type: NSComparisonResult
 */ 
+(NSComparisonResult) VersionCompare:(NSString*)verA vs:(NSString*)verB
{
    NSArray* listA = [verA componentsSeparatedByString:@"."];
    NSArray* listB = [verB componentsSeparatedByString:@"."];
    for (NSInteger i = 0; i< MAX(listA.count, listB.count); i++) {
        NSInteger a = [(i>=listA.count?@"0":[listA objectAtIndex:i]) longLongValue];
        NSInteger b = [(i>=listB.count?@"0":[listB objectAtIndex:i]) longLongValue];   
        if (a!=b) // the 'if' part
        {
            //the return stmt
            return a>b?NSOrderedAscending:NSOrderedDescending;
        }
    }
    //the return stmt
    return NSOrderedSame;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: GetAppVerCompareWithLastRun
 * Returning Type: NSComparisonResult
 */ 
+(NSComparisonResult) GetAppVerCompareWithLastRun{
	MicroMessengerAppDelegate *delegate = (MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate];
    //the return stmt
    return [delegate GetAppVerCompareWithLastRun];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getRecommandAppItemCurrentLanguageAppName:
 * Returning Type: NSString *
 */ 
+(NSString *)getRecommandAppItemCurrentLanguageAppName:(RecommandAppItem *)item{
    NSString *result = nil;
    
    if([[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString: MM_LANGUAGE_CHS])// the 'if' part
    {
        result = item.appName;
    }else // the 'else' part
    if([GET_SERVICE(MMLanguageMgr) curLanguageIsChineseTraditional])// the 'if' part
    {
        result = item.appNameTW;
    }else // the 'else' part
    {
        result = item.appNameEn;
    }
    
    return (result != nil && result.length > 0) ? result : item.appName;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getServiceAppItemCurrentLanguageAppName:
 * Returning Type: NSString *
 */ 
+(NSString *)getServiceAppItemCurrentLanguageAppName:(ServiceAppData *)item{
    NSString *result = nil;
    
    if([[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString: MM_LANGUAGE_CHS])// the 'if' part
    {
        result = item.appName;
    }else // the 'else' part
    if([[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString:MM_LANGUAGE_CHT_HK])// the 'if' part
    {
        result = item.appNameHK.length > 0 ? item.appNameHK : item.appNameTW;
    }else // the 'else' part
    if([[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString:MM_LANGUAGE_CHT])// the 'if' part
    {
        result = item.appNameTW;
    }else // the 'else' part
    {
        result = item.appNameEn;
    }
    
    return (result != nil && result.length > 0) ? result : item.appName;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getCurrentLanguageAppName:
 * Returning Type: NSString *
 */ 
+(NSString*) getCurrentLanguageAppName:(AppRegisterInfo*)appinfo{
    NSString *result = nil;
    
    if([[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString: MM_LANGUAGE_CHS])// the 'if' part
    {
        result = appinfo.appName;
    }else // the 'else' part
    if([GET_SERVICE(MMLanguageMgr) curLanguageIsChineseTraditional])// the 'if' part
    {
        result = appinfo.appName4ZhTw;
    }else // the 'else' part
    {
        result = appinfo.appName4EnUs;
    }
    
    return (result != nil && result.length > 0) ? result : appinfo.appName;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getCurrentLanguageAppDescription:
 * Returning Type: NSString *
 */ 
+(NSString*) getCurrentLanguageAppDescription:(AppRegisterInfo*)appinfo{
    NSString *result = nil;
    
    if([[GET_SERVICE(MMLanguageMgr) getCurLanguage] isEqualToString: MM_LANGUAGE_CHS])// the 'if' part
    {
        result = appinfo.appDescription;
    }else // the 'else' part
    if([GET_SERVICE(MMLanguageMgr) curLanguageIsChineseTraditional])// the 'if' part
    {
        result = appinfo.appDescription4ZhTw;
    }else // the 'else' part
    {
        result = appinfo.appDescription4EnUs;
    }
    
    return (result != nil && result.length > 0) ? result : appinfo.appDescription;
}


/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isOrientationLandscape
 * Returning Type: BOOL
 */ 
+(BOOL) isOrientationLandscape 
{   
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation ;
    return UIInterfaceOrientationIsLandscape( (UIInterfaceOrientation)orientation ) ; 
}
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: isOrientationPortrait
 * Returning Type: BOOL
 */ 
+(BOOL) isOrientationPortrait 
{
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation ;
    return UIInterfaceOrientationIsPortrait( (UIInterfaceOrientation)orientation ) ; 
}

#pragma mark - 模拟memory warning

#define LOCAL_MEMORY_WARNING_NOTIFY @"LOCAL_MEMORY_WARNING_NOTIFY"

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: addLocalMemoryWarningObserver:selector:
 * Returning Type: void
 */ 
+(void) addLocalMemoryWarningObserver:(id)notificationObserver selector:(SEL)notificationSelector {
	[[NSNotificationCenter defaultCenter] addObserver:notificationObserver selector:notificationSelector name:LOCAL_MEMORY_WARNING_NOTIFY object:nil];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: removeLocalMemoryWarningObserver:
 * Returning Type: void
 */ 
+(void) removeLocalMemoryWarningObserver:(id)notificationObserver {
	[[NSNotificationCenter defaultCenter] removeObserver:notificationObserver name:LOCAL_MEMORY_WARNING_NOTIFY object:nil];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: fireLocalMemoryWarningNotify
 * Returning Type: void
 */ 
+(void) fireLocalMemoryWarningNotify {
    //the func--->MMDebug() begin called!
    MMDebug(@"fireLocalMemoryWarningNotify");
	[[NSNotificationCenter defaultCenter] postNotificationName:LOCAL_MEMORY_WARNING_NOTIFY object:nil];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: getCurrentDeviceName
 * Returning Type: NSString *
 */ 
+(NSString *) getCurrentDeviceName
{
    return [[UIDevice currentDevice] name];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: addHtmlHrefForText:
 * Returning Type: NSString *
 */ 
+(NSString *) addHtmlHrefForText:(NSString *)content
{
    if (content.length <= 0) // the 'if' part
    {
        //the return stmt
        return nil;
    }
    
    NSMutableString *hrefContent = [NSMutableString stringWithString:content];
    
    LinkTextParser *linkTextParser = [[LinkTextParser alloc] init];
    
    NSRange startRange = //the func--->NSMakeRange() begin called!
    NSMakeRange(0, content.length);
    NSUInteger hrefStartPos = 0;
    while (startRange.location < content.length) {
        NSRange linkRange = [linkTextParser rangeOfObjectInString:content withRange:startRange];
        if (linkRange.location == NSNotFound || linkRange.location >= content.length || linkRange.length <= 0) // the 'if' part
        {
            break;
        }
        
        NSString *linkString = [content substringWithRange:linkRange];
        
        NSString *hrefString = nil;
        if ([linkString rangeOfRegex:@"://"].location == NSNotFound) // the 'if' part
        {
            if ([MMURLHandler containEmailString:linkString]) // the 'if' part
            {
                if ([linkString hasPrefix:@"mailto:"]) // the 'if' part
                {
                    hrefString = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", linkString, linkString];
                } else // the 'else' part
                {
                    hrefString = [NSString stringWithFormat:@"<a href=\"mailto:%@\">%@</a>", linkString, linkString];
                }
            } else // the 'else' part
            {
                hrefString = [NSString stringWithFormat:@"<a href=\"http://%@\">%@</a>", linkString, linkString];
            }
        } else // the 'else' part
        {
            hrefString = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", linkString, linkString];
        }
        
        NSRange hrefRange = [hrefContent rangeOfString:linkString];
        if (hrefRange.location == NSNotFound || hrefRange.location >= hrefContent.length || hrefRange.length <= 0) // the 'if' part
        {
            //the func--->MMError() begin called!
            MMError(@"error, linkString=%@, hrefContent=%@, hrefStartPos=%lu", linkString, hrefContent, (unsigned long)hrefStartPos);
            break;
        }
        
        [hrefContent replaceCharactersInRange:hrefRange withString:hrefString];
        hrefStartPos = hrefRange.location + hrefString.length;

        startRange = //the func--->NSMakeRange() begin called!
        NSMakeRange(//the func--->NSMaxRange() begin called!
        NSMaxRange(linkRange), //the func--->NSMaxRange() begin called!
        NSMaxRange(startRange) - //the func--->NSMaxRange() begin called!
        NSMaxRange(linkRange));
    }
    //the return stmt
    return hrefContent;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: openSessionWithContact:fromViewController:
 * Returning Type: void
 */ 
+(void) openSessionWithContact:(CContact *) oContact fromViewController:(UIViewController *) viewController
{
    if (![GET_SERVICE(MMNewSessionMgr) IsActiveUser:oContact.m_nsUsrName])
    // the 'if' part
    {
        [viewController DismissModalViewControllerAnimated:NO] ;
        //Pop To Root View Controller
        while( viewController.navigationController.viewControllers.count > 1 )
        {
            [viewController.navigationController PopViewControllerAnimated:NO] ;
        }
        
        [[CAppViewControllerManager getAppViewControllerManager] newMessageByContact:[GET_SERVICE(CContactMgr) getContactByName:oContact.m_nsUsrName] msgWrapToAdd:nil];
    }
    else
    // the 'else' part
    {
        [viewController DismissModalViewControllerAnimated:NO] ;
        
        UIViewController * messageViewController = [[GET_SERVICE(MMMsgLogicManager) GetCurrentLogicController] getViewController] ;
        MMDebug(@"messageViewController.navigationController %@ messageViewController %@ getCurrentViewController %@" , messageViewController.navigationController.viewControllers , messageViewController , viewController ) ;
        while( messageViewController.navigationController.topViewController != messageViewController )
        {
            [messageViewController.navigationController PopViewControllerAnimated:NO] ;
        }
    }

}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//AppUtil.mm
 * Method Name: GetEnabledNotificationType
 * Returning Type: UInt32
 */ 
+(UInt32) GetEnabledNotificationType
{
    UInt32 notificationTypes;
    UInt32 mmNotifcationTypes = MMNotificationTypeNone;
    if ([DeviceInfo isiOS8plus]) // the 'if' part
    {
        notificationTypes = (UInt32)[[UIApplication sharedApplication] currentUserNotificationSettings].types;
        if ((notificationTypes & UIUserNotificationTypeAlert) != 0) // the 'if' part
        {
            mmNotifcationTypes |= MMNotificationTypeAlert;
        }
        if ((notificationTypes & UIUserNotificationTypeBadge) != 0) // the 'if' part
        {
            mmNotifcationTypes |= MMNotificationTypeBadge;
        }
        if ((notificationTypes & UIUserNotificationTypeSound) != 0) // the 'if' part
        {
            mmNotifcationTypes |= MMNotificationTypeSound;
        }
    }
    else // the 'else' part
    {
        notificationTypes = (UInt32)[[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if ((notificationTypes & UIRemoteNotificationTypeAlert) != 0) // the 'if' part
        {
            mmNotifcationTypes |= MMNotificationTypeAlert;
        }
        if ((notificationTypes & UIRemoteNotificationTypeBadge) != 0) // the 'if' part
        {
            mmNotifcationTypes |= MMNotificationTypeBadge;
        }
        if ((notificationTypes & UIRemoteNotificationTypeSound) != 0) // the 'if' part
        {
            mmNotifcationTypes |= MMNotificationTypeSound;
        }
    }
    //the return stmt
    return mmNotifcationTypes;
}

#ifdef DEBUG
// 暂时只在debug版本中使用，因为据说会有0.1%的概率会crash,https://gist.github.com/steipete/7668246#comment-959027
+(BOOL) isProductionSignature
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    static BOOL isProduction = YES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // There is no provisioning profile in AppStore Apps.
        NSData *data = [NSData dataWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"embedded" ofType:@"mobileprovision"]];
        if (data) {
            const char *bytes = (const char *)[data bytes];
            NSMutableString *profile = [[NSMutableString alloc] initWithCapacity:data.length];
            for (NSUInteger i = 0; i < data.length; i++) {
                [profile appendFormat:@"%c", bytes[i]];
            }
            // Look for debug value, if detected we're a development build.
            NSString *cleared = [[profile componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] componentsJoinedByString:@""];
            isProduction = [cleared rangeOfString:@"<key>get-task-allow</key><false/>"].length > 0;
        }
    });
    return isProduction;
#endif
}
#endif

@end