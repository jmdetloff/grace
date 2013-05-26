//
//  WorldPhysicsController.m
//  Grace
//
//  Created by John Detloff on 1/20/13.
//  Copyright (c) 2013 Groucho. All rights reserved.
//

#import "PlayerPhysicsWrapper.h"
#import "WorldPhysicsController.h"
#import "OrbitController.h"
#import "OrbitalCoordinate.h"
#import "OrbitalSurface.h"
#import "OrbitalStructure.h"
#import "OrbitalRect.h"
#import "OneWayEdgeCollisionDetector.h"


@implementation WorldPhysicsController {
    b2World *_world;
    OneWayEdgeCollisionDetector _contactListener;
    NSMutableArray *_rotatingBodies;
    
    PlayerPhysicsWrapper *_player;
    
//    b2Body *_boy;
//    b2Fixture *_blockingBoySensor;
//    b2Fixture *_collidingBoyFixture;
    CGFloat _boyHeight;
    
    OrbitController *_orbitController;
}


- (id)init {
    self = [super init];
    if (self) {
        b2Vec2 gravity = b2Vec2(0.0f, -9.81f);
        _world = new b2World(gravity);
        
        _world->SetContactListener(&_contactListener);
        
        _rotatingBodies = [[NSMutableArray alloc] init];
        
        _orbitController = [[OrbitController alloc] initWithOrbitRadius:100];
    }
    return self;
}


#pragma mark - Update


- (CGFloat)updatePhysics:(NSTimeInterval)timeStep {
    CGFloat radians = self.orbitSpeed;
    
    RotationBlockState blockState = [_player rotationIsBlockedOrbitSpeed:self.orbitSpeed];
    
    for (NSValue *bodyVal in _rotatingBodies) {
        b2Body *body = (b2Body *)[bodyVal pointerValue];
        if (radians != 0 && blockState == NotBlocked) {
            [self rotateBody:body byRadians:radians setPosition:NO timeStep:timeStep];
        } else if (blockState == PushedFromLeft) {
            radians = 0.001;
            [self rotateBody:body byRadians:radians setPosition:NO timeStep:timeStep];
        } else if (blockState == PushedFromRight) {
            radians = -0.001;
            [self rotateBody:body byRadians:radians setPosition:NO timeStep:timeStep];
        } else if (radians == 0 || blockState == BlockedLeft || blockState == BlockedRight){
            radians = 0;
            body->SetLinearVelocity (b2Vec2(0,0));
            body->SetAngularVelocity(0);
        }
    }
    
    _world->Step(timeStep, 10, 10);
    
    return radians;
}




#pragma mark -


- (PlayerPhysicsWrapper *)placePlayerBodyWithSize:(CGSize)size atOrbitHeight:(CGFloat)height {
    _boyHeight = size.height/2;
    
    b2PolygonShape square;
    square.SetAsBox(size.width/2, size.height/2);
    
    b2FixtureDef boyFixtureDef;
    boyFixtureDef.shape = &square;
    boyFixtureDef.density = 3.0;
    boyFixtureDef.friction = 1;
    boyFixtureDef.restitution = 0;
    
    b2PolygonShape sensorSquare;
    sensorSquare.SetAsBox(size.width/2*1.5,size.height/2*0.65);

    b2FixtureDef sensorFixtureDef;
    sensorFixtureDef.shape = &sensorSquare;
    sensorFixtureDef.density = 3.0;
    sensorFixtureDef.friction = 1;
    sensorFixtureDef.restitution = 0;
    
    b2BodyDef boyDef;
    boyDef.fixedRotation = true;
    boyDef.position.Set(0, height);
    boyDef.type = b2_dynamicBody;
    
    b2Body *body = [self addBodyWithDef:boyDef];
    
    _player = [[PlayerPhysicsWrapper alloc] init];
    _player.physicsBody = body;
    _player.collidingFixture = [self addFixture:boyFixtureDef toBody:body];
    _player.sensorFixture = [self addFixture:sensorFixtureDef toBody:body];
    
    _contactListener.player = _player;
    
    CGFloat groundHeight = 1;
    b2Body *ground = [self addStaticCollidingRectWithSize:CGSizeMake(size.width, groundHeight) height:height-size.height/2-groundHeight/2 angle:M_PI/2];
    
    b2PrismaticJointDef prismaticJointDef;
    prismaticJointDef.bodyA = body;
    prismaticJointDef.bodyB = ground;
    prismaticJointDef.collideConnected = true;
    prismaticJointDef.localAnchorA = b2Vec2(0,0);
    prismaticJointDef.localAnchorB = b2Vec2(0,0);
    prismaticJointDef.localAxisA = b2Vec2(0,1);
    (b2PrismaticJoint*)_world->CreateJoint( &prismaticJointDef );
    
    return _player;
}


