//
//  NPCCreator.m
//  GraceWorld
//
//  Created by John Detloff on 2/21/13.
//  Copyright (c) 2013 Uebie. All rights reserved.
//

#import "NPCCreator.h"

@implementation NPCCreator


+ (GTMultiSpriteView *)spriteForNPC:(NPCCharacter)character {
    
    NSString *imagePrefix;
    NSTimeInterval duration;
    
    switch (character) {
        case BusinessMan:
            imagePrefix = @"biz";
            duration = 0.7;
            break;
            
        case Artist:
            imagePrefix = @"artist";
            duration = 2;
            break;
            
        case SuicideGuy:
            imagePrefix = @"sg";
            duration = 1;
            break;
            
        case Sweeper:
            imagePrefix = @"sweeper";
            duration = 1.6;
            break;
            
        case GuitarGuy:
            imagePrefix = @"guitar";
            duration = 1;
            break;
            
        case HomelessGuy:
            imagePrefix = @"bum";
            duration = 1;
            break;
            
        case Lady:
            imagePrefix = @"lady";
            duration = 1.1;
            break;
            
        case BigGuy:
            imagePrefix = @"fatguy";
            duration = 1;
            break;
            
        case Granny:
            imagePrefix = @"granny";
            duration = 0.5;
            break;
    }
    
    NSMutableArray *animation = [[NSMutableArray alloc] init];
    
    UIImage *img;
    int imgCount = 1;
    while ((img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%i.png",imagePrefix,imgCount]])) {
        [animation addObject:img];
        imgCount++;
    }
    
    
    GTMultiSpriteView *spriteView = [[GTMultiSpriteView alloc] init];
    
    CGFloat scale = 0.6;
    
    CGSize size = CGSizeMake(((UIImage *)animation[0]).size.width*scale, ((UIImage *)animation[0]).size.height*scale);
    spriteView.frame = CGRectMake(0,0,size.width,size.height);
    
    NSString *constantAnimationKey = @"constantAnimationKey";
    [spriteView setAnimation:animation duration:duration forKey:constantAnimationKey];
    [spriteView setAnimationToAnimationWithKey:constantAnimationKey];
    return spriteView;
}


@end
