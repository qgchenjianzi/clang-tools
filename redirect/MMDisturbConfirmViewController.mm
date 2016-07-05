//
//  MMDisturbConfirmViewController.m
//  MicroMessenger
//
//  Created by RoCry on 9/10/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "MMDisturbConfirmViewController.h"

#import "NotificationActionsMgr.h"

@interface MMDisturbConfirmViewController ()
{
    
}
@end

@implementation MMDisturbConfirmViewController

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MMDisturbConfirmViewController.mm
 * Method Name: init
 * Returning Type: id
 */ 
- (id)init {
    self = [super init];
    if (self) // the 'if' part
    {
        _level = MMWindowLevelUnderStatusBar;
        _transitionOptions = MMWindowTransitionOptionVibrancy;
        [self setStatusBarStyle:UIStatusBarStyleDefault];
    }
    //the return stmt
    return self;
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MMDisturbConfirmViewController.mm
 * Method Name: dealloc
 * Returning Type: void
 */ 
- (void)dealloc {
    
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MMDisturbConfirmViewController.mm
 * Method Name: loadView
 * Returning Type: void
 */ 
- (void)loadView {
    [super loadView];

    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnFontSize = //the func--->MFONTSIZE() begin called!
    MFONTSIZE(@"#text_actionSheet", @"button_title_font_size");
    
    ///////////////////////////////////////////////////////////////////////////////
    // bottom stuff
    
    // cancel button
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [[cancelBtn titleLabel] setFont:[UIFont systemFontOfSize:btnFontSize]];
    [cancelBtn setTitle:LOCALSTR(@"Common_Cancel") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MCOLORX(@"#base_fontbtn", @"text_color") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MCOLOR(@"#098c34") forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(onCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.bottom = self.view.bottom;
    [self.view addSubview:cancelBtn];
    
    // Line
    UIView *cancelBtnTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1 / [UIScreen mainScreen].scale)];
    cancelBtnTopLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    cancelBtnTopLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cancelBtnTopLine.bottom = cancelBtn.top;
    [self.view addSubview:cancelBtnTopLine];
    
    // Mute button
    UIButton *muteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [[muteBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:btnFontSize]];
    [muteBtn setTitle:LOCALSTR(@"do_not_disturb_mute_notification_btn_title") forState:UIControlStateNormal];
    [muteBtn setTitleColor:MCOLORX(@"#base_fontbtn", @"text_color") forState:UIControlStateNormal];
    [muteBtn setTitleColor:MCOLOR(@"#098c34") forState:UIControlStateHighlighted];
    [muteBtn addTarget:self action:@selector(onMuteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    muteBtn.bottom = cancelBtnTopLine.top;
    [self.view addSubview:muteBtn];
    
    // Line
    UIView *muteBtnTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1 / [UIScreen mainScreen].scale)];
    muteBtnTopLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    muteBtnTopLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    muteBtnTopLine.bottom = muteBtn.top;
    [self.view addSubview:muteBtnTopLine];
    ///////////////////////////////////////////////////////////////////////////////
    
    UIView *infoContainerView = [[UIView alloc] init];
    infoContainerView.backgroundColor = [UIColor clearColor];
    infoContainerView.width = self.view.width;
    
    CGFloat offsetY = 0;
    
    CGFloat paddingY = 30;
    CGFloat paddingX = ceil(self.view.size.width*0.1);
    
    // Title
    MMUILabel *titleLabel = [[MMUILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:24];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.text = LOCALSTR(@"do_not_disturb_mute_one_hour_tips_title");
    titleLabel.size = [titleLabel sizeThatFits:CGSizeMake(self.view.width - paddingX * 2, self.view.height)];
    titleLabel.center = CGPointMake(infoContainerView.width/2, titleLabel.height/2);
    [infoContainerView addSubview:titleLabel];
    
    offsetY += titleLabel.height;
    offsetY += paddingY;
    
    // icon
    UIImageView *icon = [[UIImageView alloc] initWithImage:MIMAGE(@"DND1Hour-BigHandIcon")];
    icon.center = titleLabel.center;
    icon.top = offsetY;
    [infoContainerView addSubview:icon];
    
    offsetY += icon.height;
    offsetY += paddingY;
    
    // descriptions
    NSDate *oneHourLater = [NSDate dateWithTimeIntervalSinceNow:3600];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"h:mm a";
    NSString *resumeDateString = [dateFormatter stringFromDate:oneHourLater];
    
    MMUILabel *descLabel = [[MMUILabel alloc] init];
    descLabel.numberOfLines = 0;
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont systemFontOfSize:16];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    descLabel.text = [NSString stringWithFormat:LOCALSTR(@"do_not_disturb_mute_one_hour_tips_desc_format"), resumeDateString];
    descLabel.size = [descLabel sizeThatFits:CGSizeMake(self.view.width - paddingX * 2, self.view.height)];
    descLabel.center = icon.center;
    descLabel.top = offsetY;
    [infoContainerView addSubview:descLabel];
    
    offsetY += descLabel.height;
    infoContainerView.height = offsetY;
    
    infoContainerView.center = CGPointMake(self.view.width/2, muteBtnTopLine.top/2);
    [self.view addSubview:infoContainerView];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MMDisturbConfirmViewController.mm
 * Method Name: viewDidLoad
 * Returning Type: void
 */ 
- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MMDisturbConfirmViewController.mm
 * Method Name: onCancelBtnClicked:
 * Returning Type: void
 */ 
- (void)onCancelBtnClicked:(UIButton *)sender {
    [self hideWithAnimated:MMWindowAnimationFade];
}

/**
 * File Name: /Users/currychen/Documents/git_prj/wechat/MMApp//MMDisturbConfirmViewController.mm
 * Method Name: onMuteBtnClicked:
 * Returning Type: void
 */ 
- (void)onMuteBtnClicked:(UIButton *)sender {
    [self hideWithAnimated:MMWindowAnimationFade];
    
    [GET_SERVICE(NotificationActionsMgr) muteForOneHour];
}

@end
