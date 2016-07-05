//
//  DynamicStartViewLogic.mm
//  MicroMessenger
//
//  Created by isalin on 15/7/28.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "DynamicStartViewLogic.h"
#import "Utility.h"
#import <MMCommon/PBCoder.h>
#import <MMCommon/BaseFile.h>
#import "MMImagePickerManager.h"
#import "Utility.h"
#import "WCUIAlertView.h"
#import "SettingUtil.h"
#import "Setting.h"
#import <MMCommon/Md5Hash.h>
#import <MMCommon/MZipUtil.h>
#import <PublicComponentDylib/Objc2C_Logic.h>
#import "MMNotificationCenter.h"
#import "IDKeyReport.h"

@interface StartViewFile : NSObject<PBCoding>
{
}
@property(nonatomic, strong) NSString* nsName;
@property(nonatomic, strong) NSString* nsMD5;
@property(nonatomic, strong) NSData* nsSign;

@end
@implementation StartViewFile

PBCODER_TABLE_BEGIN(StartViewFile)
PBCODER_OBJ_PROPERTY(StartViewFile, nsName, NSString, 1)
PBCODER_OBJ_PROPERTY(StartViewFile, nsMD5, NSString, 2)
PBCODER_OBJ_PROPERTY(StartViewFile, nsSign, NSData, 3)
PBCODER_TABLE_END(StartViewFile)

-(id) init
{
    if (self = [super init])
    {
        self.nsName = nil;
        self.nsMD5 = nil;
        self.nsSign = nil;
    }
    return self;
}

@end

@interface StartViewConfig : NSObject<PBCoding>
{
}
@property(nonatomic, strong) NSString* nsID;
@property(nonatomic, strong) NSString* nsContent;
@property(nonatomic, strong) NSString* nsLangs;
@property(nonatomic, strong) StartViewFile* oMatchFile;
@property(nonatomic, strong) NSMutableDictionary* dicFiles;
@property(nonatomic, assign) UInt64 startTime;
@property(nonatomic, assign) UInt64 endTime;
@property(nonatomic, assign) UInt64 nextTime;
@property(nonatomic, assign) UInt32 verMin;
@property(nonatomic, assign) UInt32 verMax;
@property(nonatomic, assign) UInt32 showCount;
@property(nonatomic, assign) UInt32 showedCount;
@property(nonatomic, assign) NSInteger resType;
@property(nonatomic, assign) NSInteger subType;
@property(nonatomic, assign) float showTime;
@property(nonatomic, assign) UInt64 lastShowTime;

@end

@implementation StartViewConfig

PBCODER_TABLE_BEGIN(StartViewConfig)
PBCODER_OBJ_PROPERTY(StartViewConfig, nsID, NSString, 1)
PBCODER_OBJ_PROPERTY(StartViewConfig, oMatchFile, StartViewFile, 3)
PBCODER_OBJ_PROPERTY(StartViewConfig, nsContent, NSString, 4)
PBCODER_UINT32_PROPERTY(StartViewConfig, showedCount, 5)
PBCODER_UINT64_PROPERTY(StartViewConfig, lastShowTime, 6)
PBCODER_TABLE_END(StartViewConfig)

-(id) init
{
    if (self = [super init])
    {
        self.nsID = nil;
        self.nsLangs = nil;
        self.oMatchFile = nil;
        self.dicFiles = nil;
        self.nsContent = nil;
        self.startTime = 0;
        self.endTime = 0;
        self.verMin = 0;
        self.verMax = 0;
        self.showCount = 0;
        self.showedCount = 0;
        self.resType = 0;
        self.subType = 0;
        self.showTime = 0;
        self.lastShowTime = 0;
        self.nextTime = 0;
        
        
    }
    return self;
}

@end

@interface StorageForStartView : NSObject<PBCoding>
{
}
@property(nonatomic, strong) NSString* nsMd5;
@property(nonatomic, strong) NSData* dtConfig;

@end

@implementation StorageForStartView

