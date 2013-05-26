//
//  OrbitalSensor.m
//  GraceWorld
//
//  Created by John Detloff on 5/25/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalSensor.h"

@implementation OrbitalSensor


- (void)contactBegan:(b2Contact *)contact {
    _sensorAction(YES);
}


- (void)contactEnded:(b2Contact *)contact {
    _sensorAction(NO);
}


@end
