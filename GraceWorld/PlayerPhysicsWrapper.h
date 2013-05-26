//
//  PlayerPhysicsWrapper.h
//  GraceWorld
//
//  Created by John Detloff on 5/2/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalSensor.h"
#import <Foundation/Foundation.h>
#import "Box2D/Box2D.h"

typedef enum {
    PushedFromLeft,
    BlockedLeft,
    NotBlocked,
    BlockedRight,
    PushedFromRight
} RotationBlockState;

typedef enum {
    ContactLeft,
    ContactRight,
    NoContact
} ContactState;


@interface PlayerPhysicsWrapper : OrbitalSensor

@property (nonatomic, assign) b2Fixture *collidingFixture;
@property (nonatomic, assign) b2Fixture *sensorFixture;

- (RotationBlockState)rotationIsBlockedOrbitSpeed:(CGFloat)orbitSpeed;
- (BOOL)isStanding;

@end
