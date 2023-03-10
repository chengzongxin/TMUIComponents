//
//  TMUIExpandLabel.h
//  Demo
//
//  Created by Joe.cheng on 2022/1/7.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TMUIExpandLabelClickActionType_Label,
    TMUIExpandLabelClickActionType_Expand,
    TMUIExpandLabelClickActionType_Shrink,
} TMUIExpandLabelClickActionType;

typedef enum : NSUInteger {
    TMUIExpandLabelAttrType_Origin,
    TMUIExpandLabelAttrType_Shrink,
    TMUIExpandLabelAttrType_Expand,
} TMUIExpandLabelAttrType;

typedef void(^TMUIExpandLabelClickAction)(TMUIExpandLabelClickActionType clickType,CGSize size);
typedef void(^TMUIExpandLabelSizeChange)(TMUIExpandLabelClickActionType clickType,CGSize size);

NS_ASSUME_NONNULL_BEGIN

@interface TMUIExpandLabel : UILabel
/// 默认行数,默认3行
@property (nonatomic, assign) NSInteger defalutLine;
/// 当前最大行数
@property (nonatomic, assign) NSInteger maxLine;
/// 最大宽度
@property (nonatomic, assign) CGFloat maxPreferWidth;
/// 默认行数
@property (nonatomic, assign) NSAttributedString *attributeString;
/// 点击
@property (nonatomic, copy) TMUIExpandLabelClickAction clickActionBlock;
/// 尺寸改变
@property (nonatomic, copy) TMUIExpandLabelSizeChange sizeChangeBlock;


#pragma mark - Public
+ (CGFloat)heightForAttr:(NSAttributedString *)attr line:(NSInteger)line width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
