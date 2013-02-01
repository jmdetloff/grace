//
//  GraceWorldView.m
//  Grace World
//
//  Created by John Detloff on 1/28/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "GraceWorldView.h"
#import "RadialObjectStore.h"
#import <QuartzCore/QuartzCore.h>

#define kSurfaceHeight 265
#define kDistanceToCenterFromSurface 1161

@implementation GraceWorldView {
    NSMutableArray *_layers;
    CGFloat _radianRotation;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _layers = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = NO;
        
        self.layer.anchorPoint = CGPointMake(0.504, 0.435);
    }
    return self;
}


- (void)shiftBy:(CGFloat)distance {
    self.transform = CGAffineTransformRotate(self.transform, distance);
//    NSLog(@"%f" ,atan2(self.transform.b, self.transform.a) + M_PI/2);
}


- (CGFloat)angle {
    return atan2(self.transform.b, self.transform.a) + M_PI/2;
}


- (void)addWorldLayer:(UIImage *)worldLayerImage {
    UIImageView *layer = [[UIImageView alloc] initWithImage:worldLayerImage];
    layer.frame = self.bounds;
    [self addSubview:layer];
    [_layers addObject:layer];
}


- (void)addProps:(NSArray *)props {
    
    for (RadialElement *prop in props) {
        UIView *display = prop.display;
        
        CGFloat anchorPointY = ([self bounds].size.height*self.layer.anchorPoint.y - kSurfaceHeight - prop.distanceFromWorldSurface)/display.frame.size.height;
        display.layer.anchorPoint = CGPointMake(0.5, anchorPointY);
        display.center = CGPointMake([self bounds].size.width*self.layer.anchorPoint.x, [self bounds].size.height*self.layer.anchorPoint.y);
        display.transform = CGAffineTransformMakeRotation(-(prop.angle - M_PI/2));
        [self addSubview:display];
    }
    
}


- (CGPoint)worldCenter {
    return CGPointMake([self bounds].size.width*self.layer.anchorPoint.x, [self bounds].size.height*self.layer.anchorPoint.y);
}


- (CGPoint)worldSurface {
    CGPoint center = [self worldCenter];
    center.y -= kDistanceToCenterFromSurface;
    return center;
}


@end
