//
//  OrbitalRect.m
//  GraceWorld
//
//  Created by John Detloff on 4/30/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalRect.h"
#import "OrbitalCoordinate.h"

@implementation OrbitalRect


- (id)initWithVertices:(NSArray *)vertices {
    self = [super init];
    if (self) {
        _vertices = vertices;
    }
    return self;
}


@end
