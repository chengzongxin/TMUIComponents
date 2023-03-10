//
//  TMUIPopupMenuView.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/24.
//

#import "TMUIPopupContainerView.h"
#import "TMUIPopupContainerView.h"
#import "TMUIPopupMenuItemProtocol.h"
#import "TMUIPopupMenuBaseItem.h"
#import "TMUIPopupMenuButtonItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  用于弹出浮层里显示一行一行的菜单的控件。
 *  使用方式：
 *  1. 调用 init 方法初始化。
 *  2. 按需设置分隔线、item 高度等样式。
 *  3. 设置完样式后再通过 items 或 itemSections 添加菜单项，并在 item 点击事件里调用 hideWithAnimated: 隐藏浮层。
 *  4. 通过为 sourceBarItem/sourceView/sourceRect 三者中的一个赋值，来决定浮层布局的位置（参考父类）。
 *  5. 调用 showWithAnimated: 即可显示（参考父类）。
 *
 *  注意，TMUIPopupMenuView 的大小默认是按内容自适应的（item 的 sizeThatFits），但同时又受 maximumWidth/minimumWidth 的限制。
 */
@interface TMUIPopupMenuView : TMUIPopupContainerView

/// 是否需要显示每个 item 之间的分隔线，默认为 NO，当为 YES 时，每个 section 除了最后一个 item 外其他 item 底部都会显示分隔线。
@property(nonatomic, assign) BOOL shouldShowItemSeparator UI_APPEARANCE_SELECTOR;

/// item 分隔线的颜色，默认为 UIColorSeparator。
@property(nonatomic, strong, nullable) UIColor *itemSeparatorColor UI_APPEARANCE_SELECTOR;

/// item 分隔线的位置偏移，默认为 UIEdgeInsetsZero。item 分隔线的默认布局是 menuView 宽度减去左右 padding，如果你希望分隔线左右贴边则可为这个属性设置一个负值的 left/right。
@property(nonatomic, assign) UIEdgeInsets itemSeparatorInset UI_APPEARANCE_SELECTOR;

/// 是否显示 section 和 section 之间的分隔线，默认为 NO，当为 YES 时，除了最后一个 section，其他 section 底部都会显示一条分隔线。
@property(nonatomic, assign) BOOL shouldShowSectionSeparator UI_APPEARANCE_SELECTOR;

/// section 分隔线的颜色，默认为 UIColorSeparator。
@property(nonatomic, strong, nullable) UIColor *sectionSeparatorColor UI_APPEARANCE_SELECTOR;

/// section 分隔线的位置偏移，默认为 UIEdgeInsetsZero。section 分隔线的默认布局是撑满整个 menuView，如果你不希望分隔线左右贴边则可为这个属性设置一个 left/right 不为 0 的值即可。
@property(nonatomic, assign) UIEdgeInsets sectionSeparatorInset UI_APPEARANCE_SELECTOR;

/// item 里文字的字体，默认为 UIFontMake(16)。
@property(nonatomic, strong, nullable) UIFont *itemTitleFont UI_APPEARANCE_SELECTOR;

/// item 里文字的颜色，默认为 UIColorBlue
@property(nonatomic, strong, nullable) UIColor *itemTitleColor UI_APPEARANCE_SELECTOR;

/// 整个 menuView 内部上下左右的 padding，其中 padding.left/right 会被作为 item.button.contentEdgeInsets.left/right，也即每个 item 的宽度一定是撑满整个 menuView 的。
@property(nonatomic, assign) UIEdgeInsets padding UI_APPEARANCE_SELECTOR;

/// 每个 item 的统一高度，默认为 44。如果某个 item 设置了自己的 height，则不受 itemHeight 属性的约束。
@property(nonatomic, assign) CGFloat itemHeight UI_APPEARANCE_SELECTOR;

/// 批量设置 item 的样式
@property(nonatomic, copy, nullable) void (^itemConfigurationHandler)(TMUIPopupMenuView *aMenuView, __kindof TMUIPopupMenuBaseItem *aItem, NSInteger section, NSInteger index);

/// 设置 item，均处于同一个 section 内
@property(nonatomic, copy, nullable) NSArray<__kindof TMUIPopupMenuBaseItem *> *items;

/// 设置多个 section 的多个 item
@property(nonatomic, copy, nullable) NSArray<NSArray<__kindof TMUIPopupMenuBaseItem *> *> *itemSections;

@end

NS_ASSUME_NONNULL_END
