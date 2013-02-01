//
//  OrbitalRect.h
//  GraceWorld
//
//  Created by John Detloff on 4/30/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrbitalRect;
@protocol OrbitalRectSensorDelegate <NSObject>
- (void)orbitalRectContactedByBoy:(OrbitalRect *)rect;
- (void)orbitalRectEndedContactWithBoy:(OrbitalRect *)rect;
@end


@interface OrbitalRect : NSObject <NSCopying>
@property (nonatomic, strong, readonly) NSArray *vertices;
@property (nonatomic, weak) id<OrbitalRectSensorDelegate> delegate;

- (id)initWithVertices:(NSArray *)vertices;
- (void)boyBeganContact;
- (void)boyEndedContact;

@end
