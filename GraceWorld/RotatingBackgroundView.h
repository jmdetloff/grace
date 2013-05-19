//
//  RotatingBackgroundView.h
//  Grace World
//
//  Created by John Detloff on 1/28/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotatingBackgroundView : UIView

@property (nonatomic, assign,readonly) CGFloat angle;
@property (nonatomic, strong, readonly) UIView *rotatingImageView;

- (void)shiftBy:(CGFloat)distance;
- (void)setRotatingImage:(UIImage *)image withRotationalCenter:(CGPoint)center;
- (void)addProps:(NSArray *)props;

@end
