//
//  PNSBuildModelUtils.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSBuildModelUtils.h"
#import "PNSBackgroundView.h"

@implementation PNSBuildModelUtils

+ (TXCustomModel *)buildModelWithStyle:(PNSBuildModelStyle)style
                          button1Title:(NSString *)button1Title
                               target1:(id)target1
                             selector1:(SEL)selector1
                          button2Title:(NSString *)button2Title
                               target2:(id)target2
                             selector2:(SEL)selector2 {
    TXCustomModel *model = nil;
    switch (style) {
        case PNSBuildModelStylePortrait:
            model = [self buildFullScreenPortraitModelWithButton1Title:button1Title
                                                               target1:target1
                                                             selector1:selector1
                                                          button2Title:button2Title
                                                               target2:target2
                                                             selector2:selector2];
            break;
        case PNSBuildModelStyleLandscape:
            model = [self buildFullScreenLandscapeModelWithButton1Title:button1Title
                                                                target1:target1
                                                              selector1:selector1
                                                           button2Title:button2Title
                                                                target2:target2
                                                              selector2:selector2];
            break;
        case PNSBuildModelStyleAutorotate:
            model = [self buildFullScreenAutorotateModelWithButton1Title:button1Title
                                                                 target1:target1
                                                               selector1:selector1
                                                            button2Title:button2Title
                                                                 target2:target2
                                                               selector2:selector2];
            break;
        case PNSBuildModelStyleAlertPortrait:
            model = [self buildAlertPortraitModeWithButton1Title:button1Title
                                                         target1:target1
                                                       selector1:selector1
                                                    button2Title:button2Title
                                                         target2:target2
                                                       selector2:selector2];
            break;
        case PNSBuildModelStyleAlertLandscape:
            model = [self buildAlertLandscapeModeWithButton1Title:button1Title
                                                          target1:target1
                                                        selector1:selector1
                                                     button2Title:button2Title
                                                          target2:target2
                                                        selector2:selector2];
            break;
        case PNSBuildModelStyleAlertAutorotate:
            model = [self buildAlertAutorotateModeWithButton1Title:button1Title
                                                           target1:target1
                                                         selector1:selector1
                                                      button2Title:button2Title
                                                           target2:target2
                                                         selector2:selector2];
            break;
        case PNSBuildModelStyleSheetPortrait:
            model = [self buildSheetPortraitModelWithButton1Title:button1Title
                                                          target1:target1
                                                        selector1:selector1
                                                     button2Title:button2Title
                                                          target2:target2
                                                        selector2:selector2];
            break;
        case PNSDIYAlertPortraitFade:
            model = [self buildAlertFadeModelWithButton1Title:button1Title
                                                      target1:target1
                                                    selector1:selector1
                                                 button2Title:button2Title
                                                      target2:target2
                                                    selector2:selector2];
            break;
        case PNSDIYAlertPortraitBounce:
            model = [self buildAlertBounceModelWithButton1Title:button1Title
                                                        target1:target1
                                                      selector1:selector1
                                                   button2Title:button2Title
                                                        target2:target2
                                                      selector2:selector2];
            break;
        case PNSDIYAlertPortraitDropDown:
            model = [self buildAlertDropDownModelWithButton1Title:button1Title
                                                          target1:target1
                                                        selector1:selector1
                                                     button2Title:button2Title
                                                          target2:target2
                                                        selector2:selector2];
            break;
        case PNSDIYPortraitFade:
            model = [self buildFadeModelWithButton1Title:button1Title
                                                 target1:target1
                                               selector1:selector1
                                            button2Title:button2Title
                                                 target2:target2
                                               selector2:selector2];
            break;
        case PNSDIYPortraitScale:
            model = [self buildScaleModelWithButton1Title:button1Title
                                                  target1:target1
                                                selector1:selector1
                                             button2Title:button2Title
                                                  target2:target2
                                                selector2:selector2];
            break;
        case PNSBuildModelStyleVideoBackground:
            model = [self buildVideoBackgroundModelWithButton1Title:button1Title
                                                            target1:target1
                                                          selector1:selector1
                                                       button2Title:button2Title
                                                            target2:target2
                                                          selector2:selector2];
            break;
        case PNSBuildModelStyleGifBackground:
            model = [self buildGifBackgroundModelWithButton1Title:button1Title
                                                          target1:target1
                                                        selector1:selector1
                                                     button2Title:button2Title
                                                          target2:target2
                                                        selector2:selector2];
            break;
        case PNSBuildModelStylePrivacyAlertPortraitAlert:
            model = [self buildPrivacyAlertPortraitModelWithButton1Title:button1Title
                                                                 target1:target1
                                                               selector1:selector1
                                                            button2Title:button2Title
                                                                 target2:target2
                                                               selector2:selector2];
            break;
        case PNSBuildModelStylePrivacyAlertPortraitActionSheet:
            model = [self buildPrivacyActionSheetPortraitModelWithButton1Title:button1Title
                                                                       target1:target1
                                                                     selector1:selector1
                                                                  button2Title:button2Title
                                                                       target2:target2
                                                                     selector2:selector2];
            break;
        case PNSBuildModelStylePrivacyAlertLandscapeAlert:
            model = [self buildPrivacyAlertLandscapeModelWithButton1Title:button1Title
                                                                  target1:target1
                                                                selector1:selector1
                                                             button2Title:button2Title
                                                                  target2:target2
                                                                selector2:selector2];
            break;
        case PNSBuildModelStylePrivacyAlertLandscapeActionSheet:
            model = [self buildPrivacyActionSheetLandscapeModelWithButton1Title:button1Title
                                                                        target1:target1
                                                                      selector1:selector1
                                                                   button2Title:button2Title
                                                                        target2:target2
                                                                      selector2:selector2];
            break;
        case PNSBuildModelStyleAlertPrivacyAlert:
            model = [self buildAlertPrivacyAlertModelWithButton1Title:button1Title
                                                              target1:target1
                                                            selector1:selector1
                                                         button2Title:button2Title
                                                              target2:target2
                                                            selector2:selector2];
        default:
            break;
    }
    return model;
}

