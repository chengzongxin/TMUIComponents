//
//  TMUIThemePrivate.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//

#import "TMUIThemePrivate.h"
#import "TMUIRuntime.h"
#import "UIColor+TMUI.h"
#import "UIVisualEffect+TMUITheme.h"
#import "UIView+TMUITheme.h"
#import "UIView+TMUI.h"
//#import "UISearchBar+TMUI.h"
#import "UITableViewCell+TMUI.h"
#import "CALayer+TMUI.h"
#import "UIVisualEffectView+TMUI.h"
#import "UIBarItem+TMUI.h"
//#import "UITabBar+TMUI.h"
#import "UITabBarItem+TMUI.h"

// TMUI classes
//#import "TMUIImagePickerCollectionViewCell.h"
//#import "TMUIAlertController.h"
#import "TMUIButton.h"
//#import "TMUIFillButton.h"
//#import "TMUIGhostButton.h"
//#import "TMUILinkButton.h"
//#import "TMUIConsole.h"
//#import "TMUIEmotionView.h"
//#import "TMUIEmptyView.h"
//#import "TMUIGridView.h"
//#import "TMUIImagePreviewView.h"
#import "TMUILabel.h"
//#import "TMUIPopupContainerView.h"
//#import "TMUIPopupMenuButtonItem.h"
//#import "TMUIPopupMenuView.h"
#import "TMUISlider.h"
#import "TMUITextField.h"
#import "TMUITextView.h"
//#import "TMUIVisualEffectView.h"
//#import "TMUIToastBackgroundView.h"
#import "TMUIBadgeProtocol.h"

#import "NSObject+TMUI.h"

@interface TMUIThemePropertiesRegister : NSObject

@end

