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


- (void)updatePhysics {
    if (_physicsBody) {
        // set any necessary physics attributes
    }
}


- (void)setPhysicsBody:(b2Body *)physicsBody {
    _physicsBody = physicsBody;
    
    [self updatePhysics];
}


#pragma mark -


- (void)boyMadeContactOnSide:(SurfaceRelativeDirection)relativeDirection {
    if (!_isSensor) return;
    
    if ((relativeDirection == SurfaceLeft && _lastContactDirection == SurfaceRight) || (relativeDirection == SurfaceRight && _lastContactDirection == SurfaceLeft)) {
        if (_sensorAction) {
            _sensorAction();
        }
    }
    
    _lastContactDirection = relativeDirection;
}

- (void)boyEndedContact {
    if (!_isSensor) return;
    
    _lastContactDirection = SurfaceUntouched;
}

@end
