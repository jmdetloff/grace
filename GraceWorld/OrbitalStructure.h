//
//  OrbitalStructure.h
//  GraceWorld
//
//  Created by John Detloff on 4/27/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrbitalSurface;
@class OrbitalRect;

@interface OrbitalStructure : NSObject

@property (nonatomic, assign) BOOL activated;
@property (nonatomic, strong, readonly) NSArray *orbitalSurfaces;
@property (nonatomic, strong, readonly) NSArray *sensorSurfaces;
@property (nonatomic, strong, readonly) NSArray *orbitalRects;

- (void)addOrbitalSurfaces:(NSArray *)orbitalSurfaces;
- (void)addSensorSurface:(OrbitalSurface *)surface;
- (void)addOrbitalRect:(OrbitalRect *)rect;

@end
