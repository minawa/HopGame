//
//  MyHero.m
//  HopGame
//
//  Created by Min on 10/25/16.
//  Copyright © 2016. All rights reserved.
//

#import "MyHero.h"

@interface MyHero()
@property BOOL isJumping;

@end

@implementation MyHero
static const uint32_t heroCategory =0x1<<0;
static const uint32_t obstacleCategory = 0x1<<1;
static const uint32_t groundCategory = 0x1 <<2;

+(id) hero {
    MyHero *hero = [MyHero spriteNodeWithColor:[NSColor redColor] size:CGSizeMake(60,60)];
    SKSpriteNode *leftEye = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:CGSizeMake(10, 10)];
    leftEye.position = CGPointMake(-13, 8);
    [hero addChild:leftEye];
    
    SKSpriteNode *rightEye = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:CGSizeMake(10, 10)];
    rightEye.position= CGPointMake(13, 8);
    [hero addChild:rightEye];
                                   
    
    hero.name =@"hero";
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hero.size];
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.contactTestBitMask = obstacleCategory |groundCategory;
    return hero;
}

-(void) jump {
    if (!self.isJumping) {
        [self.physicsBody applyImpulse:CGVectorMake(0, 100)];
        [self runAction:[SKAction playSoundFileNamed:@"onJump.wav" waitForCompletion:NO]];
        
        self.isJumping = YES;
    }
}

-(void) land {
    self.isJumping = NO;
}

-(void) start {
    SKAction *incrementRight = [SKAction moveByX:1.0 y:0 duration:0.004];
    SKAction *moveRight = [SKAction repeatActionForever:incrementRight];
    [self runAction:moveRight];
}

-(void) stop {
    [self removeAllActions];
}



@end
