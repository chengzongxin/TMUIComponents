//
//  TMUITips.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/19.
//

#import <UIKit/UIKit.h>
#import "TMUIToastView.h"

#define TMUITipsText(text) [TMUITips showWithText:text]
// 自动计算秒数的标志符，在 delay 里面赋值 TMUITipsAutomaticallyHideToastSeconds 即可通过自动计算 tips 消失的秒数
extern const NSInteger TMUITipsAutomaticallyHideToastSeconds;

/// 默认的 parentView
#define DefaultTipsParentView (UIApplication.sharedApplication.delegate.window)

/**
 * 简单封装了 TMUIToastView，支持弹出纯文本、loading、succeed、error、info 等五种 tips。如果这些接口还满足不了业务的需求，可以通过 TMUITips 的分类自行添加接口。
 * 注意用类方法显示 tips 的话，会导致父类的 willShowBlock 无法正常工作，具体请查看 willShowBlock 的注释。
 * @warning 使用类方法，除了 showLoading 系列方法不会自动隐藏外，其他方法如果没有 delay 参数，则会自动隐藏
 * @see [TMUIToastView willShowBlock]
 */
@interface TMUITips : TMUIToastView

NS_ASSUME_NONNULL_BEGIN

/// 实例方法：需要自己addSubview，hide之后不会自动removeFromSuperView

- (void)showLoading;
- (void)showLoading:(nullable NSString *)text;
- (void)showLoadingHideAfterDelay:(NSTimeInterval)delay;
- (void)showLoading:(nullable NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showLoading:(nullable NSString *)text detailText:(nullable NSString *)detailText;
- (void)showLoading:(nullable NSString *)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showWithText:(nullable NSString *)text;
- (void)showWithText:(nullable NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showWithText:(nullable NSString *)text detailText:(nullable NSString *)detailText;
- (void)showWithText:(nullable NSString *)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showSucceed:(nullable NSString *)text;
- (void)showSucceed:(nullable NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showSucceed:(nullable NSString *)text detailText:(nullable NSString *)detailText;
- (void)showSucceed:(nullable NSString *)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showError:(nullable NSString *)text;
- (void)showError:(nullable NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showError:(nullable NSString *)text detailText:(nullable NSString *)detailText;
- (void)showError:(nullable NSString *)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showInfo:(nullable NSString *)text;
- (void)showInfo:(nullable NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showInfo:(nullable NSString *)text detailText:(nullable NSString *)detailText;
- (void)showInfo:(nullable NSString *)text detailText:(nullable NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

/// 类方法：主要用在局部一次性使用的场景，hide之后会自动removeFromSuperView

+ (TMUITips *)createTipsToView:(UIView *)view;

+ (TMUITips *)showLoadingInView:(UIView *)view;
+ (TMUITips *)showLoading:(nullable NSString *)text inView:(UIView *)view;
+ (TMUITips *)showLoadingInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TMUITips *)showLoading:(nullable NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TMUITips *)showLoading:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (TMUITips *)showLoading:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (TMUITips *)showWithText:(nullable NSString *)text;
+ (TMUITips *)showWithText:(nullable NSString *)text detailText:(nullable NSString *)detailText;
+ (TMUITips *)showWithText:(nullable NSString *)text inView:(UIView *)view;
+ (TMUITips *)showWithText:(nullable NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TMUITips *)showWithText:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (TMUITips *)showWithText:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (TMUITips *)showSucceed:(nullable NSString *)text;
+ (TMUITips *)showSucceed:(nullable NSString *)text detailText:(nullable NSString *)detailText;
+ (TMUITips *)showSucceed:(nullable NSString *)text inView:(UIView *)view;
+ (TMUITips *)showSucceed:(nullable NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TMUITips *)showSucceed:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (TMUITips *)showSucceed:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (TMUITips *)showError:(nullable NSString *)text;
+ (TMUITips *)showError:(nullable NSString *)text detailText:(nullable NSString *)detailText;
+ (TMUITips *)showError:(nullable NSString *)text inView:(UIView *)view;
+ (TMUITips *)showError:(nullable NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TMUITips *)showError:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (TMUITips *)showError:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (TMUITips *)showInfo:(nullable NSString *)text;
+ (TMUITips *)showInfo:(nullable NSString *)text detailText:(nullable NSString *)detailText;
+ (TMUITips *)showInfo:(nullable NSString *)text inView:(UIView *)view;
+ (TMUITips *)showInfo:(nullable NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TMUITips *)showInfo:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view;
+ (TMUITips *)showInfo:(nullable NSString *)text detailText:(nullable NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

/// 隐藏 tips
+ (void)hideAllTipsInView:(UIView *)view;
+ (void)hideAllTips;

/// 自动隐藏 toast 可以使用这个方法自动计算秒数
+ (NSTimeInterval)smartDelaySecondsForTipsText:(NSString *)text;

NS_ASSUME_NONNULL_END

@end
