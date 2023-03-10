//
//  TMUIPopupContainerView.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/24.
//

#import "TMUIPopupContainerView.h"
#import "TMUICore.h"
//#import "TMUICommonViewController.h"
#import "UIViewController+TMUI.h"
//#import "TMUILog.h"
#import "UIView+TMUI.h"
//#import "UIWindow+TMUI.h"
#import "UIBarItem+TMUI.h"
#import "TMUIAppearance.h"
#import "CALayer+TMUI.h"
#import "TMUIConfigurationMacros.h"
#import "TMUICommonDefines.h"

@interface TMUIPopupContainerViewWindow : UIWindow

@end

@interface TMUIPopContainerViewController : UIViewController

@end

@interface TMUIPopContainerMaskControl : UIControl

@property(nonatomic, weak) TMUIPopupContainerView *popupContainerView;
@end

@interface TMUIPopupContainerView () {
    UIImageView                     *_imageView;
    UILabel                         *_textLabel;
}

@property(nonatomic, strong) TMUIPopupContainerViewWindow *popupWindow;
@property(nonatomic, weak) UIWindow *previousKeyWindow;
@property(nonatomic, assign) BOOL hidesByUserTap;
@end

@implementation TMUIPopupContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}

- (void)dealloc {
    _sourceView.tmui_frameDidChangeBlock = nil;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = UIFontMake(12);
        _textLabel.textColor = UIColorBlack;
        _textLabel.numberOfLines = 0;
        [self.contentView addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self.contentView) {
        return self;
    }
    return result;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    _backgroundLayer.fillColor = _backgroundColor.CGColor;
}

- (void)setMaskViewBackgroundColor:(UIColor *)maskViewBackgroundColor {
    _maskViewBackgroundColor = maskViewBackgroundColor;
    if (self.popupWindow) {
        self.popupWindow.rootViewController.view.backgroundColor = maskViewBackgroundColor;
    }
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    _backgroundLayer.shadowColor = shadowColor.CGColor;
    if (shadowColor) {
        _backgroundLayer.shadowOffset = CGSizeMake(0, 2);
        _backgroundLayer.shadowOpacity = 1;
        _backgroundLayer.shadowRadius = 10;
    } else {
        _backgroundLayer.shadowOpacity = 0;
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    _backgroundLayer.strokeColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    _backgroundLayer.lineWidth = _borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.highlightedBackgroundColor) {
        _backgroundLayer.fillColor = highlighted ? self.highlightedBackgroundColor.CGColor : self.backgroundColor.CGColor;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize contentLimitSize = [self contentSizeInSize:size];
    CGSize contentSize = [self sizeThatFitsInContentView:contentLimitSize];
    CGSize resultSize = [self sizeWithContentSize:contentSize sizeThatFits:size];
    return resultSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL isUsingArrowImage = _arrowImageLayer && !_arrowImageLayer.hidden;
    CGAffineTransform arrowImageTransform = CGAffineTransformIdentity;
    CGPoint arrowImagePosition = CGPointZero;
    
    CGSize arrowSize = self.arrowSizeAuto;
    CGRect roundedRect = CGRectMake(self.borderWidth / 2.0 + (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionRight ? arrowSize.width : 0),
                                    self.borderWidth / 2.0 + (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionBelow ? arrowSize.height : 0),
                                    CGRectGetWidth(self.bounds) - self.borderWidth - self.arrowSpacingInHorizontal,
                                    CGRectGetHeight(self.bounds) - self.borderWidth - self.arrowSpacingInVertical);
    CGFloat cornerRadius = self.cornerRadius;
    
    CGPoint leftTopArcCenter = CGPointMake(CGRectGetMinX(roundedRect) + cornerRadius, CGRectGetMinY(roundedRect) + cornerRadius);
    CGPoint leftBottomArcCenter = CGPointMake(leftTopArcCenter.x, CGRectGetMaxY(roundedRect) - cornerRadius);
    CGPoint rightTopArcCenter = CGPointMake(CGRectGetMaxX(roundedRect) - cornerRadius, leftTopArcCenter.y);
    CGPoint rightBottomArcCenter = CGPointMake(rightTopArcCenter.x, leftBottomArcCenter.y);
    
    // ???????????????????????????
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftTopArcCenter.x, CGRectGetMinY(roundedRect))];
    [path addArcWithCenter:leftTopArcCenter radius:cornerRadius startAngle:M_PI * 1.5 endAngle:M_PI clockwise:NO];
    
    if (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionRight) {
        // ????????????
        if (isUsingArrowImage) {
            arrowImageTransform = CGAffineTransformMakeRotation(AngleWithDegrees(90));
            arrowImagePosition = CGPointMake(arrowSize.width / 2, _arrowMinY + arrowSize.height / 2);
        } else {
            [path addLineToPoint:CGPointMake(CGRectGetMinX(roundedRect), _arrowMinY)];
            [path addLineToPoint:CGPointMake(CGRectGetMinX(roundedRect) - arrowSize.width, _arrowMinY + arrowSize.height / 2)];
            [path addLineToPoint:CGPointMake(CGRectGetMinX(roundedRect), _arrowMinY + arrowSize.height)];
        }
    }
    
    [path addLineToPoint:CGPointMake(CGRectGetMinX(roundedRect), leftBottomArcCenter.y)];
    [path addArcWithCenter:leftBottomArcCenter radius:cornerRadius startAngle:M_PI endAngle:M_PI * 0.5 clockwise:NO];
    
    if (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionAbove) {
        // ????????????
        if (isUsingArrowImage) {
            arrowImagePosition = CGPointMake(_arrowMinX + arrowSize.width / 2, CGRectGetHeight(self.bounds) - arrowSize.height / 2);
        } else {
            [path addLineToPoint:CGPointMake(_arrowMinX, CGRectGetMaxY(roundedRect))];
            [path addLineToPoint:CGPointMake(_arrowMinX + arrowSize.width / 2, CGRectGetMaxY(roundedRect) + arrowSize.height)];
            [path addLineToPoint:CGPointMake(_arrowMinX + arrowSize.width, CGRectGetMaxY(roundedRect))];
        }
    }
    
    [path addLineToPoint:CGPointMake(rightBottomArcCenter.x, CGRectGetMaxY(roundedRect))];
    [path addArcWithCenter:rightBottomArcCenter radius:cornerRadius startAngle:M_PI * 0.5 endAngle:0.0 clockwise:NO];
    
    if (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionLeft) {
        // ????????????
        if (isUsingArrowImage) {
            arrowImageTransform = CGAffineTransformMakeRotation(AngleWithDegrees(-90));
            arrowImagePosition = CGPointMake(CGRectGetWidth(self.bounds) - arrowSize.width / 2, _arrowMinY + arrowSize.height / 2);
        } else {
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(roundedRect), _arrowMinY + arrowSize.height)];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(roundedRect) + arrowSize.width, _arrowMinY + arrowSize.height / 2)];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(roundedRect), _arrowMinY)];
        }
    }
    
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(roundedRect), rightTopArcCenter.y)];
    [path addArcWithCenter:rightTopArcCenter radius:cornerRadius startAngle:0.0 endAngle:M_PI * 1.5 clockwise:NO];
    
    if (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionBelow) {
        // ????????????
        if (isUsingArrowImage) {
            arrowImageTransform = CGAffineTransformMakeRotation(AngleWithDegrees(-180));
            arrowImagePosition = CGPointMake(_arrowMinX + arrowSize.width / 2, arrowSize.height / 2);
        } else {
            [path addLineToPoint:CGPointMake(_arrowMinX + arrowSize.width, CGRectGetMinY(roundedRect))];
            [path addLineToPoint:CGPointMake(_arrowMinX + arrowSize.width / 2, CGRectGetMinY(roundedRect) - arrowSize.height)];
            [path addLineToPoint:CGPointMake(_arrowMinX, CGRectGetMinY(roundedRect))];
        }
    }
    [path closePath];
    
    _backgroundLayer.path = path.CGPath;
    _backgroundLayer.shadowPath = path.CGPath;
    _backgroundLayer.frame = self.bounds;
    
    if (isUsingArrowImage) {
        _arrowImageLayer.affineTransform = arrowImageTransform;
        _arrowImageLayer.position = arrowImagePosition;
    }
    
    [self layoutDefaultSubviews];
}

