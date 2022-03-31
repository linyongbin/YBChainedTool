//
//  NSMutableAttributedString+Handle.h
//  SDH
//
//  Created by 林勇彬 on 2021/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Handle)
/// 行间距
- (NSMutableAttributedString * (^)(CGFloat spacing))yb_lineSpacing;
- (NSMutableAttributedString * (^)(NSString *changeStr))yb_underline;

- (NSMutableAttributedString * (^)(UIFont *font,NSString *changeStr))yb_font;
- (NSMutableAttributedString * (^)(UIColor *color,NSString *changeStr))yb_color;
- (NSMutableAttributedString * (^)(UIFont *font,NSString *changeStr))yb_mutableFont;
- (NSMutableAttributedString * (^)(UIColor *color,NSString *changeStr))yb_mutableColor;

- (NSMutableAttributedString * (^)(NSString *tag,UIFont *font,UIColor *color,CGFloat cornerRadius))yb_borderTag;
- (NSMutableAttributedString * (^)(NSString *tag,UIFont *font,UIColor *color,CGFloat cornerRadius))yb_backgroundTag;
- (NSMutableAttributedString * (^)(NSString *tag,UIFont *font,NSArray *colors,CGFloat cornerRadius))yb_graduateTag;

- (NSMutableAttributedString * (^)(UIImage *image,BOOL isFirstTag))yb_imageTag;
@end

NS_ASSUME_NONNULL_END
