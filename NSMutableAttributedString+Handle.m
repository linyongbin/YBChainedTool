//
//  NSMutableAttributedString+Handle.m
//  SDH
//
//  Created by 林勇彬 on 2021/12/25.
//

#import "NSMutableAttributedString+Handle.h"
#import "NSString+Handle.h"
#import "UIView+BorderLine.h"

@implementation NSMutableAttributedString (Handle)

- (NSMutableAttributedString * (^)(CGFloat spacing))yb_lineSpacing {
    return ^(CGFloat spacing) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:spacing];//设置距离
        [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.string length])];
        return self;
    };
}

- (NSMutableAttributedString * (^)(NSString *changeStr))yb_underline {
    return ^(NSString *changeStr) {
        [self addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [self.string length])];
        return self;
    };
}

- (NSMutableAttributedString * (^)(UIFont *font,NSString *changeStr))yb_font {
    return ^(UIFont *font,NSString *changeStr) {
        NSRange range = [self.string rangeOfString:changeStr];
        [self addAttribute:NSFontAttributeName value:font range:range];
        return self;
    };
}

- (NSMutableAttributedString * (^)(UIColor *color,NSString *changeStr))yb_color{
    return ^(UIColor *color,NSString *changeStr) {
        NSRange range = [self.string rangeOfString:changeStr];
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
        return self;
    };
}

- (NSMutableAttributedString * (^)(UIFont *font,NSString *changeStr))yb_mutableFont{
    return ^(UIFont *font,NSString *changeStr) {
        NSMutableString * replaceString = [NSMutableString stringWithCapacity:0];
        for (int i = 0; i < changeStr.length; i ++) {
            [replaceString appendString:@" "];
        }
        NSString *copyTotalString = self.string;
        while ([copyTotalString rangeOfString:changeStr].location != NSNotFound) {
            NSRange range = [copyTotalString rangeOfString:changeStr];
            //颜色如果统一的话可写在这里，如果颜色根据内容在改变，可把颜色作为参数，调用方法的时候传入
            [self addAttribute:NSFontAttributeName value:font range:range];
            copyTotalString = [copyTotalString stringByReplacingCharactersInRange:range withString:replaceString];
        }
        return self;
    };
}

- (NSMutableAttributedString * (^)(UIColor *color,NSString *changeStr))yb_mutableColor{
    return ^(UIColor *color,NSString *changeStr) {
        NSMutableString * replaceString = [NSMutableString stringWithCapacity:0];
        for (int i = 0; i < changeStr.length; i ++) {
            [replaceString appendString:@" "];
        }
        NSString *copyTotalString = self.string;
        while ([copyTotalString rangeOfString:changeStr].location != NSNotFound) {
            NSRange range = [copyTotalString rangeOfString:changeStr];
            //颜色如果统一的话可写在这里，如果颜色根据内容在改变，可把颜色作为参数，调用方法的时候传入
            [self addAttribute:NSForegroundColorAttributeName value:color range:range];
            copyTotalString = [copyTotalString stringByReplacingCharactersInRange:range withString:replaceString];
        }
        return self;
    };
}

- (NSMutableAttributedString * (^)(NSString *tag,UIFont *font,UIColor *color,CGFloat cornerRadius))yb_borderTag{
    return ^(NSString *tag,UIFont *font,UIColor *color,CGFloat cornerRadius) {
        UIButton *button = [self getTagButtonWithTitle:tag font:font color:color cornerRadius:cornerRadius];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [color CGColor];
        [button setTitleColor:color forState:UIControlStateNormal];
        UIImage *lbImage = [button makeImageWithSize:button.frame.size];
        self.yb_imageTag(lbImage,YES);
        return self;
    };
}

- (NSMutableAttributedString * (^)(NSString *tag,UIFont *font,UIColor *color,CGFloat cornerRadius))yb_backgroundTag{
    return ^(NSString *tag,UIFont *font,UIColor *color,CGFloat cornerRadius) {
        UIButton *button = [self getTagButtonWithTitle:tag font:font color:color cornerRadius:cornerRadius];
        [button setBackgroundColor:color];
        UIImage *lbImage = [button makeImageWithSize:button.frame.size];
        self.yb_imageTag(lbImage,YES);
        return self;
    };
}


- (NSMutableAttributedString * (^)(NSString *tag,UIFont *font,NSArray *colors,CGFloat cornerRadius))yb_graduateTag{
    return ^(NSString *tag,UIFont *font,NSArray *colors,CGFloat cornerRadius) {
        UIButton *button = [self getTagButtonWithTitle:tag font:font color:[UIColor whiteColor] cornerRadius:cornerRadius];
        [button graduateColorWithColors:colors];
        UIImage *lbImage = [button makeImageWithSize:button.frame.size];
        self.yb_imageTag(lbImage,YES);
        return self;
    };
}

- (NSMutableAttributedString * (^)(UIImage *image,BOOL isFirstTag))yb_imageTag{
    return ^(UIImage *image,BOOL isFirstTag) {
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = image;
        attch.bounds = CGRectMake(0, -5, image.size.width + 5, 18);
        //创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        if (isFirstTag) {
            NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:@" "];
            [self insertAttributedString:space atIndex:0];
            //将图片放在第一位
            [self insertAttributedString:string atIndex:0];
        }else{
            NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:@" "];
            [self appendAttributedString:space];
            //将图片放在最后一位
            [self appendAttributedString:string];
        }
        return self;
    };
}

- (UIButton *)getTagButtonWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius{
    CGFloat width = [title textWidthFont:font.pointSize];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width+5, 18)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.userInteractionEnabled = NO;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = cornerRadius;
    return button;
}
@end