#pragma mark - 二次确认弹窗相关
+ (TXCustomModel *)buildPrivacyAlertPortraitModelWithButton1Title:(NSString *)button1Title
                                                          target1:(id)target1
                                                        selector1:(SEL)selector1
                                                     button2Title:(NSString *)button2Title
                                                          target2:(id)target2
                                                        selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.navColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    model.privacyAlignment = NSTextAlignmentLeft;
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame),
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(button1.frame) + 15,
                                   CGRectGetWidth(loginFrame),
                                   30);
    };
    model.privacyAlertIsNeedShow = YES;
    model.privacyAlertMaskAlpha = 0.5;
    model.privacyAlertMaskColor = UIColor.blackColor;
    model.privacyAlertCornerRadiusArray = @[@10,@10,@10,@10];
    model.privacyAlertBackgroundColor = UIColor.whiteColor;
    model.privacyAlertAlpha = 1.0;
    model.privacyAlertTitleContent = @"请确认";
    model.privacyAlertTitleBackgroundColor = UIColor.whiteColor;
    model.privacyAlertContentBackgroundColor = UIColor.whiteColor;
    model.privacyAlertTitleFont = [UIFont systemFontOfSize:16];
    model.privacyAlertTitleColor = UIColor.blackColor;
    model.privacyAlertContentColors = @[UIColor.grayColor, UIColor.orangeColor];
    model.privacyAlertContentAlignment = NSTextAlignmentLeft;
    UIImage *activeImage = [TXCommonUtils imageWithColor:UIColor.whiteColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    UIImage *hightLightImage = [TXCommonUtils imageWithColor:UIColor.whiteColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    model.privacyAlertBtnBackgroundImages = @[activeImage, hightLightImage];
    model.privacyAlertBtnContent = @"确定";
    model.privacyAlertButtonTextColors = @[UIColor.blackColor,UIColor.blackColor];
    model.privacyAlertButtonFont = [UIFont systemFontOfSize:18];
    model.privacyAlertCloseButtonIsNeedShow = YES;
    model.privacyAlertMaskIsNeedShow = YES;
    model.privacyAlertIsNeedAutoLogin = NO;
    model.tapPrivacyAlertMaskCloseAlert = NO;
    model.expandAuthPageCheckedScope = YES;
    model.privacyAlertCloseButtonIsNeedShow = YES;
    
    UIView *horizontalLine = [UIView new];
    horizontalLine.backgroundColor = UIColor.lightGrayColor;
    
    UIView *verticalLine = [UIView new];
    verticalLine.backgroundColor = UIColor.lightGrayColor;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelPrivacyAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    model.privacyAlertTitleFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, 20, frame.size.width, frame.size.height);
    };
    model.privacyAlertPrivacyContentFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, frame.origin.y+10, frame.size.width, frame.size.height);
    };
    model.privacyAlertButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(superViewSize.width * 0.5 ,superViewSize.height - 50, superViewSize.width * 0.5, 50);;
    };
    model.privacyAlertFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(40, (superViewSize.height - 150)*0.5, screenSize.width-80, 150);
    };
    model.privacyAlertCustomViewBlock = ^(UIView * _Nonnull superPrivacyAlertCustomView) {
        [superPrivacyAlertCustomView addSubview:horizontalLine];
        [superPrivacyAlertCustomView addSubview:verticalLine];
        [superPrivacyAlertCustomView addSubview:cancelBtn];
    };
    model.privacyAlertCustomViewLayoutBlock = ^(CGRect privacyAlertFrame, CGRect privacyAlertTitleFrame, CGRect privacyAlertPrivacyContentFrame, CGRect privacyAlertButtonFrame, CGRect privacyAlertCloseFrame) {
        horizontalLine.frame = CGRectMake(0, CGRectGetHeight(privacyAlertFrame) - 50 - 1, CGRectGetWidth(privacyAlertFrame), 1);
        verticalLine.frame = CGRectMake(CGRectGetWidth(privacyAlertFrame) * 0.5, CGRectGetMaxY(horizontalLine.frame), 1, 50);
        cancelBtn.frame = CGRectMake(0, CGRectGetHeight(privacyAlertFrame) - 50, CGRectGetWidth(privacyAlertFrame) * 0.5, 50);
    };
    
    return model;
}

