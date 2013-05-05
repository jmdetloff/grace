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
    if ((relativeDirection == SurfaceLeft && _lastContactDirection == SurfaceRight) || (relativeDirection == SurfaceRight && _lastContactDirection == SurfaceLeft)) {
        [self.delegate orbitalSurfaceCrossedByBoy:self];
    }
    
    _lastContactDirection = relativeDirection;
}

- (void)boyEndedContact {
    _lastContactDirection = SurfaceUntouched;
}


#pragma mark -


- (id)copyWithZone:(NSZone *)zone {
    OrbitalSurface *surface = [[OrbitalSurface allocWithZone:zone] initWithCoordA:_coordA coordB:_coordB];
    return surface;
}


- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[OrbitalSurface class]]) {
        OrbitalSurface *surface = object;
        return surface.coordA == _coordA && surface.coordB == _coordB;
    }
    return NO;
}


- (NSUInteger)hash {
    return [_coordA height] + [_coordA angle]*10 + [_coordB height]*100 + [_coordB angle]*1000;
}

@end
