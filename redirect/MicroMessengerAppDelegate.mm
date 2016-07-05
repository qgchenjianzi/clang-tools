//
//  MicroMessengerAppDelegate.m
//  MicroMessenger
//
//  Created by QQ Tencent on 10-11-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved
//

#import "MMUIDef.h"
#import "MicroMessengerAppDelegate.h"
#import "MicroMessengerAppDelegate+MMCommonAdapter.h"
#import "ControlUtil.h"
#import "AppUtil.h"
#import "MMNotificationCenter.h"
#import "ContactMgr.h"
#import "QQContactMgr.h"
#import "WCAudioSession.h"
#import "WCAudioSessionLogic.h"
#import "AudioReceiver.h"
#import "AudioSender.h"
#import <objc/runtime.h>
#import "NetworkStatusMgr.h"
#import "MessageMgr.h"
#import "GroupMgr.h"
#import "NewArrivalCountMgr.h"
#import "AppObserverCenter.h"
#import "MMThemeManager.h"
#import "BottleMgr.h"
#import "BottleContactMgr.h"
#import "BackgroundTask.h"
#import "EmoticonMgr.h"
#import "VOIPHelper.h"
#import "MMNewSessionMgr.h"
#import "MassSendMgr.h"
#import "NewSyncPluginMgr.h"
#import "DeviceInfo.h"
#import "MMFacebookMgr.h"
#import "AppDataMgr.h"
#import "WCFacade.h"
#import <MMCommon/BaseFile.h>
#import "OpenApiMgr.h"
#import "OpenApiMgrHelper.h"
#import "EmoticonMgr.h"
#import "MMResPackageMgr.h"
#import "MainControll.h"
#import "AppViewControllerManager.h"
#import <MMCommon/ServiceCenter.h>
#import "WeChatApiDef.h"
#import "OnlineClientMgr.h"
#import "ShakeMgr.h"
#import "ChatBackgroundMgr.h"
#import "iConsoleWindow.h"
#import "BrandStoryMgr.h"
#import "MMLanguagePackageDownloadMgr.h"
#import "IDCHostMgr.h"
#import "MMTwitterMgr.h"
#import "ReportStrategyCtrlMgr.h"
#import "AutoSetRemarkMgr.h"
#import "Utility.h"
#import "MMConfigMgr.h"
#import "VoiceReminderMgr.h"
#import "SysCallCheck.h"
#import "WXTalkMgr.h"
#import "MMEnterpriseBrandSessionMgr.h"
#import "VOIPMessageMgr.h"
#import "WXTalkPresentMgr.h"
#import "QQSessionMgr.h"
#import "PushSystemMsgMgr.h"
#import "SettingUtil.h"
#import "FriendAsistSessionMgr.h"
#import "LbsRoomSessionMgr.h"
#import "BrandServiceMgr.h"
#import "CdnComMgr.h"
#import "RsaCertMgr.h"
#import "AudioHelper.h"
#import <PublicComponentDylib/Objc2C_Comm.h>
#import <PublicComponentDylib/Objc2C_Logic.h>
#import <PublicComponentDylib/Objc2C_LogLogic.h>
#import <PublicComponentDylib/Objc2C_Comm.h>
#import <PublicComponentDylib/KVCommReport.h>

#import "AutoVerifySMS.h"
#import "WCBizUIInclude.h"
#import "FavAddItemHelper.h"
#import "VolumeCheckHelper.h"
#import <MMCommon/NSMutableObject+SafeInsert.h>
#import "URLSourceInfo.h"
#import "CleanCacheService.h"
#import "DeletePathService.h"
#import <MMCommon/ClassMethodDispatchCenter.h>
#import "MessageWrap.h"
#import "EmoticonRecommendMgr.h"
#import "WCPayLogicMgr.h"
#import "NewSyncService.h"
#import "VerifyQQPwdMgr.h"
#import "AppCommentMgr.h"
#import "UpdateProfileMgr.h"
#import "PowerMonitor.h"
#import "NewQQMailMgr.h"
#import "WCMallLogicMgr.h"
#import "VoipUIManager.h"
#import "WTLoginMgr.h"
#import "HRHResistantURLCache.h"
#import "WCPayControlMgr.h"
#import "WCRedEnvelopesControlMgr.h"


#import "EventService.h"

#import "FriendAsistSessionMgr.h"
#import "LbsRoomSessionMgr.h"
#import "FTSFacade.h"

#import "BannerToastMgr.h"
#import "WCAccountControlMgr.h"
#import "WCDeviceBrandMgr.h"
#import "WCBeaconGuideModeMgr.h"
#import "WCBeaconUtilsMgr.h"
#import "WCBeaconTouchMgr.h"
#import "PublicWifiManager.h"
#import "WCDeviceFriendWifiMgr.h"
#import "ContactTagMgr.h"
#import "ImageAutoDownloadMgr.h"

#import "TemplateMsgRecvMgr.h"
#import "MMUINavigationController.h"
#import "ContactsViewController.h"
#import "FindFriendEntryViewController.h"
#import "LocalNotificationTypeDef.h"
#import "WCUIAlertView.h"

#import "MMDumpReporterMgr.h"
#import "MMUIWindow.h"
#import "MMMonitorConfigMgr.h"
#import "MMBaseSessionStorage.h"
#import "ClearDataExt.h"

#import "MMEnterpriseBrandSessionMgr.h"

#import "KitManager.h"
#import "CameraScanViewController.h"

#import "KFContactMgr.h"
#import "WCJdBussinessMgr.h"
#import "WCInnerJumpMgr.h"
#import "mmprotodef.h"
#import "MMMonitorMgr.h"
#import "MMDumpReporterMgr.h"
#import "KitManager.h"

#import "DeviceModelConfigMgr.h"
#import "WCCardPkgMgr.h"
#import "WCShareCardMgr.h"

#import "SEFavoritesManager.h"
#import "MMKeychainManager.h"
#import "MMPerformanceDataReportMgr.h"
#import "WCBusinessJumpMgr.h"

#import "EmoticonBackUpMgr.h"

#import "SightFacade.h"

#import "WCWatchNativeMgr.h"

#import "MMShareExtMgr.h"
#import "MMExtensionShareDataUtil.h"

#import "XOMgr.h"

#import "ShakeCardMgr.h"
#import "SvrErrorMgr.h"

#import "MMEasterEggMgr.h"
#import "MMDatabaseRecoverMgr.h"
#import "MMFreeSpaceCheckMgr.h"
#import "NSObjectSwizzling.h"

#import "NotificationActionsMgr.h"
#import "BrandAttrMgr.h"

#import "EnterpriseSessionMgr.h"
#import "EnterpriseMsgDelegate.h"
#import "EnterpriseContactMgr.h"
#import "EnterpriseMsgMgr.h"

#import "MMResourceService.h"
#import "MMUrlCache.h"
#import "MMWebLocalStorageMgr.h"

#import "UIView+BlurEffect.h"
#import "UIImage+ImageEffects.h"

#import "StoreEmotionBackupMgr.h"
#import "StoreEmotionRecoverMgr.h"
#import "StoreEmotionSearchResMgr.h"

#import "WCNearbyMsgNotifyMgr.h"
#import "ClientCheckMgr.h"
#import "OutLinkHijackDetector.h"

#import "NewABTestMgr.h"
#import "NewABTestKeyMgr.h"
#import "WCAdvertiseLogMgr.h"
#import "KVCommReportLogic.h"
#import "EmoticonTabRecommendMgr.h"
#import "MMDBPerformanceMgr.h"

#import "mmpack.h"
#import "SendMassBrandSessionMgr.h"
#import "InteractiveBrandSessionMgr.h"
#import "MMDiskUsageMgr.h"
#import "MMDBPerformanceMgr.h"

#import "WCOutFacade.h"
#import "MMWebViewController+DeepLink.h"

#ifdef OPEN_COVERAGE
#import "testFlush.h"
#endif

#import "F2FMgr.h"

#import "MultiTalkMgr.h"
#import "WCNearbyPullFeedMgr.h"

#import "MMPatchMgr.h"
#import "WCDBABTestExt.h"

#import "AddFriendEntryViewController.h"
#import "QRCodeViewController.h"
#import "MoreViewController.h"
#import "NewMainFrameViewController+RightMenuActions.h"
#import "MMWCResourceMgr.h"
#import "MMOOMCrashReport.h"

#import "MMLocalNotificationUtil.h"
#import "WCDurationLogMgr.h"

#import "FunctionMsgMgr.h"
#import "WeChatApiDef.h"
#import "BadRoomMgr.h"
#import "VoIPTokenRetriveObject.h"
#import "AppleSearchMgr.h"
#import <CoreSpotlight/CoreSpotlight.h>

#import "MMCrashReportHandler.h"
#import "WCTempChatMgr.h"

#import "MMSafeModeMgr.h"
#import "MMSMStartViewController.h"
#import "WXGLogMonitor.h"
#import "MMCrashProtectedMgr.h"

#import "MMWatchDogMonitor.h"
#import "WCAppBrandMgr.h"
#import "WCGet3rdNetworkDataMgr.h"
#import "SendMassBrandMoreSessionMgr.h"
#import "WCImageConvertMgr.h"

#import "MMDBRepairManager.h"
#import "WCSuspectedDBCorrupt.h"
#import "MMB2FDumpMgr.h"
#import "WCNewClickStatMgr.h"
#import "WWKApi.h"
#import "BizLivePresentManager.h"

@interface MicroMessengerAppDelegate () {
    BOOL m_isFirstLaunching;
    BOOL m_isInSafeMode;
}

@property(nonatomic, strong) VoIPTokenRetriveObject* m_voipTokenRetriveObject;

@end

#define RESOURCE_LABEL_WIDTH  140
#define RESOURCE_LABEL_HEIGTH 20

#define CHANGE_LABLE_WIDTH    80
#define CHANGE_LABEL_HEIGHT   RESOURCE_LABEL_HEIGTH

#define CHANGE_VALUE_LIMIT    6 // MB

// 程序最长执行时间
#define MAX_RUNNING_HOURS	24
#define ALERT_VIEW_PUSH_TIP 10001
#define DL_ALERT_VIEW_TAG 10002

//apns 超时时间
#define APNS_ITMEOUT	(60 * 2)

@interface MicroMessengerAppDelegate () {
    MMSMStartViewController *m_safeModeViewController;
}

- (void)detectAppFirstRunOrFirstRunAfterUpgrade;
- (void)firstStartAfterUpgradeDowngrade;
- (void)continueMainLaunching:(NSDictionary*)launchOptions;
- (void)saveAppVersion;
- (void)handleApnsDeepLink:(NSDictionary *)userInfo;
@end

@interface MicroMessengerAppDelegate (SafeMode)
- (BOOL)shouldEnterSafeMode;
@end

@implementation MicroMessengerAppDelegate (SafeMode)

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: shouldEnterSafeMode
 * Returning Type: BOOL
 */ 
- (BOOL)shouldEnterSafeMode
{
	if ([[MMSafeModeMgr shareInstance] shouldEnterSafeMode]) // the 'if' part
	{
        // 进入安全模式
        m_isInSafeMode = YES;
        
        m_safeModeViewController = [[MMSMStartViewController alloc] init];
        MMUINavigationController *navController = [[MMUINavigationController alloc] initWithRootViewController:m_safeModeViewController];
        self.window.rootViewController = navController;
        
        [m_safeModeViewController startupFirstRun];
        
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleMMSafeModeDidEndNotification:)
													 name:MMSafeModeDidEndNotification object:nil];
		//the return stmt
		return YES;
	}
	
	//the return stmt
	return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: handleMMSafeModeDidEndNotification:
 * Returning Type: void
 */ 
- (void)handleMMSafeModeDidEndNotification:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MMSafeModeDidEndNotification object:nil];
    
    m_isInSafeMode = NO;
    self.window.rootViewController = nil;
    m_safeModeViewController = nil;
    
    [self beforeMainLauching];
    [self continueMainLaunching:nil];
}

@end

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Function Name: safeExitPublic
 * Returning Type: void
 */ 
void safeExitPublic()
{
    [MMOOMCrashReport setFlag:DEF_APP_INTENTIONALLY_QUIT];
    [GET_SERVICE(MMCrashProtectedMgr) onExit];
    //the func--->kvCommOnAppCrashOrExit() begin called!
    kvCommOnAppCrashOrExit();
    //the func--->Objc2C_onDestroy() begin called!
    Objc2C_onDestroy();
    //the func--->Objc2C_AppenderClose() begin called!
    Objc2C_AppenderClose();
}

@implementation MicroMessengerAppDelegate {
	UIView* m_blurView;
}

@synthesize window = _window ;
@synthesize m_mainController;
@synthesize m_nsToken;
@synthesize m_nsSound;
@synthesize m_nsVoipSound;
@synthesize m_appViewControllerMgr;
@synthesize m_appObserverCenter;
@synthesize m_isActive;
@synthesize mInBackGroundFetch;
@synthesize m_ui64BackGroundFetchStopTime;

@synthesize mActiveLock;

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: RenamePath
 * Returning Type: void
 */ 
-(void) RenamePath
{
    [CEmoticonMgr RenameEmoticon];
    [MMResPackageMgr RenameResRoot];
}

#pragma mark -
#pragma mark ServiceCenter
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: releaseSeviceCenter
 * Returning Type: void
 */ 
-(void) releaseSeviceCenter
{
//	// free service center
//	MMDebug(@"ServiceCenter count:%lu", (unsigned long)[m_serviceCenter retainCount]);
//	
//	if ([m_serviceCenter retainCount] > 1)
//	{
//		MMError(@"!!! ServiceCenter can't release !!!");
//	}
//	[m_serviceCenter release];
    
    //the func--->MMDebug() begin called!
    MMDebug(@"release service center");
	
	m_serviceCenter = nil;
}

//往ClassMethodDispatchCenter中注册需要监听的类方法调用
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: registerClsMethodObserver
 * Returning Type: void
 */ 
-(void)registerClsMethodObserver
{
    NSInteger msgType = MM_DATA_VOICEMSG;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfVoiceMsg))
    msgType = (UInt32)MM_DATA_PUSHMAIL;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfPushMail))
    msgType = (UInt32)MM_DATA_QMSG;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfQQ))
    msgType = (UInt32)MM_DATA_VIDEO;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfVideo))
    msgType = (UInt32)MM_DATA_VIDEO_IPHONE_EXPORT;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfVideo))
    msgType = (UInt32)MM_DATA_SHORT_VIDEO;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfVideo))
    msgType = (UInt32)MM_DATA_EMOJI;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfEmoticon))
    msgType = (UInt32)MM_DATA_LOCATION;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfLocation))
    msgType = (UInt32)MM_DATA_APPMSG;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfAPP))
    msgType = (UInt32)MM_DATA_VOIP_INVITE;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfVoip))
    msgType = (UInt32)MM_DATA_IMG;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfImg))
    msgType = (UInt32)MM_DATA_PRIVATEMSG_IMG;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfImg))
    msgType = (UInt32)MM_DATA_QQLIXIANMSG_IMG;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfImg))
    msgType = (UInt32)MM_DATA_SYSCMD_NEWXML;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapForBizExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfSysNewXmlForBiz))
    
    REGISTER_CLSMETHOD_OBSERVER(IMessageWrapExt, CLASS_NAME(CExtendInfoOfMassSend))
    REGISTER_CLSMETHOD_OBSERVER(IMessageWrapExt, CLASS_NAME(CExtendInfoOfReader))
    
    REGISTER_CLSMETHOD_OBSERVER(IAppMsgPathMgr, CLASS_NAME(CMessageWrap))
    
    // for biz
    msgType = (UInt32)MM_DATA_TEXT;
    REGISTER_KEY_CLSMETHOD_OBSERVER(IMessageWrapForBizExt, MSGWRAP_EXTENDKEY(msgType), CLASS_NAME(CExtendInfoOfTextForBiz))
}
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: registerLazyExtensionListener
 * Returning Type: void
 */ 
