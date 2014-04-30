//
//  audioObjectView.m
//  tactile.motion
//
//  Created by Bridget Johnson on 5/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import "audioObjectView.h"

@implementation audioObjectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
          }
    return self;
}

- (id)initWithFrame:(CGRect)frame
             colour:(UIColor*)col
              label:(NSString*)str
{
   self = [super initWithFrame:frame];
   if (self) {
      [self setBackgroundColor:col];
      [self setLabel:str];
   }
   return self;
}

-(void) dragging:(UIPanGestureRecognizer *)pan
{
   if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
      
      CGPoint delta = [pan translationInView:self];
      CGPoint centre = self.center;
      centre.x += delta.x;
      centre.y += delta.y;
      self.center = centre;
      [pan setTranslation:CGPointZero inView:self];
      // at this point we also need to send some type of message out as the position changes
      _dragVelocity = [pan velocityInView:self];
      _currentD = [self getObjectD:self.center];

    
       [self setMyCenter:self.center];
   }
   if (pan.state == UIGestureRecognizerStateBegan)
   {
      [self setStartPoint:self.center];
   }
   if(pan.state == UIGestureRecognizerStateEnded)
   {
       _endPoint = self.center;
      [self setEndPoint:self.center];
    //    NSLog([NSString stringWithFormat:@"veloc %f %f", _dragVelocity.x, _dragVelocity.y]);
      //here we need to also find a way to make this reset
   }
}
-(void)doubleTapOccured:(UITapGestureRecognizer *)doubleTap
{
      doubleTap.numberOfTapsRequired = 2;
      //put something in here that stops the spin motion
      NSLog(@"doubleTap");
      _motion = YES;
}

-(void)spin
{
   // float radialChange = 0.1; //this should be the velocity
   
   if (_motion == YES) {
      CGPoint newPoint;
      float velocity = -0.01;
      //get the angle in polar
      _currentAngle = [self getObjectAngle:self.center];
      NSLog([NSString stringWithFormat:@" %f",_currentAngle]);
      
      //increase the theta by how ever much is needed
      _currentAngle += velocity;
      
      if (_currentAngle > (M_PI *2))
          {
             _currentAngle = 0.0;
          }
      if (_currentAngle < 0.00) {
         _currentAngle = ((M_PI *2)-0.01);
      }
   //   NSLog([NSString stringWithFormat:@"angle %f", _currentAngle]);
      
      // then convert that data back to cartesian co-ords
      newPoint.x = [self getXpos:_currentAngle fromD:_currentD];
      newPoint.y = [self getYpos:_currentAngle fromD:_currentD];
      
      // and translate the view to the position and update my centre
      self.center = newPoint;
      
      [self setMyCenter:self.center];
      [self setNeedsDisplay];
   }
}

- (float)getObjectAngle:(CGPoint)position {
   // Translate into cartesian space with origin at the center of a 320-pixel square
  // CGPoint cavcenter = controlArea.center;

   //these values are hard coded but they should be the centre of the control area view
   
   float x = position.x - 384.0;
   float y = -(position.y - 512);
   // Take care not to divide by zero!
   
  float theta = atan2f(y,x);
   if (theta < 0.0)
   {
    theta = theta + (M_PI *2);
   }
   return theta;
}
-(float)getObjectD:(CGPoint)position
{
   float x = position.x - 384.0;
   float y = -(position.y - 512);
   
   float distance = sqrtf(x * x + y * y);
   
   return distance;
}
-(float)getXpos:(float)angle fromD:(float)d
{
    float x = d * cos(angle);
    float y = d * sin(angle);
   
   //hard coding is bad -- fix it
   
   if(x >= 0 && y >= 0)
   {
      x = (384.0 + x);
   }
   else if(x > 0 && y < 0) {
      x = (384.0 + x);
   }
   else if(x < 0 && y < 0) {
      x = (384.0- abs(x));
   }
   else if(x < 0 && y > 0) {
      x = (384.0 - abs(x));
   }
   
   return x;

}
-(float)getYpos:(float)angle fromD:(float)d
{
   float y = d * sin(angle);
   float x = d * cos(angle);
 
   //hard coding is bad -- fix it

   if (x >= 0 && y >= 0)
   {
      y = 512 - y;
   }
   else if(x > 0 && y < 0) {
      y = 512 + abs(y);
   }
   else if(x < 0 && y < 0) {
      y = 512  + abs(y);
   }
   else if(x < 0 && y > 0) {
      y = 512  - y;
   }
   
   return y;

}
@synthesize myCenter;
@end
