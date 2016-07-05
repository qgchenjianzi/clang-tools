//
//  NotificationActionsMgr.m
//  MicroMessenger
//
//  Created by yiyang on 9/4/14.
//  Copyright (c) 2014 Tencent. All rights reserved.
//

#import "NotificationActionsMgr.h"
#import "MMNotificationIdentifier.h"
#import "MsgDelegate.h"
#import "MessageMgr.h"
#import "MMNewSessionMgr.h"

#import "mmextdevice.pb.h"

#import "AppUtil.h"
#import "AppViewControllerManager.h"
#import "Setting.h"

#import "mmprimsend.pb.h"
#import "mmweb_pb.pb.h"
#import "WCWatchNativeMgr.h"
#import "SettingUtil.h"
#import "MicroMessengerAppDelegate.h"
#import "MMDisturbConfirmViewController.h"
#import "MMToastViewController.h"
#import "ExtraDeviceLoginMgr.h"
#import "MMOnlineDeviceStatusMgr.h"
#import "MMBezelWindowController.h"
#import "MMBezelWindowInfo.h"

#define ONE_HOUR_IN_SECONDS 3600

@interface NotificationActionsMgr () <IMsgExt, PBMessageObserverDelegate>

{
    NSMutableDictionary *_actionCompletions;
    MMToastViewController *_toastView;
    
    __weak MMDisturbConfirmViewController *_distrubConfirmViewController;
    NSMutableArray *_sendingMessages;
}

@end

@implementation NotificationActionsMgr

@synthesize actionMaping = _actionMaping;

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: init
 * Returning Type: id
 */ 
