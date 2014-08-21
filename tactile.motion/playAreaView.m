//
//  playAreaView.m
//  tactile.motion
//
//  Created by Timothy J on 21/08/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import "playAreaView.h"

@implementation playAreaView

-(void)drawRect:(CGRect)rect
{
    [self setBackgroundColor:[UIColor clearColor]];
    float origIncr = self.bounds.size.width / (2*_maxDistance);
    float orig = 0.0;
    float widthHeight = self.bounds.size.width;
    float widthHeightIncr = -2*origIncr;
    
    for (int i = 0; i < _maxDistance; i++,orig+=origIncr,widthHeight += widthHeightIncr) {
        CGRect circleRect = CGRectMake(orig, orig, widthHeight, widthHeight);
        UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:circleRect];
        [[UIColor lightGrayColor] setStroke];
        [circle stroke];
    }
    CGRect sweetSpot = CGRectMake(self.bounds.size.width/2-10, self.bounds.size.width/2-10, 20, 20);
    UIBezierPath *sweetSpotCircle = [UIBezierPath bezierPathWithOvalInRect:sweetSpot];
    [[UIColor colorWithRed:36/255.0 green:103/255.0 blue:124/255.0 alpha:1.0]setFill];
    [sweetSpotCircle fill];
}

@end
