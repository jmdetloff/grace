//
//  PolygonView.m
//  GraceWorld
//
//  Created by John Detloff on 5/1/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "PolygonView.h"

@implementation PolygonView {
    NSArray *_points;
}

- (id)initWithFrame:(CGRect)frame points:(NSArray *)points {
    self = [super initWithFrame:frame];
    if (self) {
        _points = points;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, _color.CGColor);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 4;

    CGPoint firstPoint = [_points[0] CGPointValue];
    [path moveToPoint:firstPoint];
    
    for (int i = 1; i < [_points count]; i++) {
        CGPoint point = [_points[i] CGPointValue];
        [path addLineToPoint:point];
    }
    
    [path addLineToPoint:firstPoint];
    [path fill];
}


@end
