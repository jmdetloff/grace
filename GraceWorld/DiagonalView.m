//
//  DiagonalView.m
//  GraceWorld
//
//  Created by John Detloff on 3/29/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "DiagonalView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DiagonalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}


- (void)setPositive:(BOOL)positive {
    _positive = positive;
    
    [self setNeedsDisplay];
}


- (void)setLineColor:(UIColor *)lineColor {
    if (lineColor != _lineColor) {
        _lineColor = lineColor;
        [self setNeedsDisplay];
    }
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [_lineColor colorWithAlphaComponent:0.7].CGColor);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 4;
    if (_positive) {
        [path moveToPoint:CGPointMake(0, self.frame.size.height)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    } else {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    }
    [path stroke];
}


@end
