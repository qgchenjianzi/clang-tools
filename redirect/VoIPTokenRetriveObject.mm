//
//  VoIPTokenRetriveObject.m
//  MicroMessenger
//
//  Created by yukiyylin on 15/12/21.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "VoIPTokenRetriveObject.h"

#import <PushKit/PushKit.h>
#import "MMKernelExt.h"

#import "VoIPPushKitExt.h"
#import "VoIPTokenRegisterObject.h"
#import "VoIPPushDef.h"
#import "VoIPTokenIDkeyReport.h"
#import "AppUtil.h"


@interface VoIPTokenRetriveObject ()<PKPushRegistryDelegate, MMKernelExt, VoIPTokenRegisterObjectDelegate>

@property(nonatomic, strong) VoIPTokenRegisterObject* m_register;
@property(nonatomic, strong) VoIPTokenRegisterObject* m_secondTryRegister;
@property(nonatomic, strong) PKPushRegistry* m_tokenRetriver;

@property(nonatomic, strong) NSData* m_token;

@end

@implementation VoIPTokenRetriveObject

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: dealloc
 * Returning Type: void
 */ 
-(void) dealloc
{
    UNREGISTER_EXTENSION(MMKernelExt, self);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: init
 * Returning Type: id
 */ 
-(id) init
{
    self = [super init];
    if (self)
    // the 'if' part
    {
        REGISTER_EXTENSION(MMKernelExt, self);
    }
    
    //the return stmt
    return self;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: voipRegistration
 * Returning Type: void
 */ 
- (void) voipRegistration
{
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @".");
    if ([DeviceInfo isiOS8_1plus] == NO)
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"lower than iOS 8.1");
        //the return stmt
        return;
    }
    
    self.m_tokenRetriver = [[PKPushRegistry alloc] initWithQueue: dispatch_get_main_queue()];
    self.m_tokenRetriver.delegate = self;
    self.m_tokenRetriver.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    [VoIPTokenIDkeyReport registerPushKit];
}

#pragma mark - PKPushRegistryDelegate

//收到了apple返回的token
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: pushRegistry:didUpdatePushCredentials:forType:
 * Returning Type: void
 */ 
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)tempType
{
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @".");
    MMInfoWithModule(VoIPPushKit, @"\n{\n callType = %@ \n pushtype = %@, \n voip token = %@ \n}", tempType, credentials.type, credentials.token);
    if ([tempType isEqualToString:PKPushTypeVoIP] == NO)
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"callback type not voip.");
        [VoIPTokenIDkeyReport tokenCallbackNotVoipType];
        //the return stmt
        return;
    }
    
    if ([credentials.type isEqualToString:PKPushTypeVoIP] == NO)
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"credential type not voip.");
        [VoIPTokenIDkeyReport tokenCallbackTokenNotVoipType];
        //the return stmt
        return;
    }
    
    self.m_token = credentials.token;
    [VoIPTokenIDkeyReport tokenCallbackTokenTypeOk];
    
    if ([CAppUtil isLogin])
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"already login, go register.");
        [self goRegister];
    }
}