- (void)layoutDefaultSubviews {
    self.contentView.frame = CGRectMake(
                                        self.borderWidth + self.contentEdgeInsets.left + (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionRight ? self.arrowSizeAuto.width : 0),
                                        self.borderWidth + self.contentEdgeInsets.top + (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionBelow ? self.arrowSizeAuto.height : 0),
                                        CGRectGetWidth(self.bounds) - self.borderWidth * 2 - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets) - self.arrowSpacingInHorizontal,
                                        CGRectGetHeight(self.bounds) - self.borderWidth * 2 - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets) - self.arrowSpacingInVertical);
    // contentView???????????????????????????path????????????????????????????????????????????????self.contentEdgeInsets.left???self.cornerRadius????????????????????????contentView?????????????????????
    // ??????????????????????????????contentView?????????????????????????????????????????????????????????????????????
    CGFloat contentViewCornerRadius = fabs(MIN(CGRectGetMinX(self.contentView.frame) - self.cornerRadius, 0));
    self.contentView.layer.cornerRadius = contentViewCornerRadius;
    
    BOOL isImageViewShowing = [self isSubviewShowing:_imageView];
    BOOL isTextLabelShowing = [self isSubviewShowing:_textLabel];
    if (isImageViewShowing) {
        [_imageView sizeToFit];
        _imageView.frame = CGRectSetX(_imageView.frame, self.imageEdgeInsets.left);//, self.imageEdgeInsets.top + (self.contentMode == UIViewContentModeTop ? 0 : CGFloatGetCenter(CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(_imageView.frame))));
        if (self.contentMode == UIViewContentModeTop) {
            _imageView.frame = CGRectSetY(_imageView.frame, self.imageEdgeInsets.top);
        } else if (self.contentMode == UIViewContentModeBottom) {
            _imageView.frame = CGRectSetY(_imageView.frame, CGRectGetHeight(self.contentView.bounds) - self.imageEdgeInsets.bottom - CGRectGetHeight(_imageView.frame));
        } else {
            _imageView.frame = CGRectSetY(_imageView.frame, self.imageEdgeInsets.top + CGFloatGetCenter(CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(_imageView.frame)));
        }
    }
    if (isTextLabelShowing) {
        CGFloat textLabelMinX = (isImageViewShowing ? ceil(CGRectGetMaxX(_imageView.frame) + self.imageEdgeInsets.right) : 0) + self.textEdgeInsets.left;
        CGSize textLabelLimitSize = CGSizeMake(ceil(CGRectGetWidth(self.contentView.bounds) - textLabelMinX), ceil(CGRectGetHeight(self.contentView.bounds) - self.textEdgeInsets.top - self.textEdgeInsets.bottom));
        CGSize textLabelSize = [_textLabel sizeThatFits:textLabelLimitSize];
        _textLabel.frame = CGRectMake(textLabelMinX, 0, textLabelLimitSize.width, ceil(textLabelSize.height));
        if (self.contentMode == UIViewContentModeTop) {
            _textLabel.frame = CGRectSetY(_textLabel.frame, self.textEdgeInsets.top);
        } else if (self.contentMode == UIViewContentModeBottom) {
            _textLabel.frame = CGRectSetY(_textLabel.frame, CGRectGetHeight(self.contentView.bounds) - self.textEdgeInsets.bottom - CGRectGetHeight(_textLabel.frame));
        } else {
            _textLabel.frame = CGRectSetY(_textLabel.frame, self.textEdgeInsets.top + CGFloatGetCenter(CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(_textLabel.frame)));
        }
    }
}

