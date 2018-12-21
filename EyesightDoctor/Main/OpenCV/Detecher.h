//
//  Detecher.h
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/9/27.
//  Copyright © 2018年 Chonghua Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DetecherDelegate <NSObject>

@required
- (void)didnotDetechFace;
- (void)didDetechMultiFace;
- (void)didDetechFaceRect:(CGRect)rect;
- (void)didDetechHasGlasses:(BOOL)has;
- (void)didDetechLeftEyeState:(int)state;
- (void)didDetechRightEyeState:(int)state;
- (void)didDetechNoseRect:(CGRect)rect;
@end

@interface Detecher : NSObject

@property (nonatomic, assign)id<DetecherDelegate> delegate;

- (void)startDetecherWithView:(UIView *)view;
- (void)stop;
@end
