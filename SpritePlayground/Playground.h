//
//  Playground.h
//  FightingSprites
//
//  Created by John Pavley on 11/30/11.
//  Copyright 2011 Spotify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Playground : CCLayer {
    
}

+ (CCScene *) scene;
+ (CGPoint) locationFromTouch:(UITouch*)touch;

- (id) init;
- (void) dealloc;
- (void) registerWithTouchDispatcher;
- (bool) isTouchForMe:(CGPoint)touchLocation;
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent*)event;
- (void) hiliteSprite:(CCSprite *)sprite;
- (void) turnSprite:(CCSprite *)sprite andAttackPoint:(CGPoint)touchLocation;


@end
