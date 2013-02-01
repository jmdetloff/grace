//
//  RunJumpCrawlEventView.m
//  Grace World
//
//  Created by John Detloff on 1/28/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "RunJumpCrawlEventView.h"
#include <objc/runtime.h>

#define kSwipeWidth 50
#define kSwipeHeight 120

static const char* kGTUITouchOriginalLocation = "kGTUITouchOriginalLocation";

@interface UITouch (OriginalLocation)
@property (nonatomic, assign) CGPoint originalLocation;
@end

@implementation UITouch (OriginalLocation)

- (CGPoint)originalLocation {
    NSValue *pointVal = (NSValue *)objc_getAssociatedObject(self, kGTUITouchOriginalLocation);
    return [pointVal CGPointValue];
}

- (void)setOriginalLocation:(CGPoint)originalLocation {
    NSValue *pointVal = [NSValue valueWithCGPoint:originalLocation];
    objc_setAssociatedObject(self, kGTUITouchOriginalLocation, pointVal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@interface RunJumpCrawlEventView () <UIGestureRecognizerDelegate>
@property (nonatomic, assign, readwrite) MovementControlState movementState;
@end


@implementation RunJumpCrawlEventView {
    UITouch *_horizontalMovementTouch;
    UITouch *_swipeTouch;
    
    NSMutableArray *_potentialMovementTouches;
    NSMutableArray *_potentialSwipeTouches;
    
    NSUInteger _movementMask;
    UISwipeGestureRecognizer *_upGestureRecognizer;
    UISwipeGestureRecognizer *_downGestureRecognizer;
    BOOL _cancelDelayedTap;
}


- (id)initWithFrame:(CGRect)frame touchWidth:(CGFloat)touchWidth {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _touchWidth = touchWidth;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        _potentialSwipeTouches = [[NSMutableArray alloc] init];
        _potentialMovementTouches = [[NSMutableArray alloc] init];
        
        [self setMultipleTouchEnabled:YES];
    }
    return self;
}


#pragma mark - Touch handling


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        CGPoint loc = [touch locationInView:self];
        [touch setOriginalLocation:loc];
        
        [_potentialMovementTouches addObject:touch];
        [_potentialSwipeTouches addObject:touch];
        
        double delayInSeconds = 0.15;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self attemptToMoveHorizontallyWithTouch:touch];
        });
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        CGPoint loc = [touch locationInView:self];
        
        if ([self horizontalMovementForPoint:loc] == 0) {
            if (_horizontalMovementTouch == touch) {
                [self resetHorizontalState];
            }
            if ([_potentialMovementTouches containsObject:touch]) {
                [_potentialMovementTouches removeObject:touch];
            }
        }
        
        CGPoint originalPoint = [touch originalLocation];
        if ([_potentialSwipeTouches containsObject:touch]) {
            if (fabs(loc.x-originalPoint.x) > kSwipeWidth) {
                [_potentialSwipeTouches removeObject:touch];
            } else if (originalPoint.y - loc.y > kSwipeHeight) {
                [_potentialMovementTouches removeObject:touch];
                [_potentialSwipeTouches removeObject:touch];
                [self addMovementStateMask:Up];
                if (!_handleUpAsContinuous) {
                    self.movementState = ((MovementControlState)(self.movementState & ~Up));
                } else {
                    _swipeTouch = touch;
                }
            } else if (loc.y - originalPoint.y > kSwipeHeight) {
                [_potentialMovementTouches removeObject:touch];
                [_potentialSwipeTouches removeObject:touch];
                [self addMovementStateMask:Down];
                if (!_handleUpAsContinuous) {
                    self.movementState = ((MovementControlState)(self.movementState & ~Down));
                } else {
                    _swipeTouch = touch;
                }
            }
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        [_potentialSwipeTouches removeObject:touch];
        [_potentialMovementTouches removeObject:touch];
        
        if (_horizontalMovementTouch == touch) {
            [self resetHorizontalState];
        }
        
        if (touch == _swipeTouch) {
            [self resetVerticalState];
        }
    }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        [_potentialSwipeTouches removeObject:touch];
        [_potentialMovementTouches removeObject:touch];
        
        if (_horizontalMovementTouch == touch) {
            [self resetHorizontalState];
        }
        
        if (_handleUpAsContinuous && touch == _swipeTouch) {
            [self resetVerticalState];
        }
    }
}


- (void)addMovementStateMask:(MovementControlState)state {
    MovementControlState currentState = self.movementState;
    switch (state) {
        case Left:
            currentState = (MovementControlState)(currentState & ~Right);
            currentState = (MovementControlState)(currentState | state);
            break;
            
        case Right:
            currentState = (MovementControlState)(currentState & ~Left);
            currentState = (MovementControlState)(currentState | state);
            break;
            
        case Up:
            if ((currentState & Down) == Down) {
                currentState = (MovementControlState)(currentState & ~Down);
            } else {
                currentState = (MovementControlState)(currentState | state);
            }
            break;
            
        case Down:
            if ((currentState & Up) == Up) {
                currentState = (MovementControlState)(currentState & ~Up);
            } else {
                currentState = (MovementControlState)(currentState | state);
            }
            break;
            
        default:
            break;
    }
    self.movementState = currentState;
}


- (void)resetHorizontalState {
    MovementControlState currentState = self.movementState;
    currentState = (MovementControlState)(currentState & ~Left);
    currentState = (MovementControlState)(currentState & ~Right);
    self.movementState = currentState;
}


- (void)resetVerticalState {
    MovementControlState currentState = self.movementState;
    currentState = (MovementControlState)(currentState & ~Up);
    currentState = (MovementControlState)(currentState & ~Down);
    self.movementState = currentState;
}


- (void)setMovementState:(MovementControlState)movementState {
    if (_movementState != movementState) {
        _movementState = movementState;
        [self.delegate movementStateChanged:movementState];
    }
}


- (BOOL)movingHorizontally {
    return ((self.movementState & Left) == Left || (self.movementState & Right) == Right);
}


- (MovementControlState)horizontalMovementForPoint:(CGPoint)point {
    if (point.x <= _touchWidth) {
        return Left;
    } else if (point.x >= self.bounds.size.width - _touchWidth) {
        return Right;
    } else {
        return NoControl;
    }
}


- (void)attemptToMoveHorizontallyWithTouch:(UITouch *)touch {
    if (![_potentialMovementTouches containsObject:touch]) return;
    
    CGPoint loc = [touch locationInView:self];
    MovementControlState state = [self horizontalMovementForPoint:loc];
    if (state == Left || state == Right) {
        _horizontalMovementTouch = touch;
        [_potentialSwipeTouches removeObject:touch];
        [self addMovementStateMask:state];
    }
}


@end
