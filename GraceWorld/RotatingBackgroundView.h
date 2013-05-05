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

- (void)shiftBy:(CGFloat)distance;
- (void)addWorldLayer:(UIImage *)worldLayerImage;
- (void)addProps:(NSArray *)props;

- (CGPoint)worldCenter;
- (CGPoint)worldSurface;

@end
