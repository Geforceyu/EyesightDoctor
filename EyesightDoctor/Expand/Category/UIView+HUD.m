//
//  UIView+HUD.m
//  LongWebviewScreenshot
//
//  Created by Geforceyu on 2018/9/7.
//  Copyright © 2018年 geforecyu. All rights reserved.
//

#import "UIView+HUD.h"

@implementation UIView (HUD)

- (void)showSuccessToast:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = text;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    FAKIonIcons *icons = [FAKIonIcons checkmarkCircledIconWithSize:37];
    [icons addAttribute:NSForegroundColorAttributeName value:[UIColor successColor]];
    imageView.image = [icons imageWithSize:CGSizeMake(37, 37)];
    hud.customView = imageView;
    
    [hud hideAnimated:YES afterDelay:2.0];
}
- (void)showErrorToast:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = text;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    FAKIonIcons *icons = [FAKIonIcons alertIconWithSize:37];
    [icons addAttribute:NSForegroundColorAttributeName value:[UIColor warningColor]];
    imageView.image = [icons imageWithSize:CGSizeMake(37, 37)];
    hud.customView = imageView;
    
    [hud hideAnimated:YES afterDelay:2.0];
}
- (MBProgressHUD *)showLoadingWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    if (text&&text.length>0) {
//        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    return hud;
}
- (void)dismissHUD
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [MBProgressHUD hideHUDForView:self animated:YES];
}
- (void)showLoadingWithText:(NSString *)text delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    if (text&&text.length>0) {
        //        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
    }
    [hud hideAnimated:YES afterDelay:delay];
}
@end
