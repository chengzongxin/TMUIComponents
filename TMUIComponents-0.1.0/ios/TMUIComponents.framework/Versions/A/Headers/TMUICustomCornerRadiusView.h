//
//  TMUIFilterContentView.h
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    CGFloat leftTopRadius;
    CGFloat rightTopRadius;
    CGFloat rightBottomRadius;
    CGFloat leftBottomRadius;
} TMUICustomCornerRadius;

NS_INLINE TMUICustomCornerRadius TMUICustomCornerRadiusMake(CGFloat leftTopRadius,
                                                      CGFloat rightTopRadius,
                                                      CGFloat rightBottomRadius,
                                                      CGFloat leftBottomRadius) {
    return (TMUICustomCornerRadius){leftTopRadius, rightTopRadius, rightBottomRadius, leftBottomRadius};
}

@interface TMUICustomCornerRadiusView : UIView
@property (nonatomic, assign)TMUICustomCornerRadius customCornerRadius;///< 可指定四个角各自对应一个圆角半径值

@property (nonatomic, assign) BOOL disableDrawPathWhenLayoutSubviews;///< 执行动画的时候，需要禁用掉，否则动画不会执行

@end

NS_ASSUME_NONNULL_END
