//
//  BoyView.m
//  Grace
//
//  Created by John Detloff on 1/14/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "BoyView.h"

@implementation BoyView {
    BoyMovementDirection _horizontalDirection;
    BoyMovementDirection _verticalDirection;
}

#define kLandTime 0.2
#define kDropTime 0.1

static NSString * const kClimbStillAnimationKey = @"kClimbStillAnimationKey";
static NSString * const kClimbUpAnimationKey = @"kClimbUpAnimationKey";
static NSString * const kClimbDownAnimationKey = @"kClimbDownAnimationKey";
static NSString * const kRunAnimationKey = @"gtBoyRunKey";
static NSString * const kStandAnimationKey = @"gtBoyStandKey";
static NSString * const kJumpUpAnimationKey = @"gtBoyJumpUpKey";
static NSString * const kJumpDownAnimationKey = @"gtBoyJumpDownKey";
static NSString * const kLandAnimationKey = @"gtBoyLandKey";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _horizontalDirection = HorizontalStill;
        _verticalDirection = VerticalStill;
        
        NSArray *runImages = @[[UIImage imageNamed:@"R-1.png"],
                                [UIImage imageNamed:@"R-2.png"],
                                [UIImage imageNamed:@"R-3.png"],
                                [UIImage imageNamed:@"R-4.png"],
                                [UIImage imageNamed:@"R-5.png"],
                                [UIImage imageNamed:@"R-6.png"],
                                [UIImage imageNamed:@"R-7.png"],
                                [UIImage imageNamed:@"R-8.png"],
                                [UIImage imageNamed:@"R-9.png"],
                                [UIImage imageNamed:@"R-10.png"]];

        NSArray *standImages = @[[UIImage imageNamed:@"S-1.png"],
                                [UIImage imageNamed:@"S-2.png"],
                                [UIImage imageNamed:@"S-3.png"],
                                [UIImage imageNamed:@"S-4.png"],
                                [UIImage imageNamed:@"S-5.png"],
                                [UIImage imageNamed:@"S-6.png"],
                                [UIImage imageNamed:@"S-7.png"],
                                [UIImage imageNamed:@"S-8.png"],
                                [UIImage imageNamed:@"S-9.png"]];
        
        NSArray *jumpUpImages = @[[UIImage imageNamed:@"jump_up.png"]];
        
        NSArray *jumpDownImages = @[[UIImage imageNamed:@"jump_down.png"]];
        
        NSArray *landImages = @[[UIImage imageNamed:@"LAND-1.png"],
                                [UIImage imageNamed:@"LAND-2.png"],
                                [UIImage imageNamed:@"LAND-3.png"],
                                [UIImage imageNamed:@"LAND-4.png"],
                                [UIImage imageNamed:@"LAND-5.png"]];
        
        NSArray *climbUpImages = @[
                                   [UIImage imageNamed:@"1.png"],
                                  [UIImage imageNamed:@"2.png"],
                                  [UIImage imageNamed:@"3.png"],
                                  [UIImage imageNamed:@"4.png"],
                                  [UIImage imageNamed:@"5.png"],
                                  [UIImage imageNamed:@"6.png"],
                                  [UIImage imageNamed:@"7.png"],
                                  [UIImage imageNamed:@"8.png"],
                                  [UIImage imageNamed:@"9.png"],
                                  [UIImage imageNamed:@"10.png"],
                                  [UIImage imageNamed:@"11.png"],
                                  [UIImage imageNamed:@"12.png"],
                                  [UIImage imageNamed:@"13.png"],
                                  [UIImage imageNamed:@"14.png"],
                                  [UIImage imageNamed:@"15.png"],
                                  [UIImage imageNamed:@"16.png"],
                                  [UIImage imageNamed:@"17.png"],
                                  [UIImage imageNamed:@"18.png"],
                                  [UIImage imageNamed:@"19.png"],
                                  [UIImage imageNamed:@"20.png"]
                                   ];

        NSArray *climbDownImages = @[
                                   [UIImage imageNamed:@"20.png"],
                                   [UIImage imageNamed:@"19.png"],
                                   [UIImage imageNamed:@"18.png"],
                                   [UIImage imageNamed:@"17.png"],
                                   [UIImage imageNamed:@"16.png"],
                                   [UIImage imageNamed:@"15.png"],
                                   [UIImage imageNamed:@"14.png"],
                                   [UIImage imageNamed:@"13.png"],
                                   [UIImage imageNamed:@"12.png"],
                                   [UIImage imageNamed:@"11.png"],
                                   [UIImage imageNamed:@"10.png"],
                                   [UIImage imageNamed:@"9.png"],
                                   [UIImage imageNamed:@"8.png"],
                                   [UIImage imageNamed:@"7.png"],
                                   [UIImage imageNamed:@"6.png"],
                                   [UIImage imageNamed:@"5.png"],
                                   [UIImage imageNamed:@"4.png"],
                                   [UIImage imageNamed:@"3.png"],
                                   [UIImage imageNamed:@"2.png"],
                                   [UIImage imageNamed:@"1.png"]
                                   ];
        
        NSArray *climbStillImages = @[
                                      [UIImage imageNamed:@"1"]
                                      ];
        
        [self setAnimation:climbUpImages duration:2 forKey:kClimbUpAnimationKey];
        [self setAnimation:climbDownImages duration:2 forKey:kClimbDownAnimationKey];
        [self setAnimation:climbStillImages duration:10 forKey:kClimbStillAnimationKey];
        [self setAnimation:runImages duration:1 forKey:kRunAnimationKey];
        [self setAnimation:standImages duration:1 forKey:kStandAnimationKey];
        [self setAnimation:jumpUpImages duration:0 forKey:kJumpUpAnimationKey];
        [self setAnimation:jumpDownImages duration:0 forKey:kJumpDownAnimationKey];
        [self setTransitionAnimation:landImages duration:0.2 fromKey:kJumpDownAnimationKey toKey:nil];
    }
    return self;
}


