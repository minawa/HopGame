//
//  WorldGenerator.h
//  HopGame
//
//  Created by Min on 10/26/16.
//  Copyright © 2016. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WorldGenerator : SKNode

+(id) generatorWithWorld: (SKNode*) world;
-(void)populate; 
-(void) generate;

@end