-(void) registerLazyExtensionListener
{
	LOG_FUNTION_TIME;
    
    LAZY_REGISTER_EXTENSION(IMsgExt, QQMailMgr);
    LAZY_REGISTER_EXTENSION(IEnterpriseMsgExt, MMNewSessionMgr);
	LAZY_REGISTER_EXTENSION(IMsgExt, MMNewSessionMgr);
	LAZY_REGISTER_EXTENSION(IContactMgrExt, MMNewSessionMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, CGroupMgr);
	
	LAZY_REGISTER_EXTENSION(IContactMgrExt, AutoSetRemarkMgr);
    
	LAZY_REGISTER_EXTENSION(MMResPackageMgrExt, CEmoticonMgr);
    LAZY_REGISTER_EXTENSION(MMConfigMgrExt, CEmoticonMgr);
    
	LAZY_REGISTER_EXTENSION(IMsgExt, NewArrivalCountMgr);
    
	LAZY_REGISTER_EXTENSION(MMKernelExt, MMConfigMgr);
    
	LAZY_REGISTER_EXTENSION(MMKernelExt, ContactTagMgr);
    
    LAZY_REGISTER_EXTENSION(IMMNewSessionMgrExt, KFContactMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, KFContactMgr);
    
	LAZY_REGISTER_EXTENSION(IMsgExt, OpenApiMgr);
    
	LAZY_REGISTER_EXTENSION(IMsgExt, VoiceReminderMgr);
	
	LAZY_REGISTER_EXTENSION(IMsgExt, VOIPMessageMgr);
    LAZY_REGISTER_EXTENSION(VoIPPushKitExt, VOIPMessageMgr);
    
	LAZY_REGISTER_EXTENSION(IContactMgrExt, BrandStoryMgr);
	
	LAZY_REGISTER_EXTENSION(IMsgExt, WXTalkPresentMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, TrackPresentMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, BizLivePresentManager);
#ifndef SPAY_VOIP
	LAZY_REGISTER_EXTENSION(IMMNewSessionMgrExt, WXTalkMgr);
#endif
    
	LAZY_REGISTER_EXTENSION(INewArrivalExt, QQSessionMgr);
	LAZY_REGISTER_EXTENSION(IQQContactMgrExt, QQSessionMgr);
	LAZY_REGISTER_EXTENSION(IMsgExt, QQSessionMgr);
	LAZY_REGISTER_EXTENSION(IAudioSenderExt, QQSessionMgr);
	LAZY_REGISTER_EXTENSION(IMMNewSessionMgrExt, QQSessionMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, MassSendMgr);
    
    LAZY_REGISTER_EXTENSION(IMMNewSessionMgrExt, FriendAsistSessionMgr);
    LAZY_REGISTER_EXTENSION(IContactMgrExt, FriendAsistSessionMgr);
    
    LAZY_REGISTER_EXTENSION(IMsgExt, FriendAsistSessionMgr);
    LAZY_REGISTER_EXTENSION(IMMNewSessionMgrExt, LbsRoomSessionMgr);
    
	LAZY_REGISTER_EXTENSION(IMsgExt, BrandServiceMgr);
	LAZY_REGISTER_EXTENSION(JSEventExt, WCPayControlMgr);
    LAZY_REGISTER_EXTENSION(WCPayOpenApiExt, WCPayControlMgr);
    LAZY_REGISTER_EXTENSION(WCHBOpenApiExt, WCRedEnvelopesControlMgr);
    LAZY_REGISTER_EXTENSION(JSEventExt, WCRedEnvelopesControlMgr);
    LAZY_REGISTER_EXTENSION(WCHBOpenApiExt, WCRedEnvelopesControlMgr);
	LAZY_REGISTER_EXTENSION(JSEventExt, WCAddressControlMgr);
    
    LAZY_REGISTER_EXTENSION(IMsgExt, EmoticonRecommendMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, EmoticonTabRecommendMgr);
    LAZY_REGISTER_EXTENSION(ICheckQQExt, VerifyQQPwdMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, AppCommentMgr);
    LAZY_REGISTER_EXTENSION(MMKernelExt, UpdateProfileMgr);
    LAZY_REGISTER_EXTENSION(MMConfigMgrExt, VoipUIManager);
    
    LAZY_REGISTER_EXTENSION(IMsgExt, BannerToastMgr);
    
    LAZY_REGISTER_EXTENSION(IMsgExt, ImageAutoDownloadMgr);
    LAZY_REGISTER_EXTENSION(MMKernelExt, OnlineClientMgr);
    
    LAZY_REGISTER_EXTENSION(IMsgExt, MMPackageDownloadMgr);
    LAZY_REGISTER_EXTENSION(MMKernelExt, WCCardPkgMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, WCCardPkgMgr);
    LAZY_REGISTER_EXTENSION(MMKernelExt, WCShareCardMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, WCJdBussinessMgr);
	LAZY_REGISTER_EXTENSION(IClearDataMgrExt, WCFacade);
	LAZY_REGISTER_EXTENSION(IClearDataMgrExt, MMHttpCacheMgr);
	    //voip device model
    LAZY_REGISTER_EXTENSION(MMKernelExt, DeviceModelConfigMgr);
    
    LAZY_REGISTER_EXTENSION(MMKernelExt, MMKeychainManager);
    LAZY_REGISTER_EXTENSION(MMKernelExt, EmoticonBackUpMgr);
    
    LAZY_REGISTER_EXTENSION(IMMNewSessionMgrExt, SightFacade);
    LAZY_REGISTER_EXTENSION(IMsgExt, ShakeCardMgr);
    LAZY_REGISTER_EXTENSION(MMPackageDownloadMgrExt, MMEasterEggMgr);
    
    LAZY_REGISTER_EXTENSION(IEnterpriseMsgExt, EnterpriseSessionMgr);
    LAZY_REGISTER_EXTENSION(IEnterpriseContactMgrExt, EnterpriseSessionMgr);
    LAZY_REGISTER_EXTENSION(IContactMgrExt, EnterpriseContactMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, EnterpriseContactMgr);

     LAZY_REGISTER_EXTENSION(IMsgExt,MMResourceService);

    
    LAZY_REGISTER_EXTENSION(MMKernelExt, StoreEmotionBackupMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, StoreEmotionRecoverMgr);
    LAZY_REGISTER_EXTENSION(MMResourceMgrExt, StoreEmotionSearchResMgr);

    LAZY_REGISTER_EXTENSION(IMsgExt, WCNearbyMsgNotifyMgr);
    
    LAZY_REGISTER_EXTENSION(IMsgExt, ClientCheckMgr);
    LAZY_REGISTER_EXTENSION(IMsgExt, CKVCommReportLogic);
    
    LAZY_REGISTER_EXTENSION(MMKernelExt, ReportStrategyCtrlMgr);
    LAZY_REGISTER_EXTENSION(ReportStrategyExt, MMMonitorConfigMgr);
    
#ifndef SPAY_PERFORMNCE_DATA_MONITOR
    LAZY_REGISTER_EXTENSION(ReportStrategyExt, MMDiskUsageMgr);
#endif
    
    LAZY_REGISTER_EXTENSION(ReportStrategyExt, MMDatabaseRecoverMgr);
    
    LAZY_REGISTER_EXTENSION(MMKernelExt, MultiTalkMgr);
    
    LAZY_REGISTER_KEY_EXTENSION(IMsgExt, WCOutFacade, @MM_DATA_SYSCMD_NEWXML_SUBTYPE_WECHATOUT);
    LAZY_REGISTER_KEY_EXTENSION(IMsgExt, WCOutFacade, @MM_DATA_SYSCMD_NEWXML_SUBTYPE_WECHATOUT_MSG);
    LAZY_REGISTER_EXTENSION(IVOIPExt,WCOutFacade);//voip 不支持带key的
    LAZY_REGISTER_KEY_EXTENSION(IMMWebViewControllerDeepLinkExt, WCOutFacade, @"wechatout");
    
    LAZY_REGISTER_EXTENSION(IMsgExt, WCAppBrandMgr);
    LAZY_REGISTER_EXTENSION(SendMassBrandSessionMgrDataSourceExt, SendMassBrandMoreSessionMgr);
    
    LAZY_REGISTER_EXTENSION(IMsgExt, SendMassBrandSessionMgr);
    LAZY_REGISTER_EXTENSION(IContactMgrExt, SendMassBrandSessionMgr);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: initServiceObject
 * Returning Type: void
 */ 
-(void) initServiceObject
{
	LOG_FUNTION_TIME;
    
    LOG_STEP_START(service);
    
    if (GET_SERVICE(MMDBPerformanceMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"MMDBPerformanceMgr init success");
    }
    
    if(GET_SERVICE(RsaCertMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"RsaCertMgr init success");
	if(GET_SERVICE(IDCHostMgr) != nil) // the 'if' part
	//the func--->MMDebug() begin called!
	MMDebug(@"IDCHostMgr init success");
    
	// init contactmgr.
	LOG_STEP_START(CContactMgr);
	CContactMgr *mgr = GET_SERVICE(CContactMgr);
	[mgr initDB:m_mainController.m_oMMDB lock:m_mainController.m_oLock];
	LOG_STEP_END(CContactMgr);
    
	LOG_STEP_START(CQQContactMgr);
	CQQContactMgr *qqmgr = GET_SERVICE(CQQContactMgr);
	[qqmgr initDB:m_mainController.m_oMMDB lock:m_mainController.m_oLock];
	LOG_STEP_END(CQQContactMgr);
	
	LOG_STEP_START(CBottleContactMgr);
	CBottleContactMgr *bottleContactMgr = GET_SERVICE(CBottleContactMgr);
	[bottleContactMgr initDB:m_mainController.m_oMMDB lock:m_mainController.m_oLock];
	LOG_STEP_END(CBottleContactMgr);
    
	LOG_STEP_START(CMessageMgr);
	CMessageMgr* oMsgMgr = GET_SERVICE(CMessageMgr);
	[oMsgMgr InitMsgMgr:m_mainController.m_oMMDB Lock:m_mainController.m_oLock];
	LOG_STEP_END(CMessageMgr);
    

    
    if(GET_SERVICE(FavoritesMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"FavoritesMgr init success");
    
    if(GET_SERVICE(CdnComMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"CdnComMgr init success");
    
    
    LOG_STEP_START(WCAudioSessionInit);
    if ([[WCAudioSession shareInstance] isOtherAudioPlaying] == NO)
    // the 'if' part
    {
        //the func--->WCAudioSessionInfo() begin called!
        WCAudioSessionInfo(@"invoke setActive.");
        [[WCAudioSession shareInstance] setActive:YES];
    }
    LOG_STEP_END(WCAudioSessionInit);
    
    [[WCAudioSessionLogic shareInstance] startLogic];
	
	// init audioreceiver
	LOG_STEP_START(AudioReceiver);
	AudioReceiver *audioReceiver = GET_SERVICE(AudioReceiver);
	[audioReceiver initFacade:m_mainController];
	LOG_STEP_END(AudioReceiver);
    
    LOG_STEP_START(other);
	
	// todo。 pre alloc obj. 临时处理。 有个bug：再contact回调中创建这个对象， 然后向contact注册， 然后破坏enum
	//id o =
	if(GET_SERVICE(MMHeadImageMgr) != nil) // the 'if' part
	//the func--->MMDebug() begin called!
	MMDebug(@"HeadImageMgr init success!");
    
    // not to late.
    if(GET_SERVICE(MMThemeManager) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"MMThemeManager init success");
    
	   
    if(GET_SERVICE(OnlineClientMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"OnlineClientMgr init success");
	
    if(GET_SERVICE(ShakeMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"ShakeMgr init success");
    
    if(GET_SERVICE(VOIPMessageMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"VOIPMessageMgr init success");
	
    if(GET_SERVICE(WXTalkPresentMgr)  != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"WXTalkPresentMgr init success");
    
    if(GET_SERVICE(TrackPresentMgr)  != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"TrackPresentMgr init success");
    
    LOG_STEP_START(WCFacade);
	if(GET_SERVICE(WCFacade) != nil) // the 'if' part
	//the func--->MMDebug() begin called!
	MMDebug(@"WCFacade init success");
	LOG_STEP_END(WCFacade);
    
    //new sync plugin mgr
    if(GET_SERVICE(NewSyncPluginMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"NewSyncPluginMgr init success");
    
    if(GET_SERVICE(CNetworkStatusMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"CNetworkStatusMgr init success");
    
    [GET_SERVICE(SysCallCheck) startCheck];
    
    [VOIPHelper EnableVoIPComLog];
    
	// init PushSystemMsgMgr to handle system-push-message
	if(GET_SERVICE(PushSystemMsgMgr) != nil) // the 'if' part
	//the func--->MMDebug() begin called!
	MMDebug(@"PushSystemMsgMgr init success");
    
    if(GET_SERVICE(DeletePathService) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"DeletePathService init success");
    if(GET_SERVICE(CleanCacheService) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"CleanCacheService init success");
    
    
    if(GET_SERVICE(WCPayLogicMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"weixin Pay Logic Init Success");
    
    if(GET_SERVICE(WCMallLogicMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"Mall Logic Init Success");
    
    if(GET_SERVICE(WCRedEnvelopesControlMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"RedEnvelopes Logic Init Success");
    
    if (GET_SERVICE(NewQQMailMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"NewQQMailMgr init success");
    
    if (GET_SERVICE(VoipUIManager) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"VoipUIManager init success");
    
    LOG_STEP_START(FTSFacade);
    if (GET_SERVICE(FTSFacade) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"FTSFacade init success");
    LOG_STEP_END(FTSFacade);
    
    if(GET_SERVICE(WCDeviceBrandMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"WCDeviceBrandMgr init success");
    
    if(GET_SERVICE(PublicWifiManager) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"PublicWifiManager init success");
    
    if(GET_SERVICE(WCBeaconGuideModeMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"WCBeaconGuideModeMgr init success");
    
    if(GET_SERVICE(WCBeaconUtilsMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"WCBeaconUtilsMgr init success");
    
    if(GET_SERVICE(WCBeaconTouchMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"WCBeaconTouchMgr init success");
    
    if (GET_SERVICE(TranslateMsgMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"TranslateMsgMgr init success");
    
    if (GET_SERVICE(MMEnterpriseBrandSessionMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"MMEnterpriseBrandSessionMgr init success");
    
    if (GET_SERVICE(EnterpriseBrandContactMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"EnterpriseBrandContactMgr init success");
    
    if(GET_SERVICE(TemplateMsgRecvMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"TemplateMsgRecvMgr init success");
//    if(GET_SERVICE(BrandSessionMgr) != nil) MMDebug(@"BrandSessionMgr init success");
    
    if (GET_SERVICE(MMLanguagePackageDownloadMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"MMLanguagePackageDownloadMgr init success");
    }
    
    if (GET_SERVICE(MMWCResourceMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"MMWCResourceMgr init success");
    }
    
    if (GET_SERVICE(CKVCommReportLogic) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"CKVCommReportLogic init success");
    }
    
    if (GET_SERVICE(MMKeychainManager) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"MMKeychainManager init success");
    }
    
    if (GET_SERVICE(MMLocationMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"MMLocationMgr init success");
    }
    
    if (GET_SERVICE(WCWatchNativeMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"WCWatchNativeMgr init success");
    
    if ([DeviceInfo isiOS8plus]) // the 'if' part
    {
        if (GET_SERVICE(MMShareExtMgr) != nil) // the 'if' part
        {
            //the func--->MMDebug() begin called!
            MMDebug(@"MMShareExtMgr init success");
        }
        
        if (GET_SERVICE(XOMgr) != nil) // the 'if' part
        {
            //the func--->MMDebug() begin called!
            MMDebug(@"XOMgr init success");
        }
    }
    
    if(GET_SERVICE(SvrErrorMgr) != nil)
    // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"SvrErrorMgr init Success");
    }
    
    if (GET_SERVICE(ShakeCardMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"ShakeCardMgr init success");
    }
    
    if (GET_SERVICE(WCTempChatMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"WCTempChatMgr init success");
    }
    
    if (GET_SERVICE(BrandServiceMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"BrandServiceMgr init success");
    }
    
    if (GET_SERVICE(BrandAttrMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"BrandAttrMgr init success");
    }

    if (GET_SERVICE(NewABTestMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"NewABTestMgr init success");
    }
    
    if (GET_SERVICE(NewABTestKeyMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"NewABTestKeyMgr init success");
    }
    
    if (GET_SERVICE(WCDBABTestExt) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"WCDBABTestExt init success");
    }

    if (GET_SERVICE(F2FMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"F2FMgr init success");
    }
    
    if (GET_SERVICE(WCAdvertiseLogMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"WCAdvertiseLogMgr init success");
    }
    
    if (GET_SERVICE(OutLinkHijackDetector) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"OutLinkHijackDetector init success");
    }
    
    if(GET_SERVICE(SendMassBrandSessionMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"SendMassBrandSessionMgr init success");
    if(GET_SERVICE(InteractiveBrandSessionMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"InteractiveBrandSessionMgr init success");
    if (GET_SERVICE(SendMassBrandMoreSessionMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"SendMassBrandMoreSessionMgr init success");
    }
    
    if(GET_SERVICE(MMResourceService) != nil)// the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"MMResourceService init success");
    }
    
    if (GET_SERVICE(MMFreeSpaceCheckMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"MMFreeSpaceCheckMgr init success");
    }
    
    if (GET_SERVICE(WCNearbyPullFeedMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"WCNearbyPullFeedMgr init success");
    }
    
    if (GET_SERVICE(EnterpriseMsgMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"EnterpriseMsgMgr init success");
    }
    
    if (GET_SERVICE(GameCenterMsgMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"GameCenterMsgMgr init success");
    }
    
    if(GET_SERVICE(BadRoomMgr) != nil)
    // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"BadRoomMgr init success");
    }
    
    if(GET_SERVICE(FunctionMsgMgr) != nil)
    // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"FunctionMsgMgr init success");
    }
    
    if (GET_SERVICE(WCDurationLogMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"WCDurationLogMgr init success");
    }
    
    if (GET_SERVICE(MMWebLocalStorageMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"MMWebLocalStorageMgr init success");
    }

    if (GET_SERVICE(MMDBRepairManager) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"MMDBRepairManager init success");
    }
    
    if (GET_SERVICE(WCGet3rdNetworkDataMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"WCGet3rdNetworkDataMgr init success");
    }

//#ifndef SPAY_HEVC_IMAGE
    if (GET_SERVICE(WCImageConvertMgr) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"WCImageConvertMgr init success");
    }
//#endif
    
    if(GET_SERVICE(WCNewClickStatMgr) != nil)// the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"WCNewClickStatMgr init success");
    }
    
    if (GET_SERVICE(WCSuspectedDBCorrupt) != nil) // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"WCSuspectedDBCorrupt init success");
    }
    
    [WXGLogMonitor sharedMonitor];
    LOG_STEP_END(other);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: clearServiceObject
 * Returning Type: void
 */ 
-(void) clearServiceObject
{
	// remove some services and clear resource
	[m_serviceCenter callClearData];
    
    [VOIPHelper DisableVoIPComLog];
}

#pragma mark -
#pragma mark Application lifecycle

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: logEssencialInfo
 * Returning Type: void
 */ 
-(void)logEssencialInfo {
	@autoreleasepool {
		NSMutableDictionary* essencialInfo = [NSMutableDictionary dictionary];
		[essencialInfo setObject:[GET_SERVICE(MMLanguageMgr) getCurLanguage] forKey:@"language"];
		[essencialInfo setObject:[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] forKey:@"locale"];
		
		//the func--->MMInfo() begin called!
		MMInfo(@"log essencial info:%@", essencialInfo);
	}
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: beforeMainLauching
 * Returning Type: void
 */ 
-(void) beforeMainLauching
{
    if (m_mainController != nil) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    LOG_FUNTION_TIME;
    
    // Override point for customization after application launch.
    
    [CUtility PrintClientInfo];
    
    //the func--->LOG_STEP_START() begin called!
    LOG_STEP_START(1);
    
    m_appObserverCenter = [[CAppObserverCenter alloc]init];
    
    m_uLastTimeResignActive = 0;
    m_tTotalRunningTime = 0;
    m_tLastActiveTime = time(NULL);
    
    [self logEssencialInfo];
    
    //the func--->LOG_STEP_END() begin called!
    LOG_STEP_END(1);
    
    ////
    //the func--->LOG_STEP_START() begin called!
    LOG_STEP_START(2);
    
    //加一个文件权限检查，防止用户在没有重启设备后，在没有输入设备pin码前就被voip或Background fetch拉起
    
    [self tryProtectLaunchBeforeDeviceFirstUnlock];
    
    [MMDatabaseRecoverMgr SetupMMDatabaseRecoverMgr];
    
    m_mainController = [[CMainControll alloc] init];
    m_uInitViewType = [m_mainController Start:m_appObserverCenter];
    
    //the func--->Objc2C_onCreate() begin called!
    Objc2C_onCreate();
    Objc2C_onForeground(true);
    g_bBackGround = NO;
    
    [[MMPatchMgr getInstance] registerExtension];
    
    //the func--->LOG_STEP_END() begin called!
    LOG_STEP_END(2);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: tryProtectLaunchBeforeDeviceFirstUnlock
 * Returning Type: void
 */ 
- (void)tryProtectLaunchBeforeDeviceFirstUnlock {
    BOOL isLaunchBeforeDeviceFirstUnlock = [CUtility isLaunchBeforeDeviceFirstUnlock];
    if (isLaunchBeforeDeviceFirstUnlock) // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"Keychain is not accessible now because of deivce is not first unlock. Must exit");
        //the func--->exit() begin called!
        exit(0);
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: continueMainLaunching:
 * Returning Type: void
 */ 
- (void)continueMainLaunching:(NSDictionary*)launchOptions
{
    LOG_FUNTION_TIME;
    
    // Override point for customization after application launch.
    
    // 这里才能执行脚本
    [[MMPatchMgr getInstance] loadAndExecutePatch];
    [[MMSafeModeMgr shareInstance] didEnterWeChat];
    
    // 这里需要比 initServiceObject 稍早一点
    [self registerLazyExtensionListener];
    
    [self registerClsMethodObserver];
    
    [self initServiceObject];
    
    //the func--->LOG_STEP_START() begin called!
    LOG_STEP_START(02);

    //register extension after service center init
    [[MMPerformanceDataReportMgr shareInstance] registerExtension];
    [GET_SERVICE(MMDBPerformanceMgr) registerExtension];

#ifndef CLEARTEST
    //主要为了清理自己生成的图片
    [THEME_MGR onFirstRun];
#endif
    
    if (m_appVerCompareWithLastRun != NSOrderedSame) // the 'if' part
    {
        // 检测到版本升级或降级
        [MMBaseSessionStorage processVersionUpdate];
        
        [self firstStartAfterUpgradeDowngrade];
        
        [self saveAppVersion];
    }
    //the func--->LOG_STEP_END() begin called!
    LOG_STEP_END(02);
    
	//the func--->LOG_STEP_START() begin called!
	LOG_STEP_START(3);
	m_appViewControllerMgr = [[CAppViewControllerManager alloc]initWithWindow:_window];
	
	//result  = VIEW_FIRST;
	[m_appViewControllerMgr openView:m_uInitViewType launchOptions:launchOptions isAppUpdated:m_appVerCompareWithLastRun == NSOrderedAscending];
    
	//the func--->LOG_STEP_END() begin called!
	LOG_STEP_END(3);
	
	//the func--->LOG_STEP_START() begin called!
	LOG_STEP_START(4);
	
    [GET_SERVICE(NotificationActionsMgr) registerNotification];
	
	[self safePerformSelector:@selector(doSendTokenTimeOut) withObject:nil afterDelay:APNS_ITMEOUT];
	
	//the func--->LOG_STEP_END() begin called!
	LOG_STEP_END(4);
	
	//the func--->LOG_STEP_START() begin called!
	LOG_STEP_START(5);
	
    // 5s后上报crash
    [[MMCrashReportHandler shareCrashReportHandler] safePerformSelector:@selector(tryCrashReportAfterRun) withObject:nil afterDelay:5.0];
    
    [CAppUtil addLocalMemoryWarningObserver:self selector:@selector(didReceiveLocalMemoryWarning:)];
    
    if (launchOptions) // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"launchOptions %@", launchOptions);
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSString *nsCmd = [userInfo objectForKey:@"cmd"];
        
        if (nsCmd != nil && [nsCmd hasPrefix:@PUSH_CMD_VOIP]) // the 'if' part
        {
            [VOIPHelper APNSPushWithUsrInfo:userInfo];
        } else // the 'else' part
        if (nsCmd != nil && [nsCmd hasPrefix:@PUSH_CMD_JD])// the 'if' part
        {
            [GET_SERVICE(WCJdBussinessMgr) handleBackgroundAPNSPushWithUsrInfo:userInfo];
        } else // the 'else' part
        if (nsCmd != nil && [nsCmd hasPrefix:@PUSH_CMD_URL])
        // the 'if' part
        {
            [GET_SERVICE(WCInnerJumpMgr) handleBackgroundAPNSPushWithUsrInfo:userInfo];
        }
        
        NSString* nsDeepLink = [userInfo objectForKey:@"jump"];
        if([nsDeepLink length] > 0)
        // the 'if' part
        {
            [self safePerformSelector:@selector(handleApnsDeepLink:) withObject:userInfo afterDelay:1];
        }
    }
    
    [self safePerformSelector:@selector(setUserAgent) withObject:nil afterDelay:5];
    
    //the func--->LOG_STEP_END() begin called!
    LOG_STEP_END(5);
#ifndef SPAY_MSG_ARCHIVE
    [CAppUtil updateMessageArchiveContactsMsg];
#endif
    NSInteger width = MMScreenWidthOri(UIInterfaceOrientationPortrait);
    NSInteger height = MMScreenHeightOri(UIInterfaceOrientationPortrait);
    BOOL isZoomed = NO;
    if (([DeviceInfo isiPhone6p] && [DeviceInfo is667hScreen]) || ([DeviceInfo isiPhone6] && [DeviceInfo is568hScreen]))
    // the 'if' part
    {
        isZoomed = YES;
    }
    NSString *logInfo =[ NSString stringWithFormat:@"%ld*%ld[%@]", (long)width, (long)height, isZoomed?@"zoomed":@"standard"];
    //the func--->LOG_FEATURE_EXT() begin called!
    LOG_FEATURE_EXT(11489, logInfo);
    
    
    //the func--->atexit() begin called!
    atexit(safeExitPublic);
    
    mInBackGroundFetch = NO;
    m_ui64BackGroundFetchStopTime = [CUtility genCurrentTimeInMs];
    
    // didFinishLaunching后面的逻辑
    [MMOOMCrashReport checkAndReport];
    [MMOOMCrashReport registerExtension];
    
#ifndef CLEARTEST
    [self monitorResource];
#endif
    if (![DeviceInfo isiPhone4] && ![DeviceInfo isiPhone3GS]) // the 'if' part
    {
        [self safePerformSelector:@selector(mainThreadMonitorStart) withObject:nil afterDelay:3.0f];
    }
    
    // 跟老板讨论过了，这玩意可以稍微延后
    [MMUrlCache shareCache];
    [HRHResistantURLCache cleanOldURLCache];
    
    // voip token
    self.m_voipTokenRetriveObject = [[VoIPTokenRetriveObject alloc] init];
    [self.m_voipTokenRetriveObject voipRegistration];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: mainThreadMonitorStart
 * Returning Type: void
 */ 
-(void)mainThreadMonitorStart
{
    [MMMonitorMgr shareInstance];
    [MMDumpReporterMgr shareInstance];
    
    //old file path
    CleanTaskInfo *taskInfo = [[CleanTaskInfo alloc] init];
    taskInfo.fileDirPath = [NSString stringWithFormat:@"%@/%@", [CUtility GetDocPath], @"Dump"];
    taskInfo.readWriteInterval = 7 * 24 * 60 * 60;  // 7 days
    [GET_SERVICE(CleanCacheService) addAutoCleanTask:taskInfo];
    
    //new file path
    CleanTaskInfo *newTaskInfo = [[CleanTaskInfo alloc] init];
    newTaskInfo.fileDirPath = [NSString stringWithFormat:@"%@/%@", [CUtility GetLibraryCachePath], @"Dump"];
    newTaskInfo.readWriteInterval = 7 * 24 * 60 *60;   //7 days
    [GET_SERVICE(CleanCacheService) addAutoCleanTask:newTaskInfo];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: monitorResource
 * Returning Type: void
 */ 
- (void)monitorResource {
    //默认开启资源监控
    //    m_resourceMonitor = [[ResourceMonitor alloc] init];
    //    m_resourceMonitor.delegate = self;
    //    [m_resourceMonitor startService];
    //    return ;
/*
    if ([SettingUtil getMainSettingExt].m_bMonitorMemory ||
        [SettingUtil getMainSettingExt].m_nMonitorResource) {
        
        [m_resourceLabel removeFromSuperview];
        SAFE_DELETE(m_resourceLabel);
        
        [m_changeValueLabel removeFromSuperview];
        SAFE_DELETE(m_changeValueLabel);
        
        SAFE_DELETE(m_resourceMonitor);
        SAFE_DELETE(m_resourceWindow);
        
        m_resourceLabel = [[MMUILabel alloc] initWithFrame:CGRectMake((MMMainWidth - RESOURCE_LABEL_WIDTH)/2.0 + 20, 0, RESOURCE_LABEL_WIDTH, RESOURCE_LABEL_HEIGTH)];
        m_resourceLabel.textColor = [UIColor whiteColor];
        m_resourceLabel.backgroundColor = [UIColor blackColor];
        m_resourceLabel.textAlignment = NSTextAlignmentLeft;
        m_resourceLabel.font = [UIFont systemFontOfSize:12];
        [m_resourceLabel removeFromSuperview];
        
        m_changeValueLabel = [[MMUILabel alloc] initWithFrame:CGRectMake(m_resourceLabel.right, m_resourceLabel.top, CHANGE_LABLE_WIDTH, CHANGE_LABEL_HEIGHT)];
        m_changeValueLabel.textColor = [UIColor whiteColor];
        m_changeValueLabel.backgroundColor = [UIColor blackColor];
        m_changeValueLabel.textAlignment = NSTextAlignmentLeft;
        m_changeValueLabel.font = [UIFont systemFontOfSize:12];
        [m_changeValueLabel removeFromSuperview];
        
        if (![DeviceInfo isiOS9plus]) {
            m_resourceWindow = [[MMUIWindow alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        } else {
            m_resourceWindow = [[MMUIWindow alloc] init];
        }
        m_resourceWindow.windowLevel = UIWindowLevelStatusBar + 2;
        [m_resourceWindow addSubview:m_resourceLabel];
        [m_resourceWindow addSubview:m_changeValueLabel];
        [m_resourceWindow makeKeyAndVisible];
    }
*/
#ifndef CLEARTEST
    m_resourceMonitor = [[ResourceMonitor alloc] init];
    m_resourceMonitor.delegate = self;
    [m_resourceMonitor startService];
#endif
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: mainUISetting
 * Returning Type: void
 */ 
-(void) mainUISetting
{
    [ UiUtil setStatusBarFontWhite ] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    
    LOG_STEP_START(supportIOS5)
    
    CGFloat fontSize = 16.0f;
    
    // 自定义 SearchBar 背景
    [[UISearchBar appearance] setBarTintColor:MCOLORX(@"#base_fontbtn",@"text_color")] ;
    [[UISearchBar appearance] setTintColor:MCOLORX(@"#base_fontbtn",@"text_color")] ;
    [[UISearchBar appearance] setBackgroundImage:MIMAGEX(@"#widget_searchbar",@"cell_image") forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault] ;
     [[UISearchBar appearance] setBackgroundImage:MIMAGEX(@"#widget_searchbar",@"cell_image") forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefaultPrompt] ;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationController class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             MCOLORX(@"#widget_searchbar",@"text_cancel_color"), NSForegroundColorAttributeName,
                             [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationController class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             MCOLORX(@"#widget_searchbar",@"text_cancel_color"), NSForegroundColorAttributeName,
                             [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], NSForegroundColorAttributeName, nil] forState:UIControlStateHighlighted];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             MCOLOR( @"navigator_btn_text_color" ), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             MCOLOR( @"navigator_btn_text_highlight_color" ), NSForegroundColorAttributeName, nil] forState:UIControlStateHighlighted];
    [[UINavigationBar appearanceWhenContainedIn:[UIImagePickerController class], nil] setTintColor:[UIColor whiteColor]];
    //        [[UINavigationBar appearanceWhenContainedIn:[UIImagePickerController class], nil] setBackIndicatorImage:[MMUICommonUtil getBarButtonBackgroundImage:BarButtonStyleBack]];
    //        [[UINavigationBar appearanceWhenContainedIn:[UIImagePickerController class], nil] setBackIndicatorTransitionMaskImage:[MMUICommonUtil getBarButtonBackgroundImage:BarButtonStyleBack]];
    UIOffset offset ;
    offset.horizontal = 5 ;
    offset.vertical = 0 ;
    [[UISearchBar appearance] setSearchTextPositionAdjustment : offset ] ;
    
    [[UISearchBar appearance] setSearchFieldBackgroundImage:MIMAGEX(@"#widget_searchbar",@"textfield_image") forState:UIControlStateNormal] ;
    
    // 自定义 NavigationBar 背景
    //if (KIT_INT(WTStyle) == 2){
        [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    /*}else{
        //ios7 设纯色背景
        [[UINavigationBar appearance] setBarTintColor:MCOLOR(@"navigator_background_color")];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }*/
    fontSize = 16.0f;
    

    
    {
        /*
         UIImage * barButtonBkg = [MIMAGE(@"BarButton_gray.png") stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
         UIImage *barButtonBkgHL = [MIMAGE_HL(@"BarButton_gray.png") stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
         UIImage *barButtonBkgDisable = [MIMAGE_DISABLE(@"BarButton_gray.png") stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
         [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:barButtonBkg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
         [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:barButtonBkgHL forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
         [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:barButtonBkgDisable forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
         
         */
    }
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      MCOLOR( @"navigator_btn_text_color" ), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:fontSize], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      MCOLOR( @"navigator_btn_text_highlight_color" ), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:fontSize], NSFontAttributeName, nil] forState:UIControlStateHighlighted];
    
    NSShadow * shadow = [[ NSShadow alloc ] init ] ;
    shadow.shadowOffset = CGSizeMake( 1 , 1 ) ;
    shadow.shadowColor = MCOLOR( @"navigator_title_shadow_color") ;

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MCOLOR( @"navigator_btn_text_color" ),NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSShadowAttributeName:shadow } ] ;
    
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor] ] ;
    
	LOG_STEP_END(supportIOS5)
    
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didFinishLaunchingWithOptions:
 * Returning Type: BOOL
 */ 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 函数置换，用于解决头痛的crash
    [NSObject switchSomeCriticalMethod];
    
    if (application.applicationState != UIApplicationStateBackground) // the 'if' part
    {
        m_isFirstLaunching = YES;
        // WatchDog开始监控
        [MMWatchDogMonitor beginMonitor];
    } else // the 'else' part
    {
        // 判断超时的前提是连续N次state不等于background
        [MMWatchDogMonitor clearFlag];
    }
    
    // 设置MMCommon的回调delegate
    [self setupMMCommonAdapter];
    
    MMInfo(@"<!WXG!>didFinishLaunchingWithOptions %p, state %ld, options %@", application, application.applicationState, launchOptions);
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // iConsoleWindow中有设备接入逻辑，不能屏蔽
    if ([DeviceInfo isiOS9plus] && [DeviceInfo isiPad]) // the 'if' part
    {
        //iOS 9使用alloc init，系统帮我们初始化window到正确的大小
        _window = [[iConsoleWindow alloc] init];
    } else // the 'else' part
    {
        if ([DeviceInfo isiPad] && [DeviceInfo isiOS8plus])
        // the 'if' part
        {
            _window = [[ iConsoleWindow alloc ] initWithFrame:MMScreenBounds];
        }
        else
        // the 'else' part
        {
            _window = [[ iConsoleWindow alloc ] initWithFrame:MMScreenBoundsOri(UIInterfaceOrientationPortrait) ] ;
        }
    }
    [_window setWindowLevel:UIWindowLevelNormal];
	_window.backgroundColor = [UIColor clearColor];
    [_window makeKeyAndVisible];
    
    //预加载键盘
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
	
    //苹果的目录控制，要将旧数据迁移
	[self RenamePath];
    [self detectAppFirstRunOrFirstRunAfterUpgrade];
    
    [THEME_MGR reloadThemeList];
    [THEME_MGR loadUserPreferedTheme];
    [self mainUISetting];
    
    self.mActiveLock = [[NSRecursiveLock alloc] init];
    
    // init service center.
    if (m_serviceCenter == nil) // the 'if' part
    {
        m_serviceCenter = [[MMServiceCenter alloc] init];
    }
    
    // enable crash reporter
    [[MMCrashReportHandler shareCrashReportHandler] enableCrashReportHandler];
    
	if ([self shouldEnterSafeMode] == NO) // the 'if' part
	{
        START_LOG_PERFORMANCE(ePERFORMANCE_DATA_TYPE_TIME | ePERFORMANCE_DATA_TYPE_MEMORY, eCASEID_STARTUP);
        
        LOG_FUNTION_TIME;
        
        LOG_STEP_START(didFinishLaunchingWithOptions);
        LOG_STEP_NEED_REPORT(didFinishLaunchingWithOptions, 5);

        [self beforeMainLauching];
        [self continueMainLaunching:launchOptions];
        
        PM_LOG_DETAIL_INFO(eSTATE_LAUNCH_FINISH);
        
        LOG_STEP_END(didFinishLaunchingWithOptions);
        
        END_LOG_PERFORMANCE(ePERFORMANCE_DATA_TYPE_TIME | ePERFORMANCE_DATA_TYPE_MEMORY, eCASEID_STARTUP);
	}
    
#ifdef OPEN_COVERAGE
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    #ifdef VERSION_REV
        NSString *newDir = [NSString stringWithFormat:@"%@/covdata/%@",documentsDirectory,VERSION_REV];
    #else
        NSString *newDir = [NSString stringWithFormat:@"%@/covdata/unkownrev",documentsDirectory];
    #endif
    setenv("GCOV_PREFIX", [newDir cStringUsingEncoding:NSUTF8StringEncoding], 1);
    setenv("GCOV_PREFIX_STRIP", "9", 1);
    
    [[testFlush alloc] init];
#endif
    
    for (UIWindow *window in [UIApplication sharedApplication].windows)
    {
        if (window.rootViewController == nil)
        {
            MMError(@"Window without rootViewController:%@", window);
        }
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(pasteboardChangedNotification:)
     name:UIPasteboardChangedNotification
     object:[UIPasteboard generalPasteboard]];
    
    if (m_isFirstLaunching) // the 'if' part
    {
        // 如果是正常启动，那理论上会进入didBecomeActive
        [[MMSafeModeMgr shareInstance] reportDataWithKey:8 value:1];
    }
    
    [WWKApi registerApp:@"weixin"];
    
    MMInfo(@"<!WXG!>didFinishLaunchingWithOptions end, state %ld", application.applicationState);
    
    //the return stmt
    return YES;
}

#pragma mark apns
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: doSendToken:error:
 * Returning Type: void
 */ 
- (void) doSendToken:(NSString *)nsToken error:(BOOL)bError{
	
	[NSObject safeCancelPreviousPerformRequestsWithTarget:self selector:@selector(doSendTokenTimeOut) object:nil];
	
    //the func--->KernWarning() begin called!
    KernWarning(@"send token %@ error %u", nsToken, bError);
    
	UInt32 uiStatus = 0;//0表示正常
	NSString *nsTempToken = nil;
	
	//apple返回token不为空 则替换本地token
	if(nsToken != nil && nsToken.length != 0)// the 'if' part
	{
		self.m_nsToken = nsToken;
		
		[SettingUtil getLocalInfo].m_nsLastApnsToken = nsToken;
        [GET_SERVICE(AccountStorageMgr) SaveLocalInfo:YES];
		
		nsTempToken = nsToken;
	}
	else // the 'else' part
	if(m_nsToken != nil && m_nsToken.length != 0)
	// the 'if' part
	{
		uiStatus = 2;
		nsTempToken = m_nsToken;
	}
	else // the 'else' part
	if( [SettingUtil getLocalInfo].m_nsLastApnsToken != nil && [SettingUtil getLocalInfo].m_nsLastApnsToken.length != 0 )
	// the 'if' part
	{
		uiStatus = 1;
		nsTempToken = [SettingUtil getLocalInfo].m_nsLastApnsToken  ;
	}
	
	if( nsTempToken ==  nil || nsTempToken.length == 0 )
	// the 'if' part
	{
		//the func--->KernError() begin called!
		KernError(@"invalid token");
		//the return stmt
		return ;
	}
	
    //默认新音效:由于后台历史原因,register时,音效文件名不能大于6个字符,因此只能采取数字式命名节约字符空间
	self.m_nsSound = @"in.caf";
	self.m_nsVoipSound = DEFAULT_VOIP_PUSH_SOUND;
    
	//Upload the deviceToken and sound file
	[m_mainController SendToken:nsTempToken Status:uiStatus Sound:m_nsSound VoipSound:m_nsVoipSound];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: doSendTokenTimeOut
 * Returning Type: void
 */ 
- (void) doSendTokenTimeOut{
    //the func--->MMError() begin called!
    MMError(@"token error time out");
    kvCommImportantReport(11867, @"timeout,2", false);
	[self doSendToken:nil error:YES];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didRegisterUserNotificationSettings:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //the func--->MMInfo() begin called!
    MMInfo(@"didRegisterUserNotificationSettings bundleID[%@]", [NSBundle mainBundle].bundleIdentifier);
    // debug版只有在使用wc/wx证书时才注册token。正式版的com.tencent.xin因为公司不提供debug的push证书，先不注册。
#ifdef DEBUG
    if ([[NSBundle mainBundle].bundleIdentifier hasPrefix:@"com.tencent.wc.xin"] || [[NSBundle mainBundle].bundleIdentifier hasPrefix:@"com.tencent.wx"])
#endif
    {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

// one of these will be called after calling -registerForRemoteNotifications
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didRegisterForRemoteNotificationsWithDeviceToken:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // debug版只有在使用wc/wx证书时才注册token。正式版的com.tencent.xin因为公司不提供debug的push证书，先不注册。
    //the func--->MMInfo() begin called!
    MMInfo(@"didRegisterForRemoteNotificationsWithDeviceToken token[%@]", deviceToken);
#ifdef DEBUG
	if ([[NSBundle mainBundle].bundleIdentifier hasPrefix:@"com.tencent.wc.xin"] || [[NSBundle mainBundle].bundleIdentifier hasPrefix:@"com.tencent.wx"])
#endif
    {
        NSString *nsToken = [[NSString alloc]initWithFormat:@"%@",deviceToken];
        [self doSendToken:nsToken error:NO];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didFailToRegisterForRemoteNotificationsWithError:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSString* nsErrorDesc = [error description];
    if([nsErrorDesc length] > 0)
    // the 'if' part
    {
        NSMutableString* nsTemp = [NSMutableString stringWithString:nsErrorDesc];
        [nsTemp replaceOccurrencesOfString:@"," withString:@" " options:NSLiteralSearch range://the func--->NSMakeRange() begin called!
        NSMakeRange(0, [nsTemp length])];
        [nsTemp appendString:@",1"];
        //11867
        kvCommImportantReport(11867, nsTemp, false);
    }
    //the func--->MMError() begin called!
    MMError(@"token error %@", error);
	[self doSendToken:nil error:YES];
}

#define REMOTENOTIFYINTERVALMIN 1

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: jumpToChatWhenReceivePush:remotePush:
 * Returning Type: void
 */ 
- (void)jumpToChatWhenReceivePush:(NSDictionary *)userInfo remotePush:(BOOL)bRemotePush{
    
    //the return stmt
    return;
    
    UIApplication *app = [UIApplication sharedApplication];
    
    if(![app respondsToSelector:@selector(applicationState)])// the 'if' part
    {
        //the return stmt
        return;
    }
    
    if(m_uLastTimeResignActive == 0)// the 'if' part
    {
        //the return stmt
        return;
    }
    
    UInt32 uTime = (UInt32)//the func--->time() begin called!
    time(NULL);
    
    //从界面resignActive到ReceiveRemoteNotification 超过1秒才视为时通过push进来程序
    //防止其他app弹apns的误操作  因为此时app 会从inactive到active的转换过程
    UInt32 uInterval = (uTime > m_uLastTimeResignActive)?uTime - m_uLastTimeResignActive:0;
    
    m_uLastTimeResignActive = 0;
    
    if(uInterval < REMOTENOTIFYINTERVALMIN || app.applicationState != UIApplicationStateInactive)// the 'if' part
    {
        //the return stmt
        return;
    }
    
    // 从APNS进来，跳到相应的聊天界面
    NSString* nsUsrName = [userInfo objectForKey:@"u"];
    
    //the func--->KernDebug() begin called!
    KernDebug(@"Notification Push UsrName:%@; Remote:%d", //the func--->GeneratePrivacyString() begin called!
    GeneratePrivacyString(nsUsrName),bRemotePush);
    
    if (nsUsrName == nil || [nsUsrName length] == 0) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    CContact* oContact = [GET_SERVICE(CContactMgr) getContactByName:nsUsrName];
    
    if (oContact != nil && !([GET_SERVICE(MMNewSessionMgr) IsActiveUser:nsUsrName])) // the 'if' part
    {
        
        [[CAppViewControllerManager getAppViewControllerManager] newMessageByContact:oContact msgWrapToAdd:nil];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: handleApnsDeepLink:
 * Returning Type: void
 */ 
-(void) handleApnsDeepLink:(NSDictionary *)userInfo
{
    //the func--->MMInfo() begin called!
    MMInfo(@"handleApnsDeepLink %@", userInfo);
    NSString* nsDeepLink = [userInfo objectForKey:@"jump"];
    if([nsDeepLink length] > 0)
    // the 'if' part
    {
        if (![CAppViewControllerManager hasEnterWechatMain])
        // the 'if' part
        {
            //the func--->MMInfo() begin called!
            MMInfo(@"not enter main");
            //the return stmt
            return;
        }
        
        UInt32 uiBitset = [GET_SERVICE(MMConfigMgr) uintFromDynamicConfigForKey:@MXM_DynaCfg_AV_Item_Key_WakenPushDeepLinkBitSet];
        //the func--->MMInfo() begin called!
        MMInfo(@"uiBitset %u", (uint32_t)uiBitset);
        //判断是否是升级deeplink
        if(![nsDeepLink isEqualToString:@"weixin://dl/update_newest_version"])
        // the 'if' part
        {
            if (![WCDeepLinkHandler isDeepLink:nsDeepLink])
            // the 'if' part
            {
                //the return stmt
                return;
            }
            
            DeepLinkDef* dlDef = [WCDeepLinkHandler deepLinkByUrl:nsDeepLink];
            if((dlDef.dlBitset.bitValue & uiBitset) == 0)
            // the 'if' part
            {
                //the return stmt
                return;
            }
            [[CAppViewControllerManager getAppViewControllerManager] moveToRootViewController];
            [WCDeepLinkHandler jumpDeepLink:dlDef];
        }
        else
        // the 'else' part
        {
            NSDictionary* dicAps = [userInfo objectForKey:@"aps"];
            if(dicAps == nil)
            // the 'if' part
            {
                //the return stmt
                return;
            }
            NSString* nsMessage = [dicAps objectForKey:@"alert"];
            if([nsMessage length] == 0)
            // the 'if' part
            {
                //the return stmt
                return;
            }
            UIAlertView* alertView = [CControlUtil showAlertEx:LOCALSTR(@"Update_Tip_Title") message:nsMessage delegate:self cancelButtonTitle:LOCALSTR(@"Update_Tip_Later") otherButtonTitle:LOCALSTR(@"Update_Tip_Update")];
            alertView.tag = DL_ALERT_VIEW_TAG;
        }
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didReceiveRemoteNotification:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    LOG_FUNTION_TIME;
    
    NSString* nsDeepLink = [userInfo objectForKey:@"jump"];
    //在前台不应该处理deeplink
    if(!m_isActive && [nsDeepLink length] > 0)
    // the 'if' part
    {
        if (![CAppViewControllerManager hasEnterWechatMain])
        // the 'if' part
        {
            //the return stmt
            return;
        }
        [self handleApnsDeepLink:userInfo];
        //the return stmt
        return;
    }
    
    if(![CAppUtil isLogin])// the 'if' part
    {
        //the return stmt
        return;
    }
    
	//when running  receive the push info
	//NSString *nsMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
	//the func--->KernDebug() begin called!
	KernDebug(@"ReceiveRemoteNotification: push info:%@",[userInfo objectForKey:@"aps"]);
    
    UIApplication *app = [UIApplication sharedApplication];
	
	NSString *nsCmd = [userInfo objectForKey:@"cmd"];
	if (nsCmd != nil && [nsCmd hasPrefix:@PUSH_CMD_VOIP]) // the 'if' part
	{
		[VOIPHelper APNSPushWithUsrInfo:userInfo];
	}
    else // the 'else' part
    if (nsCmd != nil && [nsCmd hasPrefix:@PUSH_CMD_JD])
    // the 'if' part
    {
        [GET_SERVICE(WCJdBussinessMgr) handleInactiveAPNSPushWithUsrInfo:userInfo];
    }
    else // the 'else' part
    if (nsCmd != nil && [nsCmd hasPrefix:@PUSH_CMD_URL])
    // the 'if' part
    {
        [GET_SERVICE(WCInnerJumpMgr) handleInactiveAPNSPushWithUsrInfo:userInfo];
    }
    else
    // the 'else' part
    {
		if([app respondsToSelector:@selector(applicationState)])
        // the 'if' part
        {
            if(app.applicationState == UIApplicationStateActive)
            // the 'if' part
            {
                [GET_SERVICE(NewSyncService) ApnsNotifySync];
            }
        }
        
        //Apns进来，非voip 跳到相应的聊天界面
        [self jumpToChatWhenReceivePush:userInfo remotePush:YES];
	}
    
	NSString *nsMsgType = [userInfo objectForKey:@"m"];
	NSString *nsFromUserName = [userInfo objectForKey:@"u"];
    NSString *log_ext = [NSString stringWithFormat:@"%@,%@,%@", nsMsgType, nsFromUserName, @"0"];
    //the func--->LOG_FEATURE_EXT() begin called!
    LOG_FEATURE_EXT(10889, log_ext)
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didReceiveLocalNotification:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{    
    if ([m_appViewControllerMgr checkResentFailMsg:notification isFromLaunch:NO])
    // the 'if' part
    {
        //the return stmt
        return;
    }
    
    if(![CAppUtil isLogin])// the 'if' part
    {
        //the return stmt
        return;
    }
    
    [GET_SERVICE(NotificationActionsMgr) handleReceiveLocalNotification:notification];
    
    NSString* cmd = [notification.userInfo stringForKey:@"cmd"];
    if ([cmd isEqualToString:@PUSH_CMD_JD]) // the 'if' part
    {
        [GET_SERVICE(WCJdBussinessMgr) handleLocalPushWithUsrInfo:notification.userInfo];
    } else // the 'else' part
    if ([cmd isEqualToString:@PUSH_CMD_URL])
    // the 'if' part
    {
        [GET_SERVICE(WCInnerJumpMgr) handleLocalPushWithUsrInfo:notification.userInfo];
    }
    
    // 从Local Apns进来，跳到相应的聊天界面
    [self jumpToChatWhenReceivePush:notification.userInfo remotePush:NO];
	NSString *nsMsgType = [notification.userInfo objectForKey:@"m"];
	NSString *nsFromUserName = [notification.userInfo objectForKey:@"u"];
    NSString *log_ext = [NSString stringWithFormat:@"%@,%@,%@", nsMsgType, nsFromUserName, @"1"];
    //the func--->LOG_FEATURE_EXT() begin called!
    LOG_FEATURE_EXT(10889, log_ext)
}

#pragma mark - background fetch
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:performFetchWithCompletionHandler:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    MMInfo(@"<!WXG!>performFetchWithCompletionHandler %ld remain time %f", application.applicationState, application.backgroundTimeRemaining);
    
    // backgroundFetch停掉watchDog监控
    [MMWatchDogMonitor clearFlag];
    
    mInBackGroundFetch = YES;
    //收到back ground fetch的时候要停掉耗时打点，以免采样道德耗时有误
    if (application.applicationState != UIApplicationStateActive) // the 'if' part
    {
        MMPerformanceDataReportMgr *mgr = [MMPerformanceDataReportMgr shareInstance];
        [mgr stop];
        
        [GET_SERVICE(MMDBPerformanceMgr) OnApplicationBackgroundFetch];
    }
    
    if(![CAppUtil isLogin] || m_fetchCompletionHandler != nil || ![GET_SERVICE(CNetworkStatus) isOnWifi])

    // the 'if' part
    {
        BOOL bLogin = [CAppUtil isLogin];
        BOOL bFetch = (m_fetchCompletionHandler != nil);
        BOOL bIsWifi = [GET_SERVICE(CNetworkStatus) isOnWifi];
        //the func--->MMInfo() begin called!
        MMInfo(@"not fetch bLogin %u bFetch %u bIsWifi %u", bLogin, bFetch, bIsWifi);
        mInBackGroundFetch = NO;
        m_ui64BackGroundFetchStopTime = [CUtility genCurrentTimeInMs];
        completionHandler(UIBackgroundFetchResultNewData);
        //the return stmt
        return;
    }
    
    //发现如果打开一个web页面后,退到后台,这时做backgroundfetch可能会导致crash,所以只保证在四大Tab界面的时候才backgroundfetch
    BOOL bInFourTab = YES;
    UINavigationController* currentViewController = [CAppViewControllerManager getCurrentNavigationController];
    if(currentViewController != nil)
    // the 'if' part
    {
        if([[currentViewController viewControllers] count] >= 2 || [currentViewController presentedViewController] != nil)
        // the 'if' part
        {
            bInFourTab = NO;
        }
    }
    else
    // the 'else' part
    {
        bInFourTab = NO;
    }
    if(!bInFourTab)
    // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"not in four tab");
        mInBackGroundFetch = NO;
        m_ui64BackGroundFetchStopTime = [CUtility genCurrentTimeInMs];
        completionHandler(UIBackgroundFetchResultNewData);
        //the return stmt
        return;
    }
    
    BOOL bSync = [GET_SERVICE(NewSyncService) BackGroundFetchToSync];
    //the func--->MMInfo() begin called!
    MMInfo(@"create sync %u", bSync);
    if(!bSync)
    // the 'if' part
    {
        mInBackGroundFetch = NO;
        m_ui64BackGroundFetchStopTime = [CUtility genCurrentTimeInMs];
        completionHandler(UIBackgroundFetchResultNewData);
        //the return stmt
        return;
    }
    else
    // the 'else' part
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@NOTIFICATION_NAME_FETCH_SYNC_DONE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClearBackGroundFetch) name:@NOTIFICATION_NAME_FETCH_SYNC_DONE object:nil];
        m_fetchCompletionHandler = [completionHandler copy];
        [self performSelector:@selector(ClearBackGroundFetch) withObject:nil afterDelay:25];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:handleActionWithIdentifier:forLocalNotification:completionHandler:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    //the func--->MMInfo() begin called!
    MMInfo(@"handle local action:%@ notification:%@", identifier, notification);
    
    [GET_SERVICE(NotificationActionsMgr) handleLocalActionWithIdentifier:identifier forUserInfo:notification.userInfo withResponseInfo:nil completionHandler:completionHandler];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler
{
    //the func--->MMInfo() begin called!
    MMInfo(@"handle local action:%@ notification:%@ responseInfo: %@", identifier, notification, responseInfo);
    
    [GET_SERVICE(NotificationActionsMgr) handleLocalActionWithIdentifier:identifier forUserInfo:notification.userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:handleActionWithIdentifier:forRemoteNotification:completionHandler:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //the func--->MMInfo() begin called!
    MMInfo(@"handle remote action:%@ notification:%@", identifier, userInfo);
    
    [GET_SERVICE(NotificationActionsMgr) handleRemoteActionWithIdentifier:identifier forUserInfo:userInfo withResponseInfo:nil completionHandler:completionHandler];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:handleActionWithIdentifier:forRemoteNotification:withResponseInfo:completionHandler:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    //the func--->MMInfo() begin called!
    MMInfo(@"handle remote action:%@ notification:%@ responseInfo: %@", identifier, userInfo, responseInfo);
    
    [GET_SERVICE(NotificationActionsMgr) handleRemoteActionWithIdentifier:identifier forUserInfo:userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
}


/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: ClearBackGroundFetch
 * Returning Type: void
 */ 
-(void) ClearBackGroundFetch
{
    //the func--->MMInfo() begin called!
    MMInfo(@"ClearBackGroundFetch");
    mInBackGroundFetch = NO;
    m_ui64BackGroundFetchStopTime = [CUtility genCurrentTimeInMs];
    if(m_fetchCompletionHandler != nil)
    // the 'if' part
    {
        m_fetchCompletionHandler(UIBackgroundFetchResultNewData);
        SAFE_DELETE(m_fetchCompletionHandler);
        //the func--->MMInfo() begin called!
        MMInfo(@"ClearBackGroundFetch done");
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: getMainWindowWidth
 * Returning Type: CGFloat
 */ 
-(CGFloat) getMainWindowWidth
{
    CGFloat width = _window.width;
    //the return stmt
    return width;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: getMainWindowHeight
 * Returning Type: CGFloat
 */ 
-(CGFloat) getMainWindowHeight
{
    CGFloat height = _window.height;
    //the return stmt
    return height;
}

#pragma mark background URLSession

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:handleEventsForBackgroundURLSession:completionHandler:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    //the func--->MMInfo() begin called!
    MMInfo(@"######## handle event for background url session:%@ #######", identifier);
    
    NSString *timelineBackgroundIdPrefix = [MMExtensionShareDataUtil getTimelineBackgroundURLSessionIdentifierPrefix];
    if ([identifier hasPrefix:timelineBackgroundIdPrefix]) // the 'if' part
    {
        [GET_SERVICE(MMShareExtMgr) handleTimelineUploadTaskWithURLSessionID:identifier completionHandler:completionHandler];
        //the return stmt
        return;
    }
    
    NSString *messageBackgroundIdPrefix = [MMExtensionShareDataUtil getMessageBackgroundURLSessionIdentifierPrefix];
    if ([identifier hasPrefix:messageBackgroundIdPrefix]) // the 'if' part
    {
        [GET_SERVICE(MMShareExtMgr) handleMessageUploadTaskWithURLSessionID:identifier completionHandler:completionHandler];
        //the return stmt
        return;
    }
}

#pragma mark interruptions

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: resetBadge
 * Returning Type: void
 */ 
- (void)resetBadge{
	
	NSInteger badgeNum = [m_appViewControllerMgr getTotalUnReadCount];
	
	if([UIApplication sharedApplication].applicationIconBadgeNumber != badgeNum)// the 'if' part
	{
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum];
	}
	
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: applicationWillResignActive:
 * Returning Type: void
 */ 
- (void)applicationWillResignActive:(UIApplication *)application {
    
    [self setInBackground:YES];
    
    m_isActive = NO;
    
	m_uLastTimeResignActive = (UInt32)time(NULL);
	
    MMInfo(@"<!WXG!>applicationWillResignActive %u", (uint32_t)m_uLastTimeResignActive);
	
	//Notification Center
	[[NSNotificationCenter defaultCenter] postNotificationName:MMApplicationWillResignActiveNotification object:self userInfo:nil];
    
	//重置app badge
	[self resetBadge];
    
//	[self prepareBlurMultiTaskingScreenshot];
	
    TRACK_ALL_RUN_TIME;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: applicationDidEnterBackground:
 * Returning Type: void
 */ 
- (void)applicationDidEnterBackground:(UIApplication *)application {
    MMInfo(@"<!WXG!>applicationDidEnterBackground %f", application.backgroundTimeRemaining);
    PM_LOG_DETAIL_INFO(eSTATE_ENTER_BACKGROUND);
    
#ifndef SPAY_FORCE_TOUCH
    [self setupForShortcut]; // 放在退后台之后有些时机其实就不太必要了
#endif
    [GET_SERVICE(AppleSearchMgr) indexActivities];
    
    m_isActive = NO;
	// check runingtime
	time_t uDelta = time(NULL) - m_tLastActiveTime;
	if (uDelta > 0)
	// the 'if' part
	{
		m_tTotalRunningTime += uDelta;
	}
	
	if (m_tTotalRunningTime > 60 * 60 * MAX_RUNNING_HOURS)
	// the 'if' part
	{
		// run Terminate
        //the func--->MMInfo() begin called!
        MMInfo(@"m_tTotalRunningTime > 60 * 60 * MAX_RUNNING_HOURS ");
		[self applicationWillTerminate:application];
		
		//the func--->exit() begin called!
		exit(0);
		//the return stmt
		return;
	}
	
	// callEnterBackground for service center
	[m_serviceCenter callEnterBackground];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MMApplicationDidEnterBackground object:self userInfo:nil];
	
//	[self showBlurMultiTaskingScreenshot];
	
	[BackgroundTask run];
    
    // 初始化卡顿监控，监控从suspend恢复：enterforeground到becomeactive的卡顿
    [MMB2FDumpMgr shareInstance];
    
    Objc2C_onForeground(false);
    g_bBackGround = YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: applicationProtectedDataWillBecomeUnavailable:
 * Returning Type: void
 */ 
-(void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
	//the func--->MMInfo() begin called!
	MMInfo(@"protected data will be Unavailable");
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: applicationProtectedDataDidBecomeAvailable:
 * Returning Type: void
 */ 
-(void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
	//the func--->MMInfo() begin called!
	MMInfo(@"protected data has been Available");
}

#define OPENPUSHTIP_INTRENAL (24 * 60 * 60)

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: handleOpenPush
 * Returning Type: void
 */ 
- (void) handleOpenPush{
    UInt32 type = [CAppUtil GetEnabledNotificationType];
	UInt32 uTime = [CAppUtil genCurrentTime];
	UInt32 uLastTime = [SettingUtil getMainSetting].m_uiLastTimeOfNotifyOpenPush;
	NSString *nsUsrName = [SettingUtil getMainSetting].m_nsUsrName;
    BOOL bNoShow = [SettingUtil getMainSettingExt].m_bNoShowPushTip;
    if(bNoShow)
    // the 'if' part
    {
        //the return stmt
        return;
    }
	
    if( (type == MMNotificationTypeNone || (type & MMNotificationTypeBadge) == 0) && nsUsrName != nil && nsUsrName.length > 0 &&
       (uLastTime == 0 || uTime < uLastTime || uTime - uLastTime > OPENPUSHTIP_INTRENAL))// the 'if' part
       {
        [SettingUtil getMainSetting].m_uiLastTimeOfNotifyOpenPush = uTime;
        [GET_SERVICE(AccountStorageMgr) MainThreadSaveSetting];
        NSString* nsMessage = NSLocalizedString(@"Util_OpenPushMsg",@"Util_OpenPushMsg");
        if(type == MMNotificationTypeNone)
        // the 'if' part
        {
            
        }
        else // the 'else' part
        if((type & MMNotificationTypeBadge) == 0)
        // the 'if' part
        {
            nsMessage = //the func--->LOCALSTR() begin called!
            LOCALSTR(@"Util_OpenPushTag");
        }

        UIAlertView* alert = [CControlUtil showAlertEx:nil
                                               message:nsMessage
                                              delegate:self cancelButtonTitle:LOCALSTR(@"Util_NeverShow") otherButtonTitle:LOCALSTR(@"Common_Confirm")];
        alert.tag = ALERT_VIEW_PUSH_TIP;
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: applicationWillEnterForeground:
 * Returning Type: void
 */ 
- (void)applicationWillEnterForeground:(UIApplication *)application {
	//the func--->MMInfo() begin called!
	MMInfo(@"applicationWillEnterForeground");
    PM_LOG_DETAIL_INFO(eSTATE_ENTER_FOREGROUND);
    
    //        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [MMLocalNotificationUtil cancelAllNotReservedLocalNotifications];
    
	CNetworkStatusMgr *oNetworkStatusMgr = GET_SERVICE(CNetworkStatusMgr);
	[oNetworkStatusMgr setReadToGettingData];
	
	//notify user open the push notification if closed by user
	[self handleOpenPush];
    
#ifndef SPAY_MSG_ARCHIVE
    [CAppUtil updateMessageArchiveContactsMsg];
#endif
    // callEnterForeground for service center
	[m_serviceCenter callEnterForeground];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:MMApplicationWillEnterForeground object:self userInfo:nil];
	
//	[self hideBlurMultiTaskingScreenshot];
	
    Objc2C_onForeground(true);
    g_bBackGround = NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didChangeStatusBarOrientation:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
    //the func--->MMInfo() begin called!
    MMInfo(@"<!WXG!>application didChangeStatusBarOrientation%ld", oldStatusBarOrientation);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: applicationDidBecomeActive:
 * Returning Type: void
 */ 
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    BOOL bPreActive = m_isActive;
    
    //防止后台运行的background没有停掉
    [self ClearBackGroundFetch];
    
    m_isActive = YES;
	
	m_tLastActiveTime = time(NULL);
	
    //the func--->MMInfo() begin called!
    MMInfo(@"<!WXG!>applicationDidBecomeActive");
    
    if (m_isInSafeMode) // the 'if' part
    {
        // 安全模式下不能做太多逻辑
        //the return stmt
        return;
    } else // the 'else' part
    if (m_isFirstLaunching) // the 'if' part
    {
        m_isFirstLaunching = NO;
        // 证明applicationState是正常的
        [[MMSafeModeMgr shareInstance] reportDataWithKey:8 value:-1];
    }
    
    [GET_SERVICE(AppDataMgr) checkAndUpdateAppData];
    [GET_SERVICE(WXTalkPresentMgr) loadWXTalkRoomInfoList];
    [GET_SERVICE(TrackPresentMgr) loadTrackRoomInfoList];
    [GET_SERVICE(BizLivePresentManager) loadBizLiveRoomInfoList];
    //ios8发现有些用户在webview看视频时会不断地调用applicationDidBecomeActive
    //所以这里加个逻辑保护
    if(!bPreActive)
    // the 'if' part
    {
        [GET_SERVICE(NewSyncService) BackGroundToForeGroundSync];
        [GET_SERVICE(NewSyncService) NeedToSyncOplog];
        
        if([CAppUtil isLogin])
        // the 'if' part
        {
            [GET_SERVICE(CNetworkStatusMgr) CheckBG2FG];
        }
    }
    [m_mainController ReportApnsSetting:NO];
    
	//Notification Center
	[[NSNotificationCenter defaultCenter] postNotificationName:MMApplicationDidBecomeActiveNotification object:self userInfo:nil];
    
    [self setInBackground:NO];
    
    //check一下语言更新包
    //没登陆的就别费这个劲了
    //if(m_mainController.m_oSetting.m_nsUsrName != nil && [m_mainController.m_oSetting.m_nsUsrName length] != 0){
    //    [GET_SERVICE(MMLanguagePackageDownloadMgr) doCheckUpdate:NO];
    //}
    
    [self timerCheckUploadFavorites];
}


/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: applicationWillTerminate:
 * Returning Type: void
 */ 
- (void)applicationWillTerminate:(UIApplication *)application
{
    //the func--->MMInfo() begin called!
    MMInfo(@"applicationWillTerminate");
    [MMOOMCrashReport setFlag:DEF_USER_QUIT_APP];
    [[MMCrashReportHandler shareCrashReportHandler] disableExceptionHandle];

    //app被干掉时，置上次进入钱包时间为0，使得每次微信被kill之后起来，第一次进钱包都需要验手势密码(如果设了的话)
    [SettingUtil getMainSettingExt].m_patternLockLastEnterTime = 0;
    [SettingUtil getMainSettingExt].m_patternLockVCLastEnterTime = 0;
    [GET_SERVICE(AccountStorageMgr) SaveSettingExt];

    [GET_SERVICE(CdnComMgr) UnInit];

	[CAppUtil removeLocalMemoryWarningObserver:self];
    
#ifdef DEBUG
    [m_resourceMonitor stopService];
#endif
	
	[m_serviceCenter callTerminate];
    
	
	[m_mainController Stop];
	
	[self resetBadge];
	
	//Notification Center
	[[NSNotificationCenter defaultCenter] postNotificationName:MMApplicationWillTerminateNotification object:self userInfo:nil];
    
    PM_LOG_DETAIL_INFO(eSTATE_WILL_TERMINATE);
    
	// uninit log
    //the func--->kvCommOnAppCrashOrExit() begin called!
    kvCommOnAppCrashOrExit();
	//the func--->Objc2C_onDestroy() begin called!
	Objc2C_onDestroy();
    //the func--->Objc2C_AppenderClose() begin called!
    Objc2C_AppenderClose();
    
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:willChangeStatusBarOrientation:duration:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
{
    if( [DeviceInfo isiPadUniversal] )
    // the 'if' part
    {
        [[ [[m_appViewControllerMgr getMainWindow] rootViewController] class] attemptRotationToDeviceOrientation ]  ;
    }
    [UiUtil OnSystemStatusBarOrientationChange:newStatusBarOrientation];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:willChangeStatusBarFrame:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame{
	//the func--->MMInfo() begin called!
	MMInfo(@"willChangeStatusBarFrame frame:%@", //the func--->NSStringFromCGRect() begin called!
	NSStringFromCGRect(newStatusBarFrame));
}
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didChangeStatusBarFrame:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame{
	//Notification Center
    //	[[NSNotificationCenter defaultCenter] postNotificationName:MMTopBarFrameChangeNotification object:self userInfo:nil];
    [UiUtil OnSystemStatusBarFrameChange];
}

#pragma mark Handle Outsize URL

//处理第三方应用注册到微信的支持文件类型的参数,处理后会将url和strUrl设置为不附带注册支持文件类参数的原始数据！//
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: process3rdAppSupportContentFlagFromOpenUrl:andUrlStr:appID:
 * Returning Type: void
 */ 
-(void) process3rdAppSupportContentFlagFromOpenUrl:(NSURL **)url andUrlStr:(NSString **)strUrl appID:(NSString *)strAppID
{
    //找到"supcntflag="字符串
    NSString *parameterStr = [*url query];
    if (parameterStr.length <= 0) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    NSString *findStr = [NSString stringWithFormat:@"%@=", URL_PARAMETER_APPSUPPORTCONTENTFLAG];
    NSInteger findedLocation = [parameterStr rangeOfString:findStr].location;
    
    if (findedLocation == NSNotFound) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    //找到之后需要把＝后面的数据取出来，是UInt64类型
    if (parameterStr.length <= findedLocation) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    NSString *subStr = [parameterStr substringFromIndex:findedLocation];
    //再看看后面是否还有其他的参数
    UInt64 typeFlag = 0;
    NSArray *aryPara = [subStr componentsSeparatedByString:@"&"];
    if (aryPara <= 0) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    NSString *resultStr = [aryPara firstObject];
    if (resultStr.length <= 0) // the 'if' part
    {
        //the return stmt
        return;
    }

    NSInteger startLocation = [resultStr rangeOfString:@"="].location + 1;
    if (subStr.length <= startLocation)
    // the 'if' part
    {
        //the return stmt
        return;
    }
    
    NSString *valueStr = [subStr substringFromIndex:startLocation];
    typeFlag = [valueStr unsignLongLongValue];
    
    //设置typeFlag到微信中
    [GET_SERVICE(AppDataMgr) save3rdAppSupportContentType:typeFlag withAppID:strAppID];
    //the func--->MMInfo() begin called!
    MMInfo(@"app set supportcontentfromwx %lld", (unsigned long long)typeFlag);
    
    //需要把url 和 strUrl中的此参数清理干净，否则会影响下面的逻辑
    NSString *targetStr = [NSString stringWithFormat:@"&%@", resultStr]; //先搜索带&字符的
    NSInteger shouldRemoveStartLocation = [*strUrl rangeOfString:targetStr].location;
    if (shouldRemoveStartLocation != NSNotFound)
    // the 'if' part
    {
        // weixin://app/wxd930ea5d5a258f4f/sendreq/?&supportcontentfromwx=8191
        // weixin://app/wxd930ea5d5a258f4f/sendreq/?abc=123&supportcontentfromwx=8191
        if (shouldRemoveStartLocation+targetStr.length <= (*strUrl).length) // the 'if' part
        {
            NSString *tmpFrontStr = [*strUrl substringToIndex:shouldRemoveStartLocation];
            NSString *tmpBackStr  = [*strUrl substringFromIndex:shouldRemoveStartLocation+targetStr.length];
            *strUrl = [NSString stringWithFormat:@"%@%@", tmpFrontStr, tmpBackStr];
            *url = [NSURL URLWithString:*strUrl];
        }
    }
    else
    // the 'else' part
    {
        // weixin://app/wxd930ea5d5a258f4f/sendreq/?supportcontentfromwx=8191&abc=123
        shouldRemoveStartLocation = [*strUrl rangeOfString:resultStr].location;
        if (shouldRemoveStartLocation != NSNotFound) // the 'if' part
        {
            NSString *tmpFrontStr = [*strUrl substringToIndex:shouldRemoveStartLocation];
            NSString *tmpBackStr  = [*strUrl substringFromIndex:shouldRemoveStartLocation+resultStr.length];
            *strUrl = [NSString stringWithFormat:@"%@%@", tmpFrontStr, tmpBackStr];
            *url = [NSURL URLWithString:*strUrl];
        }
    }
}

/* url scheme
 common
 weixin://(command)/
 addfriend
 weixin://addfriend/(username)
 qr
 weixin://qr/(username)
 app
 weixin://app/(appid)
 verifysms
 weixin://verifysms/(kind)/(sms)
 
 */
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: handleOpenURL:bundleID:
 * Returning Type: BOOL
 */ 
-(BOOL) handleOpenURL:(NSURL *)url bundleID:(NSString *)bundleID
{
    //the func--->MMInfo() begin called!
    MMInfo(@"url[%@]", url);
    
    // 解决 becomeactive:调用比handleurl:慢，导致第三方调起已关闭的微信时拉不到appinfo
    if (![GET_SERVICE(AppDataMgr) isAppDataChecked]) // the 'if' part
    {
        [GET_SERVICE(AppDataMgr) checkAndUpdateAppData];
    }
    
    NSString *strPrefix = @"weixin://";
    NSString *strUrl = url.absoluteString;
    
    
    NSRange preFixRange = [strUrl rangeOfString:strPrefix options:NSCaseInsensitiveSearch];
    
    if (preFixRange.location != 0 || preFixRange.length == 0 || strUrl.length <= strPrefix.length)
    // the 'if' part
    {
        //the return stmt
        return NO;
    }
    
    NSString *subString = [strUrl substringFromIndex:strPrefix.length];
    NSArray *aryString = [subString componentsSeparatedByString:@"/"];
    
    if (!aryString || aryString.count == 0)
    // the 'if' part
    {
        //the return stmt
        return NO;
    }
    
    NSString *nsCommand = [aryString firstObject];
    //the func--->MMInfo() begin called!
    MMInfo(@"nsCommand=%@, aryString.count=%lu", nsCommand, [aryString count]);
    
    if ([nsCommand caseInsensitiveCompare:@"jumpurl"] == NSOrderedSame && aryString.count >= 2)
    // the 'if' part
    {
        if ([[aryString objectAtIndex:1] length] > 0) // the 'if' part
        {
            URLSourceInfo *urlSourceInfo = [[URLSourceInfo alloc]init];
            urlSourceInfo.m_url = [subString substringFromIndex:nsCommand.length + 1];
            urlSourceInfo.m_bundleId = bundleID;
            
            [[CAppViewControllerManager getAppViewControllerManager] jumpToURLShardBy3rdApp:urlSourceInfo];
            //the return stmt
            return YES;
        }
    }
    else // the 'else' part
    if ([nsCommand caseInsensitiveCompare:@"app"] == NSOrderedSame && aryString.count >= 2)
    // the 'if' part
    {
        NSString *strAppID = [aryString objectAtIndex:1];
        
        //处理第三方应用注册到微信的支持文件类型的参数,处理后会将url和strUrl设置为不附带注册支持文件类参数的原始数据！//
        [self process3rdAppSupportContentFlagFromOpenUrl:&url andUrlStr:&strUrl appID:strAppID];
        ///////////////////////////////////////
        
        //支付流程 url:weixin://app/appid/pay/?a=1&b=2&c=3.../
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] caseInsensitiveCompare:@"pay"] == NSOrderedSame) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doWCPayOpenApi:strAppID payInfo:url];
            [GET_SERVICE(AppDataMgr) checkAndUpdateAppDataForiOS7Plus:strAppID forceUpdate:YES];
            //the return stmt
            return YES;
        }
        //红包流程 url:weixin://app/appid/hb/?a=1&b=2&c=3.../
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] caseInsensitiveCompare:@"hb"] == NSOrderedSame) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doWCHBOpenApi:strAppID BundleID:bundleID payInfo:url];
            [GET_SERVICE(AppDataMgr) checkAndUpdateAppDataForiOS7Plus:strAppID forceUpdate:YES];
            //the return stmt
            return YES;
        }
        //OAuth url:weixin://app/appid/auth/?scope=%@&state=%@
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] caseInsensitiveCompare:@"auth"] == NSOrderedSame)// the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doOAuthOpenApi:strAppID authInfo:url];
            [GET_SERVICE(AppDataMgr) checkAndUpdateAppDataForiOS7Plus:strAppID forceUpdate:YES];
            //the return stmt
            return YES;
        }
        
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] isEqualToString:@"openprofile"]) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doOpenProfileApi:strAppID BundleID:bundleID Info:url];
            //the return stmt
            return YES;
        }
        
        if([aryString count] > 3 && [[aryString objectAtIndex:2] isEqualToString:@"jumptobizwebview"])// the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doJumpToBizWebview:strAppID BundleID:bundleID Info:url];
            //the return stmt
            return YES;
        }
        
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] isEqualToString:@"cardpackage"]) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doAppAddCard:strAppID BundleID:bundleID Info:url];
            //the return stmt
            return YES;
        }
        
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] isEqualToString:@"choosecard"]) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doChooseCard:strAppID BundleID:bundleID Info:url];
            //the return stmt
            return YES;
        }
        
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] isEqualToString:@"opentempsession"]) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doOpenTempSessionWithAppId:strAppID bundleId:bundleID info:url];
            //the return stmt
            return YES;
        }
        
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] isEqualToString:@"openwebview"]) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doOpenWebviewWithAppId:strAppID bundleId:bundleID info:url];
            //the return stmt
            return YES;
        }

        
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] isEqualToString:@"openranklist"]) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doOpenRankListWithAppId:strAppID bundleId:bundleID info:url];
            //the return stmt
            return YES;
        }
        
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] isEqualToString:@"createchatroom"]) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) doCreateChatRoom:strAppID bundleId:bundleID info:url];
            //the return stmt
            return YES;
        }
        
        if ([aryString count] > 3 && [[aryString objectAtIndex:2] isEqualToString:@"joinchatroom"]) // the 'if' part
        {
            [GET_SERVICE(OpenApiMgr) joinChatRoom:strAppID bundleId:bundleID info:url];
            //the return stmt
            return YES;
        }
        
        [GET_SERVICE(AppDataMgr) checkAndUpdateAppDataForiOS7Plus:strAppID forceUpdate:NO];
        
        /*
         * SDK的普通跳转
         * SDK1.4 url:weixin://app/appid/sendreq/?
         url:weixin://app/appid/sendresp/?
         * SDK1.4及以下 url:weixin://app/appid/
         */
        if ([aryString count] > 3) // the 'if' part
        {
            if ([[aryString objectAtIndex:2] caseInsensitiveCompare:@"sendreq"] == NSOrderedSame) // the 'if' part
            {
                //do nothing
                
            } else // the 'else' part
            if ([[aryString objectAtIndex:2] caseInsensitiveCompare:@"sendresp"] == NSOrderedSame)// the 'if' part
            {
                //do nothing
                
            }else // the 'else' part
            {
                //非法的请求，弹框提示
                if ([GET_SERVICE(AppDataMgr) isNeedDetectRequetURL:strAppID]) // the 'if' part
                {
                    [CControlUtil showAlert:LOCALSTR(@"OpenApi_UnknownUrlRequestTitle") message:LOCALSTR(@"OpenApi_UnknownUrlRequestDesc") delegate:nil cancelButtonTitle:nil];
                    //the return stmt
                    return NO;
                }
            }
        }
        
		[GET_SERVICE(OpenApiMgr) doApi:strAppID bundleId:bundleID];
		
        //the return stmt
        return YES;
    }
    else // the 'else' part
    if ([nsCommand caseInsensitiveCompare:@"sign-in-twitter.wechatapp"] == NSOrderedSame && aryString.count >= 2)
    // the 'if' part
    {
        NSArray * splitQuerys = [[aryString objectAtIndex:1] componentsSeparatedByString:@"?"];
        if(splitQuerys.count == 2)// the 'if' part
        {
            [GET_SERVICE(MMTwitterMgr) didTwitterLogin:[splitQuerys objectAtIndex:1]];
        }
    }
    else // the 'else' part
    if([nsCommand caseInsensitiveCompare:@"verifysms"] == NSOrderedSame && aryString.count >= 3)
    // the 'if' part
    {
        //若需要处理自动填写短信，则需要与服务器约定好key后监控这个;
        //目前已经有的key列表如下：
        //@"pay" - 对应于支付中所有的自动填写短信
        //支付 url:weixin://verifysms/pay/123456
        //the func--->MMDebug() begin called!
        MMDebug(@"%@",(NSString *)[aryString objectAtIndex:1]);
        SAFECALL_KEY_EXTENSION(IAutoVerifySMSExt, (NSString *)[aryString objectAtIndex:1], @selector(OnHandleOpenAutoVerifySMS:), OnHandleOpenAutoVerifySMS:[aryString objectAtIndex:2]);
        //the return stmt
        return YES;
    }
    else // the 'else' part
    if ([nsCommand caseInsensitiveCompare:@"verifyemail"] == NSOrderedSame && aryString.count >= 3)
    // the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"%@",(NSString *)[aryString objectAtIndex:1]);
        SAFECALL_KEY_EXTENSION(IAutoVerifySMSExt, (NSString *)[aryString objectAtIndex:1], @selector(OnHandleOpenAutoVerifySMS:), OnHandleOpenAutoVerifySMS:[aryString objectAtIndex:2]);
        //the return stmt
        return YES;
    }
    else // the 'else' part
    if([nsCommand caseInsensitiveCompare:@"scanqrcode"] == NSOrderedSame)
    // the 'if' part
    {
        [[CAppViewControllerManager getAppViewControllerManager] jumpToCameraScan:CameraScanQRCode];
        //the return stmt
        return YES;
    }
    else // the 'else' part
    if([nsCommand caseInsensitiveCompare:@"cardpackage"] == NSOrderedSame)
    // the 'if' part
    {
        [GET_SERVICE(OpenApiMgr) doSMSAddCardApi:url];
        //the return stmt
        return YES;
    }
    else // the 'else' part
    if([nsCommand caseInsensitiveCompare:@"dl"] == NSOrderedSame)
    // the 'if' part
    {
        if (![CAppViewControllerManager hasEnterWechatMain])
        // the 'if' part
        {
            //the return stmt
            return NO;
        }
        
        if ([GET_SERVICE(WCBusinessJumpMgr) isBusinessJump:strUrl])
        // the 'if' part
        {
            [GET_SERVICE(WCBusinessJumpMgr) handleJumpFromOuter:strUrl bundleId:bundleID parentViewController:nil];
            //the return stmt
            return YES;
        }
        if (![WCDeepLinkHandler isDeepLink:strUrl])
        // the 'if' part
        {
            //the return stmt
            return NO;
        }
        
        [[CAppViewControllerManager getAppViewControllerManager] moveToRootViewController];
        
        MMURLHandler* urlHandler = [[MMURLHandler alloc] init];
        urlHandler.m_isDisableShare = YES;
        urlHandler.m_viewController = nil ;
        urlHandler.m_urlPermittedSet = ALLPERMIT_URL_PERMISSION;
        [urlHandler handleURL:strUrl withExtraInfo:@{WEBVIEWKEY_GETA8KEY_SCENCE:@(MMGETA8KEY_SCENE_OUTSIDE_DEEPLINK)}];
        //the return stmt
        return YES;
    }
    else // the 'else' part
    if([nsCommand caseInsensitiveCompare:@"connectToFreeWifi"] == NSOrderedSame)
    // the 'if' part
    {
        [GET_SERVICE(PublicWifiManager) handle3rdAppWithUrl:url];
        
        if (aryString.count >= 2)
        // the 'if' part
        {
            NSString *nsBizCommond = [aryString objectAtIndex:1];
            if ([nsBizCommond hasPrefix:@"friendWifi?"])
            // the 'if' part
            {
                [GET_SERVICE(WCDeviceFriendWifiMgr) handle3rdAppUrl:url];
            }
        }
        //the return stmt
        return YES;
    }
    else // the 'else' part
    if([nsCommand caseInsensitiveCompare:@"wap"] == NSOrderedSame)
    // the 'if' part
    {
        if(aryString.count < 2)
        // the 'if' part
        {
            //the return stmt
            return NO;
        }
        NSString *nsBizCommond = [aryString objectAtIndex:1];
        if([nsBizCommond hasPrefix:@"pay?"])
        // the 'if' part
        {
            UIViewController *vc = [CAppViewControllerManager topMostController];
            if([vc isKindOfClass:[MMUIViewController class]])
            // the 'if' part
            {
                //the return stmt
                return NO;
            }
            
            [GET_SERVICE(WCPayControlMgr) startPayMoneyFromWAPPayLogic:(MMUIViewController *)[CAppViewControllerManager topMostController] HandleUrl:[nsBizCommond substringFromIndex:@"pay?".length]];
            //the return stmt
            return YES;
        }
        //the return stmt
        return NO;
    }

    //the return stmt
    return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: decodeUrlAttrs:
 * Returning Type: NSDictionary *
 */ 
