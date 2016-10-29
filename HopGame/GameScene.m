//
//  GameScene.m
//  HopGame
//
//  Created by Min on 10/25/16.
//  Copyright (c) 2016. All rights reserved.
//

#import "GameScene.h"
#import "MyHero.h"
#import "WorldGenerator.h"
#import "PointsLabel.h"
#import "GameData.h"

@interface GameScene ()
@property BOOL isStarted;
@property BOOL isGameOver;
@end


@implementation GameScene {
    MyHero *hero;
    SKNode *world;
    WorldGenerator *generator;
}
static NSString *GAME_FONT = @"AmericanTypewriter-Bold"; //@"Helvetica";

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.anchorPoint = CGPointMake(0.5,0.5);
    self.physicsWorld.contactDelegate = self;
    
    [self createContent];
 
}

-(void) createContent {
    self.backgroundColor = [SKColor colorWithRed:0.54 green:0.7853 blue:1.0 alpha:1.0];
    world  = [SKNode node];
    [self addChild:world];
    
    generator = [WorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    [generator populate];
    
    hero = [MyHero hero];
    [world addChild:hero];
    
    [self loadScoreLabels];
    
    SKLabelNode *tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToBeginLabel.name = @"tapToBeginLabel";
    tapToBeginLabel.text = @"tap to begin";
    tapToBeginLabel.fontSize = 20.0;
    [self addChild:tapToBeginLabel];
    
    [self animateWithPulse:tapToBeginLabel];
    
}

-(void) loadScoreLabels {
    PointsLabel *pointsLabel = [PointsLabel pointLabelWithFontNamed:GAME_FONT];
    pointsLabel.name = @"pointsLabel";
    pointsLabel.position = CGPointMake(-200, 100);
    [self addChild:pointsLabel];
    
    GameData *data = [GameData data];
    [data load];
    
    PointsLabel *highscoreLabel = [PointsLabel pointLabelWithFontNamed:GAME_FONT];
    highscoreLabel.name = @"highscoreLabel";
    highscoreLabel.position = CGPointMake(200, 100);
    [highscoreLabel setPoints:data.highscore];
    [self addChild:highscoreLabel];
    
    SKLabelNode *bestLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    bestLabel.text = @"best";
    bestLabel.fontSize = 16.0;
    bestLabel.position = CGPointMake(-38, 0);
    [highscoreLabel addChild:bestLabel];
}

-(void) loadClouds {
  //  SKShapeNode *cloud1 = [SKShapeNode node];
  //  cloud1.path = [NSBezierPath bezierPathWithOvalInRect:CGRectMake(0, 65, 100, 40)].bezierPath;
    
}

-(void) start {
    self.isStarted = YES;
    [[self childNodeWithName:@"tapToBeginLabel"] removeFromParent];
    [hero start];
}

-(void) clear {
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:scene];
}

-(void) gameOver {
    self.isGameOver = YES;
    [hero stop];
    [self runAction:[SKAction playSoundFileNamed:@"onGameOver.mp3" waitForCompletion:NO]];
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.text = @"Game Over";
    gameOverLabel.position = CGPointMake(0, 100);
    [self addChild:gameOverLabel];
    
    SKLabelNode *tapToResetLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToResetLabel.name = @"tapToResetLabel";
    tapToResetLabel.text = @"tap to reset";
    tapToResetLabel.fontSize = 20.0;
    [self addChild:tapToResetLabel];
    
    [self animateWithPulse:tapToResetLabel];
    [self updateHighScore]; 
}

-(void) updateHighScore {
    PointsLabel *pointsLabel = (PointsLabel*) [self childNodeWithName:@"pointsLabel"];
    PointsLabel *highscoreLabel = (PointsLabel*) [self childNodeWithName:@"highscoreLabel"];
    
    if (pointsLabel.number> highscoreLabel.number) {
        [highscoreLabel setPoints:pointsLabel.number];
        GameData *data = [GameData data];
        data.highscore = pointsLabel.number;
        [data save];
    }
}


-(void) didSimulatePhysics {
    [self centerOnNode: hero];
    [self handlePoints];
    [self handleGeneration];
    [self handleCleanup];

}
-(void) handlePoints {
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x) {
            PointsLabel *pointsLabel = (PointsLabel*) [self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
        }
    }];
}

-(void) handleGeneration {
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x <hero.position.x) {
            node.name = @"obstacle_Cancelled";
            [generator generate];
        }
    }];
}

-(void) handleCleanup {
    [world enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x <hero.position.x -self.frame.size.width/2 - node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
    [world enumerateChildNodesWithName:@"obstacle_cancelled" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x <hero.position.x - self.frame.size.width/2 - node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
}


-(void) centerOnNode: (SKNode*) node {
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x-positionInScene.x, world.position.y);
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    if (!self.isStarted) {
        [self start];
    } else if (self.isGameOver) {
        [self clear];
    } else {
        [hero jump];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void) didBeginContact:( SKPhysicsContact *)contact {
    
    if ([contact.bodyA.node.name isEqualToString:@"ground"] || [contact.bodyB.node.name isEqualToString:@"ground"]) {
        [hero land];
    } else {
        [self gameOver];
    }
}

//** Animation Section **//

-(void) animateWithPulse: (SKNode*) node {
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:1.0];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:1.0];
    SKAction *pulse = [SKAction sequence:@[disappear,appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}


@end
