//
//  OrbitalSurface.m
//  GraceWorld
//
//  Created by John Detloff on 4/27/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalSurface.h"
#import "OrbitalCoordinate.h"

@implementation OrbitalSurface {
    SurfaceRelativeDirection _lastContactDirection;
}


- (id)initWithCoordA:(OrbitalCoordinate *)coordA coordB:(OrbitalCoordinate *)coordB {
    self = [super init];
    if (self) {
        _coordA = coordA;
        _coordB = coordB;
        _lastContactDirection = SurfaceUntouched;
        _collideFromBelow = YES;
        _activated = YES;
    }
    return self;
}


#pragma mark -


- (BOOL)allowsCollision {
    return _activated && !_isSensor;
}


#pragma mark -


- (void)contactBegan:(b2Contact *)contact {
    // NO-op
}


- (void)contactEnded:(b2Contact *)contact {
    if (!_isSensor) return;
    
    _lastContactDirection = SurfaceUntouched;
}


- (void)boyMadeContactOnSide:(SurfaceRelativeDirection)relativeDirection {
    if (!_isSensor) return;
    
    if ((relativeDirection == SurfaceLeft && _lastContactDirection == SurfaceRight) || (relativeDirection == SurfaceRight && _lastContactDirection == SurfaceLeft)) {
        self.sensorAction(YES);
    }
    
    _lastContactDirection = relativeDirection;
}

@end
