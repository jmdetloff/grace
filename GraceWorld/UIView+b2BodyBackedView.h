//
//  UIView+b2BodyBackedView.h
//  GraceWorld
//
//  Created by John Detloff on 4/21/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Box2D/Box2D.h"

@class DiagonalView;

@interface UIView (b2BodyBackedView)

- (id)initWithb2Fixture:(b2Fixture *)fixture orbitsToPixelsRatio:(CGFloat)orbitsToPixelsRatio;

- (void)setPhysicsFixture:(b2Fixture *)fixture;
- (b2Fixture *)physicsFixture;
- (void)setBodyOffset:(CGPoint)bodyOffset;
- (CGPoint)bodyOffset;
- (DiagonalView *)surfaceView;

@end