- (b2Body *)placeOrbitalSurface:(OrbitalSurface *)surface {
    b2Body *body = [self placeStaticEdgeFromCoordinateA:surface.coordA toCoordinateB:surface.coordB];
    body->SetUserData((void *)CFBridgingRetain(surface));
    surface.physicsBody = body;
    return body;
}


- (void)placeOrbitalSurfaces:(NSArray *)surfaces {
    for (OrbitalSurface *surface in surfaces) {
        [self placeOrbitalSurface:surface];
    }
}


- (void)placeOrbitalStructure:(OrbitalStructure *)orbitalStructure {
    for (OrbitalSurface *surface in orbitalStructure.orbitalSurfaces) {
        [self placeOrbitalSurface:surface];
    }
    for (OrbitalSurface *sensor in orbitalStructure.sensorSurfaces) {
        [self placeOrbitalSurface:sensor];
    }
    for (OrbitalRect *rect in orbitalStructure.orbitalRects) {
        [self placeOrbitalRect:rect];
    }
}


#pragma mark -


- (b2Body *)placeOrbitalRect:(OrbitalRect *)rect {
    
    OrbitalCoordinate *coordA = rect.vertices[0];
    
    b2Vec2 position = b2Vec2(coordA.height*cos(coordA.angle),coordA.height*sin(coordA.angle));
    b2Vec2 *points = (b2Vec2*)calloc(4, sizeof(b2Vec2));
    
    [rect.vertices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OrbitalCoordinate *coord = (OrbitalCoordinate *)obj;
        b2Vec2 coordPos = b2Vec2(coord.height*cos(coord.angle),coord.height*sin(coord.angle));
        coordPos.x -= position.x;
        coordPos.y -= position.y;
        points[idx] = coordPos;
    }];

    b2PolygonShape rectShape;
    rectShape.Set(points,4);
    
    b2BodyDef rectDef;
    rectDef.type = b2_kinematicBody;
    rectDef.position.Set(position.x, position.y);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &rectShape;
    fixtureDef.density = 0.0000001;
    fixtureDef.isSensor = true;
    
    b2Body *rectBody = [self addBodyWithDef:rectDef];
    [self addFixture:fixtureDef toBody:rectBody];
    rectBody->SetGravityScale(0);
    rectBody->SetUserData((void *)CFBridgingRetain(rect));
    free(points);
    
    NSValue *rectVal = [NSValue valueWithPointer:rectBody];
    [_rotatingBodies addObject:rectVal];
    
    return rectBody;
}