- (void)setSourceBarItem:(__kindof UIBarItem *)sourceBarItem {
    _sourceBarItem = sourceBarItem;
    __weak __typeof(self)weakSelf = self;
    // ???????????????????????? block????????????????????? popup ???????????? sourceBarItem ??????????????? block ??????????????? weakSelf ?????????????????????
    sourceBarItem.tmui_viewLayoutDidChangeBlock = ^(__kindof UIBarItem * _Nonnull item, UIView * _Nullable view) {
        if (!view.window || !weakSelf.superview) return;
        UIView *convertToView = weakSelf.popupWindow ? UIApplication.sharedApplication.delegate.window : weakSelf.superview;// ????????? window ????????????????????????????????????????????????????????? window ?????????????????????????????????????????? sourceBarItem ????????? window ?????????????????? popupWindow ???????????????iOS 11 ??????????????????????????????????????????????????????????????????????????? UIApplication window
        CGRect rect = [view tmui_convertRect:view.bounds toView:convertToView];
        weakSelf.sourceRect = rect;
    };
    if (sourceBarItem.tmui_view && sourceBarItem.tmui_viewLayoutDidChangeBlock) {
        sourceBarItem.tmui_viewLayoutDidChangeBlock(sourceBarItem, sourceBarItem.tmui_view);// update layout immediately
    }
}

- (void)setSourceView:(__kindof UIView *)sourceView {
    _sourceView = sourceView;
    __weak __typeof(self)weakSelf = self;
    sourceView.tmui_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
        if (!view.window || !weakSelf.superview) return;
        UIView *convertToView = weakSelf.popupWindow ? UIApplication.sharedApplication.delegate.window : weakSelf.superview;// ????????? window ????????????????????????????????????????????????????????? window ?????????????????????????????????????????? sourceBarItem ????????? window ?????????????????? popupWindow ???????????????iOS 11 ??????????????????????????????????????????????????????????????????????????? UIApplication window
        CGRect rect = [view tmui_convertRect:view.bounds toView:convertToView];
        weakSelf.sourceRect = rect;
    };
    sourceView.tmui_frameDidChangeBlock(sourceView, sourceView.frame);// update layout immediately
}

- (void)setSourceRect:(CGRect)sourceRect {
    _sourceRect = sourceRect;
    if (self.isShowing) {
        [self layoutWithTargetRect:sourceRect];
    }
}

- (void)updateLayout {
    // call setter to layout immediately
    if (self.sourceBarItem) {
        self.sourceBarItem = self.sourceBarItem;
    } else if (self.sourceView) {
        self.sourceView = self.sourceView;
    } else {
        self.sourceRect = self.sourceRect;
    }
}

