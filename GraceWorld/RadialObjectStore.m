//
//  RadialObjectStore.m
//  GraceWorld
//
//  Created by John Detloff on 2/20/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "NPCCreator.h"
#import "RadialObjectStore.h"
#import "WorldPhysicsController.h"
#import "OrbitalCoordinate.h"
#import "OrbitalSurface.h"
#import "OrbitalStructure.h"
#import "OrbitalRect.h"

NSString *const kShowCityInterior = @"kShowCityInterior";

@implementation RadialElement
@end

@implementation RadialObjectStore {
    OrbitalStructure *_bridgeStructure;
    OrbitalStructure *_rampToCityInterior;
    OrbitalStructure *_cityInterior;
    
    RadialElement *_cityInteriorProp;
    
    BOOL _cityLadderEnabled;
    int _onCityLadder;
}


+ (NSArray *)gamePropRadialObjects {
    NSMutableArray *props = [[NSMutableArray alloc] init];
    
    RadialElement *artist = [[RadialElement alloc] init];
    artist.display = [NPCCreator spriteForNPC:Artist];
    artist.distanceFromWorldSurface = -artist.display.frame.size.height;
    artist.angle = 2.807;
    [props addObject:artist];
    
    RadialElement *businessMan = [[RadialElement alloc] init];
    businessMan.display = [NPCCreator spriteForNPC:BusinessMan];
    businessMan.distanceFromWorldSurface = -businessMan.display.frame.size.height;
    businessMan.angle = 2.448;
    [props addObject:businessMan];
    
    RadialElement *bigGuy = [[RadialElement alloc] init];
    bigGuy.display = [NPCCreator spriteForNPC:BigGuy];
    bigGuy.distanceFromWorldSurface = -bigGuy.display.frame.size.height;
    bigGuy.angle = 2.582;
    [props addObject:bigGuy];
    
    RadialElement *lady = [[RadialElement alloc] init];
    lady.display = [NPCCreator spriteForNPC:Lady];
    lady.distanceFromWorldSurface = -lady.display.frame.size.height;
    lady.angle = 2.891;
    [props addObject:lady];
    
    RadialElement *homeless = [[RadialElement alloc] init];
    homeless.display = [NPCCreator spriteForNPC:HomelessGuy];
    homeless.distanceFromWorldSurface = - (homeless.display.frame.size.height - 15);
    homeless.angle = 3.016;
    [props addObject:homeless];
    
    RadialElement *granny = [[RadialElement alloc] init];
    granny.display = [NPCCreator spriteForNPC:Granny];
    granny.distanceFromWorldSurface = -(granny.display.frame.size.height-32);
    granny.angle = 3.125;
    [props addObject:granny];
    
    RadialElement *sweeper = [[RadialElement alloc] init];
    sweeper.display = [NPCCreator spriteForNPC:Sweeper];
    sweeper.distanceFromWorldSurface = -(sweeper.display.frame.size.height - 5);
    sweeper.angle = 3.302;
    [props addObject:sweeper];
    
    RadialElement *guitarGuy = [[RadialElement alloc] init];
    guitarGuy.display = [NPCCreator spriteForNPC:GuitarGuy];
    guitarGuy.distanceFromWorldSurface = -guitarGuy.display.frame.size.height;
    guitarGuy.angle = 3.589;
    [props addObject:guitarGuy];
    
    return props;
}


- (RadialElement *)cityInteriorProp {
    if (!_cityInteriorProp) {
        CGFloat scale = 0.99;
        UIImage *cityInterior = [UIImage imageNamed:@"cityInterior.png"];
        CGSize size = [cityInterior size];
        size.width*=scale;
        size.height*=scale;
        
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextRotateCTM (context, -0.085);
        CGContextScaleCTM(context, scale, scale);
        
        [cityInterior drawInRect:CGRectMake(0, 0, size.width, size.height)];
        cityInterior = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        _cityInteriorProp = [[RadialElement alloc] init];
        _cityInteriorProp.display = [[UIImageView alloc] initWithImage:cityInterior];
        _cityInteriorProp.distanceFromWorldSurface = -_cityInteriorProp.display.frame.size.height + 373;
        _cityInteriorProp.angle = 3.07;
    }
    return _cityInteriorProp;
}


