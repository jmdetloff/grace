//
//  PolygonView.h
//  GraceWorld
//
//  Created by John Detloff on 5/1/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolygonView : UIView
@property (nonatomic, assign) UIColor *color;

- (id)initWithFrame:(CGRect)frame points:(NSArray *)points;

@end