// ?????? targetRect ??? window ???????????? window ?????????????????????????????? subview ??????????????? superview ???????????????
- (void)layoutWithTargetRect:(CGRect)targetRect {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    }
    
    _currentLayoutDirection = self.preferLayoutDirection;
    targetRect = self.popupWindow ? [self.popupWindow convertRect:targetRect toView:superview] : targetRect;
    CGRect containerRect = superview.bounds;
    
    CGSize (^sizeToFitBlock)(void) = ^CGSize(void) {
        CGSize result = CGSizeZero;
        if (self.isVerticalLayoutDirection) {
            result.width = CGRectGetWidth(containerRect) - UIEdgeInsetsGetHorizontalValue(self.safetyMarginsAvoidSafeAreaInsets);
        } else if (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionLeft) {
            result.width = CGRectGetMinX(targetRect) - self.distanceBetweenSource - self.safetyMarginsAvoidSafeAreaInsets.left;
        } else if (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionRight) {
            result.width = CGRectGetWidth(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.right - self.distanceBetweenSource - CGRectGetMaxX(targetRect);
        }
        if (self.isHorizontalLayoutDirection) {
            result.height = CGRectGetHeight(containerRect) - UIEdgeInsetsGetVerticalValue(self.safetyMarginsAvoidSafeAreaInsets);
        } else if (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionAbove) {
            result.height = CGRectGetMinY(targetRect) - self.distanceBetweenSource - self.safetyMarginsAvoidSafeAreaInsets.top;
        } else if (self.currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionBelow) {
            result.height = CGRectGetHeight(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.bottom - self.distanceBetweenSource - CGRectGetMaxY(targetRect);
        }
        result = CGSizeMake(MIN(self.maximumWidth, result.width), MIN(self.maximumHeight, result.height));
        return result;
    };
    
    
    CGSize tipSize = [self sizeThatFits:sizeToFitBlock()];
    CGFloat preferredTipWidth = tipSize.width;
    CGFloat preferredTipHeight = tipSize.height;
    CGFloat tipMinX = 0;
    CGFloat tipMinY = 0;
    
    if (self.isVerticalLayoutDirection) {
        // ??????tips?????????????????????self.safetyMarginsAvoidSafeAreaInsets.left
        CGFloat a = CGRectGetMidX(targetRect) - tipSize.width / 2;
        tipMinX = MAX(CGRectGetMinX(containerRect) + self.safetyMarginsAvoidSafeAreaInsets.left, a);
        
        CGFloat tipMaxX = tipMinX + tipSize.width;
        if (tipMaxX + self.safetyMarginsAvoidSafeAreaInsets.right > CGRectGetMaxX(containerRect)) {
            // ???????????????
            // ????????????????????????????????????????????????????????????????????????????????????
            CGFloat distanceCanMoveToLeft = tipMaxX - (CGRectGetMaxX(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.right);
            if (tipMinX - distanceCanMoveToLeft >= CGRectGetMinX(containerRect) + self.safetyMarginsAvoidSafeAreaInsets.left) {
                // ??????????????????
                tipMinX -= distanceCanMoveToLeft;
            } else {
                // ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                tipMinX = CGRectGetMinX(containerRect) + self.safetyMarginsAvoidSafeAreaInsets.left;
                tipMaxX = CGRectGetMaxX(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.right;
                tipSize.width = MIN(tipSize.width, tipMaxX - tipMinX);
            }
        }
        
        // ?????????????????????????????????tipSize.width????????????????????????????????????????????????????????????????????????????????????sizeThatFits
        BOOL tipWidthChanged = tipSize.width != preferredTipWidth;
        if (tipWidthChanged) {
            tipSize = [self sizeThatFits:tipSize];
        }
        
        // ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        BOOL canShowAtAbove = [self canTipShowAtSpecifiedLayoutDirect:TMUIPopupContainerViewLayoutDirectionAbove targetRect:targetRect tipSize:tipSize];
        BOOL canShowAtBelow = [self canTipShowAtSpecifiedLayoutDirect:TMUIPopupContainerViewLayoutDirectionBelow targetRect:targetRect tipSize:tipSize];
        
        if (!canShowAtAbove && !canShowAtBelow) {
            // ????????????????????????????????????????????????maximumHeight
            CGFloat maximumHeightAbove = CGRectGetMinY(targetRect) - CGRectGetMinY(containerRect) - self.distanceBetweenSource - self.safetyMarginsAvoidSafeAreaInsets.top;
            CGFloat maximumHeightBelow = CGRectGetMaxY(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.bottom - self.distanceBetweenSource - CGRectGetMaxY(targetRect);
            self.maximumHeight = MAX(self.minimumHeight, MAX(maximumHeightAbove, maximumHeightBelow));
            tipSize.height = self.maximumHeight;
            _currentLayoutDirection = maximumHeightAbove > maximumHeightBelow ? TMUIPopupContainerViewLayoutDirectionAbove : TMUIPopupContainerViewLayoutDirectionBelow;
            
            NSLog(NSStringFromClass(self.class), @"%@, ???????????????????????????????????????????????????????????????%@, ???????????????%@", self, @(self.maximumHeight), maximumHeightAbove > maximumHeightBelow ? @"??????" : @"??????");
            
        } else if (_currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionAbove && !canShowAtAbove) {
            _currentLayoutDirection = TMUIPopupContainerViewLayoutDirectionBelow;
            tipSize.height = [self sizeThatFits:CGSizeMake(tipSize.width, sizeToFitBlock().height)].height;
        } else if (_currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionBelow && !canShowAtBelow) {
            _currentLayoutDirection = TMUIPopupContainerViewLayoutDirectionAbove;
            tipSize.height = [self sizeThatFits:CGSizeMake(tipSize.width, sizeToFitBlock().height)].height;
        }
        
        tipMinY = [self tipOriginWithTargetRect:targetRect tipSize:tipSize preferLayoutDirection:_currentLayoutDirection].y;
        
        // ????????????????????????????????????????????????????????????tip?????????safetyMargins??????????????????????????????
        if (_currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionAbove) {
            CGFloat tipMinYIfAlignSafetyMarginTop = CGRectGetMinY(containerRect) + self.safetyMarginsAvoidSafeAreaInsets.top;
            tipMinY = MAX(tipMinY, tipMinYIfAlignSafetyMarginTop);
        } else if (_currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionBelow) {
            CGFloat tipMinYIfAlignSafetyMarginBottom = CGRectGetMaxY(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.bottom - tipSize.height;
            tipMinY = MIN(tipMinY, tipMinYIfAlignSafetyMarginBottom);
        }
        
        self.frame = CGRectFlatMake(tipMinX, tipMinY, tipSize.width, tipSize.height);
        
        // ?????????????????????????????????
        CGPoint targetRectCenter = CGPointGetCenterWithRect(targetRect);
        CGFloat selfMidX = targetRectCenter.x - CGRectGetMinX(self.frame);
        _arrowMinX = selfMidX - self.arrowSizeAuto.width / 2;
    } else {
        // ??????tips?????????????????????self.safetyMarginsAvoidSafeAreaInsets.top
        CGFloat a = CGRectGetMidY(targetRect) - tipSize.height / 2;
        tipMinY = MAX(CGRectGetMinY(containerRect) + self.safetyMarginsAvoidSafeAreaInsets.top, a);
        
        CGFloat tipMaxY = tipMinY + tipSize.height;
        if (tipMaxY + self.safetyMarginsAvoidSafeAreaInsets.bottom > CGRectGetMaxY(containerRect)) {
            // ???????????????
            // ????????????????????????????????????????????????????????????????????????????????????
            CGFloat distanceCanMoveToTop = tipMaxY - (CGRectGetMaxY(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.bottom);
            if (tipMinY - distanceCanMoveToTop >= CGRectGetMinY(containerRect) + self.safetyMarginsAvoidSafeAreaInsets.top) {
                // ??????????????????
                tipMinY -= distanceCanMoveToTop;
            } else {
                // ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                tipMinY = CGRectGetMinY(containerRect) + self.safetyMarginsAvoidSafeAreaInsets.top;
                tipMaxY = CGRectGetMaxY(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.bottom;
                tipSize.height = MIN(tipSize.height, tipMaxY - tipMinY);
            }
        }
        
        // ?????????????????????????????????tipSize.height????????????????????????????????????????????????????????????????????????????????????sizeThatFits
        BOOL tipHeightChanged = tipSize.height != preferredTipHeight;
        if (tipHeightChanged) {
            tipSize = [self sizeThatFits:tipSize];
        }
        
        // ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        BOOL canShowAtLeft = [self canTipShowAtSpecifiedLayoutDirect:TMUIPopupContainerViewLayoutDirectionLeft targetRect:targetRect tipSize:tipSize];
        BOOL canShowAtRight = [self canTipShowAtSpecifiedLayoutDirect:TMUIPopupContainerViewLayoutDirectionRight targetRect:targetRect tipSize:tipSize];
        
        if (!canShowAtLeft && !canShowAtRight) {
            // ????????????????????????????????????????????????maximumWidth
            CGFloat maximumWidthLeft = CGRectGetMinX(targetRect) - CGRectGetMinX(containerRect) - self.distanceBetweenSource - self.safetyMarginsAvoidSafeAreaInsets.left;
            CGFloat maximumWidthRight = CGRectGetMaxX(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.right - self.distanceBetweenSource - CGRectGetMaxX(targetRect);
            self.maximumWidth = MAX(self.minimumWidth, MAX(maximumWidthLeft, maximumWidthRight));
            tipSize.width = self.maximumWidth;
            _currentLayoutDirection = maximumWidthLeft > maximumWidthRight ? TMUIPopupContainerViewLayoutDirectionLeft : TMUIPopupContainerViewLayoutDirectionRight;
            
//            TMUILog(NSStringFromClass(self.class), @"%@, ???????????????????????????????????????????????????????????????%@, ???????????????%@", self, @(self.maximumWidth), maximumWidthLeft > maximumWidthRight ? @"??????" : @"??????");
            
        } else if (_currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionLeft && !canShowAtLeft) {
            _currentLayoutDirection = TMUIPopupContainerViewLayoutDirectionLeft;
            tipSize.width = [self sizeThatFits:CGSizeMake(sizeToFitBlock().width, tipSize.height)].width;
        } else if (_currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionBelow && !canShowAtRight) {
            _currentLayoutDirection = TMUIPopupContainerViewLayoutDirectionRight;
            tipSize.width = [self sizeThatFits:CGSizeMake(sizeToFitBlock().width, tipSize.height)].width;
        }
        
        tipMinX = [self tipOriginWithTargetRect:targetRect tipSize:tipSize preferLayoutDirection:_currentLayoutDirection].x;
        
        // ????????????????????????????????????????????????????????????tip?????????safetyMargins??????????????????????????????
        if (_currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionLeft) {
            CGFloat tipMinXIfAlignSafetyMarginLeft = CGRectGetMinX(containerRect) + self.safetyMarginsAvoidSafeAreaInsets.left;
            tipMinX = MAX(tipMinX, tipMinXIfAlignSafetyMarginLeft);
        } else if (_currentLayoutDirection == TMUIPopupContainerViewLayoutDirectionRight) {
            CGFloat tipMinXIfAlignSafetyMarginRight = CGRectGetMaxX(containerRect) - self.safetyMarginsAvoidSafeAreaInsets.right - tipSize.width;
            tipMinX = MIN(tipMinX, tipMinXIfAlignSafetyMarginRight);
        }
        
        self.frame = CGRectFlatMake(tipMinX, tipMinY, tipSize.width, tipSize.height);
        
        // ?????????????????????????????????
        CGPoint targetRectCenter = CGPointGetCenterWithRect(targetRect);
        CGFloat selfMidY = targetRectCenter.y - CGRectGetMinY(self.frame);
        _arrowMinY = selfMidY - self.arrowSizeAuto.height / 2;
    }
    
    [self setNeedsLayout];
    
    if (self.debug) {
        self.contentView.backgroundColor = UIColorTestGreen;
        self.borderColor = UIColorRed;
        self.borderWidth = PixelOne;
        _imageView.backgroundColor = UIColorTestRed;
        _textLabel.backgroundColor = UIColorTestBlue;
    }
}

- (CGPoint)tipOriginWithTargetRect:(CGRect)itemRect tipSize:(CGSize)tipSize preferLayoutDirection:(TMUIPopupContainerViewLayoutDirection)direction {
    CGPoint tipOrigin = CGPointZero;
    switch (direction) {
        case TMUIPopupContainerViewLayoutDirectionAbove:
            tipOrigin.y = CGRectGetMinY(itemRect) - tipSize.height - self.distanceBetweenSource;
            break;
        case TMUIPopupContainerViewLayoutDirectionBelow:
            tipOrigin.y = CGRectGetMaxY(itemRect) + self.distanceBetweenSource;
            break;
        case TMUIPopupContainerViewLayoutDirectionLeft:
            tipOrigin.x = CGRectGetMinX(itemRect) - tipSize.width - self.distanceBetweenSource;
            break;
        case TMUIPopupContainerViewLayoutDirectionRight:
            tipOrigin.x = CGRectGetMaxX(itemRect) + self.distanceBetweenSource;
            break;
        default:
            break;
    }
    return tipOrigin;
}

- (BOOL)canTipShowAtSpecifiedLayoutDirect:(TMUIPopupContainerViewLayoutDirection)direction targetRect:(CGRect)itemRect tipSize:(CGSize)tipSize {
    BOOL canShow = NO;
    if (self.isVerticalLayoutDirection) {
        CGFloat tipMinY = [self tipOriginWithTargetRect:itemRect tipSize:tipSize preferLayoutDirection:direction].y;
        if (direction == TMUIPopupContainerViewLayoutDirectionAbove) {
            canShow = tipMinY >= self.safetyMarginsAvoidSafeAreaInsets.top;
        } else if (direction == TMUIPopupContainerViewLayoutDirectionBelow) {
            canShow = tipMinY + tipSize.height + self.safetyMarginsAvoidSafeAreaInsets.bottom <= CGRectGetHeight(self.superview.bounds);
        }
    } else {
        CGFloat tipMinX = [self tipOriginWithTargetRect:itemRect tipSize:tipSize preferLayoutDirection:direction].x;
        if (direction == TMUIPopupContainerViewLayoutDirectionLeft) {
            canShow = tipMinX >= self.safetyMarginsAvoidSafeAreaInsets.left;
        } else if (direction == TMUIPopupContainerViewLayoutDirectionRight) {
            canShow = tipMinX + tipSize.width + self.safetyMarginsAvoidSafeAreaInsets.right <= CGRectGetWidth(self.superview.bounds);
        }
    }
    
    return canShow;
}

- (void)showWithAnimated:(BOOL)animated {
    [self showWithAnimated:animated completion:nil];
}

- (void)showWithAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
    BOOL isShowingByWindowMode = NO;
    if (!self.superview) {
        [self initPopupContainerViewWindowIfNeeded];
        
//        UIViewController *viewController = self.popupWindow.rootViewController;
//        viewController.supportedOrientationMask = [TMUIHelper visibleViewController].supportedInterfaceOrientations;
        
        self.previousKeyWindow = UIApplication.sharedApplication.keyWindow;
        [self.popupWindow makeKeyAndVisible];
        
        isShowingByWindowMode = YES;
    } else {
        self.hidden = NO;
    }
    
    [self updateLayout];
    
    if (self.willShowBlock) {
        self.willShowBlock(animated);
    }
    
    if (animated) {
        if (isShowingByWindowMode) {
            self.popupWindow.alpha = 0;
        } else {
            self.alpha = 0;
        }
        self.layer.transform = CATransform3DMakeScale(0.98, 0.98, 1);
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:12 options:UIViewAnimationOptionCurveLinear animations:^{
            self.layer.transform = CATransform3DMakeScale(1, 1, 1);
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (isShowingByWindowMode) {
                self.popupWindow.alpha = 1;
            } else {
                self.alpha = 1;
            }
        } completion:nil];
    } else {
        if (isShowingByWindowMode) {
            self.popupWindow.alpha = 1;
        } else {
            self.alpha = 1;
        }
        if (completion) {
            completion(YES);
        }
    }
}

- (void)hideWithAnimated:(BOOL)animated {
    [self hideWithAnimated:animated completion:nil];
}

- (void)hideWithAnimated:(BOOL)animated completion:(nullable void (^)(BOOL))completion {
    if (self.willHideBlock) {
        self.willHideBlock(self.hidesByUserTap, animated);
    }
    
    BOOL isShowingByWindowMode = !!self.popupWindow;
    
    if (animated) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (isShowingByWindowMode) {
                self.popupWindow.alpha = 0;
            } else {
                self.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self hideCompletionWithWindowMode:isShowingByWindowMode completion:completion];
        }];
    } else {
        [self hideCompletionWithWindowMode:isShowingByWindowMode completion:completion];
    }
}

- (void)hideCompletionWithWindowMode:(BOOL)windowMode completion:(void (^)(BOOL))completion {
    if (windowMode) {
        // ?????? keyWindow ?????????????????????????????????????????? https://github.com/Tencent/TMUI_iOS/issues/90
        if (UIApplication.sharedApplication.keyWindow == self.popupWindow) {
            [self.previousKeyWindow makeKeyWindow];
        }
        
        // iOS 9 ??????iOS 8 ??? 10 ????????????????????????????????????????????? rootViewController ??? popupWindow ????????????????????????????????? layout ??????????????????????????????????????? popupWindow ??????????????? nil??????????????????????????????View ?????????????????????
        // https://github.com/Tencent/TMUI_iOS/issues/75
        [self removeFromSuperview];
        self.popupWindow.rootViewController = nil;
        
        self.popupWindow.hidden = YES;
        self.popupWindow = nil;
    } else {
        self.hidden = YES;
    }
    if (completion) {
        completion(YES);
    }
    if (self.didHideBlock) {
        self.didHideBlock(self.hidesByUserTap);
    }
    self.hidesByUserTap = NO;
}

- (BOOL)isShowing {
    BOOL isShowingIfAddedToView = self.superview && !self.hidden && !self.popupWindow;
    BOOL isShowingIfInWindow = self.superview && self.popupWindow && !self.popupWindow.hidden;
    return isShowingIfAddedToView || isShowingIfInWindow;
}

#pragma mark - Private Tools

- (BOOL)isSubviewShowing:(UIView *)subview {
    return subview && !subview.hidden && subview.superview;
}

- (void)initPopupContainerViewWindowIfNeeded {
    if (!self.popupWindow) {
        self.popupWindow = [[TMUIPopupContainerViewWindow alloc] init];
//        self.popupWindow.tmui_capturesStatusBarAppearance = NO;
        self.popupWindow.backgroundColor = UIColorClear;
        self.popupWindow.windowLevel = UIWindowLevelTMUIAlertView;
        TMUIPopContainerViewController *viewController = [[TMUIPopContainerViewController alloc] init];
        ((TMUIPopContainerMaskControl *)viewController.view).popupContainerView = self;
        if (self.automaticallyHidesWhenUserTap) {
            viewController.view.backgroundColor = self.maskViewBackgroundColor;
        } else {
            viewController.view.backgroundColor = UIColorClear;
        }
//        viewController.supportedOrientationMask = [TMUIHelper visibleViewController].supportedInterfaceOrientations;
        self.popupWindow.rootViewController = viewController;// ?????? rootViewController ??????????????????
        [self.popupWindow.rootViewController.view addSubview:self];
    }
}

/// ??????????????????????????????????????????????????? distanceBetweenSource ????????????????????????????????????????????????????????????????????????????????? contentEdgeInsets ??????
- (CGSize)contentSizeInSize:(CGSize)size {
    CGSize contentSize = CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets) - self.borderWidth * 2 - self.arrowSpacingInHorizontal, size.height - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets) - self.borderWidth * 2 - self.arrowSpacingInVertical);
    return contentSize;
}