+ (TXCustomModel *)buildPrivacyActionSheetPortraitModelWithButton1Title:(NSString *)button1Title
                                                                target1:(id)target1
                                                              selector1:(SEL)selector1
                                                           button2Title:(NSString *)button2Title
                                                                target2:(id)target2
                                                              selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.navColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame),
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(button1.frame) + 15,
                                   CGRectGetWidth(loginFrame),
                                   30);
    };
    
    model.privacyAlertIsNeedShow = YES;
    model.privacyAlertMaskAlpha = 0.3;
    model.privacyAlertMaskColor = UIColor.blackColor;
    model.privacyAlertCornerRadiusArray = @[@10,@0,@0,@10];
    model.privacyAlertBackgroundColor = UIColor.whiteColor;
    model.privacyAlertAlpha = 1.0;
    model.privacyAlertTitleBackgroundColor = UIColor.whiteColor;
    model.privacyAlertContentBackgroundColor = UIColor.whiteColor;
    model.privacyAlertTitleFont = [UIFont systemFontOfSize:16];
    model.privacyAlertTitleColor = UIColor.blackColor;
    model.privacyAlertContentColors = @[UIColor.grayColor, UIColor.orangeColor];
    model.privacyAlertContentAlignment = NSTextAlignmentCenter;
    UIImage *activeImage = [TXCommonUtils imageWithColor:UIColor.orangeColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    UIImage *hightLightImage = [TXCommonUtils imageWithColor:UIColor.grayColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    model.privacyAlertBtnBackgroundImages = @[activeImage, hightLightImage];
    model.privacyAlertButtonTextColors = @[UIColor.whiteColor,UIColor.blueColor];
    model.privacyAlertButtonFont = [UIFont systemFontOfSize:13];
    model.privacyAlertCloseButtonIsNeedShow = YES;
    model.privacyAlertMaskIsNeedShow = YES;
    model.privacyAlertIsNeedAutoLogin = YES;
    model.privacyAlertTitleFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, 20, frame.size.width, frame.size.height);
    };
    model.privacyAlertPrivacyContentFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, frame.origin.y+10, frame.size.width, frame.size.height);
    };
    model.privacyAlertButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(frame.origin.x, frame.origin.y+20, frame.size.width, frame.size.height);;
    };
    model.privacyAlertFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, superViewSize.height -200, screenSize.width, 200);
    };
    return model;
}