-(NSDictionary *) decodeUrlAttrs:(NSString *)data
{
    if (data.length == 0) // the 'if' part
    {
        //the return stmt
        return nil;
    }
    if ([data hasPrefix:@"?"]) // the 'if' part
    {
        data = [data substringWithRange://the func--->NSMakeRange() begin called!
        NSMakeRange(1, data.length - 1)];
    }
    NSArray * array = [data componentsSeparatedByString:@"&"];
    NSMutableDictionary * attrDic = [NSMutableDictionary dictionary];
    for (NSString * attr in array) {
        NSArray * kvPair = [attr componentsSeparatedByString:@"="];
        [attrDic setObject:[kvPair objectAtIndex:1] forKey:[kvPair objectAtIndex:0]];
    }
    //the return stmt
    return attrDic;
    
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:handleOpenURL:bundleID:annotation:
 * Returning Type: BOOL
 */ 
-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url bundleID:(NSString *)bundleID annotation:(id)annotation
{
	
	if ([self handleOpenURL:url bundleID:bundleID])
    // the 'if' part
    {
        //the return stmt
        return YES;
    }
    else // the 'else' part
    if([url isFileURL])
    // the 'if' part
    {
        //处理文件
		[OpenApiMgrHelper makeFileInternalMessage:url];
        
        [GET_SERVICE(OpenApiMgr) doApi:FILEAPP_ID bundleId:bundleID];
        //[m_appViewControllerMgr handleRequestFromApp:FILEAPP_ID];
		
		//the return stmt
		return YES;
    }
	
	FacebookUsageType uiFacebookUsageType = FacebookUsageType_Bind;
    
    MMFacebookMgr *facebookMgr = GET_SERVICE(MMFacebookMgr);
	
	if ([GET_SERVICE(MMFacebookMgr) getFacebookUsageType] == FacebookUsageType_None) // the 'if' part
	{
		CAppViewControllerManager* ViewMgr = [CAppViewControllerManager getAppViewControllerManager];
		if([ViewMgr getNewMainFrameViewController]!=nil)// the 'if' part
		{
			uiFacebookUsageType = FacebookUsageType_Bind;
		} else // the 'else' part
		{
			uiFacebookUsageType = FacebookUsageType_Connect;
		}
		[GET_SERVICE(MMFacebookMgr) setFacebookUsageType:uiFacebookUsageType];
	}
    
    return [facebookMgr application:application openURL:url sourceApplication:bundleID annotation:annotation];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:openURL:sourceApplication:annotation:
 * Returning Type: BOOL
 */ 
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	//the func--->MMDebug() begin called!
	MMDebug(@"source app[%@], url[%@], annotation[%@]", sourceApplication, url, annotation);
    

    // 现在不需要参数, 就没带, 以后谁需要了可以加上~
    [[NSNotificationCenter defaultCenter] postNotificationName:MMApplicationWillHandleOpenURLNotification object:nil userInfo:nil];
    
    //the return stmt
    return [self application:application handleOpenURL:url bundleID:sourceApplication annotation:annotation];
}

#pragma mark Watch
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:handleWatchKitExtensionRequest:reply:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply {
    //the func--->WatchError() begin called!
    WatchError(@"this should be deprecated");
}

#pragma mark - Homescreen Shortcuts
#ifndef SPAY_FORCE_TOUCH
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: setupForShortcut
 * Returning Type: void
 */ 
- (void)setupForShortcut {
    if (!//the func--->NSClassFromString() begin called!
    NSClassFromString(@"UIApplicationShortcutItem")) // the 'if' part
    //the return stmt
    return;
    
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:4];
    
    // 我的二维码
    UIApplicationShortcutItem *myQRCodeItem = [[UIApplicationShortcutItem alloc]
                                               initWithType:@"myqrcode"
                                               localizedTitle:LOCALSTR(@"MainFrame_RBtnMyQRCode")
                                               localizedSubtitle:nil
                                               icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"MyQRCodeAction"]
                                               userInfo:nil];
    [items addObject:myQRCodeItem];
    
    // 扫描二维码
    UIApplicationShortcutItem *scanQRCodeItem = [[UIApplicationShortcutItem alloc]
                                                 initWithType:@"qrcode"
                                                 localizedTitle:LOCALSTR(@"MainFrame_RBtnQRCode")
                                                 localizedSubtitle:nil
                                                 icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"ScanQRCodeAction"]
                                                 userInfo:nil];
    [items addObject:scanQRCodeItem];
    
    // 收付款
    // 和右上角加号的逻辑保持一致
    if ([[m_appViewControllerMgr getNewMainFrameViewController] isTopRightMenuShowID:@"20"]) // the 'if' part
    {
        UIApplicationShortcutItem *payItem = [[UIApplicationShortcutItem alloc]
                                                     initWithType:@"receive_pay"
                                                     localizedTitle:LOCALSTR(@"WCPay_FacingReceiveMoney_OfflinePay_Title")
                                                     localizedSubtitle:nil
                                                     icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"QuickPayAction"]
                                                     userInfo:nil];
        [items addObject:payItem];
    }
    
    // 静音
