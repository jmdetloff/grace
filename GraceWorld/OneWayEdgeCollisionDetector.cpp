//
//  OneWayEdgeCollisionDetector.cpp
//  GraceWorld
//
//  Created by John Detloff on 4/27/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "Box2d/Box2D.h"
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
    if (ContactIsFromBelow(contact)) {
        [player beginContact:contact];
    }
    
    b2Body *platform = this->GetBodyFromContact(contact, false);
    NSObject *obj = (__bridge NSObject *)platform->GetUserData();
    if ([obj isKindOfClass:[OrbitalRect class]]) {
        [(OrbitalRect *)obj boyBeganContact];
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
    
    bool solid = ContactIsFromBelow(contact);
    
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
    
    
    b2Vec2 boyVelocity = collidingBoy->GetLinearVelocity();
    if (boyVelocity.y <= 0.01 && solid && (!surface || surface.allowsCollision)) {
        return;
    }

    contact->SetEnabled(false);
}


b2Body* OneWayEdgeCollisionDetector::GetBodyFromContact(b2Contact *contact, bool boy) {
    b2Fixture* fixtureA = contact->GetFixtureA();
    b2Fixture* fixtureB = contact->GetFixtureB();
    b2Body* bodyA = fixtureA->GetBody();
    b2Body* bodyB = fixtureB->GetBody();
    
    if (bodyA == player.playerBody) {
        return (boy ? bodyA : bodyB);
    } else if (bodyB == player.playerBody) {
        return (boy ? bodyB : bodyA);
    } else {
        return nil;
    }
}


void OneWayEdgeCollisionDetector::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}


bool OneWayEdgeCollisionDetector::ContactIsFromBelow(b2Contact *contact) {
    b2Vec2 boyPosition = player.playerBody->GetPosition();
    b2PolygonShape *boyShape = (b2PolygonShape *)player.playerBody->GetFixtureList()->GetShape();
    
    b2Vec2 lowestVertex = boyShape->GetVertex(0);
    NSInteger vertexCount = boyShape->GetVertexCount();
    for (int i = 1; i < vertexCount; i++) {
        b2Vec2 vertex = boyShape->GetVertex(i);
        if (vertex.y > lowestVertex.y) {
            lowestVertex = vertex;
        }
    }
    
    static const CGFloat footError = 0.2;
    CGFloat footPosition = boyPosition.y - lowestVertex.y + footError;
    
    int numPoints = contact->GetManifold()->pointCount;
    
    BOOL solid = NO;
    
    b2WorldManifold worldManifold;
    contact->GetWorldManifold( &worldManifold );
    for (int i = 0; i < numPoints; i++) {
        if (worldManifold.points[i].y < footPosition) {
            solid = YES;
            break;
        }
    }

    return solid;
}
