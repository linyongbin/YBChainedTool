//
//  NSString+Handle.h
//  SDH
//
//  Created by 林勇彬 on 2021/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Handle)

/// 计算字符串的宽度
/// @param font 字体大小
- (CGFloat )textWidthFont:(NSInteger )font;
/// 计算字符串的高度
/// @param font 字体大小
/// @param maxWidth 最大宽度
- (CGFloat )textHeightFont:(NSInteger )font maxWidth:(CGFloat)maxWidth;
/// 创建标签
- (NSMutableAttributedString *)creatImgAttributedStrTags:(NSArray *)tags font:(CGFloat)font backColor:(UIColor *)backColor;
- (NSMutableAttributedString *)attributedStrAddTagWithAttri:(NSMutableAttributedString *)attri tag:(NSString *)tag font:(CGFloat)font backColor:(UIColor *)backColor isGraduate:(BOOL)isGraduate isTagFirst:(BOOL)isTagFirst;
#pragma mark - 字符串颜色、字体更改
- (NSMutableAttributedString *)changeTextWithFont:(UIFont *)font substrings:(NSArray *)substrings;
- (NSMutableAttributedString *)changeTextWithColor:(UIColor *)color substrings:(NSArray *)substrings;
- (NSMutableAttributedString *)changeTextWithColor:(UIColor *_Nullable)color Font:(UIFont *_Nullable)font substrings:(NSArray *)substrings;

#pragma mark - HTML
- (NSString *)jointHtmlString;

#pragma mark - 数字格式化
- (NSString *)numberFormatting;

#pragma mark - 拆分字符串，获取成员变量
- (NSString *)getURLTarget;
- (NSMutableDictionary *)getURLParameters;
@end

NS_ASSUME_NONNULL_END