@implementation TMUIThemePropertiesRegister

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithFrame:), CGRect, UIView *, ^UIView *(UIView *selfObject, CGRect frame, UIView *originReturnValue) {
            ({
                static NSDictionary<NSString *, NSArray<NSString *> *> *classRegisters = nil;
                if (!classRegisters) {
                    classRegisters = @{
                                       NSStringFromClass(UISlider.class):                   @[NSStringFromSelector(@selector(minimumTrackTintColor)),
                                                                                              NSStringFromSelector(@selector(maximumTrackTintColor)),
                                                                                              NSStringFromSelector(@selector(thumbTintColor))],
                                       NSStringFromClass(UISwitch.class):                   @[NSStringFromSelector(@selector(onTintColor)),
                                                                                              NSStringFromSelector(@selector(thumbTintColor)),],
                                       NSStringFromClass(UIActivityIndicatorView.class):    @[NSStringFromSelector(@selector(color)),],
                                       NSStringFromClass(UIProgressView.class):             @[NSStringFromSelector(@selector(progressTintColor)),
                                                                                              NSStringFromSelector(@selector(trackTintColor)),],
                                       NSStringFromClass(UIPageControl.class):              @[NSStringFromSelector(@selector(pageIndicatorTintColor)),
                                                                                              NSStringFromSelector(@selector(currentPageIndicatorTintColor)),],
                                       NSStringFromClass(UITableView.class):                @[NSStringFromSelector(@selector(backgroundColor)),
                                                                                              NSStringFromSelector(@selector(sectionIndexColor)),
                                                                                              NSStringFromSelector(@selector(sectionIndexBackgroundColor)),
                                                                                              NSStringFromSelector(@selector(sectionIndexTrackingBackgroundColor)),
                                                                                              NSStringFromSelector(@selector(separatorColor)),],
                                       NSStringFromClass(UITableViewCell.class):            @[NSStringFromSelector(@selector(tmui_selectedBackgroundColor)),],
                                       NSStringFromClass(UICollectionViewCell.class):            @[NSStringFromSelector(@selector(tmui_selectedBackgroundColor)),],
                                       NSStringFromClass(UINavigationBar.class):            @[NSStringFromSelector(@selector(barTintColor)),],
                                       NSStringFromClass(UIToolbar.class):                  @[NSStringFromSelector(@selector(barTintColor)),],
                                       NSStringFromClass(UITabBar.class):                   ({
                                           NSMutableArray<NSString *> *result = @[
//                                               NSStringFromSelector(@selector(tmui_effect)),
//                                               NSStringFromSelector(@selector(tmui_effectForegroundColor)),
                                           ].mutableCopy;
                                           if (@available(iOS 13.0, *)) {
                                               // iOS 13 ??? UITabBar (TMUI) ???????????????????????????????????? standardAppearance??????????????????????????? standardAppearance ???????????????????????????
                                               [result addObject:NSStringFromSelector(@selector(standardAppearance))];
                                           } else {
                                               [result addObjectsFromArray:@[NSStringFromSelector(@selector(barTintColor)),
                                                                             NSStringFromSelector(@selector(unselectedItemTintColor)),
                                                                             NSStringFromSelector(@selector(selectedImageTintColor)),]];
                                           }
                                           result.copy;
                                       }),
                                       NSStringFromClass(UISearchBar.class):                        @[NSStringFromSelector(@selector(barTintColor)),
//                                                                                                      NSStringFromSelector(@selector(tmui_placeholderColor)),
//                                                                                                      NSStringFromSelector(@selector(tmui_textColor)),
                                       ],
                                       NSStringFromClass(UIView.class):                             @[NSStringFromSelector(@selector(tintColor)),
                                                                                                      NSStringFromSelector(@selector(backgroundColor)),
                                                                                                      NSStringFromSelector(@selector(tmui_borderColor)),
                                                                                                      NSStringFromSelector(@selector(tmui_badgeBackgroundColor)),
                                                                                                      NSStringFromSelector(@selector(tmui_badgeTextColor)),
                                                                                                      NSStringFromSelector(@selector(tmui_updatesIndicatorColor)),],
                                       NSStringFromClass(UIVisualEffectView.class):                 @[NSStringFromSelector(@selector(effect)),
                                                                                                      NSStringFromSelector(@selector(tmui_foregroundColor))],
                                       NSStringFromClass(UIImageView.class):                        @[NSStringFromSelector(@selector(image))],
                                       
                                       // TMUI classes
//                                       NSStringFromClass(TMUIImagePickerCollectionViewCell.class):  @[NSStringFromSelector(@selector(videoDurationLabelTextColor)),],
                                       NSStringFromClass(TMUIButton.class):                         @[NSStringFromSelector(@selector(tintColorAdjustsTitleAndImage)),
                                                                                                      NSStringFromSelector(@selector(highlightedBackgroundColor)),
                                                                                                      NSStringFromSelector(@selector(highlightedBorderColor)),],
//                                       NSStringFromClass(TMUIFillButton.class):                     @[NSStringFromSelector(@selector(fillColor)),
//                                                                                                      NSStringFromSelector(@selector(titleTextColor)),],
//                                       NSStringFromClass(TMUIGhostButton.class):                    @[NSStringFromSelector(@selector(ghostColor)),],
//                                       NSStringFromClass(TMUILinkButton.class):                     @[NSStringFromSelector(@selector(underlineColor)),],
//                                       NSStringFromClass(TMUIConsole.class):                        @[NSStringFromSelector(@selector(searchResultHighlightedBackgroundColor)),],
//                                       NSStringFromClass(TMUIEmotionView.class):                    @[NSStringFromSelector(@selector(sendButtonBackgroundColor)),],
//                                       NSStringFromClass(TMUIEmptyView.class):                      @[NSStringFromSelector(@selector(textLabelTextColor)),
//                                                                                                      NSStringFromSelector(@selector(detailTextLabelTextColor)),
//                                                                                                      NSStringFromSelector(@selector(actionButtonTitleColor))],
//                                       NSStringFromClass(TMUIGridView.class):                       @[NSStringFromSelector(@selector(separatorColor)),],
//                                       NSStringFromClass(TMUIImagePreviewView.class):               @[NSStringFromSelector(@selector(loadingColor)),],
                                       NSStringFromClass(TMUILabel.class):                          @[NSStringFromSelector(@selector(highlightedBackgroundColor)),],
//                                       NSStringFromClass(TMUIPopupContainerView.class):             @[NSStringFromSelector(@selector(highlightedBackgroundColor)),
//                                                                                                      NSStringFromSelector(@selector(maskViewBackgroundColor)),
//                                                                                                      NSStringFromSelector(@selector(shadowColor)),
//                                                                                                      NSStringFromSelector(@selector(borderColor)),
//                                                                                                      NSStringFromSelector(@selector(arrowImage)),],
//                                       NSStringFromClass(TMUIPopupMenuButtonItem.class):            @[NSStringFromSelector(@selector(highlightedBackgroundColor)),],
//                                       NSStringFromClass(TMUIPopupMenuView.class):                  @[NSStringFromSelector(@selector(itemSeparatorColor)),
//                                                                                                      NSStringFromSelector(@selector(sectionSeparatorColor)),
//                                                                                                      NSStringFromSelector(@selector(itemTitleColor))],
                                       NSStringFromClass(TMUISlider.class):                         @[NSStringFromSelector(@selector(thumbColor)),
                                                                                                      NSStringFromSelector(@selector(thumbShadowColor)),],
                                       NSStringFromClass(TMUITextField.class):                      @[NSStringFromSelector(@selector(placeholderColor)),],
                                       NSStringFromClass(TMUITextView.class):                       @[NSStringFromSelector(@selector(placeholderColor)),],
//                                       NSStringFromClass(TMUIVisualEffectView.class):               @[NSStringFromSelector(@selector(foregroundColor)),],
//                                       NSStringFromClass(TMUIToastBackgroundView.class):            @[NSStringFromSelector(@selector(styleColor)),],
                                       
                                       // UITextField ?????????????????????????????????????????? textColor ?????????????????????????????????????????????????????????????????????????????????????????????????????????
                                       // ?????????UITextField ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
//                                       NSStringFromClass(UITextField.class):                        @[NSStringFromSelector(@selector(attributedText)),],
                                       
                                       // ????????? class ?????????????????? UIView (TMUITheme) ?????? setNeedsDisplay???????????????????????? setter
//                                       NSStringFromClass(UILabel.class):                            @[NSStringFromSelector(@selector(textColor)),
//                                                                                                      NSStringFromSelector(@selector(shadowColor)),
//                                                                                                      NSStringFromSelector(@selector(highlightedTextColor)),],
//                                       NSStringFromClass(UITextView.class):                         @[NSStringFromSelector(@selector(attributedText)),],

                                       };
                }
                [classRegisters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull classString, NSArray<NSString *> * _Nonnull getters, BOOL * _Nonnull stop) {
                    if ([selfObject isKindOfClass:NSClassFromString(classString)]) {
                        [selfObject tmui_registerThemeColorProperties:getters];
                    }
                }];
            });
            return originReturnValue;
        });
    });
}

