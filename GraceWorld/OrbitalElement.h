//
//  OrbitalElement.h
//  GraceWorld
//
//  Created by John Detloff on 5/25/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "Box2d/Box2d.h"
#import <Foundation/Foundation.h>

@class PlayerPhysicsWrapper;
@interface OrbitalElement : NSObject

@property (nonatomic, assign) b2Body *physicsBody;

- (BOOL)shouldCollidePlayer:(PlayerPhysicsWrapper *)boy withElement:(OrbitalElement *)element contact:(b2Contact *)contact;

@end