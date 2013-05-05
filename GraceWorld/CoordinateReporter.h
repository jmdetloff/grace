//
//  CoordinateReporter.h
//  GraceWorld
//
//  Created by John Detloff on 5/4/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoordinateReporterDelegate <NSObject>
- (NSDictionary *)attributesToReportForCoordinate:(CGPoint)coordinate;
@end

@interface CoordinateReporter : UIView
@property (nonatomic, weak) id<CoordinateReporterDelegate>delegate;

- (void)clear;
- (void)print;

@end