+ (void)registerToClass:(Class)class byBlock:(void (^)(UIView *view))block withView:(UIView *)view {
    if ([view isKindOfClass:class]) {
        block(view);
    }
}

@end

@implementation UIView (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 13.0, *)) {
        } else {
            OverrideImplementation([UIView class], @selector(setTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(UIView *selfObject, UIColor *tintColor) {
                    
                    // iOS 12 ????????????-[UIView setTintColor:] ?????????????????????????????? tintColor ???????????? tintColor ?????????????????????????????? tintColorDidChange??????????????? dynamic color ??????????????????????????????????????? dynamic color ?????????????????????????????? rawColor ??????????????????????????????????????????????????????????????? copy ??????????????????????????????????????????
                    if (tintColor.tmui_isTMUIDynamicColor && tintColor == selfObject.tintColor) tintColor = tintColor.copy;
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, UIColor *);
                    originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, tintColor);
                };
            });
        }
        
        OverrideImplementation([UIView class], @selector(setBackgroundColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^void(UIView *selfObject, UIColor *color) {
                
                if (selfObject.backgroundColor.tmui_isTMUIDynamicColor || color.tmui_isTMUIDynamicColor) {
                    // -[UIView setBackgroundColor:] ??????????????? layer ??? backgroundColor?????????????????????????????????????????????????????????????????? color.CGColor ???????????? self.layr.backgroundColor ?????????????????????????????????????????? layer.backgroundColor ??????????????? TMUI ????????????????????????????????????????????????????????????????????????????????????????????? layer.backgroundColor ??????????????????????????? -[CALayer setBackgroundColor:] ??????
                    selfObject.layer.backgroundColor = nil;
                }
                
                void (*originSelectorIMP)(id, SEL, UIColor *);
                originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, color);
                
            };
        });
        
        // iOS 12 ?????????????????????[UIView setBackgroundColor:] ??????????????????????????? color??????????????????????????????????????????????????? TMUIThemeColor ?????????????????????
        if (@available(iOS 13.0, *)) {
        } else {
            ExtendImplementationOfVoidMethodWithSingleArgument([UIView class], @selector(setBackgroundColor:), UIColor *, ^(UIView *selfObject, UIColor *color) {
                [selfObject tmui_bindObject:color forKey:@"UIView(TMUIThemeCompatibility).backgroundColor"];
            });
            ExtendImplementationOfNonVoidMethodWithoutArguments([UIView class], @selector(backgroundColor), UIColor *, ^UIColor *(UIView *selfObject, UIColor *originReturnValue) {
                UIColor *color = [selfObject tmui_getBoundObjectForKey:@"UIView(TMUIThemeCompatibility).backgroundColor"];
                return color ?: originReturnValue;
            });
        }
    });
}