- (id)init
{
    if (self = [super init]) // the 'if' part
    {
        REGISTER_EXTENSION(IMsgExt, self);
        _actionMaping = @{
                          ACTION_IDENTIFIER_MARK_READ :     //the func--->NSStringFromSelector() begin called!
                          NSStringFromSelector(@selector(handleMarkAsReadAction   :completionHandler:)),
                          ACTION_IDENTIFIER_VIEW_MESSAGE :  //the func--->NSStringFromSelector() begin called!
                          NSStringFromSelector(@selector(handleGoToMessageAction  :completionHandler:)),
                          ACTION_IDENTIFIER_REPLY_1:        //the func--->NSStringFromSelector() begin called!
                          NSStringFromSelector(@selector(handleReply1Action       :completionHandler:)),
                          ACTION_IDENTIFIER_REPLY:          //the func--->NSStringFromSelector() begin called!
                          NSStringFromSelector(@selector(handleReplyAction        :completionHandler:)),
                          ACTION_IDENTIFIER_MUTE_CHAT:      //the func--->NSStringFromSelector() begin called!
                          NSStringFromSelector(@selector(handleMuteChatAction     :completionHandler:)),
                          ACTION_IDENTIFIER_REPLY_YO:       //the func--->NSStringFromSelector() begin called!
                          NSStringFromSelector(@selector(handleReplyYoAction      :completionHandler:)),
                          ACTION_IDENTIFIER_QUICK_REPLY :   //the func--->NSStringFromSelector() begin called!
                          NSStringFromSelector(@selector(handleGoToMessageAction  :completionHandler:)), // 暂时没启用, 简单的先填上面那个
                          ACTION_IDENTIFIER_CONFIRM_LOGIN:  //the func--->NSStringFromSelector() begin called!
                          NSStringFromSelector(@selector(handleConfirmLoginAction :completionHandler:)),
                          ACTION_IDENTIFIER_UNLOCK_DEVICE:  //the func--->NSStringFromSelector() begin called!
                          NSStringFromSelector(@selector(handleUnlockDeviceAction :completionHandler:)),
                          };
        _actionCompletions = [NSMutableDictionary dictionary];
        _sendingMessages = [NSMutableArray array];
    }
    
    //the return stmt
    return self;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: dealloc
 * Returning Type: void
 */ 
- (void)dealloc
{
    [NSObject safeCancelPreviousPerformRequestsWithTarget:self];
    //the func--->SAFE_DELETE() begin called!
    SAFE_DELETE(_actionMaping);
    [CAppUtil removePBEventObserverListItemByObject:self];
    UNREGISTER_EXTENSION(IMsgExt, self);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: onServiceTerminate
 * Returning Type: void
 */ 
-(void) onServiceTerminate {
    for (NSDictionary *info in _sendingMessages) {
        [self notifyUserSendMessageFailWithClientId:[info[@"cliendId"] unsignedIntValue] toUsername:info[@"username"]];
    }
    [_sendingMessages removeAllObjects];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: registerNotification
 * Returning Type: void
 */ 
- (void)registerNotification {
    if ([DeviceInfo isiOS8plus]) // the 'if' part
    {
        NSMutableSet *categories = [NSMutableSet set];
        
        ///////////////////////////////////////////////////////////////////////////////
        // 通用Actions
        // 进入聊天 // 暂时弃用
        //        UIMutableUserNotificationAction *enterChatAction =
        //        [[UIMutableUserNotificationAction alloc] init];
        //        enterChatAction.identifier = ACTION_IDENTIFIER_VIEW_MESSAGE;
        //        enterChatAction.title = LOCALSTR(@"Notification_TextMessage_EnterChat_Title");
        //        enterChatAction.activationMode = UIUserNotificationActivationModeForeground;
        //        enterChatAction.destructive = NO;
        //        enterChatAction.authenticationRequired = NO;
        
        // 标记已读 // 暂时弃用
        //        UIMutableUserNotificationAction *markAsReadAction =
        //        [[UIMutableUserNotificationAction alloc] init];
        //        markAsReadAction.identifier = ACTION_IDENTIFIER_MARK_READ;
        //        markAsReadAction.title = LOCALSTR(@"Notification_TextMessage_MarkAsRead_Title");
        //        markAsReadAction.activationMode = UIUserNotificationActivationModeBackground;
        //        markAsReadAction.destructive = NO;
        //        markAsReadAction.authenticationRequired = NO;
        
        UIMutableUserNotificationAction *replyAction = [[UIMutableUserNotificationAction alloc] init];
        if ([[UIMutableUserNotificationAction class] instancesRespondToSelector:@selector(behavior)]) // the 'if' part
        {
            // ios9 reply action
            replyAction.identifier = ACTION_IDENTIFIER_REPLY;
            replyAction.title = LOCALSTR(@"Notification_TextMessage_Reply_Title");
            replyAction.activationMode = UIUserNotificationActivationModeBackground;
            replyAction.behavior = UIUserNotificationActionBehaviorTextInput;
            replyAction.destructive = NO;
            replyAction.authenticationRequired = NO;
        } else // the 'else' part
        {
            // reply ok
            replyAction.identifier = ACTION_IDENTIFIER_REPLY_1;
            replyAction.title = LOCALSTR(@"Notification_TextMessage_Reply_1_Title");
            replyAction.activationMode = UIUserNotificationActivationModeBackground;
            replyAction.destructive = NO;
            replyAction.authenticationRequired = NO;
        }
        
        // reply yo
        UIMutableUserNotificationAction *replyYoAction =
        [[UIMutableUserNotificationAction alloc] init];
        replyYoAction.identifier = ACTION_IDENTIFIER_REPLY_YO;
        replyYoAction.title = LOCALSTR(@"Notification_TextMessage_Reply_Yo_Title");
        replyYoAction.activationMode = UIUserNotificationActivationModeBackground;
        replyYoAction.destructive = NO;
        replyYoAction.authenticationRequired = NO;
        
        // Open Red Pocket // 暂未启用
        //        UIMutableUserNotificationAction *notifyOpenAction =
        //        [[UIMutableUserNotificationAction alloc] init];
        //        notifyOpenAction.identifier = ACTION_IDENTIFIER_OPEN_RED_POCKET;
        //        notifyOpenAction.title = LOCALSTR(@"Notification_TextMessage_OPEN_RED_POCKET");
        //        notifyOpenAction.activationMode = UIUserNotificationActivationModeBackground;
        //        notifyOpenAction.destructive = NO;
        //        notifyOpenAction.authenticationRequired = NO;
        
        // mute chat // 暂时弃用
        //        UIMutableUserNotificationAction *muteAction =
        //        [[UIMutableUserNotificationAction alloc] init];
        //        muteAction.identifier = ACTION_IDENTIFIER_MUTE_CHAT;
        //        muteAction.title = LOCALSTR(@"Notification_TextMessage_MuteChat_Title");
        //        muteAction.activationMode = UIUserNotificationActivationModeBackground;
        //        muteAction.destructive = YES;
        //        muteAction.authenticationRequired = YES;
        
        // Notify Unlock
        UIMutableUserNotificationAction *notifyUnlockAction =
        [[UIMutableUserNotificationAction alloc] init];
        notifyUnlockAction.identifier = ACTION_IDENTIFIER_UNLOCK_DEVICE;
        notifyUnlockAction.title = LOCALSTR(@"MacHelper_Notify_Unlock");
        notifyUnlockAction.activationMode = UIUserNotificationActivationModeBackground;
        notifyUnlockAction.destructive = NO;
        notifyUnlockAction.authenticationRequired = YES;
        ///////////////////////////////////////////////////////////////////////////////
        
        // categories
        
        // Message
        // 同时支持两个category, TextMessage以后废弃
        [categories addObject:[self notificationCategoryWithIdentifier:@"TextMessage"
                                                               actions:@[replyAction]]];
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_DEFAULT
                                                               actions:@[replyAction]]];
        [categories addObject:[self notificationCategoryWithIdentifier:@"GroupTextMessage" actions:@[replyAction]]];
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_DEFAULT_GROUP actions:@[replyAction]]];
        
        
//        // QuickLogin
//        {
//            UIMutableUserNotificationAction *confirmLoginAction =
//            [[UIMutableUserNotificationAction alloc] init];
//            confirmLoginAction.identifier = ACTION_IDENTIFIER_CONFIRM_LOGIN;
//            confirmLoginAction.title = LOCALSTR(@"Notification_QuickLogin_ConfirmQuickLogin");
//            confirmLoginAction.activationMode = UIUserNotificationActivationModeBackground;
//            confirmLoginAction.destructive = NO;
//            confirmLoginAction.authenticationRequired = YES;
//            
//            [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_QUICK_LOGIN actions:@[confirmLoginAction]]];
//        }
        
        // Sticker
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_STICKER actions:@[replyAction]]];
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_STICKER_GROUP actions:@[replyAction]]];
        
        // Notify Unlock
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_NOTIFY_UNLOCK actions:@[notifyUnlockAction]]];
        
        // Yo
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_YO actions:@[replyYoAction]]];
        
        // Image
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_IMAGE actions:@[replyAction]]];
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_IMAGE_GROUP actions:@[replyAction]]];
        
        // Video
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_VIDEO actions:@[replyAction]]];
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_VIDEO_GROUP actions:@[replyAction]]];
        
        // Voice
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_VOICE actions:@[replyAction]]];
        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_VOICE_GROUP actions:@[replyAction]]];
        
        // Red Pocket
        //        [categories addObject:[self notificationCategoryWithIdentifier:CATEGORY_IDENTIFIER_HONGBAO actions:@[notifyOpenAction]]];
        
        // Voip
        // nothing for voip
        
        UIUserNotificationType type = (UIUserNotificationType) (UIUserNotificationTypeAlert |
                                                                UIUserNotificationTypeBadge |
                                                                UIUserNotificationTypeSound);
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:type categories:[categories copy]];
        
        MMInfo(@"reg token ios8 plus type %u", (unsigned int)type);
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
    else // the 'else' part
    {
        UIApplication * app = [UIApplication sharedApplication];
        UIRemoteNotificationType type = (UIRemoteNotificationType) (UIRemoteNotificationTypeAlert |
                                                                    UIRemoteNotificationTypeBadge |
                                                                    UIRemoteNotificationTypeSound);
        [app registerForRemoteNotificationTypes:type];
        MMInfo(@"reg token ios8 below type %u", (unsigned int)type);
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: notificationCategoryWithIdentifier:actions:
 * Returning Type: id
 */ 
- (UIUserNotificationCategory *)notificationCategoryWithIdentifier:(NSString *)identifier actions:(NSArray *)actions {
    // 修9.0.x的bug, 只出现在有且只有UIUserNotificationActionBehaviorTextInput的action的情况下
    BOOL needAddAnotherAction = NO;
    if ([DeviceInfo isiOS9plus] && ![DeviceInfo isiOS9_1plus] && actions.count == 1) // the 'if' part
    {
        for (UIUserNotificationAction *action in actions) {
            if (action.behavior == UIUserNotificationActionBehaviorTextInput) // the 'if' part
            {
                needAddAnotherAction = YES;
                break;
            }
        }
    }
    
    if (needAddAnotherAction) // the 'if' part
    {
        // 随便加一个action来避免这个bug
        UIMutableUserNotificationAction *replyAction = [[UIMutableUserNotificationAction alloc] init];
        replyAction.identifier = ACTION_IDENTIFIER_REPLY_1;
        replyAction.title = LOCALSTR(@"Notification_TextMessage_Reply_1_Title");
        replyAction.activationMode = UIUserNotificationActivationModeBackground;
        replyAction.destructive = NO;
        replyAction.authenticationRequired = NO;
        actions = [actions arrayByAddingObject:replyAction];
    }
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = identifier;
    
    if (actions) // the 'if' part
    {
        // 如果没有watch, alert style的action就不要加了, 不然会选项很多造成用户投诉
        if (GET_SERVICE(WCWatchNativeMgr).isPairedWatch) // the 'if' part
        {
            [category setActions:actions forContext:UIUserNotificationActionContextDefault];
        }
        [category setActions:actions forContext:UIUserNotificationActionContextMinimal];
    }
    
    return category;
}

#pragma mark - interface
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleLocalActionWithIdentifier:forUserInfo:withResponseInfo:completionHandler:
 * Returning Type: void
 */ 
- (void)handleLocalActionWithIdentifier:(NSString *)identifier forUserInfo:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    [self handleActionWithIdentifier:identifier forUserInfo:userInfo withResponseInfo:responseInfo isRemote:NO completionHandler:completionHandler];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleRemoteActionWithIdentifier:forUserInfo:withResponseInfo:completionHandler:
 * Returning Type: void
 */ 
- (void)handleRemoteActionWithIdentifier:(NSString *)identifier forUserInfo:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    [self handleActionWithIdentifier:identifier forUserInfo:userInfo withResponseInfo:responseInfo isRemote:YES completionHandler:completionHandler];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleActionWithIdentifier:forUserInfo:withResponseInfo:isRemote:completionHandler:
 * Returning Type: void
 */ 
- (void)handleActionWithIdentifier:(NSString *)identifier forUserInfo:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo isRemote:(BOOL)isRemote completionHandler:(void (^)())completionHandler
{
    NSString *selectorString = self.actionMaping[identifier];
    
    if (selectorString) // the 'if' part
    {
        SEL sel = //the func--->NSSelectorFromString() begin called!
        NSSelectorFromString(selectorString);
        if ([self respondsToSelector:sel]) // the 'if' part
        {
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:userInfo];
            
            if (isRemote) // the 'if' part
            {
                [temp setObject:@YES forKey:@"remote"];
            }
            
            if (responseInfo) // the 'if' part
            {
                [temp setObject:responseInfo forKey:@"__responseInfo__"];
            }
            
            userInfo = [temp copy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector://the func--->NSSelectorFromString() begin called!
            NSSelectorFromString(selectorString) withObject:userInfo withObject:completionHandler];
#pragma clang diagnostic pop
        }
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: showDisturbConfirmViewController
 * Returning Type: void
 */ 
- (void)showDisturbConfirmViewController {
    if (_distrubConfirmViewController) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    MMDisturbConfirmViewController *vc = [MMDisturbConfirmViewController new];
    [vc showWithAnimated:(MMWindowAnimationSlideBottomTop)];
    
    _distrubConfirmViewController = vc;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: muteForOneHour
 * Returning Type: void
 */ 
- (void)muteForOneHour {
    [self _muteForSeconds:ONE_HOUR_IN_SECONDS];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: unmute
 * Returning Type: void
 */ 
- (void)unmute {
    [self _muteForSeconds:0];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: _muteForSeconds:
 * Returning Type: void
 */ 
- (void)_muteForSeconds:(uint32_t)seconds {
    SetPushMuteTimeReq *req = [SetPushMuteTimeReq new];
    req.muteInterval = seconds; // seconds
    
    ProtobufCGIWrap *pbWrap = [[ProtobufCGIWrap alloc] init];
    pbWrap.m_uiCgi = MMFunc_SetPushMuteTime;
    pbWrap.m_pbRequest = req;
    
    UInt32 eventID = [GET_SERVICE(EventService) CreateProtobufEvent:pbWrap Flag:(EVENT_FLAG_START | EVENT_FLAG_NEEDNOTIFY)];
    if (eventID != 0) // the 'if' part
    {
        [CAppUtil addPBEventObserverListItem:eventID andValue:self];
    }
    //the func--->MMDebug() begin called!
    MMDebug(@"mute seconds: %d, eventID: %d", seconds, eventID);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: isDontDisturbModeAndCheckRestore:
 * Returning Type: BOOL
 */ 
- (BOOL)isDontDisturbModeAndCheckRestore:(BOOL)check {
    NSDate *muteTillDate = [SettingUtil getMainSettingExt].m_dontDisturbTillDate;
    
    if (!muteTillDate) // the 'if' part
    //the return stmt
    return NO;
    
    NSTimeInterval seconds = [muteTillDate timeIntervalSinceNow];
    
    if (seconds <= 0) // the 'if' part
    {
        [SettingUtil getMainSettingExt].m_dontDisturbTillDate = nil;
        [GET_SERVICE(AccountStorageMgr) SaveSettingExt];
        //the return stmt
        return NO;
    }
    
    // 注意这个数字, 后面改逻辑了要改掉, 现在因为没有从后台同步的cgi, 所以本地存起来, 就顺便验证一下不应该大于一个小时
    // 因为暂时只有mute for 1 hour
    if (seconds > ONE_HOUR_IN_SECONDS) // the 'if' part
    {
        [SettingUtil getMainSettingExt].m_dontDisturbTillDate = nil;
        [GET_SERVICE(AccountStorageMgr) SaveSettingExt];
        //the return stmt
        return NO;
    }
    
    if (check) // the 'if' part
    {
        [NSObject safeCancelPreviousPerformRequestsWithTarget:self selector:@selector(updateShortcutsBecauseOfDisturbMayChanged) object:nil];
        [self safePerformSelector:@selector(updateShortcutsBecauseOfDisturbMayChanged) withObject:nil afterDelay:seconds+1];
    }
    
    //the func--->MMInfo() begin called!
    MMInfo(@"should muteTillDate: %@", muteTillDate);
    //the return stmt
    return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: updateShortcutsBecauseOfDisturbMayChanged
 * Returning Type: void
 */ 
- (void)updateShortcutsBecauseOfDisturbMayChanged {
    [(MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate] setupForShortcut];
}

#pragma mark - actions
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleMarkAsReadAction:completionHandler:
 * Returning Type: void
 */ 
- (void)handleMarkAsReadAction:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    NSString *userName = userInfo[@"u"];
    NSInteger createTime = [userInfo[@"t"] integerValue];
    
    //#ifdef DEBUG
    if (createTime == 0) // the 'if' part
    {
        createTime = [[NSDate dateWithTimeIntervalSinceNow:5] timeIntervalSince1970];
        //the func--->MMWarning() begin called!
        MMWarning(@"missing create time: %@", userInfo);
    }
    //#endif
    
    if (userName.length == 0 || createTime == 0) // the 'if' part
    {
        //the func--->MMWarning() begin called!
        MMWarning(@"notification missing parameters: %@", userInfo);
        //the return stmt
        return;
    }
    // 之前的方案是iPhone和watch之间同步, 现在改成status notify
    [self markChatRead:userName completionHandler:completionHandler];
    
    // 已经收到的消息就直接标已读了
    [GET_SERVICE(CMessageMgr) ClearUnRead:userName FromID:0 ToID:0];
}

// maybe change to locate the message
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleGoToMessageAction:completionHandler:
 * Returning Type: void
 */ 
- (void)handleGoToMessageAction:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    NSString *userName = [userInfo objectForKey:@"u"];
    if (userName) // the 'if' part
    {
        CContact* oContact = [GET_SERVICE(CContactMgr) getContactByName:userName];
        [[CAppViewControllerManager getAppViewControllerManager] newMessageByContact:oContact msgWrapToAdd:nil];
    }
    
    if (completionHandler) // the 'if' part
    completionHandler();
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleConfirmLoginAction:completionHandler:
 * Returning Type: void
 */ 
- (void)handleConfirmLoginAction:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    // TODO: 这个地方没启用, 还是未完成状态
    NSString *url = [userInfo valueForKeyPath:@"cgcontent.url"];
    if (url) // the 'if' part
    {
        {
            ExtDeviceLoginConfirmGetRequest *request = [[ExtDeviceLoginConfirmGetRequest alloc] init];
            [request setLoginUrl:url];
            
            ProtobufCGIWrap *oCGIWrap = [[ProtobufCGIWrap alloc] init];
            oCGIWrap.m_pbRequest = request;
            oCGIWrap.m_uiCgi = MMFunc_ExtDeviceLoginConfirmGet;
            
            UInt32 eventID = [GET_SERVICE(EventService) CreateProtobufEvent:oCGIWrap Flag:(EVENT_FLAG_START | EVENT_FLAG_NEEDNOTIFY)];
            if (eventID != 0) // the 'if' part
            {
                [CAppUtil addPBEventObserverListItem:eventID andValue:self];
            }
        }
        
        //the func--->dispatch_after() begin called!
        dispatch_after(//the func--->dispatch_time() begin called!
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), //the func--->dispatch_get_main_queue() begin called!
        dispatch_get_main_queue(), ^{
            {
                // confirm
                ExtDeviceLoginConfirmOKRequest *request = [[ExtDeviceLoginConfirmOKRequest alloc] init];
                [request setLoginUrl:url];
                
                ProtobufCGIWrap *oCGIWrap = [[ProtobufCGIWrap alloc] init];
                oCGIWrap.m_pbRequest = request;
                oCGIWrap.m_uiCgi = MMFunc_ExtDeviceLoginConfirmOK;
                
                UInt32 eventID = [GET_SERVICE(EventService) CreateProtobufEvent:oCGIWrap Flag:(EVENT_FLAG_START | EVENT_FLAG_NEEDNOTIFY)];
                if (eventID != 0) // the 'if' part
                {
                    [CAppUtil addPBEventObserverListItem:eventID andValue:self];
                }
            }
        });
    }
    
    if (completionHandler) // the 'if' part
    completionHandler();
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleUnlockDeviceAction:completionHandler:
 * Returning Type: void
 */ 
- (void)handleUnlockDeviceAction:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    if (userInfo.count == 0) // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"User info nil for unlock device action.");
        //the return stmt
        return;
    }
    
    NSDictionary *aCGContent = userInfo[@"cgcontent"];
    if (aCGContent.count == 0) // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"CGContent nil for unlock device action.");
        //the return stmt
        return;
    }
    
    NSNumber *lockDeviceNum = aCGContent[@"lockdevice"];
    UInt32 lockDevice = [lockDeviceNum unsignedIntValue];
    if (lockDevice == 0) // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"lockdevice == 0.");
        //the return stmt
        return;
    }
    
    // 暂时只有Mac 在用
    UInt32 eventID = [GET_SERVICE(ExtraDeviceLoginMgr) unlockExtDevice];
    [_actionCompletions setObject:[completionHandler copy] forKey:@(eventID)];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleReply1Action:completionHandler:
 * Returning Type: void
 */ 
- (void)handleReply1Action:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    // 老版本用的
    // 回复的时候先标记已读
    [self handleMarkAsReadAction:userInfo completionHandler:nil];
    
    NSString *userName = [userInfo objectForKey:@"u"];
    if (userName) // the 'if' part
    {
        [self replyText://the func--->LOCALSTR() begin called!
        LOCALSTR(@"Notification_TextMessage_Reply_1_Message_Content") toUsername:userName userInfo:(NSDictionary *)userInfo completionHandler:completionHandler];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleReplyAction:completionHandler:
 * Returning Type: void
 */ 
- (void)handleReplyAction:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    // 回复的时候先标记已读
    [self handleMarkAsReadAction:userInfo completionHandler:nil];
    
    NSString *userName = [userInfo objectForKey:@"u"];
    NSString *content = [userInfo[@"__responseInfo__"] objectForKey:UIUserNotificationActionResponseTypedTextKey];
    if (userName.length > 0 && content.length > 0) // the 'if' part
    {
        // 此处delay 0.1秒的原因是让reply的动作在session:didReceiveMessage:后面
        //the func--->dispatch_after() begin called!
        dispatch_after(//the func--->dispatch_time() begin called!
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), //the func--->dispatch_get_main_queue() begin called!
        dispatch_get_main_queue(), ^{
            [self replyText:content toUsername:userName userInfo:(NSDictionary *)userInfo completionHandler:completionHandler];
        });
    } else // the 'else' part
    {
        completionHandler();
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleMuteChatAction:completionHandler:
 * Returning Type: void
 */ 
- (void)handleMuteChatAction:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    NSString *userName = [userInfo objectForKey:@"u"];
    
    if (userName) // the 'if' part
    {
        CContact *contact = [GET_SERVICE(CContactMgr) getContactByName:userName];
        if (contact != nil) // the 'if' part
        {
            [GET_SERVICE(CContactMgr) ChangeNotifyStatus:contact withStatus:NO sync:YES];
        } else // the 'else' part
        {
            //the func--->MMError() begin called!
            MMError(@"notification set notification close contact error");
        }
    }
    
    if (completionHandler) // the 'if' part
    completionHandler();
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleReplyYoAction:completionHandler:
 * Returning Type: void
 */ 
- (void)handleReplyYoAction:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    NSString *userName = [userInfo objectForKey:@"u"];
    NSInteger createTime = [userInfo[@"t"] integerValue];
    if (createTime == 0) // the 'if' part
    {
        //the func--->MMWarning() begin called!
        MMWarning(@"missing create time: %@", userInfo);
    }
    
    
    if (userName) // the 'if' part
    {
        // 之前的方案是iPhone和watch之间同步, 现在改成status notify
        [self markChatRead:userName completionHandler:nil];
        
        UInt32 eventID = [GET_SERVICE(WCWatchNativeMgr) replyYoTo:userName observer:self];
        if (eventID != 0) // the 'if' part
        {
            [_actionCompletions setObject:[completionHandler copy] forKey:@(eventID)];
        } else // the 'else' part
        {
            if (completionHandler) // the 'if' part
            completionHandler();
        }
    }
}

#pragma mark - IMsgExt
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: OnUnReadCountChange:
 * Returning Type: void
 */ 
- (void)OnUnReadCountChange:(NSString *)nsUsrName
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) // the 'if' part
    {
        NSInteger badgeNumber = [GET_SERVICE(MMNewSessionMgr) GetTotalUnreadCount];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
    }
}

