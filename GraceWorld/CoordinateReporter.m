//
//  CoordinateReporter.m
//  GraceWorld
//
//  Created by John Detloff on 5/4/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "CoordinateReporter.h"

@implementation CoordinateReporter {
    NSMutableString *_coordinatesString;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_coordinatesString) {
        _coordinatesString = [@"" mutableCopy];
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSDictionary *propertyDict = [self.delegate attributesToReportForCoordinate:point];
    
    NSMutableString *reportString = [@"{" mutableCopy];
    
    [propertyDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyString = (NSString *)key;
        NSNumber *val = (NSNumber *)obj;
        [reportString appendFormat:@"\"%@\":%.2f,",keyString,[val floatValue]];
    }];
    [reportString replaceCharactersInRange:NSMakeRange([reportString length]-1, 1) withString:@""];
    [reportString appendString:@"}"];
    
    [_coordinatesString appendFormat:@"%@,\n",reportString];
}


- (void)clear {
    _coordinatesString = nil;
}


- (void)print {
    NSLog(@"%@",_coordinatesString);
}


@end
