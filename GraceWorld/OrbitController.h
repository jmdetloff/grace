//
//  OrbitController.h
//  GraceWorld
//
//  Created by John Detloff on 4/30/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrbitController : NSObject

@property (nonatomic, assign, readonly) CGFloat radius;


- (id)initWithOrbitRadius:(CGFloat)radius;


@end