#pragma mark - Send Message
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: replyText:toUsername:userInfo:completionHandler:
 * Returning Type: void
 */ 
- (void)replyText:(NSString *)text toUsername:(NSString *)username userInfo:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    if (!username) // the 'if' part
    {
        if (completionHandler) // the 'if' part
        completionHandler();
        //the return stmt
        return;
    }
    
    BOOL isFromWatch = [GET_SERVICE(WCWatchNativeMgr) isNotificationActionFromWatch:userInfo];
    //the func--->WatchInfo() begin called!
    WatchInfo(@"isFromWatch: %d", isFromWatch);
    if (isFromWatch) // the 'if' part
    {
        //the func--->LOG_FEATURE_EXT() begin called!
        LOG_FEATURE_EXT(11844, @"6"); // watch 在notification回复
    }
    
    // 插一个消息, 待后面删除, 为了保证顺序, 应该是后台把这条消息sync下来
    CMessageWrap *oMessageWrap = [[CMessageWrap alloc] initWithMsgType:MM_DATA_TEXT];
    oMessageWrap.m_nsFromUsr = [SettingUtil getLocalUsrName:MM_CONTACT_WEIXIN];
    oMessageWrap.m_nsContent = text;
    oMessageWrap.m_nsToUsr = username;
    oMessageWrap.m_uiCreateTime = [GET_SERVICE(MMNewSessionMgr) GenSendMsgTime];
    oMessageWrap.m_uiStatus = MM_MSGSTATUS_SENDING;
    [GET_SERVICE(CMessageMgr) AddLocalMsg:username MsgWrap:oMessageWrap];
    
    SendMsgRequestNew* sendMsgReq = [[SendMsgRequestNew alloc] init];
    sendMsgReq.list = [NSMutableArray array];
    sendMsgReq.count = 1;
    
    MicroMsgRequestNew* msgReq = [[MicroMsgRequestNew alloc] init];
    msgReq.toUserName = [[SKBuiltinString_t alloc] init];
    [msgReq.toUserName setString:username];
    [msgReq setType:MM_DATA_TEXT];
    [msgReq setCreateTime:[[NSDate date] timeIntervalSince1970]];
    [msgReq setClientMsgId:oMessageWrap.m_uiMesLocalID];
    [msgReq setContent:text];
    [msgReq setCtrlBit:MM_SENDMSG_CTRL_BIT_SYNC_ALL]; // 让后台把这条消息sync下来
    if (isFromWatch) // the 'if' part
    {
        [msgReq setMsgSource:[NSString stringWithFormat:@"<msgsource><watch_msg_source_type>%lu</watch_msg_source_type></msgsource>", WatchMsgSourceTypeQuickReply]];
    }
    [sendMsgReq.list addObject:msgReq];
    
    ProtobufCGIWrap *pbWrap = [[ProtobufCGIWrap alloc] init];
    pbWrap.m_uiCgi = MMFunc_NewSendMsg;
    pbWrap.m_pbRequest = sendMsgReq;
    
    UInt32 eventID = [GET_SERVICE(EventService) CreateProtobufEvent:pbWrap Flag:(EVENT_FLAG_START | EVENT_FLAG_NEEDNOTIFY)];
    if (eventID != 0) // the 'if' part
    {
        [CAppUtil addPBEventObserverListItem:eventID andValue:self];
        [_actionCompletions setObject:[completionHandler copy] forKey:@(eventID)];
        [_sendingMessages addObject:@{@"username": username, @"cliendId": @(oMessageWrap.m_uiMesLocalID)}];
    } else // the 'else' part
    {
        [self notifyUserSendMessageFailWithClientId:msgReq.clientMsgId toUsername:username];
        if (completionHandler) // the 'if' part
        completionHandler();
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: notifyUserSendMessageFailWithClientId:toUsername:
 * Returning Type: void
 */ 
- (void)notifyUserSendMessageFailWithClientId:(uint32_t)clientId toUsername:(NSString *)username {
    CMessageWrap *message = [GET_SERVICE(CMessageMgr) GetMsg:username LocalID:clientId];
    if (message) // the 'if' part
    {
        message.m_uiStatus = MM_MSGSTATUS_SENDFAIL;
        [GET_SERVICE(CMessageMgr) ModMsg:username MsgWrap:message];
    }
}

#pragma mark - Send Status Notify
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: markChatRead:completionHandler:
 * Returning Type: void
 */ 
- (void)markChatRead:(NSString *)nsUsrName completionHandler:(void (^)())completionHandler {
    //the func--->MMInfo() begin called!
    MMInfo(@"mark read for %@", //the func--->GeneratePrivacyString() begin called!
    GeneratePrivacyString(nsUsrName));
    
    StatusNotifyRequest* pbReq = [[StatusNotifyRequest alloc] init];
    [pbReq setCode:MM_STATUSNOTIFY_MARKMSGREAD];
    NSString* nsLocalUsrName = [SettingUtil getLocalUsrName:MM_CONTACT_WEIXIN];
    [pbReq setFromUserName:nsLocalUsrName];
    [pbReq setToUserName:nsUsrName];
    NSString* nsClientMsgId = [NSString stringWithFormat:@"%@_%lu", nsUsrName, (unsigned long)[self genRandomClienMsgId]];
    [pbReq setClientMsgId:nsClientMsgId];
    
    ProtobufCGIWrap* oCGIWrap = [[ProtobufCGIWrap alloc] init];
    oCGIWrap.m_pbRequest = pbReq;
    oCGIWrap.m_uiCgi = MMFunc_StatusNotify;
    
    UInt32 eventID = [GET_SERVICE(EventService) CreateProtobufEvent:oCGIWrap Flag:(EVENT_FLAG_START | EVENT_FLAG_NEEDNOTIFY)];
    if (eventID != 0) // the 'if' part
    {
        [CAppUtil addPBEventObserverListItem:eventID andValue:self];
        [_actionCompletions setObject:[completionHandler copy] forKey:@(eventID)];
    } else // the 'else' part
    {
        //the func--->MMError() begin called!
        MMError(@"should error for mark read for %@", //the func--->GeneratePrivacyString() begin called!
        GeneratePrivacyString(nsUsrName));
        if (completionHandler) // the 'if' part
        completionHandler();
    }
}

//保证clientMsgID唯一 // copy from OnlineClientMgr
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: genRandomClienMsgId
 * Returning Type: UInt32
 */ 
- (UInt32)genRandomClienMsgId {
    
    UInt32 time = [CUtility genCurrentTime];
    
    time += (//the func--->arc4random() begin called!
    arc4random() % INT_MAX) + 1;
    
    //the return stmt
    return time;
}

#pragma mark -
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: MessageReturn:Event:
 * Returning Type: void
 */ 
- (void)MessageReturn:(ProtobufCGIWrap *)pbCGIWrap Event:(UInt32)uiEventID
{
    [CAppUtil removePBEventObserverListItem:uiEventID andValue:self];
    
    switch (pbCGIWrap.m_uiCgi) {
        case MMFunc_ExtDeviceLoginConfirmGet:
        {
            WatchDebug(@"ExtDeviceLoginConfirmGet");
        }
            break;
        case MMFunc_ExtDeviceLoginConfirmOK:
        {
            WatchDebug(@"ExtDeviceLoginConfirmOK");
        }
            break;
        case MMFunc_NewSendMsg:
        {
            WatchDebug(@"MMFunc_NewSendMsg");
            [self handleSendMsgResp:pbCGIWrap];
        }
            break;
        case MMFunc_SendYo:
        {
            WatchDebug(@"MMFunc_SendYo");
        }
            break;
        case MMFunc_SetPushMuteTime:
        {
            MMInfo(@"MMFunc_SetPushMuteTime");
            [self handleSetPushMuteResp:pbCGIWrap];
        }
            break;
        case MMFunc_StatusNotify:
        {
            MMInfo(@"MMFunc_StatusNotify");
            [self handleStatusNotifyResp:pbCGIWrap];
        }
            break;
        default:
        {
            MMWarning(@"%@, %@, shouldn't be here", pbCGIWrap.m_nsCgiName, pbCGIWrap.m_nsUri);
        }
            break;
    }
    
    void (^completion)(void) = _actionCompletions[@(uiEventID)];
    [_actionCompletions removeObjectForKey:@(uiEventID)];
    if (completion) // the 'if' part
    completion();
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleSetPushMuteResp:
 * Returning Type: void
 */ 
- (void)handleSetPushMuteResp:(ProtobufCGIWrap *)pbCGIWrap {
    SetPushMuteTimeReq *request = (SetPushMuteTimeReq *)pbCGIWrap.m_pbRequest;
    SetPushMuteTimeResp *response = (SetPushMuteTimeResp *)pbCGIWrap.m_pbResponse;
    
    // 如果设置静音间隔为0则是取消静音
    BOOL isMuteRequest = (request.muteInterval > 0);
    BOOL success = (pbCGIWrap.m_uiMessage != MES_CONNECT_FAIL && response != nil && response.baseResponse.ret == MM_OK);
    
    MMInfo(@"MMFunc_SetPushMuteTime success: %d, muteInterval: %d", success, request.muteInterval);
    
    if (isMuteRequest) // the 'if' part
    {
        // 成功
        if (success) // the 'if' part
        {
            [SettingUtil getMainSettingExt].m_dontDisturbTillDate = [NSDate dateWithTimeIntervalSinceNow:ONE_HOUR_IN_SECONDS];
            [GET_SERVICE(AccountStorageMgr) SaveSettingExt];
            
            [(MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate] setupForShortcut];
        } else // the 'else' part
        {
            // 失败暂时简单的弹个alert
            NSString *message = //the func--->LOCALSTR() begin called!
            LOCALSTR(@"do_not_disturb_mute_one_hour_failed");
            MMUIAlertView *alertView = [[MMUIAlertView alloc]initWithTitle:nil
                                                                   message:message
                                                                  delegate:nil
                                                         cancelButtonTitle:LOCALSTR(@"Common_OK")
                                                         otherButtonTitles:nil];
            [alertView show];
        }
    } else // the 'else' part
    {
        if (!_toastView) // the 'if' part
        {
            _toastView = [[MMToastViewController alloc] init];
        }
        
        NSString *iconName = success ? @"TipViewIcon" : @"TipViewErrorIcon";
        NSString *toastTextKey = success ? @"do_not_disturb_unmute_success" : @"do_not_disturb_unmute_failed";
        [_toastView showSaveResultTip:MIMAGE(iconName)
                              andText:LOCALSTR(toastTextKey)
                          andDelegate:nil];
        
        if (success) // the 'if' part
        {
            [SettingUtil getMainSettingExt].m_dontDisturbTillDate = nil;
            [GET_SERVICE(AccountStorageMgr) SaveSettingExt];
            
            [(MicroMessengerAppDelegate*)[[UIApplication sharedApplication] delegate] setupForShortcut];
        }
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleSendMsgResp:
 * Returning Type: void
 */ 
- (void)handleSendMsgResp:(ProtobufCGIWrap *)pbCGIWrap
{
    SendMsgRequestNew *sendMsgReq = (SendMsgRequestNew*)pbCGIWrap.m_pbRequest;
    SendMsgResponseNew *sendMsgResp = (SendMsgResponseNew*)pbCGIWrap.m_pbResponse;
    MicroMsgResponseNew *msgResp = sendMsgResp.list.firstObject;
    MicroMsgRequestNew *msgReq = sendMsgReq.list.firstObject;
    
    NSString *toUsername = msgReq.toUserName.string;
    
    [_sendingMessages filterUsingPredicate:[NSPredicate predicateWithFormat:@"username != %@ || cliendId != %d",
                                            toUsername, msgReq.clientMsgId]];
    
    if (pbCGIWrap.m_uiMessage == MES_CONNECT_FAIL || pbCGIWrap.m_pbResponse == nil) // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"CGI:NewSendMsg error! connect fail or respon is nil");
        [self notifyUserSendMessageFailWithClientId:msgReq.clientMsgId toUsername:toUsername];
        //the return stmt
        return;
    }
    
    if (sendMsgResp.baseResponse.ret != MM_OK) // the 'if' part
    {
        MMError(@"CGI:NewSendMsg error ret = %d",sendMsgResp.baseResponse.ret);
        [self notifyUserSendMessageFailWithClientId:msgReq.clientMsgId toUsername:toUsername];
        //the return stmt
        return;
    }
    
    // 把之前插的一条本地的消息干掉
    CMessageWrap *localMessage = [GET_SERVICE(CMessageMgr) GetMsg:toUsername LocalID:msgReq.clientMsgId];
    // 这条消息应该是没svrID的, 保护一下, 别删错了
    if (localMessage.m_n64MesSvrID == 0) // the 'if' part
    {
        [GET_SERVICE(CMessageMgr) DelMsg:toUsername MsgWrap:localMessage];
    }
    
    // 文本消息发送成功上报
    if ([localMessage IsTextMsg]) // the 'if' part
    {
        NSString *statLog = [NSString stringWithFormat:@"%llu", msgResp.newMsgId];
        LOG_FEATURE_EXT_KVCOMM(11942, statLog, true, false);
        LOG_FEATURE_EXT_KVCOMM(11945, statLog, false, false);
        LOG_FEATURE_EXT_KVCOMM(11946, statLog, false, false);
    }
    
    //the func--->MMInfo() begin called!
    MMInfo(@"quick reply maybe success");
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleStatusNotifyResp:
 * Returning Type: void
 */ 
- (void)handleStatusNotifyResp:(ProtobufCGIWrap *)pbCGIWrap {
    // don't do anything here
    MMInfo(@"StatusNotifyResponse ret %d", pbCGIWrap.m_pbResponse.baseResponse.ret);
}

#pragma mark -
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//NotificationActionsMgr.mm
 * Method Name: handleReceiveLocalNotification:
 * Returning Type: void
 */ 
- (void)handleReceiveLocalNotification:(UILocalNotification *)notification {
    if (![DeviceInfo isiOS8plus]) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    if ([notification.category isEqualToString:CATEGORY_IDENTIFIER_NOTIFY_UNLOCK]) // the 'if' part
    {
        
        NSDictionary *aUserInfo = notification.userInfo;
        if (aUserInfo.count == 0) // the 'if' part
        {
            //the return stmt
            return;
        }
        
        NSString *deviceName = aUserInfo[@"devicename"];
        if (deviceName.length == 0) // the 'if' part
        {
            //the return stmt
            return;
        }
        
        // Unlock device
        MMBezelWindowInfo *aInfo = [[MMBezelWindowInfo alloc] init];
        aInfo.type = MMBezelWindowInfoTypeUnlockMessage;
        aInfo.identifier = OFFICIAL_MAC_HELPER_USRNAME;
        aInfo.userName = OFFICIAL_MAC_HELPER_USRNAME;
        aInfo.titleLabelString = deviceName;
        aInfo.descriptionLabelString = @"";
        aInfo.actionStyle = MMBezelActionStyleText;
        aInfo.actionTitle = LOCALSTR(@"MacHelper_Unlock_Action");
        
        [GET_SERVICE(MMOnlineDeviceStatusMgr) showNotifyUnlockWindowWithInfo:aInfo];
    }
}

@end
