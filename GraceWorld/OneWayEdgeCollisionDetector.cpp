//
//  OneWayEdgeCollisionDetector.cpp
//  GraceWorld
//
//  Created by John Detloff on 4/27/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "Box2d/Box2D.h"
#import "OrbitalElement.h"
#import "OrbitalSurface.h"
#import "OrbitalRect.h"
#include "OneWayEdgeCollisionDetector.h"


int locationOfPointRelativeToEdge(b2Vec2 point, b2Body *edgeBody) {
    b2EdgeShape *edgeShape = (b2EdgeShape*)edgeBody->GetFixtureList()->GetShape();
    b2Vec2 a = edgeBody->GetWorldPoint(edgeShape->m_vertex1);
    b2Vec2 b = edgeBody->GetWorldPoint(edgeShape->m_vertex2);
    return ((b.x - a.x)*(point.y - a.y) - (b.y - a.y)*(point.x - a.x));
}


void OneWayEdgeCollisionDetector::BeginContact(b2Contact *contact) {
    b2Body *platformBody = this->GetBodyFromContact(contact, false);
    OrbitalElement *platform = (__bridge OrbitalElement *)platformBody->GetUserData();
    
    BOOL playerShouldCollide = [player shouldCollidePlayer:player withElement:platform contact:contact];
    if (playerShouldCollide) {
        [player beginContact:contact];
    }
    
    if ([platform isKindOfClass:[OrbitalRect class]]) {
        [(OrbitalRect *)platform boyBeganContact];
    }
}


void OneWayEdgeCollisionDetector::EndContact(b2Contact *contact) {
    [player endContact:contact];
    
    b2Body *platform = this->GetBodyFromContact(contact, false);
    NSObject *obj = (__bridge NSObject *)platform->GetUserData();
    if ([obj isKindOfClass:[OrbitalSurface class]]) {
        [(OrbitalSurface *)obj boyEndedContact];
    } else if ([obj isKindOfClass:[OrbitalRect class]]) {
        [(OrbitalRect *)obj boyEndedContact];
    }
}


void OneWayEdgeCollisionDetector::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
    b2Body* collidingBoy = this->GetBodyFromContact(contact, true);
    if (!collidingBoy) {
        return;
    }
    
    if (contact->GetFixtureA() == player.sensorFixture || contact->GetFixtureB() == player.sensorFixture) {
        contact->SetEnabled(false);
        return;
    }
    
    b2Body *platform = this->GetBodyFromContact(contact, false);
    OrbitalSurface *surface = (__bridge OrbitalSurface *)platform->GetUserData();
    if (surface) {
        int sideOfPoint = locationOfPointRelativeToEdge(collidingBoy->GetPosition(),platform);
        SurfaceRelativeDirection direction;
        if (sideOfPoint < 0) {
            direction = SurfaceRight;
        } else {
            direction = SurfaceLeft;
        }
        [surface boyMadeContactOnSide:direction];
    }
    
    BOOL playerShouldCollide = [player shouldCollidePlayer:player withElement:surface contact:contact];
    
    if (playerShouldCollide && (!surface || surface.allowsCollision)) {
        return;
    }

    contact->SetEnabled(false);
}


b2Body* OneWayEdgeCollisionDetector::GetBodyFromContact(b2Contact *contact, bool boy) {
    b2Fixture* fixtureA = contact->GetFixtureA();
    b2Fixture* fixtureB = contact->GetFixtureB();
    b2Body* bodyA = fixtureA->GetBody();
    b2Body* bodyB = fixtureB->GetBody();
    
    if (bodyA == player.physicsBody) {
        return (boy ? bodyA : bodyB);
    } else if (bodyB == player.physicsBody) {
        return (boy ? bodyB : bodyA);
    } else {
        return nil;
    }
}


void OneWayEdgeCollisionDetector::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}