/// ???????????????????????????????????????????????????????????????self size??????????????????
- (CGSize)sizeWithContentSize:(CGSize)contentSize sizeThatFits:(CGSize)sizeThatFits {
    CGFloat resultWidth = contentSize.width + UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets) + self.borderWidth * 2 + self.arrowSpacingInHorizontal;
//    resultWidth = MIN(resultWidth, sizeThatFits.width);// ??????????????????????????????size.width
    resultWidth = MAX(MIN(resultWidth, self.maximumWidth), self.minimumWidth);// ??????????????????????????????????????????
    resultWidth = ceil(resultWidth);
    
    CGFloat resultHeight = contentSize.height + UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets) + self.borderWidth * 2 + self.arrowSpacingInVertical;
//    resultHeight = MIN(resultHeight, sizeThatFits.height);
    resultHeight = MAX(MIN(resultHeight, self.maximumHeight), self.minimumHeight);
    resultHeight = ceil(resultHeight);
    
    return CGSizeMake(resultWidth, resultHeight);
}

- (BOOL)isHorizontalLayoutDirection {
    return self.preferLayoutDirection == TMUIPopupContainerViewLayoutDirectionLeft || self.preferLayoutDirection == TMUIPopupContainerViewLayoutDirectionRight;
}

- (BOOL)isVerticalLayoutDirection {
    return self.preferLayoutDirection == TMUIPopupContainerViewLayoutDirectionAbove || self.preferLayoutDirection == TMUIPopupContainerViewLayoutDirectionBelow;
}