@end

@implementation UISwitch (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // ??????????????? iOS 13 ???????????? copy ???????????????????????????????????????????????? UISwitch ?????? off ????????????????????????????????? onTintColor ?????????????????????????????????????????? on ???????????????????????? onTintColor ???????????????????????? onTintColor?????????????????????????????????
        if (@available(iOS 13.0, *)) {
            OverrideImplementation([UISwitch class], @selector(setOnTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(UISwitch *selfObject, UIColor *tintColor) {
                    
                    if (tintColor.tmui_isTMUIDynamicColor && tintColor == selfObject.onTintColor) tintColor = tintColor.copy;
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, UIColor *);
                    originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, tintColor);
                };
            });
            
            OverrideImplementation([UISwitch class], @selector(setThumbTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(UISwitch *selfObject, UIColor *tintColor) {
                    
                    if (tintColor.tmui_isTMUIDynamicColor && tintColor == selfObject.thumbTintColor) tintColor = tintColor.copy;
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, UIColor *);
                    originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, tintColor);
                };
            });
        }

    });
}


@end

@implementation UISlider (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideImplementation([UISlider class], @selector(setMinimumTrackTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UISlider *selfObject, UIColor *tintColor) {
                
                if (tintColor.tmui_isTMUIDynamicColor && tintColor == selfObject.minimumTrackTintColor) tintColor = tintColor.copy;
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIColor *);
                originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, tintColor);
            };
        });
        
        OverrideImplementation([UISlider class], @selector(setMaximumTrackTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UISlider *selfObject, UIColor *tintColor) {
                
                if (tintColor.tmui_isTMUIDynamicColor && tintColor == selfObject.maximumTrackTintColor) tintColor = tintColor.copy;
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIColor *);
                originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, tintColor);
            };
        });
        
        OverrideImplementation([UISlider class], @selector(setThumbTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UISlider *selfObject, UIColor *tintColor) {
                
                if (tintColor.tmui_isTMUIDynamicColor && tintColor == selfObject.thumbTintColor) tintColor = tintColor.copy;
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIColor *);
                originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, tintColor);
            };
        });
    });
}

@end

@implementation UIProgressView (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideImplementation([UIProgressView class], @selector(setProgressTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIProgressView *selfObject, UIColor *tintColor) {
                
                if (tintColor.tmui_isTMUIDynamicColor && tintColor == selfObject.progressTintColor) tintColor = tintColor.copy;
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIColor *);
                originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, tintColor);
            };
        });
        
        OverrideImplementation([UIProgressView class], @selector(setTrackTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIProgressView *selfObject, UIColor *tintColor) {
                
                if (tintColor.tmui_isTMUIDynamicColor && tintColor == selfObject.trackTintColor) tintColor = tintColor.copy;
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIColor *);
                originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, tintColor);
            };
        });
    });
}

@end

