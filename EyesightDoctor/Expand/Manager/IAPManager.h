//
//  IAPManager.h
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/23.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IAPManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,copy)void(^completion)(BOOL success);

- (void)startBuy;
- (void)restoreWithComplete:(void(^)(BOOL success))complete;

@end

