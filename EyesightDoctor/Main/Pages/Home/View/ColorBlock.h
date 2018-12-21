//
//  ColorBlock.h
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/12.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorBlockDelegate <NSObject>
- (void)colorBlockDidClikedStartButton;
@end

@interface ColorBlock : UIControl

@property (nonatomic, assign)id<ColorBlockDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title colors:(NSArray *)colors;

@end

