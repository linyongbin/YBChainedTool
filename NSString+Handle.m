//
//  NSString+Handle.m
//  SDH
//
//  Created by 林勇彬 on 2021/12/17.
//

#import "NSString+Handle.h"

@implementation NSString (Handle)
#pragma mark - 计算字符串宽高
- (CGFloat )textWidthFont:(NSInteger )font{
    CGSize size = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil]];
    return size.width;
}

- (CGFloat )textHeightFont:(NSInteger )font maxWidth:(CGFloat)maxWidth{
    BOOL hasEmoji = [self stringContainsEmoji];
    CGSize size = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return hasEmoji?size.height+5:size.height;
}

//判断是否存在emoji
- (BOOL)stringContainsEmoji{
    NSUInteger stringUtf8Length = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if(stringUtf8Length >= 4 && (stringUtf8Length / self.length != 3))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 字符串颜色、字体更改
- (NSMutableAttributedString *)changeTextWithFont:(UIFont *)font substrings:(NSArray *)substrings{
    return [self changeTextWithColor:nil Font:font substrings:substrings];
}

- (NSMutableAttributedString *)changeTextWithColor:(UIColor *)color substrings:(NSArray *)substrings{
    return [self changeTextWithColor:color Font:nil substrings:substrings];
}

- (NSMutableAttributedString *)changeTextWithColor:(UIColor * _Nullable)color Font:(UIFont *_Nullable)font substrings:(NSArray *)substrings{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSString * copyTotalString = self;
    for (NSString *substring in substrings) {
        NSMutableString * replaceString = [NSMutableString stringWithCapacity:0];
        for (int i = 0; i < substring.length; i ++) {
            [replaceString appendString:@" "];
        }
        while ([copyTotalString rangeOfString:substring].location != NSNotFound) {
            NSRange range = [copyTotalString rangeOfString:substring];
            //颜色如果统一的话可写在这里，如果颜色根据内容在改变，可把颜色作为参数，调用方法的时候传入
            if (font) {
                [attributedString addAttribute:NSFontAttributeName value:font range:range];
            }
            if (color) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
            }
            copyTotalString = [copyTotalString stringByReplacingCharactersInRange:range withString:replaceString];
        }
    }
    return attributedString;
}

#pragma mark -  创建标签
- (NSMutableAttributedString *)creatImgAttributedStrTags:(NSArray *)tags font:(CGFloat)font backColor:(UIColor *)backColor{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self ? :@""];
    for (NSString *tag in tags) {
        [self attributedStrAddTagWithAttri:attri tag:tag font:font backColor:backColor isGraduate:YES isTagFirst:YES];
    }
    return attri;
}

- (NSMutableAttributedString *)attributedStrAddTagWithAttri:(NSMutableAttributedString *)attri tag:(NSString *)tag font:(CGFloat)font backColor:(UIColor *)backColor isGraduate:(BOOL)isGraduate isTagFirst:(BOOL)isTagFirst{
    CGFloat width = [tag textWidthFont:font];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width+5, 15)];
    [button setTitle:tag forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    button.userInteractionEnabled = NO;
    if (isGraduate) {
        [button graduateColorWithColors:@[UIColorFromRGB(0xFF8200),UIColorFromRGB(0xFFC100)]];
    }else{
        [button setBackgroundColor:backColor];
    }
    UIImage *lbImage = [button makeImageWithSize:button.frame.size];
//
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = lbImage;
    attch.bounds = CGRectMake(0, -2, width + 5, 15);
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:@" "];
    [attri insertAttributedString:space atIndex:0];
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    if (isTagFirst) {
        NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:@" "];
        [attri insertAttributedString:space atIndex:0];
        //将图片放在第一位
        [attri insertAttributedString:string atIndex:0];
    }else{
        NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:@" "];
        [attri appendAttributedString:space];
        //将图片放在最后一位
        [attri appendAttributedString:string];
    }
    return attri;
}

#pragma mark - HTML
- (NSString *)jointHtmlString {
    NSString *htmlString = [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"zh-CN\"><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no\"><style>body{padding:0;margin:0;}img{display:block;width:100%%;}</style></head><body>%@</body></html>", self];
    return htmlString;
}
#pragma mark - 数字格式化
- (NSString *)numberFormatting;{
    if (self.integerValue >= 10000) {
        NSString *number = [self numberFormatting:4 symbol:nil];
        NSString *numberFormat = [NSString stringWithFormat:@"%@万",number];
        return numberFormat;
    }else {
        return self?:@"0";
    }
}

- (NSString *)numberFormatting:(NSInteger)coinDecimal symbol:(NSString * __nullable)symbol{
    if (!self || self.intValue == 0 ) {
        return @"0";
    }
 
    CGFloat decimal = 1.0;
    for (NSInteger i=0; i<coinDecimal; i++) {
        decimal *= 10.0;
    }
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    numFormat.numberStyle = NSNumberFormatterDecimalStyle;
    numFormat.groupingSeparator = @"";//数字分割的格式
    numFormat.maximumFractionDigits = 2;
    NSString *discountNum = [numFormat stringFromNumber:@(self.doubleValue/decimal)];
    if (symbol) {
        discountNum = [NSString stringWithFormat:@"%@%@",symbol,discountNum];
    }
    return discountNum;
}

#pragma mark - 拆分字符串，获取成员变量
- (NSString *)getURLTarget{
    NSString *targetString;
    if (self.length > 0) {
        NSRange range = [self rangeOfString:@"?"];
        if (range.length == 0) {
            targetString = self;
        }else{
            targetString = [self substringToIndex:range.location];
        }
    }else{
        targetString = @"";
    }
    return targetString;
}

- (NSMutableDictionary *)getURLParameters{
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                } else {
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                [params setValue:value forKey:key];
            }
        }
    }else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if (pairComponents.count == 1) {
            return nil;
        }
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        if (key == nil || value == nil) {
            return nil;
        }
        [params setValue:value forKey:key];
    }
    return params;
}
@end
