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

@property (nonatomic, strong, readonly) NSArray *orbitalSurfaces;
@property (nonatomic, strong, readonly) NSArray *orbitalRects;

- (void)addOrbitalSurfaces:(NSArray *)orbitalSurfaces;
- (void)addOrbitalSurface:(OrbitalSurface *)surface withCrossBlock:(void (^)())crossBlock;
- (void)addOrbitalRect:(OrbitalRect *)rect withContactBlock:(void (^)(BOOL contact))contactBlock;

@end
