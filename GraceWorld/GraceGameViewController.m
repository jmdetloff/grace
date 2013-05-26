//
//  GraceGameViewController.m
//  Grace World
//
//  Created by John Detloff on 1/28/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "OrbitalElement.h"
#import "PlayerPhysicsWrapper.h"
#import "GraceGameViewController.h"
#import "RotatingBackgroundView.h"
#import "RunJumpCrawlEventView.h"
#import "WorldPhysicsController.h"
#import "BoyView.h"
#import "WorldDataStore.h"
#import "DiagonalView.h"
#import "UIView+b2BodyBackedView.h"
#import "OrbitalCoordinate.h"
#import "OrbitalSurface.h"
#import "CoordinateReporter.h"
#import <QuartzCore/QuartzCore.h>

#define kReportingCoordinates NO

#define kLandscapeSize CGSizeMake(1024, 768)

#define kOrbitDistanceInPixels 1161.f
#define kOrbitToPixelsRatio (100/kOrbitDistanceInPixels)

@interface GraceGameViewController () <RunJumpCrawlDelegate, WorldPhysicsDelegate, CoordinateReporterDelegate>
@end


@implementation GraceGameViewController {
    NSMutableArray *_worldLayers;
    
    RunJumpCrawlEventView *_runJumpCrawlEventView;
    WorldPhysicsController *_physicsController;
    WorldDataStore *_worldDataStore;
    BoyView *_boy;
    UIView *_boyContainer;
    NSTimer *_gameLoop;
    
    NSMutableArray *_physicsBackedViews;
    
    UIView *_displayView;
    
    PlayerPhysicsWrapper *_playerPhysics;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect bounds = self.view.bounds;
    
    _worldDataStore = [[WorldDataStore alloc] init];
    [_worldDataStore loadLevelData];
    
    _displayView = [[UIView alloc] init];
    _displayView.frame = [self.view bounds];
    _displayView.layer.masksToBounds = NO;
    _displayView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_displayView];

    _runJumpCrawlEventView = [[RunJumpCrawlEventView alloc] initWithFrame:self.view.bounds touchWidth:200];
    _runJumpCrawlEventView.delegate = self;
    [self.view addSubview:_runJumpCrawlEventView];
    
    _physicsBackedViews = [[NSMutableArray alloc] init];
    _worldLayers = [[NSMutableArray alloc] init];
    
    CGSize worldSize = [_worldDataStore worldSize];
    CGPoint worldAnchorPoint = [_worldDataStore worldAnchorPoint];
    CGPoint worldPosition = [_worldDataStore worldPosition];
    
    RotatingBackgroundView *worldView = [[RotatingBackgroundView alloc] initWithFrame:bounds];
    [worldView setRotatingImage:[UIImage imageNamed:@"worldBack.png"] size:worldSize anchorPoint:worldAnchorPoint position:worldPosition];
    [_displayView addSubview:worldView];
    
    RotatingBackgroundView *frontWorldView = [[RotatingBackgroundView alloc] initWithFrame:bounds];
    [frontWorldView setRotatingImage:[UIImage imageNamed:@"worldFront.png"] size:worldSize anchorPoint:worldAnchorPoint position:worldPosition];
    [_displayView addSubview:frontWorldView];
    
    [_worldLayers addObject:worldView];
    [_worldLayers addObject:frontWorldView];
    
    NSArray *props = [_worldDataStore gamePropRadialObjects];
    [frontWorldView addProps:props];
    
    _physicsController = [[WorldPhysicsController alloc] init];
    _physicsController.delegate = self;
    
    CGSize boySize = CGSizeMake(50, 50);
    CGSize boyCollisionSize = CGSizeMake(boySize.width*0.35*kOrbitToPixelsRatio, boySize.height*kOrbitToPixelsRatio);
    
    _playerPhysics = [_physicsController placePlayerBodyWithSize:boyCollisionSize atOrbitHeight:97];
    
    _boyContainer = [[UIView alloc] init];
    [_displayView addSubview:_boyContainer];
    
    _boy = [[BoyView alloc] initWithFrame:CGRectMake(-boySize.width/2, -boySize.height/2, boySize.width, boySize.height)];
    [_boyContainer addSubview:_boy];
    
    [_boyContainer setPhysicsFixture:_playerPhysics.physicsBody->GetFixtureList()];

    [_physicsBackedViews addObject:_boyContainer];
    
    [self addTestObjects];
    
    _gameLoop = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(gameTick) userInfo:nil repeats:YES];
    
    if (kReportingCoordinates) {
        CoordinateReporter *reporter = [[CoordinateReporter alloc] initWithFrame:self.view.bounds];
        reporter.delegate = self;
        [_runJumpCrawlEventView addSubview:reporter];
        
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(950, 40, 50, 50)];
        clearButton.backgroundColor = [UIColor blueColor];
        [clearButton addTarget:reporter action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clearButton];
        
        UIButton *printButton = [[UIButton alloc] initWithFrame:CGRectMake(850, 40, 50, 50)];
        printButton.backgroundColor = [UIColor redColor];
        [printButton addTarget:reporter action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:printButton];
    }
    
}


