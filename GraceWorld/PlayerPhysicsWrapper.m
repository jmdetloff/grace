//
//  PlayerPhysicsWrapper.m
//  GraceWorld
//
//  Created by John Detloff on 5/2/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "PlayerPhysicsWrapper.h"
#import "OrbitalSurface.h"


@implementation PlayerPhysicsWrapper {
    NSMutableArray *_bottomContacts;
    BOOL _standing;
}

- (id)initWithb2Body:(b2Body *)body {
    self = [super init];
    if (self) {
        _bottomContacts = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)beginContact:(b2Contact *)contact {
    NSValue *val = [NSValue valueWithPointer:contact];
    [_bottomContacts addObject:val];
    _standing = YES;
}


- (void)endContact:(b2Contact *)contact {
    NSValue *valToRemove = nil;
    for (NSValue *val in _bottomContacts) {
        b2Contact *existingContact = (b2Contact *)[val pointerValue];
        if (contact == existingContact) {
            valToRemove = val;
            break;
        }
    }
    if (valToRemove) {
        [_bottomContacts removeObject:valToRemove];
    }
    if ([_bottomContacts count] == 0) {
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([_bottomContacts count] == 0) {
                _standing = NO;
            }
        });
    }
}


- (BOOL)isStanding {
    return _standing;
}


- (RotationBlockState)rotationIsBlockedOrbitSpeed:(CGFloat)orbitSpeed {
    
    for (b2ContactEdge *contactEdge = self.physicsBody->GetContactList() ; contactEdge ; contactEdge = contactEdge->next) {
        b2Contact *contact = contactEdge->contact;
        
        b2Fixture *fixtureA = contact->GetFixtureA();
        b2Fixture *fixtureB = contact->GetFixtureB();
        b2Fixture *platformFixture;
        if (fixtureA == _sensorFixture) {
            platformFixture = fixtureB;
        } else if (fixtureB == _sensorFixture) {
            platformFixture = fixtureA;
        } else {
            continue;
        }
        
        ContactState state = [self stateFromContact:contact];
        
        if (state == ContactLeft || state == ContactRight) {
            BOOL pushing = NO;
            for (b2ContactEdge *contactEdge = self.physicsBody->GetContactList() ; contactEdge ; contactEdge = contactEdge->next) {
                b2Contact *contact = contactEdge->contact;
                ContactState state = [self stateFromContact:contact];
                BOOL collidingContact = NO;
                if (state != NoContact) {
                    collidingContact = [self contact:contact isBetweenFixtureA:_collidingFixture fixtureB:platformFixture];
                }
                if (collidingContact) {
                    pushing = YES;
                    break;
                }
            }
            
            if (state == ContactLeft && (orbitSpeed < 0 || pushing)) {
                return (pushing ? PushedFromLeft : BlockedLeft);
            } else if (state == ContactRight && (orbitSpeed > 0 || pushing)) {
                return (pushing ? PushedFromRight : BlockedRight);
            }
        } else {
            continue;
        }
    }
    
    return NotBlocked;
}


- (BOOL)contact:(b2Contact *)contact isBetweenFixtureA:(b2Fixture *)fixtureA fixtureB:(b2Fixture *)fixtureB {
    b2Fixture *contactFixtureA = contact->GetFixtureA();
    b2Fixture *contactFixtureB = contact->GetFixtureB();
    return ((contactFixtureA == fixtureA && contactFixtureB == fixtureB) || (contactFixtureB == fixtureA && contactFixtureA == fixtureB));
}


- (ContactState)stateFromContact:(b2Contact *)contact {
    if (!contact->IsTouching()) {
        return NoContact;
    }
    
    b2Body* platform = [self platformFromBoyContact:contact];
    OrbitalSurface *surface = (__bridge OrbitalSurface *)platform->GetUserData();
    if (!surface || ![surface isKindOfClass:[OrbitalSurface class]] || !surface.allowsCollision) {
        return NoContact;
    }
    
    if (!surface.collideFromBelow) {
        return NoContact;
    }
    
    b2WorldManifold manifold;
    contact->GetWorldManifold(&manifold);
    
    b2Vec2 normal = manifold.normal;
    
    if (normal.x < -0.1) {
        return ContactRight;
    } else if (normal.x > 0.0) {
        return ContactLeft;
    } else {
        return NoContact;
    }
}


- (b2Body *)platformFromBoyContact:(b2Contact *)contact {
    b2Fixture* fixtureA = contact->GetFixtureA();
    b2Fixture* fixtureB = contact->GetFixtureB();
    b2Body* bodyA = fixtureA->GetBody();
    b2Body* bodyB = fixtureB->GetBody();
    if (self.physicsBody == bodyA) {
        return bodyB;
    } else {
        return bodyA;
    }
}


@end
