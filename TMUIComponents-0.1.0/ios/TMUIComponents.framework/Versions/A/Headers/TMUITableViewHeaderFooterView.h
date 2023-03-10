//
//  TMUITableViewHeaderFooterView.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TMUITableViewHeaderFooterViewType) {
    TMUITableViewHeaderFooterViewTypeUnknow,
    TMUITableViewHeaderFooterViewTypeHeader,
    TMUITableViewHeaderFooterViewTypeFooter
};
NS_ASSUME_NONNULL_BEGIN
/**
 *  适用于 UITableView 的 sectionHeaderFooterView，提供的特性包括：
 *  1. 支持单个 UILabel，该 label 支持多行文字。
 *  2. 支持右边添加一个 accessoryView（注意，设置 accessoryView 之前请先保证自身大小正确）。
 *  3. 支持调整 headerFooterView 的 padding。
 *  4. 支持应用配置表的样式。
 *
 *  使用方式：
 *  基本与系统的 UITableViewHeaderFooterView 使用方式一致，额外需要做的事情有：
 *  1. 如果要支持高度自动根据内容变化，则按系统的 self-sizing 方式，用 UITableViewAutomaticDimension 指定。或者重写 tableView:heightForHeaderInSection:、tableView:heightForFooterInSection:，在里面调用 headerFooterView 的 sizeThatFits:。
 *  2. 如果要应用配置表样式，则设置 parentTableView 和 type 这两个属性即可。特别的，TMUICommonTableViewController 里默认已经处理好 parentTableView 和 type，子类无需操作。
 */
@interface TMUITableViewHeaderFooterView : UITableViewHeaderFooterView

@property(nonatomic, weak) UITableView *parentTableView;
@property(nonatomic, assign) TMUITableViewHeaderFooterViewType type;

@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong) UIView *accessoryView;

@property(nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property(nonatomic, assign) UIEdgeInsets accessoryViewMargins;
@end

@interface TMUITableViewHeaderFooterView (UISubclassingHooks)

/// 子类重写，用于修改样式，会在 parentTableView、type 属性发生变化的时候被调用
- (void)updateAppearance;

@end


NS_ASSUME_NONNULL_END