//    BOOL isMuteNow = [GET_SERVICE(NotificationActionsMgr) isDontDisturbModeAndCheckRestore:YES];
//    UIApplicationShortcutItem *shortcutItem = [[UIApplicationShortcutItem alloc]
//                                               initWithType:@"mute"
//                                               localizedTitle:isMuteNow?LOCALSTR(@"ShortcutTitleUnmute"):LOCALSTR(@"ShortcutTitleMute")
//                                               localizedSubtitle:nil
//                                               icon:[UIApplicationShortcutIcon iconWithTemplateImageName:isMuteNow?@"CancelDoNotDisturbAction":@"DoNotDisturbAction"]
//                                               userInfo:@{@"mute":@(!isMuteNow)}];
//    [items addObject:shortcutItem];
    
    [UIApplication sharedApplication].shortcutItems = [items copy];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:performActionForShortcutItem:completionHandler:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    NSString *type = shortcutItem.type;
    
    SAFECALL_EXTENSION(IShortCutExt, @selector(onPerformShortCut:), onPerformShortCut:type);
    //统计需求
    NSString *success = @"0", *opType = @"0";
    if ([SettingUtil getMainSetting].m_nsUsrName.length == 0) // the 'if' part
    {
        success = @"2";
    } else // the 'else' part
    {
        success = @"1";
    }
    if ([type isEqualToString:@"receive_pay"]) // the 'if' part
    {
        opType = @"1";
    } else // the 'else' part
    if ([type isEqualToString:@"qrcode"]) // the 'if' part
    {
        opType = @"2";
    } else // the 'else' part
    if ([type isEqualToString:@"myqrcode"]) // the 'if' part
    {
        opType = @"3";
    }
    NSString *logStr = [NSString stringWithFormat:@"%@,%@", opType, success];
    //the func--->LOG_FEATURE_EXT() begin called!
    LOG_FEATURE_EXT(13071, logStr);
            
    /*
     修复未登录出action的bug
     一开始用 `+[CAppUtil isLogin]`, 问题是如果是一启动就调用这里, 这时候还在autoauth阶段, 是会误判未未登录状态的
     然后用判断username替代, 如果有则认为已登录, 就算被踢也没关系, 会又强制跳转到登录页
     */
    if ([SettingUtil getMainSetting].m_nsUsrName.length == 0) // the 'if' part
    //the return stmt
    return;
    
    
    if ([type isEqualToString:@"qrcode"]) // the 'if' part
    {
        UIViewController *topVC = [CAppViewControllerManager getCurrentNavigationController].topViewController;
        if ([topVC isKindOfClass:[CameraScanViewController class]]) // the 'if' part
        {
            CameraScanViewController *scanQRVC = (CameraScanViewController *)topVC;
            [scanQRVC switchView:CameraScanQRCode];
        } else // the 'else' part
        {
            [m_appViewControllerMgr jumpToCameraScan:CameraScanQRCode showMainView:YES];
        }
        //the return stmt
        return;
    }
    
    if ([type isEqualToString:@"myqrcode"]) // the 'if' part
    {
        [[CAppViewControllerManager getAppViewControllerManager] moveToTab:ETabBarIndexType_More showMainView:YES];
        [(MoreViewController *)[[CAppViewControllerManager getAppViewControllerManager] getTabBarBaseViewController:ETabBarIndexType_More] showMyQRCodeInProfileView];
        //the return stmt
        return;
    }
    
    if ([type isEqualToString:@"sight"]) // the 'if' part
    {
        [GET_SERVICE(SightFacade) showSightWindowWithBottomMask:nil andTopMask:nil maskAlpha:0 iconCenter:CGPointZero byViewController:[m_appViewControllerMgr getNewMainFrameViewController]];
        [GET_SERVICE(SightFacade) startCamera];
        //the return stmt
        return;
    }
    
    if ([type isEqualToString:@"offline_pay"]) // the 'if' part
    {
        [m_appViewControllerMgr jumpToOfflinePay];
        //the return stmt
        return;
    }
    
    if ([type isEqualToString:@"new_chat"]) // the 'if' part
    {
        [[CAppViewControllerManager getAppViewControllerManager] moveToTab:ETabBarIndexType_MainFrame showMainView:YES];
        NewMainFrameViewController *vc = [[CAppViewControllerManager getAppViewControllerManager] getNewMainFrameViewController];
        UINavigationController* oNavController = [[MMUINavigationController alloc] initWithRootViewController:[vc getVCWithDeepLinkName:@"groupchat"]];
        oNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        oNavController.navigationBar.tintColor = [CShareResourceProvider GetNavigationBarTintColor];
        [vc PresentModalViewController:oNavController animated:YES];
        //the return stmt
        return;
    }
    
    if ([type isEqualToString:@"mute"]) // the 'if' part
    {
        BOOL mute = [(NSNumber *)[shortcutItem.userInfo objectForKey:@"mute"] boolValue];
        if (mute) // the 'if' part
        {
            [GET_SERVICE(NotificationActionsMgr) showDisturbConfirmViewController];
        } else // the 'else' part
        {
            [GET_SERVICE(NotificationActionsMgr) unmute];
        }
        //the return stmt
        return;
    }
    
    // 收付款
    if ([type isEqualToString:@"receive_pay"]) // the 'if' part
    {
        [[CAppViewControllerManager getAppViewControllerManager] moveToTab:ETabBarIndexType_MainFrame showMainView:YES];
        NewMainFrameViewController *vc = [[CAppViewControllerManager getAppViewControllerManager] getNewMainFrameViewController];
        [vc openSelectReceiveOrPayMoneyFromShortcut];
        //the return stmt
        return;
    }
    
