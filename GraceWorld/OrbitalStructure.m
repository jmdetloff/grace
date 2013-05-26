//
//  OrbitalStructure.m
//  GraceWorld
//
//  Created by John Detloff on 4/27/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalStructure.h"
#import "OrbitalSurface.h"
#import "OrbitalRect.h"


@implementation OrbitalStructure {
    NSMutableArray *_orbitalSurfaces;
    NSMutableArray *_sensorSurfaces;
    NSMutableArray *_orbitalRects;
}


- (id)init {
    self = [super init];
    if (self) {
        _activated = YES;
        _orbitalSurfaces = [[NSMutableArray alloc] init];
        _orbitalRects = [[NSMutableArray alloc] init];
        _sensorSurfaces = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -


- (void)setActivated:(BOOL)activated {
    if (_activated != activated) {
        _activated = activated;
        for (OrbitalSurface *surface in _orbitalSurfaces) {
            surface.activated = _activated;
        }
    }
}


- (void)addOrbitalSurfaces:(NSArray *)orbitalSurfaces {
    for (OrbitalSurface *surface in orbitalSurfaces) {
        surface.activated = _activated;
        [_orbitalSurfaces addObject:surface];
    }
}


- (void)addSensorSurface:(OrbitalSurface *)surface {
    [_sensorSurfaces addObject:surface];
}


- (void)addOrbitalRect:(OrbitalRect *)rect {
    [_orbitalRects addObject:rect];
}


@end
