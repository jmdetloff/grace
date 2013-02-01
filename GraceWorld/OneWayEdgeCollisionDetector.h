//
//  OneWayEdgeCollisionDetector.h
//  GraceWorld
//
//  Created by John Detloff on 4/27/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#ifndef __GraceWorld__OneWayEdgeCollisionDetector__
#define __GraceWorld__OneWayEdgeCollisionDetector__

#import "PlayerPhysicsWrapper.h"
#include <iostream>

class OneWayEdgeCollisionDetector : public b2ContactListener
{
    public :
    PlayerPhysicsWrapper *player;
    
    private :
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    void BeginContact(b2Contact *contact);
    void EndContact(b2Contact *contact);
    b2Body* GetBodyFromContact(b2Contact *contact, bool boy);
    bool ContactIsFromBelow(b2Contact *contact);
};


#endif /* defined(__GraceWorld__OneWayEdgeCollisionDetector__) */
