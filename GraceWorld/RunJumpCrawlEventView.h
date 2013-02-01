//
//  RunJumpCrawlEventView.h
//  Grace World
//
//  Created by John Detloff on 1/28/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NoControl = 0,
    Left    = 1 << 0,
    Right   = 1 << 1,
    Up      = 1 << 2,
    Down    = 1 << 3,
} MovementControlState;


@protocol RunJumpCrawlDelegate <NSObject>
- (void)movementStateChanged:(MovementControlState)movementState;
@end


@interface RunJumpCrawlEventView : UIView

@property (nonatomic, weak) id<RunJumpCrawlDelegate> delegate;
@property (nonatomic, assign, readonly) CGFloat touchWidth;
@property (nonatomic, assign, readonly) MovementControlState movementState;
@property (nonatomic, assign) BOOL handleUpAsContinuous;

- (id)initWithFrame:(CGRect)frame touchWidth:(CGFloat)touchWidth;

@end
