//
//  UIView+Handle.m
//  SDH
//
//  Created by 林勇彬 on 2021/12/18.
//

#import "UIView+Handle.h"
#import <objc/runtime.h>

//static char circularsModelKey;
//@interface YBCirculars : NSObject
//@property (nonatomic, assign) CGFloat topLeft;
//@property (nonatomic, assign) CGFloat topRight;
//@property (nonatomic, assign) CGFloat bottomLeft;
//@property (nonatomic, assign) CGFloat bottomRight;
//@end
//
//@implementation YBCirculars
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.topLeft = 0;
//        self.topRight = 0;
//        self.bottomLeft = 0;
//        self.bottomRight = 0;
//    }
//    return self;
//}
//
//- (instancetype)initWithTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight
//{
//    self = [super init];
//    if (self) {
//        self.topLeft = topLeft;
//        self.topRight = topRight;
//        self.bottomLeft = bottomLeft;
//        self.bottomRight = bottomRight;
//    }
//    return self;
//}
//
//@end


//@interface UIView (Handle)
//@property (nonatomic, strong) YBCirculars *radiuses;
//@end

@implementation UIView (Handle)

- (UIView *)getSubview:(Class)className{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:className]) {
            return view;
        }
    }
    return nil;
}

- (UIImage *)makeImageWithSize:(CGSize)size {
    //下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)graduateColorWithColors:(NSArray *)colors{
    [self graduateColorWithColors:colors direction:UIViewGraduateToptToBottom];
}

- (void)graduateColorWithColors:(NSArray *)colors direction:(UIViewGraduateType)direction{
    [self layoutIfNeeded];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =self.bounds;
    NSMutableArray *cgcolors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgcolors addObject:(id)color.CGColor];
    }
    gradient.colors = cgcolors;
    if (direction == UIViewGraduateToptToBottom) {
        // 从上至下（x相同，y控制方向）
        gradient.startPoint = CGPointMake(.0, .0);
        gradient.endPoint = CGPointMake(.0, 1.0);
    }else if (direction == UIViewGraduateBottomToTop) {
        // 从下至上（x相同，y控制方向）
        gradient.startPoint = CGPointMake(.0, 1.0);
        gradient.endPoint = CGPointMake(.0, .0);
    }else if (direction == UIViewGraduateLeftToRight) {
        // 从左至右（y相同，x控制方向）
        gradient.startPoint = CGPointMake(.0, .0);
        gradient.endPoint = CGPointMake(1.0, .0);
    }else if (direction == UIViewGraduateRightToLeft) {
        // 从右至左（y相同，x控制方向）
        gradient.startPoint = CGPointMake(1.0, .0);
        gradient.endPoint = CGPointMake(.0, .0);
    }else if (direction == UIViewGraduateLeftTopToBottomRight){
        // 从左上至右下（x和y控制方向）
        gradient.startPoint = CGPointMake(.0, .0);
        gradient.endPoint = CGPointMake(1.0, 1.0);
    }
    gradient.locations = @[@(0),@(1.0f)];
    [self.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - 遮罩
- (void)addShadeViewWithHeight:(CGFloat)height{
    __weak typeof(self) weakSelf = self;
    
    UIImageView *shadeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shade"]];
    shadeView.layer.masksToBounds = YES;
    [self addSubview:shadeView];
    [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
//        make.height.equalTo(weakSelf).multipliedBy(0.5);
        make.height.mas_equalTo(height);
    }];
}

//#pragma mark - 阴影
//- (void)shadowWithColor:(UIColor *)color{
//    ////阴影颜色
//    self.layer.shadowColor = color.CGColor;
//    //阴影偏移量
//    self.layer.shadowOffset = CGSizeMake(0, 3);
//    //阴影透明度
//    self.layer.shadowOpacity = 0.2;
//    //模糊计算的半径
//    self.layer.shadowRadius = 5;
//}
//
//- (void)layoutRefresh{
//    if (self.radiuses) {
//        self.radiusLayer.fillColor = [UIColor whiteColor].CGColor;
//        [self addRadiusRectangle:self.radiuses rect:self.bounds];
//    }
//}
//
//- (void)addRadiusRectangle:(YBCirculars *)circulars rect:(CGRect)rect{
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path moveToPoint:CGPointMake(circulars.topLeft, rect.origin.y)];
//    [path addLineToPoint:CGPointMake(rect.size.width - circulars.topRight, rect.origin.y)];
//    [path addQuadCurveToPoint:CGPointMake(rect.size.width, circulars.topRight) controlPoint:CGPointMake(rect.size.width, rect.origin.y)];
//
//    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height - circulars.bottomRight)];
//    [path addQuadCurveToPoint:CGPointMake(rect.size.width - circulars.bottomRight, rect.size.height) controlPoint:CGPointMake(rect.size.width, rect.size.height)];
//
//    [path addLineToPoint:CGPointMake(circulars.bottomLeft, rect.size.height)];
//    [path addQuadCurveToPoint:CGPointMake(rect.origin.x, rect.size.height - circulars.bottomLeft) controlPoint:CGPointMake(rect.origin.x, rect.size.height)];
//
//    [path addLineToPoint:CGPointMake(rect.origin.x, circulars.topLeft)];
//    [path addQuadCurveToPoint:CGPointMake(circulars.topLeft, rect.origin.y) controlPoint:CGPointMake(rect.origin.x, rect.origin.y)];
//    [path closePath];
//
//    self.radiusLayer.path = path.CGPath;
//    self.radiusLayer.shadowPath = path.CGPath;
//}
//
//+ (Class)layerClass{
//    return CAShapeLayer.self;
//}
//
//- (CAShapeLayer *)radiusLayer{
//    return (CAShapeLayer *)self.layer;
//}
//
//- (void)allRadius:(CGFloat)size{
//    self.radiuses = [[YBCirculars alloc] initWithTopLeft:size topRight:size bottomLeft:size bottomRight:size];
//}
//
//- (void)topRadius:(CGFloat)size{
//    self.radiuses = [[YBCirculars alloc] initWithTopLeft:size topRight:size bottomLeft:0 bottomRight:0];
//}
//
//- (void)bottomRadius:(CGFloat)size{
//    self.radiuses = [[YBCirculars alloc] initWithTopLeft:0 topRight:0 bottomLeft:size bottomRight:size];
//}
//
//- (void)leftRadius:(CGFloat)size{
//    self.radiuses = [[YBCirculars alloc] initWithTopLeft:size topRight:0 bottomLeft:size bottomRight:0];
//}
//
//- (void)rightRadius:(CGFloat)size{
//    self.radiuses = [[YBCirculars alloc] initWithTopLeft:0 topRight:size bottomLeft:0 bottomRight:size];
//}
//
//- (void)setRadiuses:(YBCirculars *)radiuses{
//    objc_setAssociatedObject(self, &circularsModelKey, radiuses,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (YBCirculars *)radiuses{
//    return objc_getAssociatedObject(self, &circularsModelKey);
//}
@end