//    if ([type isEqualToString:@"chat"]) {
//        NSString *userName = (NSString*)[shortcutItem.userInfo objectForKey:@"username"];
//        if (userName) {
//            CContact* oContact = [GET_SERVICE(CContactMgr) getContactByName:userName];
//            [[CAppViewControllerManager getAppViewControllerManager] newMessageByContact:oContact msgWrapToAdd:nil animated:NO];
//        } else {
//            [[CAppViewControllerManager getAppViewControllerManager] moveToTab:ETabBarIndexType_MainFrame showMainView:YES];
//        }
//        return;
//    }
//    
//    if ([type isEqualToString:@"moments"]) {
//        [m_appViewControllerMgr jumpToAlbum];
//        return;
//    }
//    
//    if ([type isEqualToString:@"add_contact"]) {
//        AddFriendEntryViewController* vc = [[AddFriendEntryViewController alloc] init];
//        vc.searchScene = MMSEARCH_SCENE_UNKNOWN;
//        [[CAppViewControllerManager getAppViewControllerManager] moveToTab:ETabBarIndexType_Contacts showMainView:YES];
//        UIViewController *vc22 = [[CAppViewControllerManager getAppViewControllerManager] getTabBarBaseViewController:ETabBarIndexType_Contacts];
//        [vc22.navigationController PushViewController:vc animated:NO];
//        return;
//    }
}
#endif // SPAY_FORCE_TOUCH