- (void)setArrowImage:(UIImage *)arrowImage {
    _arrowImage = arrowImage;
    if (arrowImage) {
        _arrowSize = arrowImage.size;
        
        if (!_arrowImageLayer) {
            _arrowImageLayer = [CALayer layer];
            [_arrowImageLayer tmui_removeDefaultAnimations];
            [self.layer addSublayer:_arrowImageLayer];
        }
        _arrowImageLayer.hidden = NO;
        _arrowImageLayer.contents = (id)arrowImage.CGImage;
        _arrowImageLayer.contentsScale = arrowImage.scale;
        _arrowImageLayer.bounds = CGRectMakeWithSize(arrowImage.size);
    } else {
        _arrowImageLayer.hidden = YES;
        _arrowImageLayer.contents = nil;
    }
}

- (void)setArrowSize:(CGSize)arrowSize {
    if (!self.arrowImage) {
        _arrowSize = arrowSize;
    }
}

// self.arrowSize ?????????????????????????????????????????? tip ????????????????????????arrowSize ??????????????????
- (CGSize)arrowSizeAuto {
    return self.isHorizontalLayoutDirection ? CGSizeMake(self.arrowSize.height, self.arrowSize.width) : self.arrowSize;
}

- (CGFloat)arrowSpacingInHorizontal {
    return self.isHorizontalLayoutDirection ? self.arrowSizeAuto.width : 0;
}