- (b2Body *)placeStaticEdgeFromCoordinateA:(OrbitalCoordinate *)coordinateA toCoordinateB:(OrbitalCoordinate *)coordinateB {
    
    // The center position of the edge is somewhat arbitrary, as long as it is a point
    // on a circle with the center 0,0 with angle 0 the endpoints will rotate correctly
    // anchored to this center point. We choose the avg orbit height as this circle's radius.
    b2Vec2 edgePosition = b2Vec2((coordinateA.height + coordinateB.height)/2, 0);
    
    b2BodyDef edgeDef;
    edgeDef.type = b2_kinematicBody;
    edgeDef.position.Set(edgePosition.x, edgePosition.y);
    
    // Our edge is created with the center at angle 0, and is then rotated to its correct position.
    // This way the transform on the body is correct. The endpoints are placed angleDifference radians
    // to the left and right of the center.
    CGFloat angleDifference = coordinateB.angle - coordinateA.angle;
    angleDifference /= 2;
    
    // XY coordinates are calculated for each OrbitalCoordinate, based off angles left and right of 0
    b2Vec2 coordAXY = b2Vec2(coordinateA.height*cos(-angleDifference),coordinateA.height*sin(-angleDifference));
    b2Vec2 coordBXY = b2Vec2(coordinateB.height*cos(angleDifference),coordinateB.height*sin(angleDifference));
    
    // The endpoints are set using the relative distances between our semi-arbitrary anchor point and adjusted coordinates
    b2EdgeShape edgeShape;
    edgeShape.Set(b2Vec2(coordAXY.x - edgePosition.x, coordAXY.y - edgePosition.y), b2Vec2(coordBXY.x - edgePosition.x, coordBXY.y - edgePosition.y));
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &edgeShape;
    fixtureDef.density = 0.0000001;
    
    b2Body *edge = [self addBodyWithDef:edgeDef];
    [self addFixture:fixtureDef toBody:edge];
    edge->SetGravityScale(0);
    
    CGFloat finalEdgePosition = (coordinateB.angle + coordinateA.angle)/2;
    [self rotateBody:edge byRadians:finalEdgePosition setPosition:YES timeStep:1];
    
    NSValue *edgeVal = [NSValue valueWithPointer:edge];
    [_rotatingBodies addObject:edgeVal];
    
    return edge;
}



- (b2Body *)addBodyWithDef:(b2BodyDef)bodyDef {
    b2Body *body = _world->CreateBody(&bodyDef);
    return body;
}


- (b2Fixture *)addFixture:(b2FixtureDef)fixtureDef toBody:(b2Body *)body {
    b2Fixture *fixture = body->CreateFixture(&fixtureDef);
    [self.delegate addedB2FixtureToWorld:fixture];
    return fixture;
}


- (b2Body *)addStaticCollidingRectWithSize:(CGSize)size height:(CGFloat)height angle:(CGFloat)radians {
    b2PolygonShape square;
    square.SetAsBox(size.width/2, size.height/2);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &square;
    fixtureDef.friction = 1;
    
    b2BodyDef bodyDef;
    bodyDef.fixedRotation = true;
    bodyDef.position.Set(0, height);
    bodyDef.type = b2_staticBody;
    
    b2Body *body = [self addBodyWithDef:bodyDef];
    [self addFixture:fixtureDef toBody:body];
    return body;
}


- (void)rotateBody:(b2Body *)body byRadians:(CGFloat)radians setPosition:(BOOL)setPosition timeStep:(NSTimeInterval)timeStep {
    b2Vec2 bodyPoint = body->GetPosition();
    
    CGFloat newAngle = [self angleByRotatingPoint:bodyPoint byRadians:radians];
    b2Vec2 newPosition = [self positionByRotatingPoint:bodyPoint toAngle:newAngle];
    
    b2Vec2 currentPosition = body->GetPosition();
    CGFloat currentAngle = atan2f(currentPosition.y, currentPosition.x);
    
    if (setPosition) {
        body->SetTransform(newPosition, newAngle);
    } else {
        b2Vec2 velocity = b2Vec2(newPosition.x - bodyPoint.x, newPosition.y - bodyPoint.y);
        velocity.x *= (1/timeStep);
        velocity.y *= (1/timeStep);
        body->SetLinearVelocity(velocity);
        CGFloat angleChange = newAngle - currentAngle;
        body->SetAngularVelocity(angleChange*(1/timeStep));
    }
}


- (CGFloat)angleByRotatingPoint:(b2Vec2)point byRadians:(CGFloat)radians {
    b2Vec2 centerPoint = b2Vec2(0,0);
    CGFloat angleOfBody = atan2(point.y - centerPoint.y, point.x - centerPoint.x);
    angleOfBody += radians;
    return angleOfBody;
}


- (b2Vec2)positionByRotatingPoint:(b2Vec2)point toAngle:(CGFloat)angle {
    CGFloat radius = [self distanceBetweenPoint1:point point2:b2Vec2(0,0)];
    return b2Vec2(radius*cos(angle),radius*sin(angle));
}


- (CGFloat)distanceBetweenPoint1:(b2Vec2)point1 point2:(b2Vec2)point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
}

@end