#pragma mark - NSUserActivity
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:willContinueUserActivityWithType:
 * Returning Type: BOOL
 */ 
- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    
    //the func--->MMDebug() begin called!
    MMDebug(@"userActivityType %@", userActivityType);
    
    //the return stmt
    return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: pasteboardChangedNotification:
 * Returning Type: void
 */ 
- (void)pasteboardChangedNotification:(NSNotification*)notification {
    NSInteger count = [UIPasteboard generalPasteboard].changeCount;
    //the func--->MMInfo() begin called!
    MMInfo(@"change count:%ld", (long)count);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:continueUserActivity:restorationHandler:
 * Returning Type: BOOL
 */ 
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    
    //the func--->MMInfo() begin called!
    MMInfo(@"Handling activity title: %@, type: %@, userInfo: %@", userActivity.title, userActivity.activityType, userActivity.userInfo);
    
    if ([userActivity.activityType isEqualToString:@"com.tencent.xin.watch"]) // the 'if' part
    {
        return [GET_SERVICE(WCWatchNativeMgr) handleUserActivty:userActivity restorationHandler:restorationHandler];
    }
    
    // universial link
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb])
    // the 'if' part
    {
        NSURL *webpageURL = userActivity.webpageURL;
        //the func--->MMInfo() begin called!
        MMInfo(@"NSUserActivityTypeBrowsingWeb: %@", webpageURL.path);
        
        if ([webpageURL.host isEqualToString:@"help.wechat.com"])
        // the 'if' part
        {
            NSString *feature = nil;
            
            // 获取feature参数
            NSString *q = [webpageURL query];
            NSArray *pairs = [q componentsSeparatedByString:@"&"];
            for (NSString * pair in pairs)
            {
                NSArray *bits = [pair componentsSeparatedByString:@"="];
                if (bits.count != 2) // the 'if' part
                continue;
                
                NSString *key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if ([key isEqualToString:@"feature"])
                // the 'if' part
                {
                    feature = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    break;
                }
            }
            
            if (feature)
            // the 'if' part
            {
                [GET_SERVICE(AppleSearchMgr) openFeature:feature];
                //the func--->LOG_FEATURE_EXT() begin called!
                LOG_FEATURE_EXT(13249, [@"0," stringByAppendingString:feature]);
            }

            //the return stmt
            return YES;
        }
    }
    
    // spotlight search
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) // the 'if' part
    {
        NSString *feature = [userActivity.userInfo objectForKey:CSSearchableItemActivityIdentifier];
        [GET_SERVICE(AppleSearchMgr) openFeature:feature];
        //the func--->LOG_FEATURE_EXT() begin called!
        LOG_FEATURE_EXT(13249, [@"1," stringByAppendingString:feature]);
        
        //the return stmt
        return YES;
    }
    
    //the return stmt
    return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didFailToContinueUserActivityWithType:error:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
    //the func--->MMWarning() begin called!
    MMWarning(@"Failed to continue activity type: %@", userActivityType);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: application:didUpdateUserActivity:
 * Returning Type: void
 */ 
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    //the func--->MMDebug() begin called!
    MMDebug(@"Did update user activity: %@", userActivity);
}

