//
//  UILabel+Handle.m
//  BangQi
//
//  Created by linyongbin on 2020/11/2.
//

#import "UILabel+Handle.h"
#import <CoreText/CoreText.h>

@implementation UILabel (Handle)
- (UILabel *(^)(NSString *text))yb_text{
    return ^(NSString *text){
        self.text = text;
        return self;
    };
}

- (UILabel *(^)(CGFloat font))yb_font{
    return ^(CGFloat font){
        self.font = [UIFont systemFontOfSize:font];
        return self;
    };
}
- (UILabel *(^)(CGFloat blodFont))yb_blodFont{
    return ^(CGFloat blodFont){
        self.font = [UIFont boldSystemFontOfSize:blodFont];
        return self;
    };
}

- (NSMutableAttributedString *)yb_attribute {
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:self.text];
    return attriString;
}

#pragma mark - 限制显示行数，后面添加“查看全文”
- (void)setReadMoreLabelContentMode:(CGFloat)labelWidth{
    NSArray *contents = [self getLinesArrayOfLabelRows:labelWidth];
    if (contents.count <= 2) {
        self.userInteractionEnabled = NO; // 如果一行就不显示查看更多，同时取消手势响应
        return;
    }
    self.userInteractionEnabled=YES;
    
    //一个中文也算1个长度，如果末尾要截取的是英文，则“查看更多”会显示不全，所以截取的长度要长一些
    NSUInteger cutLength = 8; // 后面截取的长度
    
    NSMutableString *contentText = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < self.numberOfLines; i++) {
        if (i == self.numberOfLines - 1) { // 最后一行 进行处理加上.....
            
            NSString *lastLineText = [NSString stringWithFormat:@"%@",contents[i]];
            NSUInteger lineLength = lastLineText.length;
            if (lineLength > cutLength) {
                lastLineText = [lastLineText substringToIndex:(lastLineText.length - cutLength)];
            }
            [contentText appendString:[NSString stringWithFormat:@"%@...",lastLineText]];
        } else {
            [contentText appendString:contents[i]];
        }
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dictionary = @{
                                 NSForegroundColorAttributeName : self.textColor,
                                 NSFontAttributeName : self.font,
                                 NSParagraphStyleAttributeName : style
                                 };
    NSMutableAttributedString *mutableAttribText = [[NSMutableAttributedString alloc] initWithString:[contentText stringByAppendingString:@"  全文"] attributes:dictionary];
    [mutableAttribText addAttributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16.f],
                                       NSForegroundColorAttributeName :UIColorFromRGB(0xCEA779)
                                       } range:NSMakeRange(contentText.length, 4)];
    self.attributedText = mutableAttribText;
}

// 获取 Label 每行内容 得到一个数组
- (NSArray *)getLinesArrayOfLabelRows:(CGFloat)labelWidth{
    //CGFloat labelWidth = self.frame.size.width;
    //如果使用autolayout，labelWidth会为0
    
    NSString *text = [self text];
    UIFont *font = [self font];
    if (text == nil) {
        return nil;
    }
    NSString *fontName = self.font.fontName;
    if ([self.font.fontName isEqualToString:@".SFUI-Regular"]) {
        fontName = @"TimesNewRomanPSMT";
    }
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)(fontName), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:(NSString *)kCTFontAttributeName
                   value:(__bridge  id)myFont
                   range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,labelWidth,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr,
                                       lineRange,
                                       kCTKernAttributeName,
                                       (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr,
                                       lineRange,
                                       kCTKernAttributeName,
                                       (CFTypeRef)([NSNumber numberWithInt:0.0]));
        [linesArray addObject:lineString];
    }
    CGPathRelease(path);
    CFRelease(frame);
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}
@end
