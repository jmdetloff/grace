//
//  OrbitalRect.h
//  GraceWorld
//
//  Created by John Detloff on 4/30/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalElement.h"
#import <Foundation/Foundation.h>

@class OrbitalRect;
@protocol OrbitalRectSensorDelegate <NSObject>
- (void)orbitalRectContactedByBoy:(OrbitalRect *)rect;
- (void)orbitalRectEndedContactWithBoy:(OrbitalRect *)rect;
@end


@interface OrbitalRect : OrbitalElement <NSCopying>
@property (nonatomic, strong, readonly) NSArray *vertices;
@property (nonatomic, weak) id<OrbitalRectSensorDelegate> delegate;

- (id)initWithVertices:(NSArray *)vertices;
- (void)boyBeganContact;
- (void)boyEndedContact;

@end
