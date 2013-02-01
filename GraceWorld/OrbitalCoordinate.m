//
//  OrbitalCoordinate.m
//  GraceWorld
//
//  Created by John Detloff on 4/27/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalCoordinate.h"

@implementation OrbitalCoordinate
- (id)initWithHeight:(CGFloat)height angle:(CGFloat)angle {
    self = [super init];
    if (self) {
        _height = height;
        _angle = angle;
    }
    return self;
}
@end