+ (TXCustomModel *)buildPrivacyAlertLandscapeModelWithButton1Title:(NSString *)button1Title
                                                           target1:(id)target1
                                                         selector1:(SEL)selector1
                                                      button2Title:(NSString *)button2Title
                                                           target2:(id)target2
                                                         selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    model.navColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.sloganIsHidden = YES;
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 15;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 15 + 80 + 15;
        return frame;
    };
    
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 110 + 30 + 20;
        return frame;
    };
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame) * 0.5,
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
                                   CGRectGetMinY(button1.frame),
                                   CGRectGetWidth(loginFrame) * 0.5,
                                   30);
    };
    
    model.privacyAlertIsNeedShow = YES;
    model.privacyAlertMaskAlpha = 0.3;
    model.privacyAlertTitleContent = @"请确认";
    model.privacyAlertMaskColor = UIColor.blackColor;
    model.privacyAlertCornerRadiusArray = @[@10,@10,@10,@10];
    model.privacyAlertBackgroundColor = UIColor.whiteColor;
    model.privacyAlertAlpha = 1.0;
    model.privacyAlertTitleBackgroundColor = UIColor.whiteColor;
    model.privacyAlertContentBackgroundColor = UIColor.whiteColor;
    model.privacyAlertTitleFont = [UIFont systemFontOfSize:16];
    model.privacyAlertTitleColor = UIColor.blackColor;
    model.privacyAlertContentColors = @[UIColor.grayColor, UIColor.orangeColor];
    model.privacyAlertContentAlignment = NSTextAlignmentCenter;
    UIImage *activeImage = [TXCommonUtils imageWithColor:UIColor.whiteColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    UIImage *hightLightImage = [TXCommonUtils imageWithColor:UIColor.whiteColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    model.privacyAlertBtnBackgroundImages = @[activeImage, hightLightImage];
    model.privacyAlertBtnContent = @"确定";
    model.privacyAlertButtonTextColors = @[UIColor.blackColor,UIColor.blackColor];
    model.privacyAlertButtonFont = [UIFont systemFontOfSize:18];
    model.privacyAlertCloseButtonIsNeedShow = YES;
    model.privacyAlertMaskIsNeedShow = YES;
    model.privacyAlertIsNeedAutoLogin = YES;
    
    UIView *horizontalLine = [UIView new];
    horizontalLine.backgroundColor = UIColor.lightGrayColor;
    
    UIView *verticalLine = [UIView new];
    verticalLine.backgroundColor = UIColor.lightGrayColor;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelPrivacyAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    model.privacyAlertFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake((superViewSize.width - 400)*0.5, (superViewSize.height -150)*0.5, 400, 150);
    };
    model.privacyAlertTitleFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, 20, frame.size.width, frame.size.height);
    };
    model.privacyAlertPrivacyContentFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, frame.origin.y+10, frame.size.width, frame.size.height);
    };
    model.privacyAlertButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(superViewSize.width*0.5, superViewSize.height - frame.size.height , superViewSize.width*0.5, frame.size.height);;
    };
    
    model.privacyAlertCustomViewBlock = ^(UIView * _Nonnull superPrivacyAlertCustomView) {
        [superPrivacyAlertCustomView addSubview:horizontalLine];
        [superPrivacyAlertCustomView addSubview:verticalLine];
        [superPrivacyAlertCustomView addSubview:cancelBtn];
    };
    model.privacyAlertCustomViewLayoutBlock = ^(CGRect privacyAlertFrame, CGRect privacyAlertTitleFrame, CGRect privacyAlertPrivacyContentFrame, CGRect privacyAlertButtonFrame, CGRect privacyAlertCloseFrame) {
        horizontalLine.frame = CGRectMake(0, CGRectGetHeight(privacyAlertFrame) - 50 - 1, CGRectGetWidth(privacyAlertFrame), 1);
        verticalLine.frame = CGRectMake(CGRectGetWidth(privacyAlertFrame) * 0.5, CGRectGetMaxY(horizontalLine.frame), 1, 50);
        cancelBtn.frame = CGRectMake(0, CGRectGetHeight(privacyAlertFrame) - 50, CGRectGetWidth(privacyAlertFrame) * 0.5, 50);
    };
    
    return model;
}

+ (TXCustomModel *)buildPrivacyActionSheetLandscapeModelWithButton1Title:(NSString *)button1Title
                                                                 target1:(id)target1
                                                               selector1:(SEL)selector1
                                                            button2Title:(NSString *)button2Title
                                                                 target2:(id)target2
                                                               selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    model.navColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.sloganIsHidden = YES;
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 15;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 15 + 80 + 15;
        return frame;
    };
    
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 110 + 30 + 20;
        return frame;
    };
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame) * 0.5,
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
                                   CGRectGetMinY(button1.frame),
                                   CGRectGetWidth(loginFrame) * 0.5,
                                   30);
    };
    
    model.privacyAlertIsNeedShow = YES;
    model.privacyAlertMaskAlpha = 0.3;
    model.privacyAlertMaskColor = UIColor.blackColor;
    model.privacyAlertCornerRadiusArray = @[@10,@0,@0,@10];
    model.privacyAlertBackgroundColor = UIColor.whiteColor;
    model.privacyAlertAlpha = 1.0;
    model.privacyAlertTitleBackgroundColor = UIColor.whiteColor;
    model.privacyAlertContentBackgroundColor = UIColor.whiteColor;
    model.privacyAlertTitleFont = [UIFont systemFontOfSize:16];
    model.privacyAlertTitleColor = UIColor.blackColor;
    model.privacyAlertContentColors = @[UIColor.grayColor, UIColor.orangeColor];
    model.privacyAlertContentAlignment = NSTextAlignmentCenter;
    UIImage *activeImage = [TXCommonUtils imageWithColor:UIColor.orangeColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    UIImage *hightLightImage = [TXCommonUtils imageWithColor:UIColor.grayColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    model.privacyAlertBtnBackgroundImages = @[activeImage, hightLightImage];
    model.privacyAlertButtonTextColors = @[UIColor.whiteColor,UIColor.blueColor];
    model.privacyAlertButtonFont = [UIFont systemFontOfSize:13];
    model.privacyAlertCloseButtonIsNeedShow = YES;
    model.privacyAlertMaskIsNeedShow = YES;
    model.privacyAlertIsNeedAutoLogin = YES;
    
    model.privacyAlertFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake((superViewSize.width - 400)*0.5, (superViewSize.height -150), 400, 150);
    };
    model.privacyAlertTitleFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, 20, frame.size.width, frame.size.height);
    };
    model.privacyAlertPrivacyContentFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, frame.origin.y+10, frame.size.width, frame.size.height);
    };
    model.privacyAlertButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(frame.origin.x, frame.origin.y+20, frame.size.width, frame.size.height);;
    };
    
    return model;
}