@implementation UITabBarItem (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // UITabBarItem.image ???????????????????????? image????????? TMUIThemeImage????????? selectedImage ???????????? rawImage???????????????????????? TMUIThemeImage ????????? selectedImage ????????????????????? selectedImage ????????????????????? UITabBarItem ??????????????????????????????????????? rawImage?????????????????????????????? image ????????????
        // https://github.com/Tencent/TMUI_iOS/issues/1122
        OverrideImplementation([UITabBarItem class], @selector(setSelectedImage:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UITabBarItem *selfObject, UIImage *selectedImage) {
                
                // ?????????????????????????????? super????????? setter ??? super ???????????? getter?????????????????????????????????????????? getter ???????????? boundObject ????????????
                // https://github.com/Tencent/TMUI_iOS/issues/1218
                [selfObject tmui_bindObject:selectedImage.tmui_isDynamicImage ? selectedImage : nil forKey:@"UITabBarItem(TMUIThemeCompatibility).selectedImage"];
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIImage *);
                originSelectorIMP = (void (*)(id, SEL, UIImage *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, selectedImage);
            };
        });
        
        OverrideImplementation([UITabBarItem class], @selector(selectedImage), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UIImage *(UITabBarItem *selfObject) {
                
                // call super
                UIImage * (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (UIImage * (*)(id, SEL))originalIMPProvider();
                UIImage *result = originSelectorIMP(selfObject, originCMD);
                
                UIImage *selectedImage = [selfObject tmui_getBoundObjectForKey:@"UITabBarItem(TMUIThemeCompatibility).selectedImage"];
                if (selectedImage) {
                    return selectedImage;
                }
                
                return result;
            };
        });
    });
}

@end

@implementation UITableViewCell (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 13.0, *)) {
        } else {
            //  iOS 12 ????????????-[UITableViewCell setBackgroundColor:] ?????????????????????????????? backgroundColor ???????????? backgroundColor ??????????????????????????????????????????????????????????????????????????? dynamic color ??????????????????????????????????????? dynamic color ?????????????????????????????? rawColor ??????????????????????????????????????????????????????????????? copy ??????????????????????????????????????????
            OverrideImplementation([UITableViewCell class], @selector(setBackgroundColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(UITableViewCell *selfObject, UIColor *backgroundColor) {
                     if (backgroundColor.tmui_isTMUIDynamicColor && backgroundColor == selfObject.backgroundColor) backgroundColor = backgroundColor.copy;
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, UIColor *);
                    originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, backgroundColor);
                };
            });
        }
    });
}

@end

@implementation UIVisualEffectView (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideImplementation([UIVisualEffectView class], @selector(setEffect:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIVisualEffectView *selfObject, UIVisualEffect *effect) {
                
                if (effect.tmui_isDynamicEffect && effect == selfObject.effect) effect = effect.copy;
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIVisualEffect *);
                originSelectorIMP = (void (*)(id, SEL, UIVisualEffect *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, effect);
            };
        });
    });
}

@end

@implementation UILabel (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // iOS 10-11 ??????UILabel.attributedText ??????????????????????????????????????????????????? -[UILabel setNeedsDisplay] ???????????????????????????????????????????????????????????? range ????????????????????????????????????iOS 9???12-13 ??????????????????????????????????????????????????? UIView (TMUITheme) ???????????? UILabel ??????
        if (@available(iOS 12.0, *)) {
        } else {
            OverrideImplementation([UILabel class], NSSelectorFromString(@"_needsContentsFormatUpdate"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^BOOL(UILabel *selfObject) {
                    
                    __block BOOL attributedTextContainsDynamicColor = NO;
                    if (selfObject.attributedText) {
                        [selfObject.attributedText enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, selfObject.attributedText.length) options:0 usingBlock:^(UIColor *color, NSRange range, BOOL * _Nonnull stop) {
                            if (color.tmui_isTMUIDynamicColor) {
                                attributedTextContainsDynamicColor = YES;
                                *stop = YES;
                            }
                        }];
                    }
                    if (attributedTextContainsDynamicColor) return YES;
                    
                    BOOL (*originSelectorIMP)(id, SEL);
                    originSelectorIMP = (BOOL (*)(id, SEL))originalIMPProvider();
                    return originSelectorIMP(selfObject, originCMD);
                };
            });
        }
    });
}

@end

