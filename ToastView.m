//
//  ToastView.m
//  xxx
//
//  Created by Du on 2017/9/20.
//  Copyright © 2017年 xxx. All rights reserved.
//

#import "ToastView.h"

//
#define GLOBLE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define GLOBLE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define UIRGBColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断是否刘海屏
#define iPhoneX ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? YES : NO)
//iPhoneX系列
#define Height_StatusBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define Height_NavBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
#define Height_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)

#define OG_X_Value 8
#define OG_Y_Value (iPhoneX ? 45 : 25)
#define OG_Height 44

@implementation ToastView

- (instancetype)initWithTips:(NSString *)tips withFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isNeedShow = YES;
        self.frame = frame;
        self.backgroundColor = UIRGBColor(221, 81, 82, 1);
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.alpha = 0.0f;
        
        self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, frame.size.width - 20, frame.size.height-5)];
        self.tipLabel.text = tips;
        self.tipLabel.font = [UIFont systemFontOfSize:12.0];
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.numberOfLines = 2;
        [self addSubview:self.tipLabel];
        
        UISwipeGestureRecognizer *leftGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipesLeft)];
        leftGesture.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftGesture];
        
        UISwipeGestureRecognizer *rightGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipesRight)];
        rightGesture.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightGesture];
    }
    return self;
}

//提示出现
- (void)showToastWithDelayTime:(float)delayTime withAutoDissappearTime:(float)time fromWindow:(UIWindow *)whereWindow withY:(float)y{
    if (self.isNeedShow) {
        //每次创建时复位
        [self.hiddenTimer invalidate];
        [self removeFromSuperview];
        
        self.frame = CGRectMake(OG_X_Value, -Height_NavBar, GLOBLE_WIDTH-OG_X_Value*2, OG_Height);
        [UIView animateWithDuration:delayTime animations:^{
            [whereWindow addSubview:self];
            self.alpha = 1.0f;
            self.frame = CGRectMake(OG_X_Value, y+5, GLOBLE_WIDTH-OG_X_Value*2, OG_Height);
            if (time != 0.0f) {
                [self autoDissAppearWithDelayTime:time];
            }
        }];
        //回调optional
        self.isNeedShow = NO;
    }
}

//提示出现
- (void)showToastWithDelayTime:(float)delayTime withAutoDissappearTime:(float)time fromVC:(UIViewController *)whereVC{
    if (self.isNeedShow) {
        //每次创建时复位
        [self.hiddenTimer invalidate];
        [self removeFromSuperview];
        self.frame = CGRectMake(OG_X_Value, -Height_NavBar, GLOBLE_WIDTH-OG_X_Value*2, OG_Height);
        [UIView animateWithDuration:delayTime animations:^{
            [whereVC.view addSubview:self];
            self.alpha = 1.0f;
            self.frame = CGRectMake(OG_X_Value, OG_Y_Value, GLOBLE_WIDTH-OG_X_Value*2, OG_Height);
            if (time != 0.0f) {
                [self autoDissAppearWithDelayTime:time];
            }
        }];
        //回调optional
        self.isNeedShow = NO;
    }
}

//自动消失
- (void)autoDissAppearWithDelayTime:(float)time{
    [self.hiddenTimer invalidate];
    self.hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(hideTipView) userInfo:nil repeats:NO];
}

//隐藏
- (void)hideTipView{
    if (!self.isNeedShow) {
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = CGRectMake(OG_X_Value, -Height_NavBar, GLOBLE_WIDTH-OG_X_Value*2, OG_Height);
            self.alpha = 0.0f;
        }];
        //回调optional
        if ([self.delegate respondsToSelector:@selector(toastViewHidden)]) {
            [self.delegate toastViewHidden];
        }
        self.isNeedShow = YES;
        [self.hiddenTimer invalidate];
    }
}

//向左滑隐藏
- (void)handleSwipesLeft{
    if (!self.isNeedShow) {
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = CGRectMake(OG_X_Value, OG_Y_Value, GLOBLE_WIDTH-OG_X_Value*2, OG_Height);
            self.alpha = 0.0f;
        }];
        //回调optional
        if ([self.delegate respondsToSelector:@selector(toastViewHiddenForLeft)]) {
            [self.delegate toastViewHiddenForLeft];
        }
        self.isNeedShow = YES;
        [self.hiddenTimer invalidate];
    }
    
}

//向右滑隐藏
- (void)handleSwipesRight{
    if (!self.isNeedShow) {
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = CGRectMake(OG_X_Value, OG_Y_Value, GLOBLE_WIDTH-OG_X_Value*2, OG_Height);
            self.alpha = 0.0f;
        }];
        //回调optional
        if ([self.delegate respondsToSelector:@selector(toastViewHiddenForRight)]) {
            [self.delegate toastViewHiddenForRight];
        }
        self.isNeedShow = YES;
        [self.hiddenTimer invalidate];
    }
}

- (void)setTipsWithString:(NSString *)tip{
    self.tipLabel.text = tip;
}

- (void)setTipsViewWithBackgroundColor:(UIColor *)color{
    self.backgroundColor = color;
}

- (void)viewRemoveFromSupweView{
    [self removeFromSuperview];
}
@end