//apple服务器推送了push
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: pushRegistry:didReceiveIncomingPushWithPayload:forType:
 * Returning Type: void
 */ 
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)tempType
{
    MMInfoWithModule(VoIPPushKit, @"\n{\n callType = %@ \n payloadType = %@ \n payloadInfo = %@ \n}", tempType, payload.type, payload.dictionaryPayload);
    
    if (payload.dictionaryPayload.count == 0)
    // the 'if' part
    {
        //the func--->MMErrorWithModule() begin called!
        MMErrorWithModule(VoIPPushKit, @"info count == 0.");
        [VoIPTokenIDkeyReport pushReceiveContentEmpty];
        //the return stmt
        return;
    }
    
    NSString* tempCmdString = [payload.dictionaryPayload objectForKey:VoIPPushKit_Info_Cmd];
    if ([tempCmdString isKindOfClass:[NSString class]] == NO)
    // the 'if' part
    {
        //the func--->MMErrorWithModule() begin called!
        MMErrorWithModule(VoIPPushKit, @"not NSString.");
        [VoIPTokenIDkeyReport pushReceiveCmdTypeError];
        //the return stmt
        return;
    }
    
    if (tempCmdString.length == 0)
    // the 'if' part
    {
        //the func--->MMErrorWithModule() begin called!
        MMErrorWithModule(VoIPPushKit, @"tempCmdString.length == 0.");
        [VoIPTokenIDkeyReport pushReceiveCmdEmpty];
        //the return stmt
        return;
    }

    [VoIPTokenIDkeyReport pushReceiveBroadcast];
    SAFECALL_KEY_EXTENSION(VoIPPushKitExt, tempCmdString, @selector(onReceiveVoIPPushInfo:), onReceiveVoIPPushInfo:payload.dictionaryPayload);
}

//apple服务器返回：push token 已经失效。
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: pushRegistry:didInvalidatePushTokenForType:
 * Returning Type: void
 */ 
- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type
{
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @"push token is invalidate.");
    [VoIPTokenIDkeyReport tokenCallbackTokenInvaildate];
}


#pragma mark - private method

//启动注册cgi
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: goRegister
 * Returning Type: void
 */ 
-(void) goRegister
{
    if (self.m_register != nil)
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"register is exist.");
        //the return stmt
        return;
    }
    
    if ([DeviceInfo isiOS8_1plus] == NO)
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"ios version below 8.1.");
        //the return stmt
        return;
    }
    
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @"register to wechat server.");
    if (self.m_token.length == 0)
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"token == nil. using cache token.");
        self.m_token = [self.m_tokenRetriver pushTokenForType:PKPushTypeVoIP];
        [VoIPTokenIDkeyReport tokenRegisterUsingCacheToken];
        
        if (self.m_token.length == 0)
        // the 'if' part
        {
            //the func--->MMInfoWithModule() begin called!
            MMInfoWithModule(VoIPPushKit, @"cache token == nil.");
            [VoIPTokenIDkeyReport tokenRegisterCacheTokenNil];
            //the return stmt
            return;
        }
    }
    
    //按照上面的逻辑，已经保证，能够生成register的时候，必定已经有了token
    self.m_register = [[VoIPTokenRegisterObject alloc] initWithToken:self.m_token];
    self.m_register.m_delegate = self;
    [self.m_register startRequest];
}

#pragma mark - MMKernelExt

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: onAuthOK
 * Returning Type: void
 */ 
- (void)onAuthOK
{
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @"auth ok try go register.");
    //auth ok 之后，尝试注册一次
    [self goRegister];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: onPreQuit
 * Returning Type: void
 */ 
-(void)onPreQuit
{
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @"pre quit, clear logic.");
    //退出登录，清空数据
    self.m_register = nil;
    self.m_secondTryRegister = nil;
}

#pragma mark - VoIPTokenRegisterObjectDelegate
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: onVoIPTokenRegisterObjectError
 * Returning Type: void
 */ 
-(void) onVoIPTokenRegisterObjectError
{
    //遇到cgi错误，清空cgi信息
    //the func--->MMErrorWithModule() begin called!
    MMErrorWithModule(VoIPPushKit, @"register error. try register again.");
    self.m_register = nil;
    
    //重试一次，不需要设置delegate，不然就是死循环了
    self.m_secondTryRegister = [[VoIPTokenRegisterObject alloc] initWithToken:self.m_token];
    [self.m_secondTryRegister startRequest];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRetriveObject.mm
 * Method Name: onVoIPTokenRegisterObjectOk
 * Returning Type: void
 */ 
-(void) onVoIPTokenRegisterObjectOk
{
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @"register ok, clear register.");
    self.m_register = nil;
    self.m_secondTryRegister = nil;
}

@end
