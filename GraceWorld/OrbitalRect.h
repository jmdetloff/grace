//
//  OrbitalRect.h
//  GraceWorld
//
//  Created by John Detloff on 4/30/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalElement.h"
#import <Foundation/Foundation.h>

@interface OrbitalRect : OrbitalElement

@property (nonatomic, strong, readonly) NSArray *vertices;
@property (nonatomic, strong) void (^sensorAction)(BOOL contact);

- (id)initWithVertices:(NSArray *)vertices;
- (void)boyBeganContact;
- (void)boyEndedContact;

@end
