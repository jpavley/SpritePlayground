/*
 * Playgound.m
 * By John Pavley
 */

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
