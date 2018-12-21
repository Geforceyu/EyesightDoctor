//
//  AppDelegate.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/9/25.
//  Copyright © 2018年 Chonghua Yu. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+IFly.h"
#import "RootViewController.h"
#import "TestResultsViewController.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UserNotifications/UserNotifications.h>
#import "IAPManager.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[RootViewController alloc] init];
//    self.window.rootViewController = [[TestResultsViewController alloc] init];
    [self.window makeKeyAndVisible];
//    [self configIFly];
    [self umengSharedConfig];
    [self configLocalNotification];
    return YES;
}
- (void)umengSharedConfig
{
#ifdef DEBUG
    [[UMSocialManager defaultManager] openLog:YES];
#endif
    [UMConfigure initWithAppkey:@"5b987f6da40fa3508800000d" channel:@"AppStore"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx205ef781ae8313fe" appSecret:@"9308f4cb23f66c3c72fd8e92320014f8" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101505794" appSecret:@"0b9c4b0cc56a444c1a65230d7df2d7e0" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1199393075" appSecret:@"13449597a10605f701a6f7685c04f50e" redirectURL:@"http://mobile.umeng.com/social"];
    
}
- (void)configLocalNotification
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:4];
    
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = 60*60*24*3;
    notification.alertBody =  Local(@"快来测测您现在的视力值如何了");
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
