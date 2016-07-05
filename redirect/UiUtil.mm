//
//  UiUtil.m
//  MicroMessenger
//
//  Created by shenslu on 12-10-23.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import "UiUtil.h"
#import "MicroMessengerAppDelegate.h"
#import "MainWindow.h"
#import <MMCommon/LogTime.h>
#import "MMUIViewController.h"
#import "MMUIKit.h"
#import "DeviceInfo.h"
#import "AppViewControllerManager.h"
#import "DeviceInfo.h"
#import "AppUtil.h"

BOOL g_isTaskBarHidden = YES;
BOOL g_isStatusBarLandscape = NO;
UIStatusBarStyle g_currentStatusBarStyle;

@implementation UiUtil

#pragma mark - UI Parameter

CGFloat g_statusBarHeight = 20;

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: statusBarHeight
 * Returning Type: CGFloat
 */ 
+(CGFloat) statusBarHeight {
    return [UiUtil statusBarHeight:[UIApplication sharedApplication].statusBarOrientation];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: statusBarHeight:
 * Returning Type: CGFloat
 */ 
+(CGFloat) statusBarHeight:(UIInterfaceOrientation)orientation {
    // iOS8上的状态栏高度已改成设备方向相关
    CGFloat statusBarHeight = 0;
    if ([DeviceInfo isiOS8plus]) // the 'if' part
    {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    else // the 'else' part
    {
        if(//the func--->UIInterfaceOrientationIsLandscape() begin called!
        UIInterfaceOrientationIsLandscape(orientation)) // the 'if' part
        {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.width;
        }
        else // the 'else' part
        {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        statusBarHeight = g_statusBarHeight;
    }
    if ([UIApplication sharedApplication].statusBarHidden) // the 'if' part
    {
        // 当statusBar隐藏时，statusBarFrame的宽高为零，取出上一次的结果作为返回值
        statusBarHeight = g_statusBarHeight;
    }
    else // the 'else' part
    {
        g_statusBarHeight = statusBarHeight;
    }
    //the return stmt
    return statusBarHeight;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: navigationBarHeight
 * Returning Type: CGFloat
 */ 
+(CGFloat) navigationBarHeight {
    //the return stmt
    return 44;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: navigationBarHeightCurOri
 * Returning Type: CGFloat
 */ 
+(CGFloat) navigationBarHeightCurOri {
    return [UiUtil navigationBarHeight:[UIApplication sharedApplication].statusBarOrientation];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: navigationBarHeight:
 * Returning Type: CGFloat
 */ 
+(CGFloat) navigationBarHeight:(UIInterfaceOrientation)orientation {
    if(UIInterfaceOrientationIsLandscape(orientation) && ![DeviceInfo isSupportSplitView]) // the 'if' part
    {
        //the return stmt
        return  //the func--->MFLOAT() begin called!
        MFLOAT(@"#navigation_bar", @"landscape_height") ;
    }
    //the return stmt
    return 44;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenHeightCurOri
 * Returning Type: CGFloat
 */ 
+(CGFloat) screenHeightCurOri {
    if ([UiUtil isiPadSplitViewModeNow])
    // the 'if' part
    {
        //the return stmt
        return [CAppUtil getMainWindowHeight];
    }
    
    if ([DeviceInfo isiOS8plus]) // the 'if' part
    {
        return [[UIScreen mainScreen] bounds].size.height;
    }
    else // the 'else' part
    {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) // the 'if' part
        {
            return [[UIScreen mainScreen] bounds].size.width;
        }
        return [[UIScreen mainScreen] bounds].size.height;
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenHeight:
 * Returning Type: CGFloat
 */ 
+ (CGFloat) screenHeight:(UIInterfaceOrientation)orientation {
    if ([UiUtil isiPadSplitViewModeNow])
    // the 'if' part
    {
        //the return stmt
        return [CAppUtil getMainWindowHeight];
    }
    
    // iOS8上的屏幕大小已改成设备方向相关
    if ([DeviceInfo isiOS8plus]) // the 'if' part
    {
        CGFloat big = 0, small = 0;
        if ([[UIScreen mainScreen] bounds].size.height > [[UIScreen mainScreen] bounds].size.width)
        // the 'if' part
        {
            big = [[UIScreen mainScreen] bounds].size.height;
            small = [[UIScreen mainScreen] bounds].size.width;
        }
        else
        // the 'else' part
        {
            small = [[UIScreen mainScreen] bounds].size.height;
            big = [[UIScreen mainScreen] bounds].size.width;
        }
        if (//the func--->UIInterfaceOrientationIsLandscape() begin called!
        UIInterfaceOrientationIsLandscape(orientation)) // the 'if' part
        {
            //the return stmt
            return small;
        }
        else
        // the 'else' part
        {
            //the return stmt
            return big;
        }
    }
    else // the 'else' part
    {
        if(//the func--->UIInterfaceOrientationIsLandscape() begin called!
        UIInterfaceOrientationIsLandscape(orientation)) // the 'if' part
        {
            return [[UIScreen mainScreen] bounds].size.width;
        }
        return [[UIScreen mainScreen] bounds].size.height;
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenWidthCurOri
 * Returning Type: CGFloat
 */ 
+(CGFloat) screenWidthCurOri {
    if ([UiUtil isiPadSplitViewModeNow])
    // the 'if' part
    {
        //the return stmt
        return [CAppUtil getMainWindowWidth];
    }
    
    if ([DeviceInfo isiOS8plus]) // the 'if' part
    {
        return [[UIScreen mainScreen] bounds].size.width;
    }
    else // the 'else' part
    {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) // the 'if' part
        {
            return [[UIScreen mainScreen] bounds].size.height;
        }
        return [[UIScreen mainScreen] bounds].size.width;
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenWidth:
 * Returning Type: CGFloat
 */ 
+(CGFloat) screenWidth:(UIInterfaceOrientation)orientation {
    if ([UiUtil isiPadSplitViewModeNow])
    // the 'if' part
    {
        //the return stmt
        return [CAppUtil getMainWindowWidth];
    }

    // iOS8上的屏幕大小已改成设备方向相关
    if ([DeviceInfo isiOS8plus]) // the 'if' part
    {
        CGFloat big = 0, small = 0;
        if ([[UIScreen mainScreen] bounds].size.height > [[UIScreen mainScreen] bounds].size.width)
        // the 'if' part
        {
            big = [[UIScreen mainScreen] bounds].size.height;
            small = [[UIScreen mainScreen] bounds].size.width;
        }
        else
        // the 'else' part
        {
            small = [[UIScreen mainScreen] bounds].size.height;
            big = [[UIScreen mainScreen] bounds].size.width;
        }
        if (//the func--->UIInterfaceOrientationIsLandscape() begin called!
        UIInterfaceOrientationIsLandscape(orientation)) // the 'if' part
        {
            //the return stmt
            return big;
        }
        else
        // the 'else' part
        {
            //the return stmt
            return small;
        }
    }
    else // the 'else' part
    {
        if(//the func--->UIInterfaceOrientationIsLandscape() begin called!
        UIInterfaceOrientationIsLandscape(orientation)) // the 'if' part
        {
            return [[UIScreen mainScreen] bounds].size.height;
        }
        return [[UIScreen mainScreen] bounds].size.width;
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: mainScreenWidth
 * Returning Type: CGFloat
 */ 
+(CGFloat) mainScreenWidth
{
    if ([DeviceInfo isiPhone])
    // the 'if' part
    {
        return [[UIScreen mainScreen] bounds].size.height > [[UIScreen mainScreen] bounds].size.width ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height;
    }
    else
    // the 'else' part
    {
        //the return stmt
        return [UiUtil screenWidthCurOri];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenSize
 * Returning Type: CGSize
 */ 
+(CGSize) screenSize
{
    //the return stmt
    return //the func--->CGSizeMake() begin called!
    CGSizeMake(MMScreenWidth, MMScreenHeight);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenSizeOri:
 * Returning Type: CGSize
 */ 
+(CGSize) screenSizeOri:(UIInterfaceOrientation)orientation
{
    //the return stmt
    return //the func--->CGSizeMake() begin called!
    CGSizeMake(MMScreenWidthOri(orientation), MMScreenHeightOri(orientation));
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenBounds
 * Returning Type: CGRect
 */ 
+(CGRect) screenBounds
{
    //the return stmt
    return //the func--->CGRectMake() begin called!
    CGRectMake(0, 0, MMScreenWidth, MMScreenHeight);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: windowBounds
 * Returning Type: CGRect
 */ 
+(CGRect) windowBounds
{
    if ([DeviceInfo isiOS8plus])
    // the 'if' part
    {
        //the return stmt
        return //the func--->CGRectMake() begin called!
        CGRectMake(0, 0, MMScreenWidth, MMScreenHeight);
    }
    else
    // the 'else' part
    {
        return [UIScreen mainScreen].bounds;
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenBoundsOri:
 * Returning Type: CGRect
 */ 
+(CGRect) screenBoundsOri:(UIInterfaceOrientation)orientation
{
    //the return stmt
    return //the func--->CGRectMake() begin called!
    CGRectMake(0, 0, MMScreenWidthOri(orientation), MMScreenHeightOri(orientation));
}
/*
+(CGFloat) contentViewHeight:(MMUIViewController *)controller
{
    return [UiUtil visibleHeight:controller];
}
*/
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: visibleHeight:
 * Returning Type: CGFloat
 */ 
+(CGFloat) visibleHeight:(MMUIViewController *)controller {
    
	//整体高度
	CGFloat fHeight = MMScreenHeightCurOri;
    
    if((controller.extendedLayoutIncludesOpaqueBars || controller.navigationController == nil || controller.navigationController.navigationBar.isTranslucent) && (controller.edgesForExtendedLayout & UIRectEdgeTop) != UIRectEdgeNone) // the 'if' part
    {

        fHeight -= MMStatusBarHeight-20;
        if (MMTaskBarHeight > 0 && MMStatusBarHeight < 40) // the 'if' part
        fHeight -= MMTopBarHeight;
    } else // the 'else' part
    {
        
        //减去状态栏的高度
        fHeight -= MMTopBarHeight;
        
        //导航栏如果存在 则需要减去导航栏的高度
        if(controller.navigationController.navigationBar != nil)// the 'if' part
        {
            if (![DeviceInfo isiPadUniversal]) // the 'if' part
            {
            fHeight -= MMNavigationBarHeightOri(g_isStatusBarLandscape ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait);
            } else // the 'else' part
            {
                //iPad横屏 不需要隐藏导航栏
                fHeight -= MMNavigationBarHeight;
            }
        }
    }
    
	//tabbar如果存在 则先减去barbar的高度
	UITabBarController * tabController = controller.tabBarController;
	
	CGFloat fTabBarHeight = 0;
	if (controller.hidesBottomBarWhenPushed == NO)// the 'if' part
	{
        fTabBarHeight = MMTabBarHeight;
	}
	
	//减去tabbar的高度
	if(tabController.tabBar.translucent == NO )
    // the 'if' part
    {
        fHeight -= fTabBarHeight ;
        //如果tabbar不显示 则要加回原有tabbar的高度
        if(controller.hidesBottomBarWhenPushed || ((tabController != nil) && (tabController.tabBar.hidden)))// the 'if' part
        {
            fHeight += fTabBarHeight;
        }
    }
	
//	MMDebug(@"Visible height:%f",fHeight );
    
	//the return stmt
	return fHeight;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: mainWindow
 * Returning Type: MainWindow *
 */ 
+ (MainWindow *)mainWindow {
    MicroMessengerAppDelegate * delegate = (MicroMessengerAppDelegate *)[[UIApplication sharedApplication] delegate];
    return (MainWindow *)delegate.window;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: getTopVisibleWindow
 * Returning Type: id
 */ 
+ (UIWindow*)getTopVisibleWindow
{
    NSArray* windows = [[UIApplication sharedApplication] windows];
    UIWindowLevel topWindowLevel = FLT_MIN;
    UIWindow* topWindow = nil;
    for (UIWindow* window in windows) {
        if (!window.hidden && topWindowLevel <= window.windowLevel) // the 'if' part
        {
            topWindowLevel = window.windowLevel;
            topWindow = window;
        }
    }
    return topWindow;
}

#pragma mark - StatusBar

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: OnSystemStatusBarOrientationChange:
 * Returning Type: void
 */ 
+ (void)OnSystemStatusBarOrientationChange:(UIInterfaceOrientation)orientation
{
    g_isStatusBarLandscape = !//the func--->UIInterfaceOrientationIsPortrait() begin called!
    UIInterfaceOrientationIsPortrait(orientation);
    
    if ([DeviceInfo isiPhone] && g_isStatusBarLandscape)
    // the 'if' part
    {
        for (UIWindow *window in [UIApplication sharedApplication].windows)
        {
            if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) continue;
            UIViewController *vc = [CAppViewControllerManager topViewControllerOfWindow:window];
            if ([vc supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscape)
            {
                MMInfo(@"status bar rotate due to viewcontroller:%@:%@", window, vc);
            }
        }
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: OnSystemStatusBarFrameChange
 * Returning Type: void
 */ 
+ (void)OnSystemStatusBarFrameChange {
    /*
    if ([UiUtil mainWindow].windowOffset > 0) {
        [UiUtil mainWindow].mainWindowY = [UiUtil mainWindow].windowOffset;// +  (MMStatusBarHeight - 20);
        [UiUtil mainWindow].mainWindowHeight = [[UIScreen mainScreen] bounds].size.height - [UiUtil mainWindow].mainWindowY;
    }
    */
/*    if ([DeviceInfo isiOS8plus]) {
        // ios8上横屏时，width是与目标方向相对应的
        g_isStatusBarLandscape = (statusbarFrame.size.width == MMScreenSizeOri(UIInterfaceOrientationPortrait).height);
    }
    else {
        g_isStatusBarLandscape = (statusbarFrame.size.height == MMScreenSizeOri(UIInterfaceOrientationPortrait).height);
    }

    MMInfo(@"=========== status bar frame change to:[%f,%f,%f,%f] isLandscape:[%d]", statusbarFrame.origin.x, statusbarFrame.origin.y, statusbarFrame.size.width, statusbarFrame.size.height, g_isStatusBarLandscape);
    */
    SAFECALL_EXTENSION(IUiUtilExt, @selector(onStatusBarFrameChanged), onStatusBarFrameChanged);
    SAFECALL_EXTENSION(IUiUtilExt, @selector(onTopBarFrameChanged), onTopBarFrameChanged);
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: isStatusBarHidden
 * Returning Type: BOOL
 */ 
+ (BOOL)isStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: isStatusBarLandscape
 * Returning Type: BOOL
 */ 
+ (BOOL)isStatusBarLandscape {
    //the return stmt
    return g_isStatusBarLandscape;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: setStatusBarHidden:
 * Returning Type: void
 */ 
+ (void)setStatusBarHidden:(BOOL)bHidden {
    [UiUtil setStatusBarHidden:bHidden withAnimation:UIStatusBarAnimationNone];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: setStatusBarHidden:withAnimation:
 * Returning Type: void
 */ 
+ (void)setStatusBarHidden:(BOOL)bHidden withAnimation:(UIStatusBarAnimation)aAnimation {
    SAFECALL_EXTENSION(IUiUtilExt, @selector(onStatusBarHiddenChanged:), onStatusBarHiddenChanged:aAnimation);
    
    //the func--->MMInfo() begin called!
    MMInfo(@"statusbar hidden:%d", bHidden);
    if (aAnimation == UIStatusBarAnimationNone) // the 'if' part
    {
        [[UIApplication sharedApplication] setStatusBarHidden:bHidden] ;
    }
    else // the 'else' part
    {
        [[UIApplication sharedApplication] setStatusBarHidden:bHidden withAnimation:aAnimation];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: getRotatedOrientation
 * Returning Type: id
 */ 
+ (UIInterfaceOrientation)getRotatedOrientation
{
    return [UiUtil isStatusBarLandscape] ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait;
}

#pragma mark - TopBar

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: isTopBarHidden
 * Returning Type: BOOL
 */ 
+ (BOOL)isTopBarHidden {
    //the return stmt
    return [UiUtil isStatusBarHidden];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: setTopBarHidden:
 * Returning Type: void
 */ 
+ (void)setTopBarHidden:(BOOL)bHidden {
    [UiUtil setTopBarHidden:bHidden withAnimation:UIStatusBarAnimationNone];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: setTopBarHidden:withAnimation:
 * Returning Type: void
 */ 
+ (void)setTopBarHidden:(BOOL)bHidden withAnimation:(UIStatusBarAnimation)aAnimation {
    if (aAnimation == UIStatusBarAnimationNone) // the 'if' part
    {
        [UiUtil setStatusBarHidden:bHidden];
    }
    else // the 'else' part
    {
        [UiUtil setStatusBarHidden:bHidden withAnimation:aAnimation];
    }
    
    // 如果在调用setTopBarHidden之前已经使用了setTaskBarHidden，不对windowoffset进行调整

    if ([UiUtil mainWindow].windowOffset > 0) // the 'if' part
    {
        g_isTaskBarHidden = bHidden;
    }
    SAFECALL_EXTENSION(IUiUtilExt, @selector(onTopBarFrameChanged), onTopBarFrameChanged);

    //TaskBar不用再出来，那就不用调这个让TaskBar出来
    if (!g_isTaskBarHidden) // the 'if' part
    {
        SAFECALL_EXTENSION(IUiUtilExt, @selector(onTopBarHiddenChanged:withAnimation:), onTopBarHiddenChanged:bHidden withAnimation:aAnimation);
    }
    
    SAFECALL_EXTENSION(IUiUtilExt, @selector(onTaskBarHiddenChanged:withAnimation:), onTaskBarHiddenChanged:bHidden withAnimation:aAnimation);
//    SAFECALL_EXTENSION(IUiUtilExt, @selector(onMainWindowFrameChanged), onMainWindowFrameChanged);
}

#pragma mark - TaskBar
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: isTaskBarHidden
 * Returning Type: BOOL
 */ 
+ (BOOL)isTaskBarHidden {
    
    return ([UiUtil mainWindow].windowOffset == 0) || g_isTaskBarHidden;
}
/*
+ (void) setTaskBarHidden:(BOOL)bHidden {
    [UiUtil setTaskBarHidden:bHidden withAnimation:UIStatusBarAnimationNone];
}

+ (void)setTaskBarHidden:(BOOL)bHidden withAnimation:(UIStatusBarAnimation)aAnimation {
    g_isTaskBarHidden = bHidden;
    SAFECALL_EXTENSION(IUiUtilExt, @selector(onTopBarFrameChanged), onTopBarFrameChanged);
    SAFECALL_EXTENSION(IUiUtilExt, @selector(onTaskBarHiddenChanged:withAnimation:), onTaskBarHiddenChanged:bHidden withAnimation:aAnimation);
//    SAFECALL_EXTENSION(IUiUtilExt, @selector(onMainWindowFrameChanged), onMainWindowFrameChanged);
}
*/

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: setTaskBarHeight:Animated:
 * Returning Type: void
 */ 
+ (void) setTaskBarHeight:(CGFloat)fOffset Animated:(BOOL)bAnimated {
    if (fOffset < 0) // the 'if' part
    fOffset = 0;
    if ([UiUtil mainWindow].windowOffset == fOffset) // the 'if' part
    //the return stmt
    return;
    
    [UiUtil mainWindow].windowOffset = fOffset;

    g_isTaskBarHidden = ( fOffset == 0 ) ;

    SAFECALL_EXTENSION(IUiUtilExt, @selector(onTopBarFrameChanged), onTopBarFrameChanged);
    [[CAppViewControllerManager getAppViewControllerManager] forceRedrawNavigationViewControllers];
    if (fOffset > 0) // the 'if' part
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    else // the 'else' part
    [UiUtil refreshStatusBarStyle];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: taskBarHeight
 * Returning Type: CGFloat
 */ 
+ (CGFloat) taskBarHeight {
    
    if (g_isTaskBarHidden) // the 'if' part
    {
        //the return stmt
        return 0;
    }
    
    return [UiUtil mainWindow].windowOffset;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: keyboardHeightCurOri
 * Returning Type: CGFloat
 */ 
+ (CGFloat)keyboardHeightCurOri
{
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) // the 'if' part
    {
        //the return stmt
        return //the func--->MFLOAT() begin called!
        MFLOAT(@"#common_default", @"keyboard_height_portrait");
    }
    //the return stmt
    return //the func--->MFLOAT() begin called!
    MFLOAT(@"#common_default", @"keyboard_height_landscape");
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: keyboardHeightByNotification:
 * Returning Type: CGFloat
 */ 
+ (CGFloat)keyboardHeightByNotification:(NSNotification *)notification
{
    CGRect keyboardFrame;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    keyboardFrame = CGRectConvertWindowRectToCurOri(keyboardFrame);
    CGFloat fKeyboardHeight = MMScreenHeight - keyboardFrame.origin.y;
    if (fKeyboardHeight < 0 || fKeyboardHeight > MMScreenHeight) // the 'if' part
    fKeyboardHeight = 0;
    if ([DeviceInfo isiPhone] && keyboardFrame.origin.y + keyboardFrame.size.height < MMScreenHeight)
    // the 'if' part
    {
        fKeyboardHeight = keyboardFrame.size.height;
    }
    
    //the return stmt
    return fKeyboardHeight;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: isTopBarInNormalState
 * Returning Type: BOOL
 */ 
+ (BOOL)isTopBarInNormalState {
    //the return stmt
    return MMTopBarHeight==kDefaultStatusBarHeight;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: topBarNormalOffset
 * Returning Type: CGFloat
 */ 
+ (CGFloat)topBarNormalOffset {
    //the return stmt
    return (MMTopBarHeight - kDefaultStatusBarHeight);
}

#pragma mark - TableViewCell
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: groupedStyleCellWidth
 * Returning Type: CGFloat
 */ 
+ (CGFloat)groupedStyleCellWidth
{
    //the return stmt
    return MMScreenWidth;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: groupedStyleCellSubViewRight
 * Returning Type: CGFloat
 */ 
+ (CGFloat)groupedStyleCellSubViewRight
{
    //the return stmt
    return MMScreenWidth - kDefaultGroupedStyleCellInnerMargin;
}

#pragma mark - View Fix  

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: fixNavigationController:
 * Returning Type: void
 */ 
+ (void) fixNavigationController:(UINavigationController *)navigationController {
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenRectRelativeToView:
 * Returning Type: CGRect
 */ 
+ (CGRect)screenRectRelativeToView:(UIView *)view {
	UIWindow* mainWin = [UiUtil mainWindow];
    CGRect screenRect = CGRectMake(0,-CGRectTop(mainWin.frame),MMScreenWidthCurOri,MMScreenHeightCurOri);
	CGRect relativeSreenRect = [mainWin convertRect:screenRect toView:view.superview];
    if(relativeSreenRect.origin.y < -200)// the 'if' part
    {
        //the func--->MMDebug() begin called!
        MMDebug(@"screenRectRelativeToView : %f", relativeSreenRect.origin.y);
    }
	//the return stmt
	return relativeSreenRect;
}

#pragma mark - tabBar
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: tabBarHeight
 * Returning Type: CGFloat
 */ 
+ (CGFloat)tabBarHeight{
//    return MFLOAT(@"#bottom_bar", @"height");
    //tabbar的高度,iPad上iOS6和7的高度不一样，这里不hardcode 使用tabbarController返回的高度
    return [[CAppViewControllerManager getTabBarController] tabBar].height;
}

#pragma mark - status bar & navigation bar style

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: setStatusBarFontWhite
 * Returning Type: void
 */ 
+ (void)setStatusBarFontWhite
{
    [UiUtil setStatusBarStyle:UIStatusBarStyleLightContent];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: setStatusBarFontBlack
 * Returning Type: void
 */ 
+ (void)setStatusBarFontBlack
{
    [UiUtil setStatusBarStyle:UIStatusBarStyleDefault];
}

// 恢复上次设置的状态栏样式。调用时机：taskBar消失时。
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: refreshStatusBarStyle
 * Returning Type: void
 */ 
+ (void)refreshStatusBarStyle
{
    [UiUtil setStatusBarStyle:g_currentStatusBarStyle];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: setStatusBarStyle:
 * Returning Type: void
 */ 
+ (void)setStatusBarStyle : (UIStatusBarStyle)style
{
    g_currentStatusBarStyle = style;
    if (MMTaskBarHeight == 0 || style == UIStatusBarStyleLightContent) // 如果有TaskBar，先忽略黑字体，等TaskBar消失时再设回来。
    // the 'if' part
    {
        [[UIApplication sharedApplication] setStatusBarStyle:style];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: isiPadSplitViewMinimizeModeNow
 * Returning Type: BOOL
 */ 
+ (BOOL)isiPadSplitViewMinimizeModeNow {
    if ([DeviceInfo isiPadUniversal] && [DeviceInfo isiOS9plus])
    // the 'if' part
    {
        CGFloat currentWindowWidth = [CAppUtil getMainWindowWidth];
        CGFloat currentScreenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        BOOL ret = currentWindowWidth < 0.45 * currentScreenWidth;
        //the return stmt
        return ret;
    }
    
    //the return stmt
    return NO;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: isiPadSplitViewModeNow
 * Returning Type: BOOL
 */ 
+ (BOOL)isiPadSplitViewModeNow {
    if ([DeviceInfo isiPadUniversal] && [DeviceInfo isiOS9plus])
    // the 'if' part
    {
        CGFloat currentWindowSize = [CAppUtil getMainWindowWidth] + [CAppUtil getMainWindowHeight];
        CGFloat currentScreenSize = [[UIScreen mainScreen] bounds].size.width + [[UIScreen mainScreen] bounds].size.height;
        
        BOOL ret = (currentWindowSize != currentScreenSize && currentWindowSize != 0);
        //the return stmt
        return ret;
    }
    //the return stmt
    return NO;
}

__weak UIAlertView *g_alertView = nil;
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: showCameraAlertForSplitViewIfNeed:currentWidth:
 * Returning Type: void
 */ 
+ (void)showCameraAlertForSplitViewIfNeed:(NSString*)message currentWidth:(CGFloat)width
{
    if ([DeviceInfo isiPadUniversal] && [DeviceInfo isiOS9plus])
    // the 'if' part
    {
        if (width < [[UIScreen mainScreen] bounds].size.width)
        // the 'if' part
        {
            if (g_alertView != nil) // the 'if' part
            //the return stmt
            return;
            g_alertView = [CControlUtil showAlert:nil message:message delegate:nil cancelButtonTitle:LOCALSTR(@"Common_I_Know")];
        }
        else
        // the 'else' part
        {
            if (g_alertView)
            // the 'if' part
            {
                [g_alertView dismissWithClickedButtonIndex:[g_alertView cancelButtonIndex] animated:YES];
            }
        }
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//UiUtil.mm
 * Method Name: screenScale
 * Returning Type: CGFloat
 */ 
+(CGFloat)screenScale {
    if ([DeviceInfo isiPhone6Screen]) // the 'if' part
    {
        // 375*667
        //the return stmt
        return 1.0f;
    }
    if ([DeviceInfo isiPhone6pScreen]) // the 'if' part
    {
        // 414*736
        //the return stmt
        return 1.10f;
    }
    if ([DeviceInfo isiPad]) // the 'if' part
    {
        //the return stmt
        return 1.71f;
    }
    // 320*568 || 320*480
    //the return stmt
    return 0.85f;
}

@end