- (void)addMovementState:(BoyMovementDirection)movementState {
    if (movementState == _verticalDirection) return;
    
    switch (movementState) {
        case HorizontalStill:
            _horizontalDirection = movementState;
            if (_verticalDirection == VerticalStill && !_climbing) {
                [self setAnimationToAnimationWithKey:kStandAnimationKey];
            }
            break;
            
        case MovingLeft:
            self.transform = CGAffineTransformIdentity;
            _horizontalDirection = movementState;
            
            if (_verticalDirection == VerticalStill && !_climbing) {
                [self setAnimationToAnimationWithKey:kRunAnimationKey];
            }
            break;
            
        case MovingRight:
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
            _horizontalDirection = movementState;
            if (_verticalDirection == VerticalStill) {
                [self setAnimationToAnimationWithKey:kRunAnimationKey];
            }
            break;
            
        case MovingUp:
            _verticalDirection = movementState;
            [self setAnimationToAnimationWithKey:(_climbing ? kClimbUpAnimationKey : kJumpUpAnimationKey)];
            break;
            
        case MovingDown:
            _verticalDirection = movementState;
            [self setAnimationToAnimationWithKey:(_climbing ? kClimbDownAnimationKey : kJumpDownAnimationKey)];
            break;
            
        case VerticalStill: {
            _verticalDirection = movementState;
            if (_climbing) {
                [self setAnimationToAnimationWithKey:kClimbStillAnimationKey];
            }
            [self addMovementState:_horizontalDirection];
            break;
        }
            
        default:
            break;
    }
}


- (void)setClimbing:(BOOL)climbing {
    _climbing = climbing;
    if (_climbing) {
        [self setAnimationToAnimationWithKey:kClimbStillAnimationKey];
    }
}

@end
