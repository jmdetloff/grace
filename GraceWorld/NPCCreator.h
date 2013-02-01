//
//  NPCCreator.h
//  GraceWorld
//
//  Created by John Detloff on 2/21/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "GTMultiSpriteView.h"
#import <Foundation/Foundation.h>


typedef enum {
    BusinessMan,
    BigGuy,
    Artist,
    Lady,
    HomelessGuy,
    Granny,
    Sweeper,
    GuitarGuy,
    SuicideGuy
} NPCCharacter;


@interface NPCCreator : NSObject
+ (GTMultiSpriteView *)spriteForNPC:(NPCCharacter)character;
@end