- (void)addTestObjects {
    NSArray *bridgeSurfaces = [_worldDataStore bridgeOrbitalCoordinates];
    [_physicsController placeOrbitalSurfaces:bridgeSurfaces];
    
    OrbitalStructure *rampToCityInterior = [_worldDataStore rampToCityInterior];
    [_physicsController placeOrbitalStructure:rampToCityInterior];
    
    OrbitalStructure *cityInterior = [_worldDataStore cityInterior];
    [_physicsController placeOrbitalStructure:cityInterior];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCityInterior) name:kShowCityInterior object:nil];
}


#pragma mark - 


- (void)showCityInterior {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RotatingBackgroundView *layer = [_worldLayers objectAtIndex:0];
        
        RadialElement *cityInterior = [_worldDataStore cityInteriorProp];
        cityInterior.display.alpha = 0;
        
        [UIView animateWithDuration:0.8 animations:^{
            cityInterior.display.alpha = 1;
        }];
        
        [layer addProps:@[cityInterior]];
    });
}


#pragma mark - Game loop


- (void)gameTick {
    
    CGFloat orbitRadians;
    if ((_runJumpCrawlEventView.movementState & Left) == Left) {
        orbitRadians = -0.003;
    } else if ((_runJumpCrawlEventView.movementState & Right) == Right) {
        orbitRadians = 0.003;
    } else {
        orbitRadians = 0;
    }
    
    _physicsController.orbitSpeed = orbitRadians;
    
    CGFloat radians = [_physicsController updatePhysics:0.05];
    for (RotatingBackgroundView *worldView in _worldLayers) {
        [worldView shiftBy:-radians];
    }
    
    for (UIView *view in _physicsBackedViews) {
        b2Fixture *fixture = [view physicsFixture];
        b2Body *body = fixture->GetBody();
        CGPoint bodyLoc = [self convertOrbitPointToCoordinateSystem:body->GetPosition()];
        view.center = bodyLoc;
        view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - body->GetAngle());
        
        OrbitalSurface *surface = (__bridge OrbitalSurface *)body->GetUserData();
        if ([surface isKindOfClass:[OrbitalSurface class]]) {
            if (surface.allowsCollision) {
                [view surfaceView].lineColor = [UIColor greenColor];
            } else {
                [view surfaceView].lineColor = [UIColor blueColor];
            }
        }
    }
    
    b2Fixture *boyFixture = [_boyContainer physicsFixture];
    b2Body *boyBody = boyFixture->GetBody();
    
    if (_worldDataStore.onLadder) {
        _runJumpCrawlEventView.handleUpAsContinuous = YES;

        if (_boy.climbing) {
            if ((_runJumpCrawlEventView.movementState & Up) == Up) {
                b2Vec2 velocity(boyBody->GetLinearVelocity().x, 3);
                boyBody->SetLinearVelocity(velocity);
            } else if ((_runJumpCrawlEventView.movementState & Down) == Down) {
                b2Vec2 velocity(boyBody->GetLinearVelocity().x, -3);
                boyBody->SetLinearVelocity(velocity);
            } else {
                b2Vec2 velocity(boyBody->GetLinearVelocity().x, 0);
                boyBody->SetLinearVelocity(velocity);
            }
        }

    } else {
        _boy.climbing = NO;
        _runJumpCrawlEventView.handleUpAsContinuous = NO;
        if (boyBody->GetGravityScale() == 0) {
            boyBody->SetGravityScale(1);
            boyBody->SetLinearVelocity(b2Vec2(boyBody->GetLinearVelocity().x, boyBody->GetLinearVelocity().y-0.001));
        }
    }
    
    CGFloat boyVerticalVelocity = boyBody->GetLinearVelocity().y;
    
    if ([_playerPhysics isStanding] || boyVerticalVelocity == 0) {
        [_boy addMovementState:VerticalStill];
    } else if (boyVerticalVelocity > 0.1) {
        [_boy addMovementState:MovingUp];
    } else if (boyVerticalVelocity < -0.1) {
        [_boy addMovementState:MovingDown];
    }
    
    CGPoint screenPoint = [self.view convertPoint:_boyContainer.frame.origin fromView:_displayView];
    CGFloat shift = 0;
    if (screenPoint.y < 100) {
        shift = 100 - screenPoint.y;
    } else if (screenPoint.y > 560) {
        shift = 560 - screenPoint.y;
    }
    if (fabs(shift) > 0) {
        CGRect frame = _displayView.frame;
        frame.origin.y += shift;
        _displayView.frame = frame;
    }
}