@implementation UITextField (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // ??? UITextField ????????????????????????????????????????????????????????????????????? setNeedsDisplay?????????????????????????????? setNeedsDisplay ????????????????????????????????????????????????
        // https://github.com/Tencent/TMUI_iOS/issues/777
        ExtendImplementationOfVoidMethodWithoutArguments([UITextField class], @selector(setNeedsDisplay), ^(UITextView *selfObject) {
            if (selfObject.isFirstResponder) {
                UIView *fieldEditor = [selfObject tmui_valueForKey:@"_fieldEditor"];
                if (fieldEditor) {
                    UIView *contentView = [fieldEditor tmui_valueForKey:@"_contentView"];
                    if (contentView) {
                        [contentView setNeedsDisplay];
                    }
                }
            }
        });
    });
}

@end

@implementation UITextView (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // UITextView ??? iOS 12 ?????????????????? -[UIView setNeedsDisplay]?????????????????????????????????????????? iOS 11 ????????????????????????????????????????????????????????????????????? TMUITheme ???????????? UITextView ???????????? setNeedsDisplay ???????????????????????????????????????????????? iOS 13 ?????????????????????
        if (@available(iOS 12.0, *)) {
        } else {
            ExtendImplementationOfVoidMethodWithoutArguments([UITextView class], @selector(setNeedsDisplay), ^(UITextView *selfObject) {
                UIView *textContainerView = [selfObject tmui_valueForKey:@"_containerView"];
                if (textContainerView) [textContainerView setNeedsDisplay];
            });
        }
    });
}

@end

@interface CALayer ()

@property(nonatomic, strong) UIColor *qcl_originalBackgroundColor;
@property(nonatomic, strong) UIColor *qcl_originalBorderColor;
@property(nonatomic, strong) UIColor *qcl_originalShadowColor;

@end

@implementation CALayer (TMUIThemeCompatibility)

TMUISynthesizeIdStrongProperty(qcl_originalBackgroundColor, setQcl_originalBackgroundColor)
TMUISynthesizeIdStrongProperty(qcl_originalBorderColor, setQcl_originalBorderColor)
TMUISynthesizeIdStrongProperty(qcl_originalShadowColor, setQcl_originalShadowColor)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideImplementation([CALayer class], @selector(setBackgroundColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(CALayer *selfObject, CGColorRef color) {
                
                // iOS 13 ??? UIDynamicProviderColor????????? TMUIThemeColor ????????? CGColor ???????????????????????? CGColorRef ???????????????????????? color ???????????????????????? property ?????????????????????????????????
                UIColor *originalColor = [(__bridge id)(color) tmui_getBoundObjectForKey:TMUICGColorOriginalColorBindKey];
                selfObject.qcl_originalBackgroundColor = originalColor;
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGColorRef);
                originSelectorIMP = (void (*)(id, SEL, CGColorRef))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, color);
            };
        });
        
        OverrideImplementation([CALayer class], @selector(setBorderColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(CALayer *selfObject, CGColorRef color) {
                
                UIColor *originalColor = [(__bridge id)(color) tmui_getBoundObjectForKey:TMUICGColorOriginalColorBindKey];
                selfObject.qcl_originalBorderColor = originalColor;
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGColorRef);
                originSelectorIMP = (void (*)(id, SEL, CGColorRef))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, color);
            };
        });
        
        OverrideImplementation([CALayer class], @selector(setShadowColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(CALayer *selfObject, CGColorRef color) {
                
                UIColor *originalColor = [(__bridge id)(color) tmui_getBoundObjectForKey:TMUICGColorOriginalColorBindKey];
                selfObject.qcl_originalShadowColor = originalColor;
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGColorRef);
                originSelectorIMP = (void (*)(id, SEL, CGColorRef))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, color);
            };
        });
        
        // iOS 13 ??????????????????????????????????????????????????????????????? view ??? layoutSubviews?????????????????????????????????????????????
        // ????????? TMUIThemeManager ?????????????????????????????? theme ?????????????????? tmui_setNeedsUpdateDynamicStyle?????????????????????
        if (@available(iOS 13.0, *)) {
            ExtendImplementationOfVoidMethodWithoutArguments([UIView class], @selector(layoutSubviews), ^(UIView *selfObject) {
                [selfObject.layer tmui_setNeedsUpdateDynamicStyle];
            });
        }
    });
}

