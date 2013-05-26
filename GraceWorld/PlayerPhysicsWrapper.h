//
//  PlayerPhysicsWrapper.h
//  GraceWorld
//
//  Created by John Detloff on 5/2/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalElement.h"
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


@interface PlayerPhysicsWrapper : OrbitalElement

@property (nonatomic, assign) b2Fixture *collidingFixture;
@property (nonatomic, assign) b2Fixture *sensorFixture;

- (RotationBlockState)rotationIsBlockedOrbitSpeed:(CGFloat)orbitSpeed;
- (void)beginContact:(b2Contact *)contact;
- (void)endContact:(b2Contact *)contact;
- (BOOL)isStanding;

@end
