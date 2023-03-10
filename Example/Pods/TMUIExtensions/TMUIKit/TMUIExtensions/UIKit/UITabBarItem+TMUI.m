//
//  UITabBarItem+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/29.
//

#import "UITabBarItem+TMUI.h"
#import "TMUICore.h"
#import "UIBarItem+TMUI.h"

@implementation UITabBarItem (TMUI)

TMUISynthesizeIdCopyProperty(tmui_doubleTapBlock, setTmui_doubleTapBlock)

- (UIImageView *)tmui_imageView {
    return [self.class tmui_imageViewInTabBarButton:self.tmui_view];
}

+ (UIImageView *)tmui_imageViewInTabBarButton:(UIView *)tabBarButton {
    
    if (!tabBarButton) {
        return nil;
    }
    
    if (@available(iOS 13.0, *)) {
        if ([tabBarButton.subviews.firstObject isKindOfClass:[UIVisualEffectView class]] && ((UIVisualEffectView *)tabBarButton.subviews.firstObject).contentView.subviews.count) {
            // iOS 13 下如果 tabBar 是磨砂的，则每个 button 内部都会有一个磨砂，而磨砂再包裹了 imageView、label 等 subview，但某些时机后系统又会把 imageView、label 挪出来放到 button 上，所以这里做个保护
            // https://github.com/Tencent/TMUI_iOS/issues/616
            
            UIView *contentView = ((UIVisualEffectView *)tabBarButton.subviews.firstObject).contentView;
            // iOS 13 beta5 布局发生了变化，即使有磨砂 view，内部也不一定包裹着 imageView
            for (UIView *subview in contentView.subviews) {
                if ([NSStringFromClass([subview class]) isEqualToString:@"UITabBarSwappableImageView"]) {
                    return (UIImageView *)subview;
                }
            }
        }
    }
    
    for (UIView *subview in tabBarButton.subviews) {
        
        // iOS10及以后，imageView都是用UITabBarSwappableImageView实现的，所以遇到这个class就直接拿
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITabBarSwappableImageView"]) {
            return (UIImageView *)subview;
        }
        
        // iOS10以前，选中的item的高亮是用UITabBarSelectionIndicatorView实现的，所以要屏蔽掉
        if ([subview isKindOfClass:[UIImageView class]] && ![NSStringFromClass([subview class]) isEqualToString:@"UITabBarSelectionIndicatorView"]) {
            return (UIImageView *)subview;
        }
        
    }
    return nil;
}

@end
