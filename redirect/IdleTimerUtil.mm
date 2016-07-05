//
//  IdleTimerUtil.m
//  MicroMessenger
//
//  Created by yuki－no－mac on 15/2/6.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "IdleTimerUtil.h"
#import "VoipUIManager.h"
#import "MonoServiceLogic.h"

#ifndef CLEARTEST

//请不要自己手动调用这个方法
@interface UIApplication (CustomIdleTimer)

-(void) customSetIdleTimerDisable:(BOOL) disable;

@end

@implementation UIApplication (CustomIdleTimer)

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//IdleTimerUtil.mm
 * Method Name: customSetIdleTimerDisable:
 * Returning Type: void
 */ 
-(void) customSetIdleTimerDisable:(BOOL)disable
{
    //the func--->MMError() begin called!
    MMError(@"please do not directly invoke this timer method.");
    //the return stmt
    return;
}

@end

#endif


@implementation IdleTimerUtil

#ifndef CLEARTEST
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//IdleTimerUtil.mm
 * Method Name: load
 * Returning Type: void
 */ 
+(void) load
{
    [IdleTimerUtil replace_method:[UIApplication class] originSel:@selector(setIdleTimerDisabled:) customSel:@selector(customSetIdleTimerDisable:)];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//IdleTimerUtil.mm
 * Method Name: replace_method:originSel:customSel:
 * Returning Type: void
 */ 
+(void) replace_method:(Class) nameOfClass originSel:(SEL) originSel customSel:(SEL) customSel
{
    Method origInstanceMethod = class_getInstanceMethod(nameOfClass, originSel);
    Method newInstanceMethod  = class_getInstanceMethod(nameOfClass, customSel);
    if( class_addMethod(nameOfClass, originSel, method_getImplementation(newInstanceMethod), method_getTypeEncoding(newInstanceMethod)))
    // the 'if' part
    {
        class_replaceMethod(nameOfClass, customSel, method_getImplementation(origInstanceMethod), method_getTypeEncoding(origInstanceMethod));
    }
    else
    // the 'else' part
    {
        method_exchangeImplementations(origInstanceMethod, newInstanceMethod);
    }

}
#endif

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//IdleTimerUtil.mm
 * Method Name: SetIdleTimeDisable:
 * Returning Type: void
 */ 
+(void) SetIdleTimeDisable:(BOOL)disable
{
    if ([NSThread isMainThread] == NO)
    // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"please perform this function in main thread.");
        //the return stmt
        return;
    }
    
    if ([MonoServiceLogic isAudioMonoServiceWorking])
    // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"MonoServiceLogic is running, cannot interact idle timer.");
        //the return stmt
        return;
    }
    
    //the func--->MMInfo() begin called!
    MMInfo(@"set idle time disable:%d", disable);
    
#ifndef CLEARTEST
    [[UIApplication sharedApplication] customSetIdleTimerDisable:disable];
#else
    [UIApplication sharedApplication].idleTimerDisabled = disable;
#endif
}

@end