- (NSArray *)bridgeOrbitalCoordinates {
    NSArray *coords = @[
                        [[OrbitalCoordinate alloc] initWithHeight:94.5 angle:-0.556],
                        [[OrbitalCoordinate alloc] initWithHeight:100.4 angle:-0.733],
                        [[OrbitalCoordinate alloc] initWithHeight:105.7 angle:-0.88],
                        [[OrbitalCoordinate alloc] initWithHeight:108 angle:-0.98],
                        [[OrbitalCoordinate alloc] initWithHeight:109.5 angle:-1.09],
                        [[OrbitalCoordinate alloc] initWithHeight:110 angle:-1.19],
                        [[OrbitalCoordinate alloc] initWithHeight:110 angle:-1.29],
                        [[OrbitalCoordinate alloc] initWithHeight:109.5 angle:-1.39],
                        [[OrbitalCoordinate alloc] initWithHeight:109.5 angle:-1.49],
                        [[OrbitalCoordinate alloc] initWithHeight:109.5 angle:-1.59],
                        [[OrbitalCoordinate alloc] initWithHeight:109.5 angle:-1.69],
                        [[OrbitalCoordinate alloc] initWithHeight:109.5 angle:-1.79],
                        [[OrbitalCoordinate alloc] initWithHeight:109.5 angle:-1.89],
                        [[OrbitalCoordinate alloc] initWithHeight:109.5 angle:-1.99],
                        [[OrbitalCoordinate alloc] initWithHeight:109 angle:-2.09],
                        [[OrbitalCoordinate alloc] initWithHeight:108 angle:-2.19],
                        [[OrbitalCoordinate alloc] initWithHeight:105.5 angle:-2.29],
                        [[OrbitalCoordinate alloc] initWithHeight:102 angle:-2.39],
                        [[OrbitalCoordinate alloc] initWithHeight:99.6 angle:-2.47],
                       ];
    NSArray *surfaces = [RadialObjectStore orbitalSurfacesWithChainCoordinates:coords];
    return surfaces;
}


