//
//  UILabel+Handle.h
//  BangQi
//
//  Created by linyongbin on 2020/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Handle)
- (UILabel *(^)(NSString *text))yb_text;
- (UILabel *(^)(CGFloat font))yb_font;
- (UILabel *(^)(CGFloat blodFont))yb_blodFont;
- (NSMutableAttributedString *)yb_attribute;

#pragma mark - 限制显示行数，后面添加“查看全文”
- (void)setReadMoreLabelContentMode:(CGFloat)labelWidth;
@end

NS_ASSUME_NONNULL_END
