//
//  PlayerPhysicsWrapper.h
//  GraceWorld
//
//  Created by John Detloff on 5/2/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

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


@interface PlayerPhysicsWrapper : NSObject

@property (nonatomic, assign) b2Body *playerBody;
@property (nonatomic, assign) b2Fixture *collidingFixture;
@property (nonatomic, assign) b2Fixture *sensorFixture;

- (id)initWithb2Body:(b2Body *)body;
- (RotationBlockState)rotationIsBlockedOrbitSpeed:(CGFloat)orbitSpeed;
- (void)beginContact:(b2Contact *)contact;
- (void)endContact:(b2Contact *)contact;
- (BOOL)isStanding;

@end
