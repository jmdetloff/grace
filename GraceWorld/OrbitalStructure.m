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


@interface OrbitalStructure () <OrbitalRectSensorDelegate>
@end


@implementation OrbitalStructure {
    NSMutableDictionary *_rectContactBlocks;
    NSMutableArray *_orbitalSurfaces;
    NSMutableArray *_sensorSurfaces;
    NSMutableArray *_orbitalRects;
}

@synthesize orbitalSurfaces = _orbitalSurfaces;

- (id)init {
    self = [super init];
    if (self) {
        _activated = YES;
        _rectContactBlocks = [[NSMutableDictionary alloc] init];
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


- (void)addOrbitalRect:(OrbitalRect *)rect withContactBlock:(void (^)(BOOL contact))contactBlock {
    rect.delegate = self;
    [_orbitalRects addObject:rect];
    
    void (^blockCopy)(BOOL) = [contactBlock copy];
    if (blockCopy) {
        [_rectContactBlocks setObject:blockCopy forKey:rect];
    }
}


#pragma mark -


- (void)orbitalRectContactedByBoy:(OrbitalRect *)rect {
    void (^contactBlock)(BOOL) = [_rectContactBlocks objectForKey:rect];
    if (contactBlock) {
        contactBlock(YES);
    }
}


- (void)orbitalRectEndedContactWithBoy:(OrbitalRect *)rect {
    void (^contactBlock)(BOOL) = [_rectContactBlocks objectForKey:rect];
    if (contactBlock) {
        contactBlock(NO);
    }
}


@end