- (void)tmui_setNeedsUpdateDynamicStyle {
    if (self.qcl_originalBackgroundColor) {
        UIColor *originalColor = self.qcl_originalBackgroundColor;
        self.backgroundColor = originalColor.CGColor;
    }
    if (self.qcl_originalBorderColor) {
        self.borderColor = self.qcl_originalBorderColor.CGColor;
    }
    if (self.qcl_originalShadowColor) {
        self.shadowColor = self.qcl_originalShadowColor.CGColor;
    }

    [self.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull sublayer, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!sublayer.tmui_isRootLayerOfView) {// ????????? UIView ??? rootLayer??????????????? UIView ???????????? layoutSubviews ??????????????????????????????????????????????????????????????????????????????????????? layer ?????? sublayer ??????
            [sublayer tmui_setNeedsUpdateDynamicStyle];
        }
    }];
}

@end

@interface UISearchBar ()

@property(nonatomic, readonly) NSMutableDictionary <NSString * ,NSInvocation *>*tmuiTheme_invocations;

@end

@implementation UISearchBar (TMUIThemeCompatibility)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

//        OverrideImplementation([UISearchBar class], @selector(setSearchFieldBackgroundImage:forState:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//
//            NSMethodSignature *methodSignature = [originClass instanceMethodSignatureForSelector:originCMD];
//
//            return ^(UISearchBar *selfObject, UIImage *image, UIControlState state) {
//
//                void (*originSelectorIMP)(id, SEL, UIImage *, UIControlState);
//                originSelectorIMP = (void (*)(id, SEL, UIImage *, UIControlState))originalIMPProvider();
//
//                UIImage *previousImage = [selfObject searchFieldBackgroundImageForState:state];
//                if (previousImage.tmui_isDynamicImage || image.tmui_isDynamicImage) {
//                    // setSearchFieldBackgroundImage:forState: ?????????????????????:
//                    // ???????????? image ?????????????????? layout ???????????? -[UITextFieldBorderView setImage:] ?????????????????????????????????
//                    // if (UITextFieldBorderView._image == image) return
//                    // ?????? TMUIDynamicImage ??????????????????????????????????????????????????????????????????????????????????????? image?????????????????? layoutIfNeeded ?????? -[UITextFieldBorderView setImage:] ?????? UITextFieldBorderView ????????? image ?????????????????????????????????????????????
//                    originSelectorIMP(selfObject, originCMD, UIImage.new, state);
//                    [selfObject.tmui_textField setNeedsLayout];
//                    [selfObject.tmui_textField layoutIfNeeded];
//                }
//                originSelectorIMP(selfObject, originCMD, image, state);
//
//                NSInvocation *invocation = nil;
//                NSString *invocationActionKey = [NSString stringWithFormat:@"%@-%zd", NSStringFromSelector(originCMD), state];
//                if (image.tmui_isDynamicImage) {
//                    invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
//                    [invocation setSelector:originCMD];
//                    [invocation setArgument:&image atIndex:2];
//                    [invocation setArgument:&state atIndex:3];
//                    [invocation retainArguments];
//                }
//                selfObject.tmuiTheme_invocations[invocationActionKey] = invocation;
//            };
//        });
        
        OverrideImplementation([UISearchBar class], @selector(setBarTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UISearchBar *selfObject, UIColor *barTintColor) {
                
                if (barTintColor.tmui_isTMUIDynamicColor && barTintColor == selfObject.barTintColor) barTintColor = barTintColor.copy;
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIColor *);
                originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, barTintColor);
            };
        });
    });
}

- (void)_tmui_themeDidChangeByManager:(TMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme shouldEnumeratorSubviews:(BOOL)shouldEnumeratorSubviews {
    [super _tmui_themeDidChangeByManager:manager identifier:identifier theme:theme shouldEnumeratorSubviews:shouldEnumeratorSubviews];
    [self tmuiTheme_performUpdateInvocations];
}

- (void)tmuiTheme_performUpdateInvocations {
    [[self.tmuiTheme_invocations allValues] enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull invocation, NSUInteger idx, BOOL * _Nonnull stop) {
        [invocation setTarget:self];
        [invocation invoke];
    }];
}


- (NSMutableDictionary *)tmuiTheme_invocations {
    NSMutableDictionary *tmuiTheme_invocations = objc_getAssociatedObject(self, _cmd);
    if (!tmuiTheme_invocations) {
        tmuiTheme_invocations = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, tmuiTheme_invocations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tmuiTheme_invocations;
}

@end
