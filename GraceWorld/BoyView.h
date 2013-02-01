//
//  BoyView.h
//  Grace
//
//  Created by John Detloff on 1/14/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMultiSpriteView.h"

typedef enum {
    BoyRunAnimation,
    BoyCrawlAnimation,
    BoyStandAnimation,
    BoyJumpUpAnimation,
    BoyJumpDownAnimation,
    BoyLandAnimation,
    BoyDropAnimation
} BoyAnimation;

typedef enum {
    MovingLeft,
    MovingRight,
    MovingUp,
    MovingDown,
    BoyCrawling,
    HorizontalStill,
    VerticalStill
} BoyMovementDirection;

@interface BoyView : GTMultiSpriteView
@property (nonatomic, assign) BOOL climbing;
- (void)addMovementState:(BoyMovementDirection)movementState;
@end
