//
//  OrbitalElement.m
//  GraceWorld
//
//  Created by John Detloff on 5/25/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalElement.h"

@implementation OrbitalElement

- (BOOL)shouldCollidePlayer:(PlayerPhysicsWrapper *)boy withElement:(OrbitalElement *)element contact:(b2Contact *)contact {
    return YES;
}

@end
