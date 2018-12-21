//
//  AppDelegate+IFly.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/9/26.
//  Copyright © 2018年 Chonghua Yu. All rights reserved.
//

#import "AppDelegate+IFly.h"
#import "iflyMSC/IFlyFaceSDK.h"


@implementation AppDelegate (IFly)

- (void)configIFly
{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"5baa06a3"];
    [IFlySpeechUtility createUtility:initString];
}
@end
