//
//  controlAreaView.m
//  tactile.motion
//
//  Created by Bridget Johnson on 4/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import "controlAreaView.h"

@implementation controlAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define MAX_DISTANCE 5

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
   [self drawCircle]; //call method to draw the circles
}

-(void)drawCircle
{
   float origIncr = self.bounds.size.width / (2*MAX_DISTANCE);
   float orig = 0.0;
   float widthHeight = self.bounds.size.width;
   float widthHeightIncr = -2*origIncr;
   
   for (int i = 0; i < MAX_DISTANCE; i++,orig+=origIncr,widthHeight += widthHeightIncr) {
      CGRect circleRect = CGRectMake(orig, orig, widthHeight, widthHeight);
      UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:circleRect];
      [[UIColor lightGrayColor] setStroke];
      [circle stroke];
   }
   
}

@end
