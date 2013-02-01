//
//  OrbitalCoordinate.h
//  GraceWorld
//
//  Created by John Detloff on 4/27/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrbitalCoordinate : NSObject
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat angle;
- (id)initWithHeight:(CGFloat)height angle:(CGFloat)angle;
@end
