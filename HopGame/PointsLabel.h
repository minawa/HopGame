//
//  PointsLabel.h
//  HopGame
//
//  Created by Min on 10/26/16.
//  Copyright © 2016 Mina. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PointsLabel : SKLabelNode
@property int number;

+(id) pointLabelWithFontNamed: (NSString*) fontName ;
-(void) increment;
-(void) setPoints: (int) points;
-(void) reset; 


@end