#pragma mark - Physics Delegate 


- (void)addedB2FixtureToWorld:(b2Fixture *)fixture {
    UIView *marker = [[UIView alloc] initWithb2Fixture:fixture orbitsToPixelsRatio:kOrbitToPixelsRatio];
    marker.userInteractionEnabled = NO;
    [_physicsBackedViews addObject:marker];
    [_displayView addSubview:marker];
}


#pragma mark -


- (CGPoint)convertOrbitPointToCoordinateSystem:(b2Vec2)point {
    point.x /= kOrbitToPixelsRatio;
    point.y /= kOrbitToPixelsRatio;
    
    CGPoint convertedPosition = [_worldDataStore worldPosition];
    convertedPosition.x += point.x;
    convertedPosition.y -= point.y;
    return convertedPosition;
}


#pragma mark -


- (void)movementStateChanged:(MovementControlState)movementState {
    if ((movementState & Left) == Left) {
        [_boy addMovementState:MovingLeft];
    } else if ((movementState & Right) == Right) {
        [_boy addMovementState:MovingRight];
    } else {
        [_boy addMovementState:HorizontalStill];
    }
    
    if ((movementState & Up) == Up) {
        if (!_worldDataStore.onLadder) {
            [self jump];
        } else {
            _boy.climbing = YES;
            _playerPhysics.physicsBody->SetGravityScale(0);
        }
    }
}


- (void)jump {
    b2Body *boyPhysics = [_boyContainer physicsFixture]->GetBody();
    if (boyPhysics->GetLinearVelocity().y < 0.01 && boyPhysics->GetLinearVelocity().y > -0.01) {
        b2Vec2 velocity(boyPhysics->GetLinearVelocity().x, 12);
        boyPhysics->SetLinearVelocity(velocity);
    }
}


- (NSDictionary *)attributesToReportForCoordinate:(CGPoint)coordinate {
    CGPoint center = [_worldDataStore worldPosition];
    CGFloat convertedX = center.x - (1024/2 - coordinate.x);
    
    RotatingBackgroundView *layer = [_worldLayers objectAtIndex:0];
    CGFloat angle = [layer angle];
    CGFloat touchAngle = - atan2(coordinate.y - center.y, center.x - convertedX) - M_PI/2;
    
    CGFloat dx = (coordinate.x - center.x) * kOrbitToPixelsRatio;
    CGFloat dy = -(coordinate.y - center.y) * kOrbitToPixelsRatio;
    CGFloat height = sqrtf(dx*dx + dy*dy);
    
    NSNumber *angleNum = [NSNumber numberWithFloat:angle-touchAngle];
    NSNumber *heightNum = [NSNumber numberWithFloat:height];
    return @{@"height":heightNum,@"angle":angleNum};
}

@end