- (OrbitalStructure *)cityInterior {
    if (!_cityInterior) {
        
        NSMutableArray *surfaces = [[NSMutableArray alloc] init];
        
        OrbitalCoordinate *leftWallCoordA = [[OrbitalCoordinate alloc] initWithHeight:182.9 angle:3.48];
        OrbitalCoordinate *leftWallCoordB = [[OrbitalCoordinate alloc] initWithHeight:122.7 angle:3.52];
        OrbitalSurface *leftWallSurface = [[OrbitalSurface alloc] initWithCoordA:leftWallCoordA coordB:leftWallCoordB];
        [surfaces addObject:leftWallSurface];
        
        OrbitalCoordinate *entranceSensorCoordA = [[OrbitalCoordinate alloc] initWithHeight:122 angle:3.54];
        OrbitalCoordinate *entranceSensorCoordB = [[OrbitalCoordinate alloc] initWithHeight:112 angle:3.54];
        OrbitalSurface *entranceSensor = [[OrbitalSurface alloc] initWithCoordA:entranceSensorCoordA coordB:entranceSensorCoordB];
        entranceSensor.allowsCollision = NO;
        
        NSArray *groundCoordinates = @[
                                       [[OrbitalCoordinate alloc] initWithHeight:112.5 angle:3.53],
                                       [[OrbitalCoordinate alloc] initWithHeight:111.9 angle:3.435],
                                       [[OrbitalCoordinate alloc] initWithHeight:104.2 angle:3.425],
                                       [[OrbitalCoordinate alloc] initWithHeight:104.5 angle:3.35],
                                       [[OrbitalCoordinate alloc] initWithHeight:107.4 angle:3.345],
                                       [[OrbitalCoordinate alloc] initWithHeight:107.3 angle:3.26],
                                       [[OrbitalCoordinate alloc] initWithHeight:112.6 angle:3.25],
                                       [[OrbitalCoordinate alloc] initWithHeight:112.2 angle:3.12],
                                       [[OrbitalCoordinate alloc] initWithHeight:130.4 angle:3.10]
                                       ];
        
        NSArray *groundSurfaces = [RadialObjectStore orbitalSurfacesWithChainCoordinates:groundCoordinates];
        for (OrbitalSurface *surface in groundSurfaces) {
            surface.allowsCollision = NO;
        }
        
        NSArray *platformCoordinates1 = @[
                                          [[OrbitalCoordinate alloc] initWithHeight:119.4 angle:3.44],
                                          [[OrbitalCoordinate alloc] initWithHeight:120 angle:3.34],
                                          [[OrbitalCoordinate alloc] initWithHeight:124.8 angle:3.34],
                                          [[OrbitalCoordinate alloc] initWithHeight:125.5 angle:3.32],
                                          [[OrbitalCoordinate alloc] initWithHeight:130.7 angle:3.32],
                                          [[OrbitalCoordinate alloc] initWithHeight:129.8 angle:3.45],
                                          [[OrbitalCoordinate alloc] initWithHeight:124.9 angle:3.45],
                                          [[OrbitalCoordinate alloc] initWithHeight:124 angle:3.44],
                                          [[OrbitalCoordinate alloc] initWithHeight:119.4 angle:3.44]
                                          ];
        NSArray *platform1 = [RadialObjectStore orbitalSurfacesWithChainCoordinates:platformCoordinates1];
        
        NSArray *platformCoordinates2 = @[
                                          [[OrbitalCoordinate alloc] initWithHeight:139.2 angle:3.46],
                                          [[OrbitalCoordinate alloc] initWithHeight:139.4 angle:3.31],
                                          [[OrbitalCoordinate alloc] initWithHeight:143 angle:3.31],
                                          [[OrbitalCoordinate alloc] initWithHeight:142.7 angle:3.38],
                                          [[OrbitalCoordinate alloc] initWithHeight:152.6 angle:3.38],
                                          [[OrbitalCoordinate alloc] initWithHeight:152.8 angle:3.45],
                                          [[OrbitalCoordinate alloc] initWithHeight:139.2 angle:3.46]
                                          ];
        NSArray *platform2 = [RadialObjectStore orbitalSurfacesWithChainCoordinates:platformCoordinates2];
        
        NSArray *platformCoordinates3 = @[
                                          [[OrbitalCoordinate alloc] initWithHeight:121.3 angle:3.1],
                                          [[OrbitalCoordinate alloc] initWithHeight:121.3 angle:3.19],
                                          [[OrbitalCoordinate alloc] initWithHeight:123.7 angle:3.19],
                                          [[OrbitalCoordinate alloc] initWithHeight:123.8 angle:3.11],
                                          [[OrbitalCoordinate alloc] initWithHeight:121.3 angle:3.1]
                                          ];
        NSArray *platform3 = [RadialObjectStore orbitalSurfacesWithChainCoordinates:platformCoordinates3];
        
        NSArray *platformCoordinates4 = @[
                                          [[OrbitalCoordinate alloc] initWithHeight:138.6 angle:3.25],
                                          [[OrbitalCoordinate alloc] initWithHeight:137.5 angle:3.17],
                                          [[OrbitalCoordinate alloc] initWithHeight:139.7 angle:3.17],
                                          [[OrbitalCoordinate alloc] initWithHeight:140.9 angle:3.25],
                                          [[OrbitalCoordinate alloc] initWithHeight:138.6 angle:3.25]
                                          ];
        NSArray *platform4 = [RadialObjectStore orbitalSurfacesWithChainCoordinates:platformCoordinates4];
        
        NSArray *platformCoordinates5 = @[
                                          [[OrbitalCoordinate alloc] initWithHeight:156.1 angle:3.3],
                                          [[OrbitalCoordinate alloc] initWithHeight:151.2 angle:3.3],
                                          [[OrbitalCoordinate alloc] initWithHeight:151.2 angle:3.26],
                                          [[OrbitalCoordinate alloc] initWithHeight:156.1 angle:3.25],
                                          [[OrbitalCoordinate alloc] initWithHeight:156.1 angle:3.3]
                                          ];
        NSArray *platform5 = [RadialObjectStore orbitalSurfacesWithChainCoordinates:platformCoordinates5];
        
        NSArray *platformCoordinates6 = @[
                                          [[OrbitalCoordinate alloc] initWithHeight:154.7 angle:3.1],
                                          [[OrbitalCoordinate alloc] initWithHeight:153.2 angle:3.1],
                                          [[OrbitalCoordinate alloc] initWithHeight:153.2 angle:3.17],
                                          [[OrbitalCoordinate alloc] initWithHeight:155 angle:3.17],
                                          [[OrbitalCoordinate alloc] initWithHeight:154.7 angle:3.1]
                                          ];
        NSArray *platform6 = [RadialObjectStore orbitalSurfacesWithChainCoordinates:platformCoordinates6];
        
        NSArray *platformCoordinates7 = @[
                                          [[OrbitalCoordinate alloc] initWithHeight:172.2 angle:3.44],
                                          [[OrbitalCoordinate alloc] initWithHeight:162.5 angle:3.45],
                                          [[OrbitalCoordinate alloc] initWithHeight:162.5 angle:3.43],
                                          [[OrbitalCoordinate alloc] initWithHeight:172 angle:3.42],
                                          [[OrbitalCoordinate alloc] initWithHeight:172.2 angle:3.44]
                                          ];
        NSArray *platform7 = [RadialObjectStore orbitalSurfacesWithChainCoordinates:platformCoordinates7];
        
        NSArray *platformCoordinates8 = @[
                                          [[OrbitalCoordinate alloc] initWithHeight:179.5 angle:3.44],
                                          [[OrbitalCoordinate alloc] initWithHeight:179.5 angle:3.42],
                                          [[OrbitalCoordinate alloc] initWithHeight:188.7 angle:3.42],
                                          [[OrbitalCoordinate alloc] initWithHeight:189.1 angle:3.44],
                                          [[OrbitalCoordinate alloc] initWithHeight:179.5 angle:3.44]
                                          ];
        NSArray *platform8 = [RadialObjectStore orbitalSurfacesWithChainCoordinates:platformCoordinates8];

        NSArray *platformCoordinates9 = @[
                                          [[OrbitalCoordinate alloc] initWithHeight:163.7 angle:3.39],
                                          [[OrbitalCoordinate alloc] initWithHeight:164 angle:3.37],
                                          [[OrbitalCoordinate alloc] initWithHeight:188.8 angle:3.37],
                                          [[OrbitalCoordinate alloc] initWithHeight:188.5 angle:3.39],
                                          [[OrbitalCoordinate alloc] initWithHeight:163.7 angle:3.39]
                                          ];
        NSArray *platform9 = [RadialObjectStore orbitalSurfacesWithChainCoordinates:platformCoordinates9];
        
        void (^enterCity)() = ^{
            for (OrbitalSurface *surface in groundSurfaces) {
                surface.allowsCollision = YES;
            }
            _cityLadderEnabled = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowCityInterior object:nil];
        };
        
        void (^ladderBlock)(BOOL contact) = ^(BOOL contact){
            if (!_cityLadderEnabled) {
                return;
            }
            _onCityLadder += (contact ? 1 : -1);
        };
        
        
        NSArray *ladder1Vertices = @[
                                     [[OrbitalCoordinate alloc] initWithHeight:104.8 angle:3.43],
                                     [[OrbitalCoordinate alloc] initWithHeight:114.8 angle:3.43],
                                     [[OrbitalCoordinate alloc] initWithHeight:114.8 angle:3.39],
                                     [[OrbitalCoordinate alloc] initWithHeight:104.8 angle:3.39]
                                     ];
        
        NSArray *ladder2Vertices = @[
                                     [[OrbitalCoordinate alloc] initWithHeight:107.5 angle:3.31],
                                     [[OrbitalCoordinate alloc] initWithHeight:145.9 angle:3.30],
                                     [[OrbitalCoordinate alloc] initWithHeight:146.1 angle:3.27],
                                     [[OrbitalCoordinate alloc] initWithHeight:107.4 angle:3.27]
                                     ];
        
        NSArray *ladder3Vertices = @[
                                     [[OrbitalCoordinate alloc] initWithHeight:112.7 angle:3.25],
                                     [[OrbitalCoordinate alloc] initWithHeight:130 angle:3.24],
                                     [[OrbitalCoordinate alloc] initWithHeight:129 angle:3.20],
                                     [[OrbitalCoordinate alloc] initWithHeight:112.5 angle:3.21]
                                     ];
        
        NSArray *ladder4Vertices = @[
                                     [[OrbitalCoordinate alloc] initWithHeight:124 angle:3.16],
                                     [[OrbitalCoordinate alloc] initWithHeight:124.1 angle:3.12],
                                     [[OrbitalCoordinate alloc] initWithHeight:146 angle:3.12],
                                     [[OrbitalCoordinate alloc] initWithHeight:145 angle:3.15]
                                     ];
        
        NSArray *ladder5Vertices = @[
                                     [[OrbitalCoordinate alloc] initWithHeight:140.4 angle:3.18],
                                     [[OrbitalCoordinate alloc] initWithHeight:141.3 angle:3.25],
                                     [[OrbitalCoordinate alloc] initWithHeight:156.4 angle:3.24],
                                     [[OrbitalCoordinate alloc] initWithHeight:155.2 angle:3.17]
                                     ];

        NSArray *ladder6Vertices = @[
                                     [[OrbitalCoordinate alloc] initWithHeight:112.5 angle:3.52],
                                     [[OrbitalCoordinate alloc] initWithHeight:112.6 angle:3.48],
                                     [[OrbitalCoordinate alloc] initWithHeight:195 angle:3.47],
                                     [[OrbitalCoordinate alloc] initWithHeight:195 angle:3.45]
                                     ];
        
        NSArray *ladder7Vertices = @[
                                     [[OrbitalCoordinate alloc] initWithHeight:153.5 angle:3.42],
                                     [[OrbitalCoordinate alloc] initWithHeight:153.5 angle:3.4],
                                     [[OrbitalCoordinate alloc] initWithHeight:195.3 angle:3.4],
                                     [[OrbitalCoordinate alloc] initWithHeight:195.1 angle:3.41]
                                     ];
        
        NSArray *ladder8Vertices = @[
                                     [[OrbitalCoordinate alloc] initWithHeight:143 angle:3.36],
                                     [[OrbitalCoordinate alloc] initWithHeight:143.4 angle:3.33],
                                     [[OrbitalCoordinate alloc] initWithHeight:196.3 angle:3.34],
                                     [[OrbitalCoordinate alloc] initWithHeight:195.6 angle:3.36]
                                     ];
        
        OrbitalRect *ladder1 = [[OrbitalRect alloc] initWithVertices:ladder1Vertices];
        OrbitalRect *ladder2 = [[OrbitalRect alloc] initWithVertices:ladder2Vertices];
        OrbitalRect *ladder3 = [[OrbitalRect alloc] initWithVertices:ladder3Vertices];
        OrbitalRect *ladder4 = [[OrbitalRect alloc] initWithVertices:ladder4Vertices];
        OrbitalRect *ladder5 = [[OrbitalRect alloc] initWithVertices:ladder5Vertices];
        OrbitalRect *ladder6 = [[OrbitalRect alloc] initWithVertices:ladder6Vertices];
        OrbitalRect *ladder7 = [[OrbitalRect alloc] initWithVertices:ladder7Vertices];
        OrbitalRect *ladder8 = [[OrbitalRect alloc] initWithVertices:ladder8Vertices];
        
        _cityInterior = [[OrbitalStructure alloc] init];
        [_cityInterior addOrbitalSurface:entranceSensor withCrossBlock:enterCity];
        [_cityInterior addOrbitalSurfaces:surfaces];
        [_cityInterior addOrbitalSurfaces:groundSurfaces];
        [_cityInterior addOrbitalSurfaces:platform1];
        [_cityInterior addOrbitalSurfaces:platform2];
        [_cityInterior addOrbitalSurfaces:platform3];
        [_cityInterior addOrbitalSurfaces:platform4];
        [_cityInterior addOrbitalSurfaces:platform5];
        [_cityInterior addOrbitalSurfaces:platform6];
        [_cityInterior addOrbitalSurfaces:platform7];
        [_cityInterior addOrbitalSurfaces:platform8];
        [_cityInterior addOrbitalSurfaces:platform9];
        [_cityInterior addOrbitalRect:ladder1 withContactBlock:ladderBlock];
        [_cityInterior addOrbitalRect:ladder2 withContactBlock:ladderBlock];
        [_cityInterior addOrbitalRect:ladder3 withContactBlock:ladderBlock];
        [_cityInterior addOrbitalRect:ladder4 withContactBlock:ladderBlock];
        [_cityInterior addOrbitalRect:ladder5 withContactBlock:ladderBlock];
        [_cityInterior addOrbitalRect:ladder6 withContactBlock:ladderBlock];
        [_cityInterior addOrbitalRect:ladder7 withContactBlock:ladderBlock];
        [_cityInterior addOrbitalRect:ladder8 withContactBlock:ladderBlock];
    }
    return _cityInterior;
}


