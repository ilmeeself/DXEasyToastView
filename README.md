# DXEasyToastView
iOS(OC)--提示框

#import "toastView.h"

@property (nonatomic,strong) ToastView *toastView;

// 使用方法
- (void)UsingToastView{
    self.toastView = [[ToastView alloc]initWithTips:@"init" withFrame:CGRectMake(8, -SafeAreaTopHeight, GLOBLE_WIDTH-16, 44)];
    // 自定义提示词
    [self.toastView setTipsWithString:@"提示语句"];
    // 配置背景颜色
    [self.toastView setTipsViewWithBackgroundColor:UIRGBColor(255, 91, 91, 1)];
    // 显示
    [self.toastView showToastWithDelayTime:0.5f withAutoDissappearTime:4.0f fromWindow:[UIApplication sharedApplication].keyWindow withY:SafeAreaTopHeight-44];
}
// 调用
[self UsingToastView];
