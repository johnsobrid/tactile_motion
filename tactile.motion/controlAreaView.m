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

-(CGFloat)euroOffset { return ([self speakerDivision]/2);}
-(CGFloat)speakerDivision { return M_PI/(NUM_OF_SPEAKERS/2);}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
   [self drawCircle]; //call method to draw the circles
   [self positionSpeakers];
   
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
   CGRect sweetSpot = CGRectMake(self.bounds.size.width/2-10, self.bounds.size.width/2-10, 20, 20);
   UIBezierPath *sweetSpotCircle = [UIBezierPath bezierPathWithOvalInRect:sweetSpot];
   [[UIColor colorWithRed:36/255.0 green:103/255.0 blue:124/255.0 alpha:1.0]setFill];
   [sweetSpotCircle fill];
}

-(void)positionSpeakers
{
   CGContextRef context = UIGraphicsGetCurrentContext();
   // save the cordinate scheme
   for (int i = 0; i < NUM_OF_SPEAKERS; i++) {
      CGContextSaveGState(context);
      // translate it to the centre of the listening space
      CGContextTranslateCTM(context, self.bounds.size.width/2, self.bounds.size.width/2);
      // rotate to the angle where the speaker should be depending on the NUM_OF_SPEAKERS
      CGContextRotateCTM(context, ([self euroOffset] + (i*[self speakerDivision])));
      // translate to the edge of the speaker array
      CGContextTranslateCTM(context, (self.bounds.size.width/2.93)-(SPEAKER_SIZE*0.5),((self.bounds.size.width/2.93))-(SPEAKER_SIZE*0.5));
      // call the draw speaker functions
      [self drawSpeakers];
      //return the coordinate scheme
      CGContextRestoreGState(context);
   }
}

-(void)drawSpeakers
{
   //save coordinate scheme
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSaveGState(context);
   //rotate so the speakers face the centre
   CGContextRotateCTM(context, 2.3);
   //call method to draw the rect(which in turn calls the triange)
   [self drawSpeakerRect:CGPointMake(0.0, 0.0)];
   //return scheme
    CGContextRestoreGState(context);
}

-(void)drawSpeakerRect:(CGPoint)rectPos
{
   UIBezierPath *speakerRect = [UIBezierPath bezierPathWithRect:CGRectMake(rectPos.x-SPEAKER_SIZE, rectPos.y-SPEAKER_SIZE, SPEAKER_SIZE, SPEAKER_SIZE)];
   [[UIColor colorWithRed:36/255.0 green:103/255.0 blue:124/255.0 alpha:1.0]setFill];
   [speakerRect fill];
   [self drawSpeakerTri:rectPos];
}

-(void)drawSpeakerTri:(CGPoint)rectPos
{
   CGPoint pointA = CGPointMake(rectPos.x-(SPEAKER_SIZE/2), rectPos.y);
   CGPoint pointB = CGPointMake(rectPos.x - (SPEAKER_SIZE), rectPos.y + (SPEAKER_SIZE/2));
   CGPoint pointC = CGPointMake(rectPos.x, rectPos.y + (SPEAKER_SIZE/2));
   
   UIBezierPath   *trianglePath = [[UIBezierPath alloc]init];
   [trianglePath moveToPoint:pointA];
   [trianglePath addLineToPoint:pointB];
   [trianglePath addLineToPoint:pointC];
   [trianglePath closePath];
   [[UIColor colorWithRed:36/255.0 green:103/255.0 blue:124/255.0 alpha:1.0]setFill];
   [trianglePath fill];
  
}
@end