PBCODER_TABLE_BEGIN(StorageForStartView)
PBCODER_OBJ_PROPERTY(StorageForStartView, nsMd5, NSString, 1)
PBCODER_OBJ_PROPERTY(StorageForStartView, dtConfig, NSData, 2)
PBCODER_TABLE_END(StorageForStartView)

-(id) init
{
    if (self = [super init])
    {
        self.nsMd5 = nil;
        self.dtConfig = nil;
    }
    return self;
}

@end

@implementation DynamicStartViewLogic
{
    MMUIWindow *m_testWindow;
    StartViewConfig* m_showConfig;
    MMTimer* m_timer;
}

#ifndef CLEARTEST

DynamicStartViewLogic* g_shareLogic;

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: shareLogic
 * Returning Type: DynamicStartViewLogic *
 */ 
+(DynamicStartViewLogic*)shareLogic
{
    return g_shareLogic;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: setTime
 * Returning Type: void
 */ 
- (void) setTime
{
    WCUIAlertView* alert = [[WCUIAlertView alloc] initWithTitle:LOCALSTR(@"设置启动图显示时间") message:nil];
    [alert addCancelBtnTitle:LOCALSTR(@"Common_Cancel") target:nil sel:nil];
    [alert addBtnTitle:LOCALSTR(@"Common_Confirm") target:self sel:@selector(doSetStartImageTime:)];
    
    if (![DeviceInfo isiOS8plus])
    // the 'if' part
    {
        [alert showTextFieldWithTarget:self sel:@selector(doSetStartImageTime:)];
    }
    else
    // the 'else' part
    {
        [alert showTextFieldWithTarget:nil sel:nil];
    }
    [alert setTextFieldMaxLen:3];
    UITextField* textField = [alert getTextField];
    textField.text = [NSString stringWithFormat:@"%0.1f", m_showConfig.showTime];
    
    [alert show];
}


/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: doSetStartImageTime:
 * Returning Type: void
 */ 
- (void)doSetStartImageTime:(WCUIAlertView*)alert
{
    UITextField* textField = [alert getTextField];
    if ([textField.text length] == 0)
    // the 'if' part
    {
        //the return stmt
        return;
    }
    float fTime = [textField.text floatValue];
    m_showConfig.showTime = fTime;
    [self saveConfig];
    
}

UIViewController* g_vc;

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: setImage:
 * Returning Type: void
 */ 
- (void) setImage:(UIViewController*)vc
{
    MMImagePickerManagerOptionObj *optionObj = [[MMImagePickerManagerOptionObj alloc] init];
    optionObj.delegateObj = self;
    optionObj.canSendVideoMessage = NO;
    optionObj.previewType = MMImagePreviewTypeNormal;
    optionObj.finishWordMode = MMImagePickerFinishWordModeFinish;
    optionObj.compressType = MMImageCompressTypeFullScreen;
    optionObj.canSendMultiImage = NO;
    optionObj.isCamera = NO;
    
    [MMImagePickerManager showWithOptionObj:optionObj inViewController:vc];
    g_vc = vc;
}

#pragma mark - MMimagePickerManagerDelegate

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: MMImagePickerManager:didFinishPickingImageWithInfo:
 * Returning Type: void
 */ 
- (void)MMImagePickerManager:(UINavigationController *)picker didFinishPickingImageWithInfo:(NSArray *)infos {
    if (infos.count == 0) // the 'if' part
    {
        [g_vc DismissModalViewControllerAnimated:YES];
        //the return stmt
        return;
    }
    NSDictionary *info = [infos firstObject];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (![CBaseFile FileExist:[[self getRootPath] stringByAppendingPathComponent:@"StartImg"]])
    // the 'if' part
    {
        [CBaseFile CreatePath:[[self getRootPath] stringByAppendingPathComponent:@"StartImg"]];
    }
    NSString* nsResPath = [[self getRootPath] stringByAppendingPathComponent:@"StartImg/1.png"];
    
    NSData * data = UIImagePNGRepresentation(image);
    [data writeToFile:nsResPath atomically:YES];
    
    m_showConfig.verMin = 0;
    m_showConfig.verMax = 0x1FFFFFFF;
    m_showConfig.startTime = 0;
    m_showConfig.endTime = [[NSDate distantFuture] timeIntervalSince1970];
    m_showConfig.nsID = @"test";
    m_showConfig.showCount = 3000;
    m_showConfig.showedCount = 0;
    m_showConfig.lastShowTime = 0;
    [self saveConfig];
    
    [g_vc DismissModalViewControllerAnimated:YES];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: MMImagePickerManagerDidCancel:
 * Returning Type: void
 */ 
- (void)MMImagePickerManagerDidCancel:(UINavigationController *)picker {
    [g_vc DismissModalViewControllerAnimated:YES];
}

#endif

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: init
 * Returning Type: id
 */ 
-(id)init
{
    self = [super init];
    if (self)
    // the 'if' part
    {
        m_testWindow = nil;
        m_showConfig = [[StartViewConfig alloc] init];
        
        if (![CBaseFile FileExist:[self getRootPath]])
        // the 'if' part
        {
            [CBaseFile CreatePath:[self getRootPath]];
        }
//        [self saveConfig];
        [self loadConfig];
        
        REGISTER_EXTENSION(IMsgExt, self);
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willEnterForeground) name:MMApplicationWillEnterForeground object:nil];
        // 监听前台和后台消息
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:MMApplicationWillResignActiveNotification object:nil];
        if ([m_showConfig.nsID length] > 0)
        // the 'if' part
        {
            REGISTER_EXTENSION(MMResourceMgrExt, self);
        }
#ifndef CLEARTEST
        g_shareLogic = self;
#endif
    }
    //the return stmt
    return self;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: dealloc
 * Returning Type: void
 */ 