+ (TXCustomModel *)buildAlertPrivacyAlertModelWithButton1Title:(NSString *)button1Title
                                                       target1:(id)target1
                                                     selector1:(SEL)selector1
                                                  button2Title:(NSString *)button2Title
                                                       target2:(id)target2
                                                     selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.suspendDisMissVC = YES;
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.alertCornerRadiusArray = @[@10, @10, @10, @10];
    model.alertTitleBarColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = superViewSize.width * 0.8;
        frame.size.height = frame.size.width / 0.618;
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        frame.origin.y = (superViewSize.height - frame.size.height) * 0.5;
        return frame;
    };
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 20;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 20 + 80 + 20;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 120 + 20 + 15;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 155 + 20 + 30;
        return frame;
    };
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame),
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(button1.frame) + 15,
                                   CGRectGetWidth(loginFrame),
                                   30);
    };
    model.privacyAlertIsNeedShow = YES;
    model.privacyAlertMaskAlpha = 0.3;
    model.privacyAlertTitleContent = @"请确认";
    model.privacyAlertMaskColor = UIColor.blackColor;
    model.privacyAlertCornerRadiusArray = @[@10,@10,@10,@10];
    model.privacyAlertBackgroundColor = UIColor.whiteColor;
    model.privacyAlertAlpha = 1.0;
    model.privacyAlertTitleBackgroundColor = UIColor.whiteColor;
    model.privacyAlertContentBackgroundColor = UIColor.whiteColor;
    model.privacyAlertTitleFont = [UIFont systemFontOfSize:16];
    model.privacyAlertTitleColor = UIColor.blackColor;
    model.privacyAlertContentColors = @[UIColor.grayColor, UIColor.orangeColor];
    model.privacyAlertContentAlignment = NSTextAlignmentCenter;
    UIImage *activeImage = [TXCommonUtils imageWithColor:UIColor.whiteColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    UIImage *hightLightImage = [TXCommonUtils imageWithColor:UIColor.whiteColor size:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 2 * 18, 50) isRoundedCorner:YES radius:10];
    model.privacyAlertBtnBackgroundImages = @[activeImage, hightLightImage];
    model.privacyAlertBtnContent = @"确定";
    model.privacyAlertButtonTextColors = @[UIColor.blackColor,UIColor.blackColor];
    model.privacyAlertButtonFont = [UIFont systemFontOfSize:18];
    model.privacyAlertCloseButtonIsNeedShow = YES;
    model.privacyAlertMaskIsNeedShow = YES;
    model.privacyAlertIsNeedAutoLogin = YES;
    
    UIView *horizontalLine = [UIView new];
    horizontalLine.backgroundColor = UIColor.lightGrayColor;
    
    UIView *verticalLine = [UIView new];
    verticalLine.backgroundColor = UIColor.lightGrayColor;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelPrivacyAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    model.privacyAlertFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake((superViewSize.width - 400)*0.5, (superViewSize.height -150)*0.5, 400, 150);
    };
    model.privacyAlertTitleFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, 20, frame.size.width, frame.size.height);
    };
    model.privacyAlertPrivacyContentFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, frame.origin.y+10, frame.size.width, frame.size.height);
    };
    model.privacyAlertButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(superViewSize.width*0.5, superViewSize.height - frame.size.height , superViewSize.width*0.5, frame.size.height);;
    };
    
    model.privacyAlertCustomViewBlock = ^(UIView * _Nonnull superPrivacyAlertCustomView) {
        [superPrivacyAlertCustomView addSubview:horizontalLine];
        [superPrivacyAlertCustomView addSubview:verticalLine];
        [superPrivacyAlertCustomView addSubview:cancelBtn];
    };
    model.privacyAlertCustomViewLayoutBlock = ^(CGRect privacyAlertFrame, CGRect privacyAlertTitleFrame, CGRect privacyAlertPrivacyContentFrame, CGRect privacyAlertButtonFrame, CGRect privacyAlertCloseFrame) {
        horizontalLine.frame = CGRectMake(0, CGRectGetHeight(privacyAlertFrame) - 50 - 1, CGRectGetWidth(privacyAlertFrame), 1);
        verticalLine.frame = CGRectMake(CGRectGetWidth(privacyAlertFrame) * 0.5, CGRectGetMaxY(horizontalLine.frame), 1, 50);
        cancelBtn.frame = CGRectMake(0, CGRectGetHeight(privacyAlertFrame) - 50, CGRectGetWidth(privacyAlertFrame) * 0.5, 50);
    };
    return model;
}

#pragma mark - 全屏相关

