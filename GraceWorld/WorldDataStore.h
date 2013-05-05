//
//  WorldDataStore.h
//  GraceWorld
//
//  Created by John Detloff on 2/20/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kShowCityInterior;

@interface RadialElement : NSObject
@property (nonatomic, strong) UIView *display;
@property (nonatomic, assign) CGFloat distanceFromWorldSurface;
@property (nonatomic, assign) CGFloat angle;
@end

@class OrbitalStructure;

@interface WorldDataStore : NSObject

@property (nonatomic, assign) BOOL onLadder;

+ (NSArray *)gamePropRadialObjects;
- (void)loadLevelData;
- (CGSize)worldSize;
- (CGPoint)worldRotationalCenter;
- (NSArray *)bridgeOrbitalCoordinates;
- (OrbitalStructure *)rampToCityInterior;
- (OrbitalStructure *)cityInterior;
- (RadialElement *)cityInteriorProp;

@end
