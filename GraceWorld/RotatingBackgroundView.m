//
//  RotatingBackgroundView.m
//  Grace World
//
//  Created by John Detloff on 1/28/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "RotatingBackgroundView.h"
#import "WorldDataStore.h"
#import "OrbitalCoordinate.h"
#import <QuartzCore/QuartzCore.h>

@implementation RotatingBackgroundView {
    CGPoint _rotationalCenter;
}


- (void)shiftBy:(CGFloat)distance {
    _rotatingImageView.transform = CGAffineTransformRotate(_rotatingImageView.transform, distance);
}


- (CGFloat)angle {
    return atan2(_rotatingImageView.transform.b, _rotatingImageView.transform.a) + M_PI/2;
}


- (void)setRotatingImage:(UIImage *)image withRotationalCenter:(CGPoint)center {
    _rotationalCenter = center;
    
    CGRect bounds = self.bounds;
    
    UIImageView *layer = [[UIImageView alloc] initWithImage:image];
    layer.frame = bounds;
    [self addSubview:layer];
    
    _rotatingImageView = layer;
    _rotatingImageView.layer.anchorPoint = CGPointMake(center.x / bounds.size.width, center.y / bounds.size.height);
}


- (void)addProps:(NSArray *)props {
    for (RadialElement *prop in props) {
        UIView *display = prop.display;
        
        CGFloat anchorPointY = (prop.coordinate.height)/display.frame.size.height;
        display.layer.anchorPoint = CGPointMake(0.5, anchorPointY);
        display.center = _rotationalCenter;
        display.transform = CGAffineTransformMakeRotation(-(prop.coordinate.angle - M_PI/2));
        [_rotatingImageView addSubview:display];
    }
    
}


@end
