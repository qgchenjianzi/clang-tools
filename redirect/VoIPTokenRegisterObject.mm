//
//  VoIPTokenRegisterObject.m
//  MicroMessenger
//
//  Created by yukiyylin on 15/12/21.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "VoIPTokenRegisterObject.h"
#import "mmlogin.pb.h"
#import "mmprotodef.h"
#import "AppUtil.h"
#import "VoIPPushKitExt.h"
#import "VoIPPushDef.h"
#import "VoIPTokenIDkeyReport.h"

@interface VoIPTokenRegisterObject ()<PBMessageObserverDelegate>

@property(nonatomic, strong) NSData* m_token;

@end

@implementation VoIPTokenRegisterObject
@synthesize m_token;

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRegisterObject.mm
 * Method Name: initWithToken:
 * Returning Type: id
 */ 
-(id) initWithToken:(NSData*) tempToken
{
    self = [super init];
    if (self)
    // the 'if' part
    {
        self.m_token = tempToken;
    }
    
    //the return stmt
    return self;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRegisterObject.mm
 * Method Name: startRequest
 * Returning Type: void
 */ 
-(void) startRequest
{
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @".");
    if (self.m_token.length == 0)
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"token.length == 0");
        [VoIPTokenIDkeyReport tokenRegisterTokenEmpty];
        
        [self callErrorDelegate];
        //the return stmt
        return;
    }
    
    NSString* tempToken = [[NSString alloc] initWithFormat:@"%@", self.m_token];
    IphoneRegRequest* request = [[IphoneRegRequest alloc] init];
    request.token = tempToken;
    
    request.sound = DEFAULT_MSG_PUSH_SOUND;
    request.voipSound = DEFAULT_VOIP_PUSH_SOUND;
    
    request.status = 0;
    
    //rdm和正式版本分开
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleID isEqualToString:VoIPPushKit_BundleId_AppleStore])
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"using AppleStore bundle id.");
        request.tokenCert = MM_APNS_TOKEN_CERT_APPSTORE_VOIP;
        [VoIPTokenIDkeyReport tokenRegisterCertAppStore];
    }
    else // the 'else' part
    if([bundleID isEqualToString:VoIPPushKit_BundleId_RDM])
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"using RDM bundle id.");
        request.tokenCert = MM_APNS_TOKEN_CERT_RDM_VOIP;
        [VoIPTokenIDkeyReport tokenRegisterCertWC];
    }
    
    request.tokenEnv = MM_APNS_TOKEN_ENV_PRODUCTION;
    
#ifdef DEBUG
    if ([CAppUtil isProductionSignature] == NO &&
        [bundleID isEqualToString:VoIPPushKit_BundleId_RDM])
    {
        MMInfoWithModule(VoIPPushKit, @"using sandbox.");
        request.tokenEnv = MM_APNS_TOKEN_ENV_SANDBOX;
        [VoIPTokenIDkeyReport tokenRegisterSettingSandbox];
    }
#else
    
    [VoIPTokenIDkeyReport tokenRegisterSettingAppStore];
    
#endif
    
    
    
    request.tokenScene = MM_APNS_TOKEN_SCENE_VOIP;
    
    MMInfoWithModule(VoIPPushKit, @"request:\n{\n sound = %@ \n voipSound = %@ \n status = %d \n tokenCert = %d, tokenEnv = %d, tokenScene = %d, token = %@ \n}", request.sound, request.voipSound, request.status, request.tokenCert, request.tokenEnv, request.tokenScene, request.token);
    
    ProtobufCGIWrap* tempWrap = [[ProtobufCGIWrap alloc] init];
    tempWrap.m_pbRequest = request;
    tempWrap.m_uiCgi = MMFunc_IphoneReg;
    
    UInt32 tempEventId = [GET_SERVICE(EventService) CreateProtobufEvent:tempWrap Flag:(EVENT_FLAG_START | EVENT_FLAG_NEEDNOTIFY)];
    if (tempEventId == 0)
    // the 'if' part
    {
        //the func--->MMInfoWithModule() begin called!
        MMInfoWithModule(VoIPPushKit, @"create event failed.");
        [VoIPTokenIDkeyReport tokenRegisterCgiCreateError];
        
        [self callErrorDelegate];
        //the return stmt
        return;
    }
    
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @"create event ok.");
    [CAppUtil addPBEventObserverListItem:tempEventId andValue:self];
    [VoIPTokenIDkeyReport tokenRegisterCgiSent];
}

#pragma mark - PBMessageObserverDelegate

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRegisterObject.mm
 * Method Name: MessageReturn:Event:
 * Returning Type: void
 */ 
-(void) MessageReturn:(ProtobufCGIWrap*)pbCGIWrap Event:(UInt32)uiEventID
{
    [CAppUtil removePBEventObserverListItem:uiEventID andValue:self];
    if (pbCGIWrap == nil)
    // the 'if' part
    {
        //the func--->MMErrorWithModule() begin called!
        MMErrorWithModule(VoIPPushKit, @"pbCGIWrap == nil.");
        [VoIPTokenIDkeyReport tokenRegisterCgiCallbackEmpty];
        
        [self callErrorDelegate];
        //the return stmt
        return;
    }
    
    if (pbCGIWrap.m_uiMessage == MES_CONNECT_FAIL)
    // the 'if' part
    {
        //the func--->MMErrorWithModule() begin called!
        MMErrorWithModule(VoIPPushKit, @"m_uiMessage == MES_CONNECT_FAIL");
        [VoIPTokenIDkeyReport tokenRegisterCgiConnectTimeout];
        
        [self callErrorDelegate];
        //the return stmt
        return;
    }
    
    IphoneRegResponse* resp = (IphoneRegResponse*) pbCGIWrap.m_pbResponse;
    if (resp == nil)
    // the 'if' part
    {
        //the func--->MMErrorWithModule() begin called!
        MMErrorWithModule(VoIPPushKit, @"resp == nil");
        [VoIPTokenIDkeyReport tokenRegisterCgiResponseEmpty];
        
        [self callErrorDelegate];
        //the return stmt
        return;
    }
    
    if (resp.baseResponse.ret != MM_OK)
    // the 'if' part
    {
        //the func--->MMErrorWithModule() begin called!
        MMErrorWithModule(VoIPPushKit, @"resp.baseResponse.ret != MM_OK.");
        [VoIPTokenIDkeyReport tokenRegisterCgiResponseError];
        
        [self callErrorDelegate];
        //the return stmt
        return;
    }
    
    //the func--->MMInfoWithModule() begin called!
    MMInfoWithModule(VoIPPushKit, @"cgi ok!");
    [VoIPTokenIDkeyReport tokenRegisterCgiResponseOk];
    
    [self callOkDelegate];
}


#pragma mark - delegate
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRegisterObject.mm
 * Method Name: callErrorDelegate
 * Returning Type: void
 */ 
-(void) callErrorDelegate
{
    if ([self.m_delegate respondsToSelector:@selector(onVoIPTokenRegisterObjectError)])
    // the 'if' part
    {
        [self.m_delegate onVoIPTokenRegisterObjectError];
    }
}


/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//VoIPTokenRegisterObject.mm
 * Method Name: callOkDelegate
 * Returning Type: void
 */ 
-(void) callOkDelegate
{
    if ([self.m_delegate respondsToSelector:@selector(onVoIPTokenRegisterObjectOk)])
    // the 'if' part
    {
        [self.m_delegate onVoIPTokenRegisterObjectOk];
    }
}

@end