#pragma mark Memory management
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: handleMemoryWarning
 * Returning Type: void
 */ 
- (void)handleMemoryWarning{
    
    if (m_isActive) // the 'if' part
    {
        [FavAddItemHelper freeFavAddHelper];
        [VolumeCheckHelper freeVolumeCheckHelper];
    }
	[m_serviceCenter callServiceMemoryWarning];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: applicationDidReceiveMemoryWarning:
 * Returning Type: void
 */ 
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    //the func--->MMWarning() begin called!
    MMWarning(@"<!WXG!>!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Memory Warning!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    
    [self handleMemoryWarning];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: didReceiveLocalMemoryWarning:
 * Returning Type: void
 */ 
- (void)didReceiveLocalMemoryWarning:(NSNotification *)notification{
    [self handleMemoryWarning];
}

#pragma mark -
#pragma mark Detect Enviroment

//-(void) firstStartAfterFreshInstall
//{
//    [THEME_MGR onFirstRun];
//}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: firstStartAfterUpgradeDowngrade
 * Returning Type: void
 */ 
-(void) firstStartAfterUpgradeDowngrade
{
    [THEME_MGR onFirstRun];
    
    if(GET_SERVICE(ChatBackgroundMgr) != nil) // the 'if' part
    //the func--->MMDebug() begin called!
    MMDebug(@"ChatBackgroundMgr init success"); // 安装配置
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: detectAppFirstRunOrFirstRunAfterUpgrade
 * Returning Type: void
 */ 
-(void) detectAppFirstRunOrFirstRunAfterUpgrade
{
    // Get current version ("Bundle Version") from the default Info.plist file
	NSString* currentVersion = [CUtility ParseFullVersionString:[CUtility GetVersionFromPList]];
    if (currentVersion == nil) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    NSArray *prevStartupVersions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"prevStartupVersions"];
    if (prevStartupVersions == nil)
    // the 'if' part
    {
        m_appVerCompareWithLastRun = NSOrderedAscending;
    }
    else
    // the 'else' part
    {
        m_appVerCompareWithLastRun = [CAppUtil VersionCompare:currentVersion vs:[prevStartupVersions lastObject]];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: saveAppVersion
 * Returning Type: void
 */ 
-(void) saveAppVersion
{
	NSString* currentVersion = [CUtility ParseFullVersionString:[CUtility GetVersionFromPList]];
    if (currentVersion == nil) // the 'if' part
    {
        //the return stmt
        return;
    }
    NSArray *prevStartupVersions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"prevStartupVersions"];
    if (prevStartupVersions == nil)
    // the 'if' part
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:currentVersion] forKey:@"prevStartupVersions"];
    }
    else
    // the 'else' part
    {
        if (NSOrderedSame!=[CAppUtil VersionCompare:currentVersion vs:[prevStartupVersions lastObject]])
        // the 'if' part
        {
            NSMutableArray *updatedPrevStartVersions = [NSMutableArray arrayWithArray:prevStartupVersions];
            [updatedPrevStartVersions addObject:currentVersion];
            [[NSUserDefaults standardUserDefaults] setObject:updatedPrevStartVersions forKey:@"prevStartupVersions"];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: GetAppVerCompareWithLastRun
 * Returning Type: NSComparisonResult
 */ 
-(NSComparisonResult) GetAppVerCompareWithLastRun
{
    return m_appVerCompareWithLastRun;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: timerCheckUploadFavorites
 * Returning Type: void
 */ 
- (void)timerCheckUploadFavorites
{
    if ([CAppUtil isLogin]) // the 'if' part
    {
        [[SEFavoritesManager sharedManager] uploadFavorites];
        //the return stmt
        return;
    }
    //the func--->dispatch_after() begin called!
    dispatch_after(//the func--->dispatch_time() begin called!
    dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), //the func--->dispatch_get_main_queue() begin called!
    dispatch_get_main_queue(), ^{
        [self timerCheckUploadFavorites];
    });
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: dealloc
 * Returning Type: void
 */ 
- (void)dealloc {
    
    SAFE_DELETE(m_resourceLabel);
    SAFE_DELETE(m_changeValueLabel);
    //the func--->SAFE_DELETE() begin called!
    SAFE_DELETE(m_resourceWindow);
    
    SAFE_DELETE(m_resourceMonitor);
    SAFE_DELETE(m_lastResourceInfo);
    
	//the func--->SAFE_DELETE() begin called!
	SAFE_DELETE(m_mainController);
	//the func--->SAFE_DELETE() begin called!
	SAFE_DELETE(m_appObserverCenter);
    SAFE_DELETE(_window);
	SAFE_DELETE(m_nsToken);
	SAFE_DELETE(m_nsSound);
	SAFE_DELETE(m_nsVoipSound);
	
	//the func--->SAFE_DELETE() begin called!
	SAFE_DELETE(m_appViewControllerMgr);
	
	// free service center
	//the func--->SAFE_DELETE() begin called!
	SAFE_DELETE(m_serviceCenter);
    
    SAFE_DELETE(mActiveLock);
}

#pragma mark -
#pragma mark View Management

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: closeMainFrameInternal
 * Returning Type: void
 */ 
-(void) closeMainFrameInternal{
    
	LOG_STEP_START(ClearLocalInfo);
    
    if ([SettingUtil getMainSetting].m_uiUin != 0) // the 'if' part
    {
        [WTLoginMgr clearPwdSig:[SettingUtil getMainSetting].m_uiUin];
    }
    
    SAFECALL_EXTENSION(MMKernelExt, @selector(onPreQuit), onPreQuit);
    
    //退出时，置上次进入钱包时间为0，使得每次重新登录之后，第一次进钱包都需要验手势密码(如果设了的话)
    [SettingUtil getMainSettingExt].m_patternLockLastEnterTime = 0;
    [SettingUtil getMainSettingExt].m_patternLockVCLastEnterTime = 0;
    [GET_SERVICE(AccountStorageMgr) SaveSettingExt];
    
    // 退出登录， 清除本地数据
    //  KernInfo(@"User Logout..................... main control retain count %lu", (unsigned long)[m_mainController retainCount]);
    //the func--->KernInfo() begin called!
    KernInfo(@"User Logout..................... ");
    [GET_SERVICE(AccountStorageMgr) ClearLocalInfo];
    
	LOG_STEP_END(ClearLocalInfo);
	
	//AppIcon数字需要清0
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
	// 退出到登录界面
	
	//the func--->KernDebug() begin called!
	KernDebug(@"User exit...................");
	
	LOG_STEP_START(closeMainFrame);
	[m_appViewControllerMgr closeMainFrame];
	LOG_STEP_END(closeMainFrame);
	
    //从新创建新的界面
    [self mainUISetting] ;
	
	LOG_STEP_START(openFirstView);
	[m_appViewControllerMgr openFirstView];
	LOG_STEP_END(openFirstView);
    
    SAFECALL_EXTENSION(MMKernelExt, @selector(onPostQuit), onPostQuit);
	
    [self performSelectorOnMainThread:@selector(delayStopMain) withObject:nil waitUntilDone:NO];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: delayStopMain
 * Returning Type: void
 */ 
-(void) delayStopMain
{
    if ([AudioHelper IsMusicPlaying]) // the 'if' part
    {
        [AudioHelper StopMusic];
    }
    
    LOG_FUNTION_TIME;
    //the func--->KernInfo() begin called!
    KernInfo(@"delayStopMain");
    
    //退出顺序
    //1.去掉所有回调监听，保证不会有数据刷新
    //2.停掉网络层，保证不会有数据回调
    //3.停掉所有事件，不会调用任何service及抛出数据
    //4.清除所有service(老逻辑,又重建了service,比较诡异)
    //5.停掉maincontroll
    
    //step 1
    LOG_STEP_START(clearObserver);
	[m_appObserverCenter removeAllEventObserverListItem];
	[m_appObserverCenter removeAllMessageObserverListItem];
	[m_appObserverCenter removeAllPBEventObserverListItem];
	LOG_STEP_END(clearObserver);
	
	//the func--->KernDebug() begin called!
	KernDebug(@"Begin to init object........ ");
    
    //step 2
    //the func--->Objc2C_releaseNetwork() begin called!
    Objc2C_releaseNetwork();
    
    //step 3
    [m_mainController StopAllEvent];
    
    //step 4
    [GET_SERVICE(MMDatabaseRecoverMgr) OnUserLogOut];
    LOG_STEP_START(clearServiceObject);
	[self clearServiceObject];
	LOG_STEP_END(clearServiceObject);
    
    // recreate core
	LOG_STEP_START(initServiceObject);
	[self initServiceObject];
	LOG_STEP_END(initServiceObject);
    
    //step 5
    //清理mainController资源 以保证其释放
	LOG_STEP_START(StopMainControl);
	[m_mainController Stop];
	LOG_STEP_END(StopMainControl);
	
//	KernInfo(@"用户注销..................... main control retain count %lu", (unsigned long)[m_mainController retainCount]);
    //the func--->KernInfo() begin called!
    KernInfo(@"用户注销.....................");
	self.m_mainController = nil;
	
	LOG_STEP_START(CreateMainControl);
	m_mainController = [[CMainControll alloc] init];
	[m_mainController Start:m_appObserverCenter];
	LOG_STEP_END(CreateMainControl);
    
    //the func--->Objc2C_instanceNetwork() begin called!
    Objc2C_instanceNetwork();
	
	//reUpload the deviceToken and sound file
	[self doSendToken:nil error:NO];
	
	// recreate core
	LOG_STEP_START(reinitServiceObject);
	[self initServiceObject];
	LOG_STEP_END(reinitServiceObject);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: closeMainFrameWithoutReset
 * Returning Type: void
 */ 
-(void) closeMainFrameWithoutReset{
	[self closeMainFrameInternal];
}

#pragma mark - UIAlertViewDelegate
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: alertView:clickedButtonAtIndex:
 * Returning Type: void
 */ 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ALERT_VIEW_PUSH_TIP)
    // the 'if' part
    {
        if(buttonIndex == [alertView cancelButtonIndex])
        // the 'if' part
        {
            [SettingUtil getMainSettingExt].m_bNoShowPushTip = YES;
            [GET_SERVICE(AccountStorageMgr) SaveSettingExt];
        }
        else
        // the 'else' part
        {
            NSURL* oURL = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
            if([DeviceInfo isiOS8plus])
            // the 'if' part
            {
                oURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            }
            if([[UIApplication sharedApplication] canOpenURL:oURL])
            // the 'if' part
            {
                [[UIApplication sharedApplication] openURL:oURL];
            }
        }
    }
    else // the 'else' part
    if(alertView.tag == DL_ALERT_VIEW_TAG)
    // the 'if' part
    {
        if(buttonIndex != [alertView cancelButtonIndex])
        // the 'if' part
        {
            NSString *iTunesLink = @"http://itunes.apple.com/cn/app/id414478124?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL safeUrlWithString:iTunesLink]];
            //the func--->LOG_FEATURE_EXT() begin called!
            LOG_FEATURE_EXT(11584, @"1");
        }
        else
        // the 'else' part
        {
            //the func--->LOG_FEATURE_EXT() begin called!
            LOG_FEATURE_EXT(11584, @"2");
        }
    }
}

#pragma mark - UserAgent
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: setUserAgent
 * Returning Type: void
 */ 
-(void) setUserAgent {
	// 设置默认ua
    [CUtility UpdateUserAgent];
}

#pragma mark ResourceMonitorDelegate
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: onUpdateResourceInfo:
 * Returning Type: void
 */ 
- (void)onUpdateResourceInfo:(ResourceInfo *)info {
    //    m_resourceLabel.text = [NSString stringWithFormat:@"real:%0.2fM vir:%0.2fM", info.residentMemorySize, info.virtualMemorySize];
    m_resourceLabel.text = [NSString stringWithFormat:@"real:%0.2fM cap:%lldmAh", info.residentMemorySize, info._currentCap];
    m_resourceLabel.hidden = [CAppUtil isOrientationLandscape] ? YES : NO;
    
    //    CGFloat changeValue = (m_lastResourceInfo == nil) ? 0.0 : ((info.residentMemorySize - m_lastResourceInfo.residentMemorySize) * 1.0);
    //    if (changeValue >= CHANGE_VALUE_LIMIT) {
    //        m_changeValueLabel.backgroundColor = [UIColor redColor];
    //    } else if (changeValue <= -CHANGE_VALUE_LIMIT) {
    //        m_changeValueLabel.backgroundColor = [UIColor greenColor];
    //    } else {
    //        m_changeValueLabel.backgroundColor = [UIColor blackColor];
    //    }
    m_changeValueLabel.text = [NSString stringWithFormat:@"cpu:%0.2f%%", info._cpuUsage];
    m_changeValueLabel.hidden = [CAppUtil isOrientationLandscape] ? YES : NO;
    //    m_changeValueLabel.hidden = YES;
    if (m_lastResourceInfo == nil) // the 'if' part
    {
        m_lastResourceInfo = [[ResourceInfo alloc] init];
    }
    m_lastResourceInfo.residentMemorySize = info.residentMemorySize;
    m_lastResourceInfo.virtualMemorySize = info.virtualMemorySize;
}

#pragma mark - voip render background
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: getInBackground
 * Returning Type: BOOL
 */ 
- (BOOL) getInBackground;
{
    return mInBackground;
}
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: setInBackground:
 * Returning Type: void
 */ 
- (void) setInBackground:(BOOL) isBack
{
    CScopedLock lock(self.mActiveLock);
    mInBackground = isBack;
}

#pragma mark - blur multitasking screenshot

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: prepareBlurMultiTaskingScreenshot
 * Returning Type: void
 */ 
-(void)prepareBlurMultiTaskingScreenshot {
	if (m_blurView) // the 'if' part
	{
		[self hideBlurMultiTaskingScreenshot];
	}
	
	UIWindow* window = [UIView getTopWindow];
	[UIView stopSubviewScroplling:window];
	UIImage* screenshot = [UIView getSnapshotImageForView:window];
	UIImage* blurImage = [screenshot applyBlurWithRadius:5 tintColor:[UIColor clearColor] saturationDeltaFactor:2.0 maskImage:nil];
	m_blurView = [[UIImageView alloc] initWithImage:blurImage];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: showBlurMultiTaskingScreenshot
 * Returning Type: void
 */ 
-(void)showBlurMultiTaskingScreenshot {
	UIWindow* window = [UIView getTopWindow];
	[window addSubview:m_blurView];
	[window bringSubviewToFront:m_blurView];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MicroMessengerAppDelegate.mm
 * Method Name: hideBlurMultiTaskingScreenshot
 * Returning Type: void
 */ 
-(void)hideBlurMultiTaskingScreenshot {
	if (m_blurView) // the 'if' part
	{
		[m_blurView removeFromSuperview];
		m_blurView = nil;
	}
}

@end
