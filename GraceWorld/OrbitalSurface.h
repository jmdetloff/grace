//
//  OrbitalSurface.h
//  GraceWorld
//
//  Created by John Detloff on 4/27/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalSensor.h"
#import <Foundation/Foundation.h>
#import "Box2D/Box2D.h"

typedef enum {
    SurfaceUntouched,
    SurfaceLeft,
    SurfaceRight
} SurfaceRelativeDirection;

@class OrbitalCoordinate;

@interface OrbitalSurface : OrbitalSensor

@property (nonatomic, assign) BOOL activated;
@property (nonatomic, assign) BOOL isSensor;
@property (nonatomic, assign, readonly) BOOL allowsCollision;

@property (nonatomic, assign) BOOL moving;
@property (nonatomic, assign) BOOL fallThroughOnTap;
@property (nonatomic, assign) BOOL collideFromBelow;
@property (nonatomic, assign) CGFloat verticalVelocity;
@property (nonatomic, assign) CGFloat horizontalVelocity;
@property (nonatomic, strong) OrbitalCoordinate *coordA;
@property (nonatomic, strong) OrbitalCoordinate *coordB;

- (id)initWithCoordA:(OrbitalCoordinate *)coordA coordB:(OrbitalCoordinate *)coordB;
- (void)boyMadeContactOnSide:(SurfaceRelativeDirection)relativeDirection;

@end