- (CGFloat)arrowSpacingInVertical {
    return self.isVerticalLayoutDirection ? self.arrowSizeAuto.height : 0;
}

- (UIEdgeInsets)safetyMarginsAvoidSafeAreaInsets {
    UIEdgeInsets result = self.safetyMarginsOfSuperview;
    if (self.isHorizontalLayoutDirection) {
        result.left += self.superview.tmui_safeAreaInsets.left;
        result.right += self.superview.tmui_safeAreaInsets.right;
    } else {
        result.top += self.superview.tmui_safeAreaInsets.top;
        result.bottom += self.superview.tmui_safeAreaInsets.bottom;
    }
    return result;
}

@end

@implementation TMUIPopupContainerView (UISubclassingHooks)

- (void)didInitialize {
    _backgroundLayer = [CAShapeLayer layer];
    [_backgroundLayer tmui_removeDefaultAnimations];
    [self.layer addSublayer:_backgroundLayer];
    
    _contentView = [[UIView alloc] init];
    self.contentView.clipsToBounds = YES;
    [self addSubview:self.contentView];
    
    // ???????????????????????? showWithAnimated: ????????????????????? window ???????????? appearance ????????? showWithAnimated: ??????????????????????????????????????? showWithAnimated: ???????????????????????? appearance ????????????????????????????????????????????????????????????
    [self tmui_applyAppearance];
}

