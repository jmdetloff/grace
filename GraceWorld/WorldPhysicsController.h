//
//  WorldPhysicsController.h
//  Grace
//
//  Created by John Detloff on 1/20/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D/Box2D.h"

@protocol WorldPhysicsDelegate
- (void)addedB2FixtureToWorld:(b2Fixture *)fixture;
@end

@class OrbitalCoordinate;
@class OrbitalStructure;
@class PlayerPhysicsWrapper;

@interface WorldPhysicsController : NSObject

@property (nonatomic, weak) id<WorldPhysicsDelegate> delegate;
@property (nonatomic, assign) CGFloat orbitSpeed;

- (CGFloat)updatePhysics:(NSTimeInterval)timeSet;
- (PlayerPhysicsWrapper *)placePlayerBodyWithSize:(CGSize)size atOrbitHeight:(CGFloat)height;
- (void)placeOrbitalSurfaces:(NSArray *)surfaces;
- (void)placeOrbitalStructure:(OrbitalStructure *)orbitalStructure;

//- (b2Body *)createBodyForView:(UIView *)view ofType:(b2BodyType)type;
//- (b2Body *)createEdgeWidth:(CGFloat)width height:(CGFloat)height angle:(CGFloat)angle view:(UIView *)view;
//- (b2Body *)createBoyForView:(UIView *)boyView andGroundForView:(UIView *)groundView;
//- (void)addStaticBoxAtRect:(CGRect)rect;
//- (CGPoint)positionForBody:(b2Body *)body;
//- (b2Body *)createBodyAtRect:(CGRect)rect;


@end