- (BOOL)onLadder {
    return _onCityLadder > 0;
}


- (OrbitalStructure *)rampToCityInterior {
    if (!_rampToCityInterior) {
        NSArray *coords = @[
                            [[OrbitalCoordinate alloc] initWithHeight:94.5 angle:3.68],
                            [[OrbitalCoordinate alloc] initWithHeight:99.6 angle:3.83],
                            [[OrbitalCoordinate alloc] initWithHeight:100.5 angle:3.72],
                            [[OrbitalCoordinate alloc] initWithHeight:102 angle:3.695],
                            [[OrbitalCoordinate alloc] initWithHeight:105.2 angle:3.695],
                            [[OrbitalCoordinate alloc] initWithHeight:105.2 angle:3.645],
                            [[OrbitalCoordinate alloc] initWithHeight:111 angle:3.645],
                            [[OrbitalCoordinate alloc] initWithHeight:112.8 angle:3.53]
                            ];
        NSMutableArray *surfaces = [RadialObjectStore orbitalSurfacesWithChainCoordinates:coords];
        
        OrbitalSurface *rampTop = surfaces[1];
        rampTop.collideFromBelow = NO;
        
        _rampToCityInterior = [[OrbitalStructure alloc] init];
        [_rampToCityInterior addOrbitalSurfaces:surfaces];
    }
        
    return _rampToCityInterior;
}


+ (NSMutableArray *)orbitalSurfacesWithChainCoordinates:(NSArray *)coordinates {
    if ([coordinates count] < 2) return nil;
    
    NSMutableArray *surfaces = [[NSMutableArray alloc] init];
    [coordinates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx + 1 < [coordinates count]) {
            OrbitalSurface *chainSurface = [[OrbitalSurface alloc] initWithCoordA:obj coordB:[coordinates objectAtIndex:idx+1]];
            [surfaces addObject:chainSurface];
        }
    }];
    return surfaces;
}

@end
