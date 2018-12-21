//
//  RootViewController.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/9/25.
//  Copyright © 2018年 Chonghua Yu. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "BaseNavigationController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    FAKIonIcons *eyeIcon = [FAKIonIcons iosEyeOutlineIconWithSize:33];

    HomeViewController *homevc = [[HomeViewController alloc] init];
    homevc.tabBarItem.title = Local(@"检测");
    homevc.tabBarItem.image = [eyeIcon imageWithSize:CGSizeMake(33, 33)];
    BaseNavigationController *homeNavc = [[BaseNavigationController alloc] initWithRootViewController:homevc];
    homeNavc.navigationBar.hidden = YES;
    
    FAKIonIcons *setIcon = [FAKIonIcons iosCogOutlineIconWithSize:33];
    SettingsViewController *setvc = [[SettingsViewController alloc] init];
    setvc.tabBarItem.title = Local(@"设置");
    setvc.tabBarItem.image = [setIcon imageWithSize:CGSizeMake(33, 33)];
    BaseNavigationController *setNavc = [[BaseNavigationController alloc] initWithRootViewController:setvc];
    
    self.tabBar.tintColor = [UIColor colorFromHexString:@"30848f"];
    [self setViewControllers:@[homeNavc,setNavc]];
}

@end
