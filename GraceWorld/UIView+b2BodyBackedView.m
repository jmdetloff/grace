//
//  UIView+b2BodyBackedView.m
//  GraceWorld
//
//  Created by John Detloff on 4/21/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "UIView+b2BodyBackedView.h"
#import "DiagonalView.h"
#import "OrbitalSurface.h"
#import "PolygonView.h"
#include <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static const char* kGTPhysicsBackedView             = "kGTPhysicsBackedView";
static const char* kGTPhysicsBackedViewBodyOffset   = "kGTPhysicsBackedViewBodyOffset";
static const char* kGTSurfaceView                   = "kGTSurfaceView";

@implementation UIView (b2BodyBackedView)


- (id)initWithb2Fixture:(b2Fixture *)fixture orbitsToPixelsRatio:(CGFloat)orbitsToPixelsRatio {
    self = [self init];
    if (self) {
        [self setPhysicsFixture:fixture];
        
        CGSize fixtureSize;
        CGPoint bodyOffset;
        
        switch (fixture->GetType()) {
            case 0: //circle
                NSLog(@"not ready for circle!");
                break;
                
            case 1: { // edge
                b2EdgeShape *edgeShape = (b2EdgeShape *)fixture->GetShape();
                b2Vec2 vertexA = edgeShape->m_vertex1;
                b2Vec2 vertexB = edgeShape->m_vertex2;
                
                vertexA.x /= orbitsToPixelsRatio;
                vertexA.y /= orbitsToPixelsRatio;
                vertexB.x /= orbitsToPixelsRatio;
                vertexB.y /= orbitsToPixelsRatio;
                
                BOOL positive;
                CGRect diagRect = [self rectForVertexA:vertexA vertexB:vertexB positive:&positive];
                diagRect.size.width = MAX(4, diagRect.size.width);
                diagRect.size.height = MAX(4, diagRect.size.height);
                
                DiagonalView *diagonalView = [[DiagonalView alloc] initWithFrame:diagRect];
                diagonalView.lineColor = [UIColor greenColor];
                diagonalView.positive = positive;
                [self addSubview:diagonalView];
                
                [self setSurfaceView:diagonalView];
                
                bodyOffset = CGPointZero;
                fixtureSize = CGSizeZero;
                
                break;
            }
                
            case 2: { // polygon
                b2PolygonShape *polygonShape = (b2PolygonShape *)fixture->GetShape();
                
                CGRect fixtureRect = [self rectFromVerticesOnShape:polygonShape];
                fixtureSize = fixtureRect.size;
                
                bodyOffset = CGPointMake(fixtureRect.origin.x+fixtureSize.width/2, fixtureRect.origin.y+fixtureSize.height/2);
                
                NSMutableArray *points = [[NSMutableArray alloc] init];
                for (int i = 0; i < polygonShape->GetVertexCount(); i++) {
                    b2Vec2 vertex = polygonShape->GetVertex(i);
                    CGPoint point = CGPointMake(vertex.x, vertex.y);
                    point.y = -point.y;
                    
                    point.x += -fixtureRect.origin.x;
                    point.y += -fixtureRect.origin.y;
                    point.x /= orbitsToPixelsRatio;
                    point.y /= orbitsToPixelsRatio;
                    [points addObject:[NSValue valueWithCGPoint:point]];
                }
                
                fixtureSize.width /= orbitsToPixelsRatio;
                fixtureSize.height /= orbitsToPixelsRatio;
                bodyOffset.x /= orbitsToPixelsRatio;
                bodyOffset.y /= -orbitsToPixelsRatio;
                
                fixtureRect.origin.x /= orbitsToPixelsRatio;
                fixtureRect.origin.y /= orbitsToPixelsRatio;
                
                PolygonView *polyView = [[PolygonView alloc] initWithFrame:CGRectMake(fixtureRect.origin.x + fixtureSize.width/2 , fixtureRect.origin.y + fixtureSize.height/2, fixtureSize.width, fixtureSize.height) points:points];
                polyView.backgroundColor = [UIColor clearColor];
                polyView.layer.masksToBounds = NO;
                polyView.userInteractionEnabled = NO;
                polyView.color = (fixture->IsSensor() ? [[UIColor blueColor] colorWithAlphaComponent:0.3] : [UIColor redColor]);
                [self addSubview:polyView];
                
                self.backgroundColor = [UIColor clearColor];
//                self.layer.borderColor = [UIColor blackColor].CGColor;
//                self.layer.borderWidth = 1;
                
                break;
            }
                
            default:
                break;
        }
        
        [self setBodyOffset:bodyOffset];
        
        self.layer.masksToBounds = NO;
        self.frame = CGRectMake(0, 0, fixtureSize.width, fixtureSize.height);
    }
    return self;
}


