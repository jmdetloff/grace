//
//  OrbitalSensor.h
//  GraceWorld
//
//  Created by John Detloff on 5/25/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalElement.h"

@interface OrbitalSensor : OrbitalElement

@property (nonatomic, strong) void(^sensorAction)(BOOL colliding);

- (void)contactBegan:(b2Contact *)contact;
- (void)contactEnded:(b2Contact *)contact;

@end
