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


#pragma mark -


- (void)boyBeganContact {
    [self.delegate orbitalRectContactedByBoy:self];
}


- (void)boyEndedContact {
    [self.delegate orbitalRectEndedContactWithBoy:self];
}


#pragma mark -

- (id)copyWithZone:(NSZone *)zone {
    OrbitalRect *rect = [[OrbitalRect allocWithZone:zone] initWithVertices:_vertices];
    return rect;
}


- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[OrbitalRect class]]) {
        OrbitalRect *rect = object;
        return rect.vertices == _vertices;
    }
    return NO;
}


- (NSUInteger)hash {
    return [_vertices[0] height] + [_vertices[0] angle]*5 + [_vertices[1] height]*25 + [_vertices[1] angle]*125 + [_vertices[2] height]*625 + [_vertices[2] angle]*3125 + [_vertices[3] height]*15625 + [_vertices[3] angle]*78125;
}

@end
