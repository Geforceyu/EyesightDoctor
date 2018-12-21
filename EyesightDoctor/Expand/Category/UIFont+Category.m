//
//  UIFont+Category.m
//  LongWebviewScreenshot
//
//  Created by Geforceyu on 2018/9/11.
//  Copyright © 2018年 geforecyu. All rights reserved.
//

#import "UIFont+Category.h"

@implementation UIFont (Category)

+ (UIFont *)lightFontWithSize:(CGFloat)size
{
    if (@available(iOS 8.2, *)) {
        return [self systemFontOfSize:size weight:UIFontWeightLight];
    } else {
        return [self systemFontOfSize:size];
    }
}
+ (UIFont *)blodFontWithSize:(CGFloat)size
{
    if (@available(iOS 8.2, *)) {
        return [self systemFontOfSize:size weight:UIFontWeightBold];
    }else{
        return [self systemFontOfSize:size];
    }
}
@end