+ (TXCustomModel *)buildFullScreenPortraitModelWithButton1Title:(NSString *)button1Title
                                                        target1:(id)target1
                                                      selector1:(SEL)selector1
                                                   button2Title:(NSString *)button2Title
                                                        target2:(id)target2
                                                      selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.suspendDisMissVC = YES;
    model.navColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.values = @[@0,@(-10),@10,@(-10),@5,@(-5),@0];
    animation.keyTimes = @[@0,@(1/6.0),@(2/6.0),@(3/6.0),@(4/6.0),@(5/6.0),@1];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.5;
    
    model.checkboxAnimation = animation;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame),
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(button1.frame) + 15,
                                   CGRectGetWidth(loginFrame),
                                   30);
    };
    return model;
}

+ (TXCustomModel *)buildFullScreenLandscapeModelWithButton1Title:(NSString *)button1Title
                                                         target1:(id)target1
                                                       selector1:(SEL)selector1
                                                    button2Title:(NSString *)button2Title
                                                         target2:(id)target2
                                                       selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    model.navColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.sloganIsHidden = YES;
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 15;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 15 + 80 + 15;
        return frame;
    };
    
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 110 + 30 + 20;
        return frame;
    };
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame) * 0.5,
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
                                   CGRectGetMinY(button1.frame),
                                   CGRectGetWidth(loginFrame) * 0.5,
                                   30);
    };
    return model;
}

+ (TXCustomModel *)buildFullScreenAutorotateModelWithButton1Title:(NSString *)button1Title
                                                          target1:(id)target1
                                                        selector1:(SEL)selector1
                                                     button2Title:(NSString *)button2Title
                                                          target2:(id)target2
                                                        selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    model.navColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = screenSize.height > screenSize.width ? 30 : 15;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.size.width = superViewSize.width - 40;
            frame.size.height = 20;
            frame.origin.x = 20;
            frame.origin.y = 20 + 80 + 20;
            return frame;
        } else {
            return CGRectZero;
        }
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.origin.y = 130 + 20 + 15;
        } else {
            frame.origin.y = 15 + 80 + 15;
        }
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.origin.y = 170 + 30 + 20;
        } else {
            frame.origin.y = 110 + 30 + 20;
        }
        return frame;
    };
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        if (screenSize.height > screenSize.width) {
            button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                       CGRectGetMaxY(loginFrame) + 20,
                                       CGRectGetWidth(loginFrame),
                                       30);
            
            button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                       CGRectGetMaxY(button1.frame) + 15,
                                       CGRectGetWidth(loginFrame),
                                       30);
        } else {
            button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                       CGRectGetMaxY(loginFrame) + 20,
                                       CGRectGetWidth(loginFrame) * 0.5,
                                       30);
            
            button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
                                       CGRectGetMinY(button1.frame),
                                       CGRectGetWidth(loginFrame) * 0.5,
                                       30);
        }
    };
    return model;
}

#pragma mark - 弹窗

+ (TXCustomModel *)buildAlertPortraitModeWithButton1Title:(NSString *)button1Title
                                                  target1:(id)target1
                                                selector1:(SEL)selector1
                                             button2Title:(NSString *)button2Title
                                                  target2:(id)target2
                                                selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.suspendDisMissVC = YES;
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.alertCornerRadiusArray = @[@10, @10, @10, @10];
    model.alertTitleBarColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = superViewSize.width * 0.8;
        frame.size.height = frame.size.width / 0.618;
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        frame.origin.y = (superViewSize.height - frame.size.height) * 0.5;
        return frame;
    };
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 20;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 20 + 80 + 20;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 120 + 20 + 15;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 155 + 20 + 30;
        return frame;
    };
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame),
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(button1.frame) + 15,
                                   CGRectGetWidth(loginFrame),
                                   30);
    };
    return model;
}

+ (TXCustomModel *)buildAlertLandscapeModeWithButton1Title:(NSString *)button1Title
                                                   target1:(id)target1
                                                 selector1:(SEL)selector1
                                              button2Title:(NSString *)button2Title
                                                   target2:(id)target2
                                                 selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    model.alertCornerRadiusArray = @[@10, @10, @10, @10];
    model.alertTitleBarColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    model.logoIsHidden = YES;
    model.sloganIsHidden = YES;
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.height = superViewSize.height * 0.8;
        frame.size.width = frame.size.height / 0.618;
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        frame.origin.y = (superViewSize.height - frame.size.height) * 0.5;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 30;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 30 + 20 + 30;
        return frame;
    };
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame) * 0.5,
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
                                   CGRectGetMinY(button1.frame),
                                   CGRectGetWidth(loginFrame) * 0.5,
                                   30);
    };
    return model;
}

