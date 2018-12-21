//
//  TestedHistoryView.h
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/10/12.
//  Copyright © 2018 Chonghua Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestedHistoryViewDelegate <NSObject>

- (void)historyViewDidClikedMoreButton;

@end

@interface TestedHistoryView : UIView

@property (nonatomic, assign)id<TestedHistoryViewDelegate> delegate;

@end

