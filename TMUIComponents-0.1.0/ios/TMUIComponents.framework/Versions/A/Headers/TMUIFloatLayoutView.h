//
//  TMUIFloatLayoutView.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/20.
//

#import <UIKit/UIKit.h>

/// 用于属性 maximumItemSize，是它的默认值。表示 item 的最大宽高会自动根据当前 floatLayoutView 的内容大小来调整，从而避免 item 内容过多时可能溢出 floatLayoutView。
extern const CGSize TMUIFloatLayoutViewAutomaticalMaximumItemSize;

/**
 *  做类似 CSS 里的 float:left 的布局，自行使用 addSubview: 将子 View 添加进来即可。
 *
 *  支持通过 `contentMode` 属性修改子 View 的对齐方式，目前仅支持 `UIViewContentModeLeft` 和 `UIViewContentModeRight`，默认为 `UIViewContentModeLeft`。
 */
@interface TMUIFloatLayoutView : UIView

/**
 *  TMUIFloatLayoutView 内部的间距，默认为 UIEdgeInsetsZero
 */
@property(nonatomic, assign) UIEdgeInsets padding;

/**
 *  item 的最小宽高，默认为 CGSizeZero，也即不限制。
 */
@property(nonatomic, assign) IBInspectable CGSize minimumItemSize;

/**
 *  item 的最大宽高，默认为 TMUIFloatLayoutViewAutomaticalMaximumItemSize，也即不超过 floatLayoutView 自身最大内容宽高。
 */
@property(nonatomic, assign) IBInspectable CGSize maximumItemSize;

/**
 *  item 之间的间距，默认为 UIEdgeInsetsZero。
 *
 *  @warning 上、下、左、右四个边缘的 item 布局时不会考虑 itemMargins.top/bottom/left/right。
 */
@property(nonatomic, assign) UIEdgeInsets itemMargins;
@end
