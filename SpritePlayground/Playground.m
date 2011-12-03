/*
 * Playgound.m
 * By John Pavley
 * All rights reserved.
 */

#import "Playground.h"

#define kCompositeTag 100


@implementation Playground


+ (CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Playground *layer = [Playground node];
	[scene addChild: layer];
	return scene;
}

+ (CGPoint) locationFromTouch:(UITouch*)touch {
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (id) init
{
	if( (self=[super init])) {
        
        CCSprite * cocos2dGuy = [CCSprite spriteWithFile:@"avatar_n1_tang.png"];
        CGSize spriteSize = cocos2dGuy.textureRect.size;

        
		CGSize size = [[CCDirector sharedDirector] winSize];
		CGPoint centerPt =  ccp(size.width/2,size.height/2);
        
        CCNode * composite = [CCNode node];
        composite.anchorPoint = ccp(0.5,0.5);
        composite.contentSize = spriteSize;
        composite.position = centerPt;
        [self addChild:composite z:0 tag:kCompositeTag];
        
        
        // create the sprite
        cocos2dGuy.anchorPoint = ccp(0.5, 0.5);
        CGSize compositeSize = composite.contentSize;
        CGPoint compositeCenterPt = ccp(compositeSize.width/2,compositeSize.height/2);
        cocos2dGuy.position = compositeCenterPt;
        [composite addChild:cocos2dGuy z:1 tag:1];
        
        // create the xf
        CCParticleSystem * fx = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"fireball_small_fast_green.plist"];
        
        fx.anchorPoint = ccp(0.5, 0.5);
        fx.position = compositeCenterPt;
        fx.duration = kCCParticleDurationInfinity;
        fx.scale = 2.0f;
        fx.autoRemoveOnFinish = YES;
        
        [composite addChild:fx z:0 tag:1];

        
        self.isTouchEnabled = YES;
		
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void) registerWithTouchDispatcher 
{
	
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (bool) isTouchForMe:(CGPoint)touchLocation 
{
	bool hit = false;
	for(CCNode * node in [self children]) {
		if(node.tag == kCompositeTag) {
			hit = CGRectContainsPoint([node boundingBox], touchLocation);
            if (hit) {
                [self hiliteSprite:(CCSprite *)node];
            } else {
                [self turnSprite:(CCSprite *)node andAttackPoint:touchLocation];
            }
        }
    }
    return hit;
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
        
	CGPoint location = [Playground locationFromTouch:touch];
	bool isTouchHandled = [self isTouchForMe:location];
    return isTouchHandled;
}

- (void) hiliteSprite:(CCSprite *)sprite {
    CCScaleTo * scaleUp = [CCScaleTo actionWithDuration:0.25f scale:1.3f];
    CCEaseExponentialInOut * ease1 = [CCEaseExponentialInOut actionWithAction:scaleUp];
    CCScaleTo * scaleDown = [CCScaleTo actionWithDuration:0.25f scale:1.0f];
    CCEaseExponentialInOut * ease2 = [CCEaseExponentialInOut actionWithAction:scaleDown];
    CCSequence * sequence = [CCSequence actions:ease1, ease2, nil];
    [sprite runAction:sequence];
}

- (void) turnSprite:(CCSprite *)sprite andAttackPoint:(CGPoint)touchLocation {
    
    // calculation
    CGPoint difference = ccpSub(sprite.position, touchLocation);
    CGFloat rotationRadians = ccpToAngle(difference);
    CGFloat rotationDegrees = -CC_RADIANS_TO_DEGREES(rotationRadians);
    rotationDegrees += 90.0f; // because my sprites are already rotated 90 degrees
    CGFloat rotateByDegrees = rotationDegrees - sprite.rotation;
    
    // animation
    CCMoveTo* move = [CCMoveTo actionWithDuration:1.0f position:CGPointMake(touchLocation.x, touchLocation.y)];
    CCEaseExponentialInOut* ease = [CCEaseExponentialInOut actionWithAction:move];
    CCRotateBy* turnBy = [CCRotateBy actionWithDuration:0.5f angle:rotateByDegrees];
	CCEaseExponentialInOut* ease2 = [CCEaseExponentialInOut actionWithAction:turnBy];
    CCMoveTo* move2 = [CCMoveTo actionWithDuration:1.0f position:sprite.position];
    CCEaseExponentialInOut* ease3 = [CCEaseExponentialInOut actionWithAction:move2];
    CCSequence* sequence = [CCSequence actions:ease2, ease, ease3, nil];
    [sprite runAction:sequence];

}



@end