- (CGSize)sizeThatFitsInContentView:(CGSize)size {
    // ????????????????????????????????????
    if (![self isSubviewShowing:_imageView] && ![self isSubviewShowing:_textLabel]) {
        CGSize selfSize = [self contentSizeInSize:self.bounds.size];
        return selfSize;
    }
    
    CGSize resultSize = CGSizeZero;
    
    BOOL isImageViewShowing = [self isSubviewShowing:_imageView];
    if (isImageViewShowing) {
        CGSize imageViewSize = [_imageView sizeThatFits:size];
        resultSize.width += ceil(imageViewSize.width) + self.imageEdgeInsets.left;
        resultSize.height += ceil(imageViewSize.height) + self.imageEdgeInsets.top;
    }
    
    BOOL isTextLabelShowing = [self isSubviewShowing:_textLabel];
    if (isTextLabelShowing) {
        CGSize textLabelLimitSize = CGSizeMake(size.width - resultSize.width - self.imageEdgeInsets.right, size.height);
        CGSize textLabelSize = [_textLabel sizeThatFits:textLabelLimitSize];
        resultSize.width += (isImageViewShowing ? self.imageEdgeInsets.right : 0) + ceil(textLabelSize.width) + self.textEdgeInsets.left;
        resultSize.height = MAX(resultSize.height, ceil(textLabelSize.height) + self.textEdgeInsets.top);
    }
    return resultSize;
}

@end

@implementation TMUIPopupContainerView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    TMUIPopupContainerView *appearance = [TMUIPopupContainerView appearance];
    appearance.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    appearance.arrowSize = CGSizeMake(18, 9);
    appearance.maximumWidth = CGFLOAT_MAX;
    appearance.minimumWidth = 0;
    appearance.maximumHeight = CGFLOAT_MAX;
    appearance.minimumHeight = 0;
    appearance.preferLayoutDirection = TMUIPopupContainerViewLayoutDirectionAbove;
    appearance.distanceBetweenSource = 5;
    appearance.safetyMarginsOfSuperview = UIEdgeInsetsMake(10, 10, 10, 10);
    appearance.backgroundColor = UIColorWhite;
    appearance.maskViewBackgroundColor = UIColorMask;
    appearance.highlightedBackgroundColor = nil;
    appearance.shadowColor = UIColorMakeWithRGBA(0, 0, 0, .1);
    appearance.borderColor = UIColorGrayLighten;
    appearance.borderWidth = PixelOne;
    appearance.cornerRadius = 10;
    appearance.tmui_outsideEdge = UIEdgeInsetsZero;
    
}

@end

@implementation TMUIPopContainerViewController

- (void)loadView {
    TMUIPopContainerMaskControl *maskControl = [[TMUIPopContainerMaskControl alloc] init];
    self.view = maskControl;
}

@end

@implementation TMUIPopContainerMaskControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(handleMaskEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self) {
        if (!self.popupContainerView.automaticallyHidesWhenUserTap) {
            return nil;
        }
    }
    return result;
}

// ?????????????????????????????? addTarget: ?????????????????? hitTest:withEvent: ?????????????????? hitTest:withEvent: ??????????????????
- (void)handleMaskEvent:(id)sender {
    if (self.popupContainerView.automaticallyHidesWhenUserTap) {
        self.popupContainerView.hidesByUserTap = YES;
        [self.popupContainerView hideWithAnimated:YES];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.popupContainerView updateLayout];// ??????????????????????????? sourceView window ?????????????????? popupWindow ???????????????????????? popupWindow ???????????????????????????????????? popup ?????????
}

@end

@implementation TMUIPopupContainerViewWindow

// ?????? UIWindow ??????????????????????????????????????????????????????
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self) {
        return nil;
    }
    return result;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rootViewController.view.frame = self.bounds;// ???????????????????????????????????????
}

@end
