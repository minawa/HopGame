//
//  GameData.m
//  HopGame
//
//  Created by Min on 10/27/16.
//  Copyright © 2016. All rights reserved.
//

#import "GameData.h"

@interface GameData()
@property NSString *filePath;

@end


@implementation GameData

+(id) data {
    GameData *data = [[GameData alloc] init];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = @"archive.data";
    data.filePath =[path stringByAppendingString:fileName];
    return data;
}

-(void) save {
    NSNumber *highscoreObject = [NSNumber numberWithInteger:self.highscore];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:highscoreObject];
    [data writeToFile:self.filePath atomically:YES];
    
}

-(void) load {
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    NSNumber *highscoreObject =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.highscore = highscoreObject.intValue;
}


@end
