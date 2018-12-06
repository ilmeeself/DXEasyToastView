//
//  ToastView.m
//  xxx
//
//  Created by Du on 2017/9/20.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToastView;

/**
 对提示框触发行为的协议
 */
@protocol ToastViewDelegate <NSObject>
@optional
- (void)toastViewShow;
- (void)toastViewHidden;
- (void)toastViewHiddenForLeft;
- (void)toastViewHiddenForRight;
@end

@interface ToastView : UIView
@property (weak,nonatomic) id<ToastViewDelegate> delegate;
@property (nonatomic,strong)UILabel *tipLabel;
@property (nonatomic,strong)NSTimer *hiddenTimer;
@property (nonatomic)BOOL isNeedShow;

/**
 init
 
 @param tips 提示语
 @param frame 大小位置
 @return 视图对象
 */
- (instancetype)initWithTips:(NSString *)tips withFrame:(CGRect)frame;

/**
 设置提示框提示词

 @param tip 提示词
 */
- (void)setTipsWithString:(NSString *)tip;

/**
 设置提示框背景颜色

 @param color 颜色
 */
- (void)setTipsViewWithBackgroundColor:(UIColor *)color;


/**
 触发显示APP

 @param delayTime 出现时间（快慢）
 @param time 保存时间
 @param whereWindow 显示窗口
 @param y y轴位置
 */
- (void)showToastWithDelayTime:(float)delayTime withAutoDissappearTime:(float)time fromWindow:(UIWindow *)whereWindow withY:(float)y;

/**
 触发显示share extension
 
 @param delayTime 出现时间（快慢）
 @param time 保存时间
 @param whereVC 显示VC
 */
- (void)showToastWithDelayTime:(float)delayTime withAutoDissappearTime:(float)time fromVC:(UIViewController *)whereVC;

/**
 触发隐藏
 */
- (void)hideTipView;

@end