-(void)dealloc
{
    UNREGISTER_EXTENSION(IMsgExt, self);
    UNREGISTER_EXTENSION(MMResourceMgrExt, self);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: getRootPath
 * Returning Type: NSString *
 */ 
-(NSString*)getRootPath
{
    return [[CUtility GetPathOfCacheLocalUsrDir] stringByAppendingPathComponent:@"StartView"];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: getConfigPath
 * Returning Type: NSString *
 */ 
-(NSString*)getConfigPath
{
    //the return stmt
    return [[self getRootPath] stringByAppendingPathComponent:@"ShowConfig.dat"];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: getImgRootPath
 * Returning Type: NSString *
 */ 
-(NSString*)getImgRootPath
{
    //the return stmt
    return [[self getRootPath] stringByAppendingPathComponent:@"StartImg"];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: getImgPath
 * Returning Type: NSString *
 */ 
-(NSString*)getImgPath
{
    NSString* nsResPath = [self getImgRootPath];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSString* nsMatchPath = nil;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat ratio = screenSize.height / screenSize.width;
    CGFloat minMatch = 100;
    
    for (NSString* subPath in [m_showConfig.dicFiles allKeys])
    {
        NSString* fullPath = [nsResPath stringByAppendingPathComponent:subPath];
        BOOL isDir = NO;
        if (![fileMgr fileExistsAtPath:fullPath isDirectory:&isDir])
        {
            continue;
        }
        if (isDir)
        {
            continue;
        }
        UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
        if (!image)
        {
            continue;
        }
        CGFloat imgRatio = image.size.height / image.size.width;
        
        if (ratio > imgRatio && minMatch > ratio - imgRatio)
        {
            nsMatchPath = subPath;
        }
        else if (ratio < imgRatio && minMatch > imgRatio - ratio)
        {
            nsMatchPath = subPath;
        }
    }
    
    //the return stmt
    return nsMatchPath;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: updateImageFile
 * Returning Type: BOOL
 */ 
-(BOOL)updateImageFile
{
    NSString* nsResPath = [GET_SERVICE(MMResourceService) getResPath:m_showConfig.resType WithSubRestype:m_showConfig.subType];
    
    if ([nsResPath length] == 0)
    // the 'if' part
    {
        //the return stmt
        return NO;
    }
    if (![CBaseFile FileExist:nsResPath])
    // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"File not Exist:%@", nsResPath);
        //the return stmt
        return NO;
    }
    [CBaseFile RemoveFile:[self getImgRootPath]];
    [CBaseFile CreatePath:[self getImgRootPath]];

    if ([MZipUtil UnZipFile:nsResPath toPath:[self getImgRootPath]] == NO)
    // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"unzip startview failed %@", nsResPath);
        //the return stmt
        return NO;
    }
    NSString* realPath = [self getImgPath];
    
    if ([realPath length] == 0)
    // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"can't find startview img");
        //the return stmt
        return NO;
    }
    m_showConfig.oMatchFile = [m_showConfig.dicFiles objectForKey:realPath];
    //the return stmt
    return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: test
 * Returning Type: void
 */ 
- (void)test
{
    for (NSString* key in m_showConfig.dicFiles)
    {
        StartViewFile* file = [m_showConfig.dicFiles objectForKey:key];
        
        const char* fileMD5 = [file.nsMD5 UTF8String];
        
        static const unsigned char PUBLIC_KEY[] = {0x30,0x32,0x30,0x10,0x06,0x07,0x2a,0x86,0x48,0xce,0x3d,0x02,0x01,0x06,0x05,0x2b,0x81,0x04,0x00,0x06,0x03,0x1e,0x00,0x04,0x2d,0xb5,0xf0,0x2f,0xd9,0x45,0x89,0xf2,0x78,0x0d,0x8e,0x47,0xc6,0x52,0x6b,0xb2,0x39,0x33,0x9a,0x84,0xf2,0x21,0x6c,0xd6,0x79,0xed,0xb9,0xd8};
        
        int ret = Objc2C_doEcdsaVerify((const unsigned char*)PUBLIC_KEY, 52, fileMD5, (int)(strlen(fileMD5)), (const char*)file.nsSign.bytes, (int)(file.nsSign.length));
        
        if (ret != 1)
        {
            MMError(@"not match");
        }
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: loadConfig
 * Returning Type: void
 */ 
-(void)loadConfig
{
    NSString* nsPath = [self getConfigPath];
    StorageForStartView* storage = [[StorageForStartView alloc] init];
    [PBCoder decodeObject:storage fromFile:nsPath];
    
    NSData* dtOutput = [CAESCrypt AESDecryptWithKey:[[SettingUtil getMainSetting].m_nsUsrName dataUsingEncoding:NSUTF8StringEncoding] Data:storage.dtConfig];
    
    Md5Hash md5Hash;
    md5Hash.DoHash(dtOutput.bytes, dtOutput.length);
    
    if (![storage.nsMd5 isEqualToString:[NSString stringWithUTF8String:md5Hash.ToString().c_str()]])
    // the 'if' part
    {
        //the return stmt
        return;
    }
    
    [PBCoder decodeObject:m_showConfig fromData:dtOutput];
    
    [self parseXML:m_showConfig.nsContent];
    
//    [self test];
    if (!m_showConfig.oMatchFile && [self updateImageFile])
    // the 'if' part
    {
        [self saveConfig];
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: saveConfig
 * Returning Type: void
 */ 
-(void)saveConfig
{
    StorageForStartView* storage = [[StorageForStartView alloc] init];
    
    NSData* dtInput = [PBCoder encodeDataWithObject:m_showConfig];
    
    Md5Hash md5Hash;
    md5Hash.DoHash(dtInput.bytes, dtInput.length);
    [[SettingUtil getMainSetting].m_nsUsrName dataUsingEncoding:NSUTF8StringEncoding];
    
    storage.nsMd5 = [NSString stringWithUTF8String:md5Hash.ToString().c_str()];
    
    NSData* dtOutput = [CAESCrypt AESEncryptWithKey:[[SettingUtil getMainSetting].m_nsUsrName dataUsingEncoding:NSUTF8StringEncoding] Data:dtInput];
    
    storage.dtConfig = dtOutput;
    
    NSString* nsPath = [self getConfigPath];
    [PBCoder encodeObject:storage toFile:nsPath];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: showStartView
 * Returning Type: BOOL
 */ 
-(BOOL)showStartView
{
    if (m_testWindow)
    // the 'if' part
    {
        //the return stmt
        return YES;
    }
    if (!m_showConfig)
    // the 'if' part
    {
        //the return stmt
        return NO;
    }
    
    if ([m_showConfig.nsID length] == 0)
    // the 'if' part
    {
        //the return stmt
        return NO;
    }
    
    if (!m_showConfig.oMatchFile)
    // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"can't find the match file");
        //the return stmt
        return NO;
    }
    
    UInt64 curTime = [[NSDate date] timeIntervalSince1970];
    if (m_showConfig.lastShowTime + m_showConfig.nextTime > curTime)
    // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"not this moment");
        //the return stmt
        return NO;
    }
    
    if (![self isLangSupport])
    // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"language not support");
        //the return stmt
        return NO;
    }
    
    if (m_showConfig.showedCount >= m_showConfig.showCount)
    // the 'if' part
    {
        LOG_FEATURE_EXT_IDKEY(206, 0, m_showConfig.showedCount, NO);
        //the func--->MMInfo() begin called!
        MMInfo(@"show count enough");
        //the return stmt
        return NO;
    }
    
    UInt32 uiCurVer = [CUtility GetVersion];
    if (m_showConfig.verMin > uiCurVer || m_showConfig.verMax < uiCurVer)
    // the 'if' part
    {
        LOG_FEATURE_EXT_IDKEY(206, 0, m_showConfig.showedCount, NO);
        //the func--->MMInfo() begin called!
        MMInfo(@"version not support");
        //the return stmt
        return NO;
    }
    
    if (m_showConfig.startTime > curTime || m_showConfig.endTime < curTime)
    // the 'if' part
    {
        LOG_FEATURE_EXT_IDKEY(206, 0, m_showConfig.showedCount, NO);
        //the func--->MMInfo() begin called!
        MMInfo(@"time expired");
        //the return stmt
        return NO;
    }
    
    NSString* realPath = [[self getImgRootPath] stringByAppendingPathComponent:m_showConfig.oMatchFile.nsName];
    
    //the func--->MMInfo() begin called!
    MMInfo(@"should Show Start View");
    NSData * data = [NSData dataWithContentsOfFile:realPath];
    if (!data)
    // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"can't read img:%@", realPath);
        //the return stmt
        return NO;
    }
    Md5Hash md5Hash;
    md5Hash.DoHash(data.bytes, data.length);
    
    if (![m_showConfig.oMatchFile.nsMD5 isEqualToString:[NSString stringWithUTF8String:md5Hash.ToString().c_str()]])
    // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"img MD5 can't match!!!");
        //the return stmt
        return NO;
    }
    
    static const unsigned char PUBLIC_KEY[] = {0x30,0x32,0x30,0x10,0x06,0x07,0x2a,0x86,0x48,0xce,0x3d,0x02,0x01,0x06,0x05,0x2b,0x81,0x04,0x00,0x06,0x03,0x1e,0x00,0x04,0x2d,0xb5,0xf0,0x2f,0xd9,0x45,0x89,0xf2,0x78,0x0d,0x8e,0x47,0xc6,0x52,0x6b,0xb2,0x39,0x33,0x9a,0x84,0xf2,0x21,0x6c,0xd6,0x79,0xed,0xb9,0xd8};
    
    int ret = Objc2C_doEcdsaVerify(PUBLIC_KEY, 52, md5Hash.ToString().c_str(), (int)(md5Hash.ToString().length()), (const char*)m_showConfig.oMatchFile.nsSign.bytes, (int)(m_showConfig.oMatchFile.nsSign.length));
    
    if (ret != 1)
    // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"img sign can't match!!!");
        //the return stmt
        return NO;
    }
    
    UIImage* res = [UIImage imageWithData:data];
    if (!res)
    // the 'if' part
    {
        //the func--->MMError() begin called!
        MMError(@"imageWithData err!!!");
        //the return stmt
        return NO;
    }
    
    m_testWindow = [[MMUIWindow alloc] initWithFrame:CGRectMake(0, 0, MMScreenWidth, MMScreenHeight)];
    m_testWindow.windowLevel = UIWindowLevelStatusBar + 10;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:res];
    imageView.frame = CGRectMake(0, 0, MMScreenWidth, MMScreenHeight);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    m_testWindow.backgroundColor = [UIColor blackColor];
    [m_testWindow addSubview:imageView];
    [m_testWindow makeKeyAndVisible];
    m_timer = [MMTimer scheduledNoRetainTimerWithTimeInterval:m_showConfig.showTime target:self selector:@selector(closeStartView) userInfo:nil repeats:NO];
    
    //the func--->MMInfo() begin called!
    MMInfo(@"finally show");
    //the return stmt
    return YES;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: closeStartView
 * Returning Type: void
 */ 
-(void)closeStartView
{
    if (m_testWindow == nil)
    // the 'if' part
    {
        //the return stmt
        return;
    }
    m_showConfig.showedCount ++;
    [self saveConfig];
    [m_timer invalidate];
    m_timer = nil;
    [UIView animateWithDuration:1.0 animations:^{
        m_testWindow.alpha = 0.0;
    } completion:^(BOOL finished) {
        m_testWindow.rootViewController = nil;
        [m_testWindow removeAllSubViews];
        SAFE_DELETE(m_testWindow);
    }];
}

//MMKernelExt,IMMLanguageMgrExt,IMsgExt,MMResourceMgrExt

#pragma mark - MMResourceMgrExt
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: onResUpdateFinish:resType:subResType:
 * Returning Type: void
 */ 
- (void)onResUpdateFinish:(EResOperationErrorCode)errorCode resType:(NSInteger)resType subResType:(NSInteger)subType
{
    if (m_showConfig.resType == resType && m_showConfig.subType == subType)
    // the 'if' part
    {
        //the func--->MMInfo() begin called!
        MMInfo(@"resType:28, subType:%ld", (long)subType);
        if ([self updateImageFile])
        // the 'if' part
        {
            [self saveConfig];
        }
    }
}

#pragma mark - IMMLanguageMgrExt
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: isLangSupport
 * Returning Type: BOOL
 */ 
-(BOOL) isLangSupport
{
    if ([m_showConfig.nsLangs length] > 0)
    // the 'if' part
    {
        NSArray* langs = [m_showConfig.nsLangs componentsSeparatedByString:@","];
        if (![langs containsObject:[GET_SERVICE(MMLanguageMgr) getCurLanguage]])
        // the 'if' part
        {
            //the return stmt
            return NO;
        }
    }
    
    //the return stmt
    return YES;
}

#pragma mark - IMsgExt
#define MM_DATA_SYSCMD_NEWXML_SUBTYPE_DYNC_SPLASH_SCREEN "DyncSplashScreen"
//<sysmsg type="DyncSplashScreen"><DyncSplashScreen><EventID><![CDATA[123456]]></EventID>
//<Language><![CDATA[zh_CN,en,zh_TW]]></Language>
//<CliVerMin><![CDATA[0x16020400]]></CliVerMin>
//<CliVerMax><![CDATA[0x1FFFFFFF]]></CliVerMax>
//<StartTime>1439455107</StartTime>
//<EndTime>1439541507</EndTime>
//<ShowTimes>1000</ShowTimes>
//<NextTimeS>10</NextTimeS>
//<ShowTimeDurationMS>500</ShowTimeDurationMS>
//<ResType>28</ResType>
//<ResSubType>0</ResSubType>
//<ResFileID>0</ResFileID>
//<FileList>
//<FileName><![CDATA[test_file_1]]></FileName>
//<FileMD5><![CDATA[test_file_md5_1]]></FileMD5>
//<FileSign><![CDATA[test_file_sign_1]]></FileSign>
//</FileList>
//<FileList>
//<FileName><![CDATA[test_file_2]]></FileName>
//<FileMD5><![CDATA[test_file_md5_2]]></FileMD5>
//<FileSign><![CDATA[test_file_sign_2]]></FileSign>
//</FileList>
//<FileList>
//<FileName><![CDATA[test_file_3]]></FileName>
//<FileMD5><![CDATA[test_file_md5_3]]></FileMD5>
//<FileSign><![CDATA[test_file_sign_3]]></FileSign>
//</FileList>
//</DyncSplashScreen></sysmsg>

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: parseXML:
 * Returning Type: void
 */ 
-(void)parseXML:(NSString*)nsContent
{
    //the func--->MMInfo() begin called!
    MMInfo(@"%@",nsContent);
    
    CXmlReader xmlReader(true);
    xmlReader.Parse((char*)[nsContent UTF8String], (int32_t)[nsContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    XmlReaderNode_t *pRootNode = xmlReader.GetRootNode();
    if (pRootNode == NULL)
    // the 'if' part
    {
        //the return stmt
        return;
    }
    
    XmlReaderNode_t *pSysMsgNode = pRootNode->FirstChild("sysmsg");
    if (pSysMsgNode == NULL) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    XmlReaderNode_t *pMsgNode = pSysMsgNode->FirstChild();
    if (pMsgNode == NULL) // the 'if' part
    {
        //the return stmt
        return;
    }
    
    NSString* nsID = [self decodeToString:pMsgNode key:"EventID"];
    
    if (![nsID isEqualToString:m_showConfig.nsID])
    // the 'if' part
    {
        if ([m_showConfig.nsID length] > 0)
        // the 'if' part
        {
            LOG_FEATURE_EXT_IDKEY(206, 0, m_showConfig.showedCount, NO);
        }
        //id不同，清除原来所有配置
        m_showConfig = [[StartViewConfig alloc] init];
        m_showConfig.nsID = nsID;
        m_showConfig.nsContent = nsContent;
    }
    NSString* nsResType = [self decodeToString:pMsgNode key:"ResType"];
    NSString* nsResSubType = [self decodeToString:pMsgNode key:"ResSubType"];
    m_showConfig.resType = [nsResType longLongValue];
    m_showConfig.subType = [nsResSubType longLongValue];
    m_showConfig.dicFiles = [[NSMutableDictionary alloc] init];
    
    for (XmlReaderNode_t *pFileNode = pMsgNode->FirstChild("FileList"); pFileNode != NULL; pFileNode = pFileNode->NextSibling("FileList"))
    {
        StartViewFile* file = [[StartViewFile alloc] init];
        file.nsName = [self decodeToString:pFileNode key:"FileName"];
        file.nsMD5 = [self decodeToString:pFileNode key:"FileMD5"];
        
        NSString* nsSign = [self decodeToString:pFileNode key:"FileSign"];
        
        char* bytes = new char[[nsSign length]];
        int len = //the func--->hexToBytes() begin called!
        hexToBytes([nsSign UTF8String], (unsigned char*)bytes);
        file.nsSign = [NSData dataWithBytes:bytes length:len];
        delete bytes;
        
        [m_showConfig.dicFiles safeSetObject:file forKey:file.nsName];
    }
    
    if ([m_showConfig.nsID length] == 0 || ![nsResType isEqualToString:@"28"] || [m_showConfig.dicFiles count] == 0)
    // the 'if' part
    {
        //出错
        //the return stmt
        return;
    }
    REGISTER_EXTENSION(MMResourceMgrExt, self);
    NSString* nsShowTimes = [self decodeToString:pMsgNode key:"ShowTimes"];
    m_showConfig.showCount = (UInt32)[nsShowTimes longLongValue];
    
    m_showConfig.nsLangs = [self decodeToString:pMsgNode key:"Language"];
    
    NSString* nsCliVerMin = [self decodeToString:pMsgNode key:"CliVerMin"];
    if ([nsCliVerMin length] == 0)
    // the 'if' part
    {
        m_showConfig.verMin = 0;
    }
    else
    // the 'else' part
    {
        m_showConfig.verMin = (UInt32)strtoull([nsCliVerMin UTF8String], 0, 16);
    }
    
    NSString* nsCliVerMax = [self decodeToString:pMsgNode key:"CliVerMax"];
    if ([nsCliVerMin length] == 0)
    // the 'if' part
    {
        m_showConfig.verMax = 0x1FFFFFFF;
    }
    else
    // the 'else' part
    {
        m_showConfig.verMax = (UInt32)strtoull([nsCliVerMax UTF8String], 0, 16);
    }
    
    NSString* nsStartTime = [self decodeToString:pMsgNode key:"StartTime"];
    if ([nsStartTime length] == 0)
    // the 'if' part
    {
        m_showConfig.startTime = 0;
    }
    else
    // the 'else' part
    {
        m_showConfig.startTime = (UInt64)[nsStartTime longLongValue];
    }
    NSString* nsEndTime = [self decodeToString:pMsgNode key:"EndTime"];
    if ([nsEndTime length] == 0)
    // the 'if' part
    {
        m_showConfig.endTime = [[NSDate distantFuture] timeIntervalSince1970];
    }
    else
    // the 'else' part
    {
        m_showConfig.endTime = (UInt64)[nsEndTime longLongValue];
    }
    NSString* nsNextTime = [self decodeToString:pMsgNode key:"NextTimeS"];
    if ([nsNextTime length] == 0)
    // the 'if' part
    {
        m_showConfig.nextTime = 0;
    }
    else
    // the 'else' part
    {
        m_showConfig.nextTime = (UInt64)[nsNextTime longLongValue];
    }
    NSString* nsShowTimeDurationMS = [self decodeToString:pMsgNode key:"ShowTimeDurationMS"];
    if ([nsShowTimeDurationMS length] == 0)
    // the 'if' part
    {
        m_showConfig.showTime = 2;
    }
    else
    // the 'else' part
    {
        m_showConfig.showTime = ((double)[nsShowTimeDurationMS longLongValue]) / 1000.0;
    }
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: decodeToString:key:
 * Returning Type: NSString *
 */ 
-(NSString*) decodeToString:(XmlReaderNode_t *)pRootNode key:(const char *) sKey
{
    XmlReaderNode_t* pNode = pRootNode->FirstChild(sKey);
    if (pNode != NULL)
    // the 'if' part
    {
        const char * pValue = pNode->GetText();
        
        if (pValue)
        // the 'if' part
        {
            // ContactDebug(@"decode key:%s value:%s", sKey, pValue);
            //the return stmt
            return [NSString stringWithUTF8String:pValue];
        }
    }
    //the return stmt
    return nil;
}
/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: OnGetNewXmlMsg:Type:MsgWrap:
 * Returning Type: void
 */ 
-(void) OnGetNewXmlMsg:(NSString*)nsUsrName Type:(NSString*)nsType MsgWrap:(CMessageWrap*)wrapMsg
{
    if (![nsType isEqualToString:@MM_DATA_SYSCMD_NEWXML_SUBTYPE_DYNC_SPLASH_SCREEN])
    // the 'if' part
    {
        //the return stmt
        return;
    }
    
    MMInfo(@"OnGetNewXmlMsg:%@", wrapMsg.m_nsContent);
    m_showConfig.nsContent = wrapMsg.m_nsContent;
    [self parseXML:wrapMsg.m_nsContent];
    [self updateImageFile];
    [self saveConfig];
}

#pragma mark - begin

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: willEnterForeground
 * Returning Type: void
 */ 
- (void)willEnterForeground
{
    [self showStartView];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//DynamicStartView/DynamicStartViewLogic.mm
 * Method Name: enterBackground
 * Returning Type: void
 */ 
- (void)enterBackground
{
    
    m_testWindow = [[MMUIWindow alloc] initWithFrame:CGRectMake(0, 0, MMScreenWidth, MMScreenHeight)];
    m_testWindow.windowLevel = UIWindowLevelStatusBar + 10;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:MIMAGE(@"ShakeHideImg_women.png")];
    imageView.frame = CGRectMake(0, 0, MMScreenWidth, MMScreenHeight);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    m_testWindow.backgroundColor = [UIColor blackColor];
    [m_testWindow addSubview:imageView];
    [m_testWindow makeKeyAndVisible];
    m_timer = [MMTimer scheduledNoRetainTimerWithTimeInterval:5 target:self selector:@selector(closeStartView) userInfo:nil repeats:NO];
    
    //the func--->MMInfo() begin called!
    MMInfo(@"finally show");
}

@end
