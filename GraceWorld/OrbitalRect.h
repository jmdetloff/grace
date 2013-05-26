//
//  OrbitalRect.h
//  GraceWorld
//
//  Created by John Detloff on 4/30/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalSensor.h"
#import <Foundation/Foundation.h>

@interface OrbitalRect : OrbitalSensor

@property (nonatomic, strong, readonly) NSArray *vertices;

- (id)initWithVertices:(NSArray *)vertices;

@end
