//
//  SignView.h
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/15.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SignViewStateTooClose,
    SignViewStateSuitable,
    SignViewStateTooFar,
} SignViewState;
@interface SignView : UIView

@property (nonatomic, assign)NSInteger distanceRate;
@property (nonatomic, strong)NSString *info;

@end

