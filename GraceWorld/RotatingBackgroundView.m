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


- (void)setRotatingImage:(UIImage *)image size:(CGSize)imageSize anchorPoint:(CGPoint)anchorPoint position:(CGPoint)position {
    _rotationalCenter = anchorPoint;
    
    UIImageView *layer = [[UIImageView alloc] initWithImage:image];
    layer.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    layer.center = position;
    [self addSubview:layer];
    
    _rotatingImageView = layer;
    _rotatingImageView.layer.anchorPoint = CGPointMake(anchorPoint.x / imageSize.width, anchorPoint.y / imageSize.height);
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
