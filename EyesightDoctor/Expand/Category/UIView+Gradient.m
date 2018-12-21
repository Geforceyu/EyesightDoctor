//
//  UIView+Gradient.m
//  LongWebviewScreenshot
//
//  Created by Geforceyu on 2018/9/5.
//  Copyright © 2018年 geforecyu. All rights reserved.
//

#import "UIView+Gradient.h"

@implementation UIView (Gradient)

- (void)setColors:(NSArray<UIColor *> *)colors
{
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    NSMutableArray *transColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [transColors addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = transColors;
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}
- (void)themeColors
{
    [self setColors:@[[UIColor colorFromHexString:@"#53b2f7"],[UIColor colorFromHexString:@"#30848f"]]];
}
@end
