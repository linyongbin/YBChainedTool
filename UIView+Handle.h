//
//  UIView+Handle.h
//  SDH
//
//  Created by 林勇彬 on 2021/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, UIViewGraduateType) {
    UIViewGraduateLeftToRight  = 0,
    UIViewGraduateRightToLeft,
    UIViewGraduateToptToBottom,
    UIViewGraduateBottomToTop,
    UIViewGraduateLeftTopToBottomRight
};

@interface UIView (Handle)

/// 获取子空件
- (UIView *)getSubview:(Class)className;

/// 把一个View转化成一张图片
/// @param size 图片大小
- (UIImage *)makeImageWithSize:(CGSize)size;
/// 设置渐变颜色
- (void)graduateColorWithColors:(NSArray *)colors;
- (void)graduateColorWithColors:(NSArray *)colors direction:(UIViewGraduateType)direction;
/// 遮罩
- (void)addShadeViewWithHeight:(CGFloat)height;

////阴影设置
//- (void)shadowWithColor:(UIColor *)color;
////圆角设置
//- (void)allRadius:(CGFloat)size;
//- (void)topRadius:(CGFloat)size;
//- (void)bottomRadius:(CGFloat)size;
//- (void)leftRadius:(CGFloat)size;
//- (void)rightRadius:(CGFloat)size;
////设置圆角的话，需要在layout刷新的时候调用此方法，才能实现
//- (void)layoutRefresh;
@end

NS_ASSUME_NONNULL_END
