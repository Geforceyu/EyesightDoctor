//
//  EView.h
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/16.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EView : UIView

@property (nonatomic, assign)float scale;
@property (nonatomic, assign)UISwipeGestureRecognizerDirection direction;

- (void)setScale:(float)scale andDirection:(UISwipeGestureRecognizerDirection)direction;
@end

@interface EViewStro : UIView

@end