#pragma mark - getters/setters


- (void)setSurfaceView:(UIView *)surfaceView {
    objc_setAssociatedObject(self, kGTSurfaceView, surfaceView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIView *)surfaceView {
    return (UIView *)objc_getAssociatedObject(self, kGTSurfaceView);
}


- (void)setPhysicsFixture:(b2Fixture *)fixture {
    NSValue *val = [NSValue valueWithPointer:fixture];
    objc_setAssociatedObject(self, kGTPhysicsBackedView, val, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (b2Fixture *)physicsFixture {
    NSValue *val = objc_getAssociatedObject(self, kGTPhysicsBackedView);
    return (b2Fixture *)[val pointerValue];
}


- (void)setBodyOffset:(CGPoint)bodyOffset {
    NSValue *val = [NSValue valueWithCGPoint:bodyOffset];
    objc_setAssociatedObject(self, kGTPhysicsBackedViewBodyOffset, val, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGPoint)bodyOffset {
    NSValue *val = objc_getAssociatedObject(self, kGTPhysicsBackedViewBodyOffset);
    return [val CGPointValue];
}


#pragma mark -


- (CGRect)rectFromVerticesOnShape:(b2PolygonShape *)polygonShape {
    NSInteger vertexCount = polygonShape->GetVertexCount();
    if (vertexCount == 0) {
        return CGRectZero;
    }
    
    b2Vec2 firstVertex = polygonShape->GetVertex(0);
    b2Vec2 leftMostVertex = firstVertex;
    b2Vec2 rightMostVertex = firstVertex;
    b2Vec2 lowestVertex = firstVertex;
    b2Vec2 highestVertex = firstVertex;
    
    for (int i = 1; i < vertexCount; i++) {
        b2Vec2 vertex = polygonShape->GetVertex(i);
        
        if (vertex.x < leftMostVertex.x) {
            leftMostVertex = vertex;
        }
        if (vertex.x > rightMostVertex.x) {
            rightMostVertex = vertex;
        }
        if (vertex.y > highestVertex.y) {
            highestVertex = vertex;
        }
        if (vertex.y < lowestVertex.y) {
            lowestVertex = vertex;
        }
    }
    
    CGFloat width = rightMostVertex.x - leftMostVertex.x;
    CGFloat height = highestVertex.y - lowestVertex.y;
    return CGRectMake(leftMostVertex.x, -highestVertex.y, width, height);
}


- (CGRect)rectForVertexA:(b2Vec2)vertexA vertexB:(b2Vec2)vertexB positive:(BOOL *)positive {
    if (vertexA.x > vertexB.x) {
        b2Vec2 temp = vertexA;
        vertexA = vertexB;
        vertexB = temp;
    }
    
    CGSize size = CGSizeMake(vertexB.x - vertexA.x, fabsf(vertexB.y - vertexA.y));
    
    CGPoint origin;
    if (vertexA.y < vertexB.y) {
        *positive = YES;
        origin = CGPointMake(vertexA.x, -(vertexA.y + size.height));
    } else {
        *positive = NO;
        origin = CGPointMake(vertexA.x, -vertexA.y);
    }
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

@end
