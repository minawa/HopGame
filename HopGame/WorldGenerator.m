//
//  WorldGenerator.m
//  HopGame
//
//  Created by Min on 10/26/16.
//  Copyright © 2016 All rights reserved.
//

#import "WorldGenerator.h"

@interface WorldGenerator()
@property double currentGroundX;
@property double currentObstacleX;
@property SKNode *world;
@end

@implementation WorldGenerator
static const uint32_t obstacleCategory = 0x1<<1;
static const uint32_t groundCategory = 0x1 <<2;

+(id) generatorWithWorld: (SKNode*) world {
    WorldGenerator *generator = [WorldGenerator node];
    generator.currentGroundX=0;
    generator.currentObstacleX = 400;
    generator.world = world;
    return generator;
}

-(void) populate {
    for (int i =0; i<3; i++) {
        [self generate]; 
    }
}

-(void) generate {

    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor:[NSColor greenColor] size:CGSizeMake(self.scene.frame.size.width, 200)];
    ground.name = @"ground";
    ground.position = CGPointMake(self.currentGroundX, -self.scene.frame.size.height/2+ground.frame.size.height/2);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.categoryBitMask = groundCategory;
    ground.physicsBody.dynamic = NO;
    [self.world addChild:ground];
    
    self.currentGroundX += ground.frame.size.width;
    
    SKSpriteNode *obstacle = [SKSpriteNode spriteNodeWithColor:[self getRandomColor] size:CGSizeMake(40,50)];
    obstacle.name = @"obstacle"; 
    obstacle.position = CGPointMake(self.currentObstacleX, ground.position.y + ground.frame.size.height/2+obstacle.frame.size.height/2);
    obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstacle.size];
   
    obstacle.physicsBody.categoryBitMask = obstacleCategory;
    
    obstacle.physicsBody.dynamic = NO;
    
    [self.world addChild:obstacle];
    self.currentObstacleX += 250;
}

-(NSColor*) getRandomColor {
    int rand = arc4random() %6;
    NSColor *color;
    switch (rand) {
        case 0:
            color = [NSColor redColor];
            break;
        case 1:
            color = [NSColor orangeColor];
            break;
        case 2:
            color = [NSColor yellowColor];
            break;
        case 3:
            color = [NSColor greenColor];
            break;
        case 4:
            color = [NSColor purpleColor];
            break;
        case 5:
            color = [NSColor blueColor];
            break;
        default:
            break;
    }
    return color;
}

@end
