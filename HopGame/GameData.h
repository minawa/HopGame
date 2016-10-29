//
//  GameData.h
//  HopGame
//
//  Created by Min on 10/27/16.
//  Copyright © 2016. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject
@property int highscore;

+(id) data;
-(void) save;
-(void) load; 

@end