+ (TXCustomModel *)buildAlertAutorotateModeWithButton1Title:(NSString *)button1Title
                                                    target1:(id)target1
                                                  selector1:(SEL)selector1
                                               button2Title:(NSString *)button2Title
                                                    target2:(id)target2
                                                  selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    model.alertCornerRadiusArray = @[@10, @10, @10, @10];
    model.alertTitleBarColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.sloganIsHidden = YES;
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"自定义协议", @"https://www.taobao.com"];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.size.width = superViewSize.width * 0.8;
            frame.size.height = frame.size.width / 0.618;
        } else {
            frame.size.height = superViewSize.height * 0.8;
            frame.size.width = frame.size.height / 0.618;
        }
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        frame.origin.y = (superViewSize.height - frame.size.height) * 0.5;
        return frame;
    };
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.size.width = 80;
            frame.size.height = 80;
            frame.origin.y = 20;
            frame.origin.x = (superViewSize.width - 80) * 0.5;
        } else {
            frame = CGRectZero;
        }
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.size.height = 20;
            frame.size.width = superViewSize.width - 40;
            frame.origin.x = 20;
            frame.origin.y = 20 + 80 + 20;
        } else {
            frame = CGRectZero;
        }
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.origin.y = 120 + 20 + 15;
        } else {
            frame.origin.y = 30;
        }
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if (screenSize.height > screenSize.width) {
            frame.origin.y = 155 + 20 + 30;
        } else {
            frame.origin.y = 30 + 20 + 30;
        }
        return frame;
    };
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        if (screenSize.height > screenSize.width) {
            button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                       CGRectGetMaxY(loginFrame) + 20,
                                       CGRectGetWidth(loginFrame),
                                       30);
            
            button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                       CGRectGetMaxY(button1.frame) + 15,
                                       CGRectGetWidth(loginFrame),
                                       30);
        } else {
            button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                       CGRectGetMaxY(loginFrame) + 20,
                                       CGRectGetWidth(loginFrame) * 0.5,
                                       30);
            
            button2.frame = CGRectMake(CGRectGetMaxX(button1.frame),
                                       CGRectGetMinY(button1.frame),
                                       CGRectGetWidth(loginFrame) * 0.5,
                                       30);
        }
    };
    return model;
}

#pragma mark - 底部弹窗

+ (TXCustomModel *)buildSheetPortraitModelWithButton1Title:(NSString *)button1Title
                                                   target1:(id)target1
                                                 selector1:(SEL)selector1
                                              button2Title:(NSString *)button2Title
                                                   target2:(id)target2
                                                 selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.alertCornerRadiusArray = @[@10, @0, @0, @10];
    model.alertTitleBarColor = [UIColor orangeColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.alertCloseImage = [UIImage imageNamed:@"icon_close_light"];
    model.logoImage = [UIImage imageNamed:@"taobao"];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = superViewSize.width;
        frame.size.height = 460;
        frame.origin.x = 0;
        frame.origin.y = superViewSize.height - frame.size.height;
        return frame;
    };
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 20;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 20 + 80 + 20;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 120 + 20 + 15;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 155 + 20 + 30;
        return frame;
    };
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:button2Title forState:UIControlStateNormal];
    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
        [superCustomView addSubview:button2];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame),
                                   30);
        
        button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(button1.frame) + 15,
                                   CGRectGetWidth(loginFrame),
                                   30);
    };
    return model;
}

#pragma mark - DIY 动画
+ (TXCustomModel *)buildAlertFadeModelWithButton1Title:(NSString *)button1Title
                                               target1:(id)target1
                                             selector1:(SEL)selector1
                                          button2Title:(NSString *)button2Title
                                               target2:(id)target2
                                             selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildAlertPortraitModeWithButton1Title:button1Title
                                                                target1:target1
                                                              selector1:selector1
                                                           button2Title:button2Title
                                                                target2:target2
                                                              selector2:selector2];
    
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.fromValue = @1.03;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.exitAnimation = exitAnimation;
    
    //背景本身就是渐变，可以省略不写 model.bgEntryAnimation、model.bgExitAnimation
    return model;
}

+ (TXCustomModel *)buildAlertBounceModelWithButton1Title:(NSString *)button1Title
                                                 target1:(id)target1
                                               selector1:(SEL)selector1
                                            button2Title:(NSString *)button2Title
                                                 target2:(id)target2
                                               selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildAlertPortraitModeWithButton1Title:button1Title
                                                                target1:target1
                                                              selector1:selector1
                                                           button2Title:button2Title
                                                                target2:target2
                                                              selector2:selector2];
    
    CAKeyframeAnimation *entryAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.values = @[@0.01, @1.2, @0.9, @1];
    entryAnimation.keyTimes = @[@0, @0.4, @0.6, @1];
    entryAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    entryAnimation.duration = 0.25;
    model.entryAnimation = entryAnimation;
    
    CAKeyframeAnimation *exitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    exitAnimation.values = @[@1, @1.2, @0.01];
    exitAnimation.keyTimes = @[@0, @0.4, @1];
    exitAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    exitAnimation.duration = 0.25;
    model.exitAnimation = exitAnimation;
    
    //背景使用默认的渐变效果，可以省略不写 model.bgEntryAnimation、model.bgExitAnimation
    return model;
}

