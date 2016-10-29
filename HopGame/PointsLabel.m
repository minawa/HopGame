//
//  PointsLabel.m
//  HopGame
//
//  Created by Min on 10/26/16.
//  Copyright © 2016 All rights reserved.
//

#import "PointsLabel.h"

@implementation PointsLabel

+(id) pointLabelWithFontNamed: (NSString*) fontName {
    PointsLabel *pointsLabel = [PointsLabel labelNodeWithFontNamed:fontName];
    pointsLabel.text = @"0";
    pointsLabel.number = 0;
    return pointsLabel;
}

-(void) increment {
    self.number++;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}

-(void) setPoints: (int) points {
    self.number = points;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}

-(void) reset {
    self.number = 0;
    self.text = @"0";
}

@end