+ (TXCustomModel *)buildAlertDropDownModelWithButton1Title:(NSString *)button1Title
                                                   target1:(id)target1
                                                 selector1:(SEL)selector1
                                              button2Title:(NSString *)button2Title
                                                   target2:(id)target2
                                                 selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildAlertPortraitModeWithButton1Title:button1Title
                                                                target1:target1
                                                              selector1:selector1
                                                           button2Title:button2Title
                                                                target2:target2
                                                              selector2:selector2];
    
    //提前设置好弹窗大小，弹窗是依赖于全屏布局，所以其父视图大小即为屏幕大小
    CGFloat width = UIScreen.mainScreen.bounds.size.width * 0.8;
    CGFloat height = width / 0.618;
    CGFloat x = (UIScreen.mainScreen.bounds.size.width - width) * 0.5;
    CGFloat y = (UIScreen.mainScreen.bounds.size.height - height) * 0.5;
    CGRect contentViewFrame = CGRectMake(x, y, width, height);
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return contentViewFrame;
    };
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.values = @[@(-CGRectGetMaxY(contentViewFrame)), @20, @-10, @0];
    animation.keyTimes = @[@0, @0.5, @0.75, @1];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.25;
    model.entryAnimation = animation;
    
    //背景使用默认的渐变效果，可以省略不写 model.bgEntryAnimation、model.bgExitAnimation
    return model;
}

+ (TXCustomModel *)buildFadeModelWithButton1Title:(NSString *)button1Title
                                          target1:(id)target1
                                        selector1:(SEL)selector1
                                     button2Title:(NSString *)button2Title
                                          target2:(id)target2
                                        selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildFullScreenPortraitModelWithButton1Title:button1Title
                                                                      target1:target1
                                                                    selector1:selector1
                                                                 button2Title:button2Title
                                                                      target2:target2
                                                                    selector2:selector2];
    
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    entryAnimation.fromValue = @0.5;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.exitAnimation = exitAnimation;
    
    return model;
}

+ (TXCustomModel *)buildScaleModelWithButton1Title:(NSString *)button1Title
                                           target1:(id)target1
                                         selector1:(SEL)selector1
                                      button2Title:(NSString *)button2Title
                                           target2:(id)target2
                                         selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildFullScreenPortraitModelWithButton1Title:button1Title
                                                                      target1:target1
                                                                    selector1:selector1
                                                                 button2Title:button2Title
                                                                      target2:target2
                                                                    selector2:selector2];
    
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.fromValue = @0;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    model.exitAnimation = exitAnimation;
    
    return model;
}

#pragma mark - other
+ (TXCustomModel *)buildVideoBackgroundModelWithButton1Title:(NSString *)button1Title
                                                     target1:(id)target1
                                                   selector1:(SEL)selector1
                                                button2Title:(NSString *)button2Title
                                                     target2:(id)target2
                                                   selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    //model.navIsHidden = YES;
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.navColor = [UIColor clearColor];
    model.navTitle = [[NSAttributedString alloc] init];
    model.logoIsHidden = YES;
    model.numberColor = [UIColor whiteColor];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    PNSBackgroundView *backgroundView = [[PNSBackgroundView alloc] init];
    backgroundView.videoUrl = [NSBundle.mainBundle URLForResource:@"background_video" withExtension:@"mp4"];
    [backgroundView show];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:backgroundView];
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45 + 50;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45 + 130;
        return frame;
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        backgroundView.frame = CGRectMake(0,
                                          -CGRectGetMaxY(navFrame),
                                          contentViewFrame.size.width,
                                          contentViewFrame.size.height);
    };
    return model;
}

+ (TXCustomModel *)buildGifBackgroundModelWithButton1Title:(NSString *)button1Title
                                                   target1:(id)target1
                                                 selector1:(SEL)selector1
                                              button2Title:(NSString *)button2Title
                                                   target2:(id)target2
                                                 selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    //model.navIsHidden = YES;
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.navColor = [UIColor clearColor];
    model.navTitle = [[NSAttributedString alloc] init];
    model.logoIsHidden = YES;
    model.numberColor = [UIColor whiteColor];
    model.changeBtnIsHidden = YES;
    model.privacyOne = @[@"协议1", @"https://www.taobao.com"];
    
    PNSBackgroundView *backgroundView = [[PNSBackgroundView alloc] init];
    backgroundView.gifUrl = [NSBundle.mainBundle URLForResource:@"background_gif" withExtension:@"gif"];
    [backgroundView show];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:backgroundView];
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45 + 50;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = superViewSize.height * 0.45 + 130;
        return frame;
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        backgroundView.frame = CGRectMake(0,
                                          -CGRectGetMaxY(navFrame),
                                          contentViewFrame.size.width,
                                          contentViewFrame.size.height);
    };
    return model;
}

+ (void)cancelPrivacyAlert:(UIButton *)btn {
    [[TXCommonHandler sharedInstance] closePrivactAlertView];
}

@end
