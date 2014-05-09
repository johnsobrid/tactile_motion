//
//  audioObjectView.m
//  tactile.motion
//
//  Created by Bridget Johnson on 5/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import "audioObjectView.h"
#define TWO_PI (M_PI *2)

enum {
   kNone = 0,
   kSpin,
   kHoroDrift,
   kVertDrift
};

@implementation audioObjectView


- (id)initWithFrame:(CGRect)frame
             colour:(UIColor*)col
              label:(NSString*)str
{
   self = [super initWithFrame:frame];
   if (self) {
      [self updateFrame];
      _animator = kNone;
       //Removed this line to stop the colour being automatically set
       //If you look at the drawRect function that's where this should be done anyway.
       //[self setBackgroundColor:col];
       
       //Replaced with these lines instead:
            //Set Background to transparent
      [self setBackgroundColor:[UIColor clearColor]];
       //Set variable colour to the intended colour
       _colour = col;
       
      [self setLabel:str];
      UILabel *textField = [[UILabel alloc] initWithFrame:[self bounds]];
      
      textField.text = str;
      textField.font = [UIFont fontWithName:@"Helvetica" size:28];
      textField.textColor = [UIColor whiteColor];
      textField.backgroundColor = [UIColor clearColor];
      textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      textField.textAlignment = NSTextAlignmentCenter;
      //   textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
      
      //[self setTextField:textField];
      [self addSubview:textField];
       NSLog(@"%f,     %f",_x,_y);
       [self setX:_x];
       [self setY:_y];
       [self setHome];
   }
    
   return self;
}

-(void) dragging:(UIPanGestureRecognizer *)pan
{
   if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
      _needsMessage = YES;
      CGPoint delta = [pan translationInView:self];
      CGPoint centre = self.center;
      centre.x += delta.x;
      centre.y += delta.y;
      self.center = centre;
      [pan setTranslation:CGPointZero inView:self];
      // at this point we also need to send some type of message out as the position changes
      _dragVelocity = [pan velocityInView:self];
   //   _currentD = [self getObjectD:self.center];
      [self updateFrame];
      
       [self setMyCenter:self.center];
   }
   if (pan.state == UIGestureRecognizerStateBegan)
   {
      [self setStartPoint:self.center];
      _needsMessage = YES;
   }
   if(pan.state == UIGestureRecognizerStateEnded)
   {
       _endPoint = self.center;
      [self setEndPoint:self.center];
      _needsMessage = YES;
   }
}
-(void)doubleTapOccured:(UITapGestureRecognizer *)doubleTap
{
//send a message to return the animator back to zero
   doubleTap.numberOfTapsRequired =2;
   _animator = 0;
}

-(void)updateFrame
{
   _x = self.center.x - _cavWidth;
   _y = _cavHeight - self.center.y;
   _d = sqrtf(_x * _x + _y * _y);
   _theta = atan2f(_y,_x);
}

-(void) beginSpinWithAngularVelocity:(float)f
{
   _animator = kSpin;
   _angularVelocity = f;
}
-(void) beginVertDrag:(float)f
{
   _animator = kVertDrift;
   _angularVelocity = f;
}

-(void)beginHoroDrag:(float)f
{
   _animator = kHoroDrift;
   _angularVelocity = f;

}
-(void)animateWithDT:(float)dt
{
   switch (_animator) {
      case kNone:
         //do nothing
         break;
         
      case kSpin:
         [self spinWithDT:dt];
         break;
         
      case kVertDrift:
         //call the drift
         [self vertDragWithDT:dt];
         break;
         
      case kHoroDrift:
         [self horoDragWithDT:dt];
         break;
         
      default:
         break;
   }
}
-(void)spinWithDT:(float)dt
{
   //increase the theta by how ever much is needed
     float newTheta= _theta + _angularVelocity *dt;
   //keep it within the appropriate range
    
      if (newTheta > TWO_PI) newTheta  -=TWO_PI;
      if (newTheta < 0) newTheta += TWO_PI;

   //   NSLog([NSString stringWithFormat:@"angle %f", _currentAngle]);
   [self setTheta:newTheta];
    _needsMessage = YES;
}

-(void)vertDragWithDT:(float)dt
{
    float newY;
    if (fabsf(_d) > _cavWidth - self.frame.size.width/2){
        _angularVelocity *= -1.0;
    }
    newY = _y + _angularVelocity * dt;
   [self setY:newY];
    _needsMessage = YES;
}
-(void)horoDragWithDT:(float)dt
{
    float newX;
    if (fabsf(_d) > _cavWidth - self.frame.size.width/2){
        _angularVelocity *= -1.0;
    }
    newX = _x + _angularVelocity * dt;
   [self setX:newX];
    _needsMessage = YES;
}

-(void)setTheta:(float)theta
{
   _theta = theta;
    _x = _d * cos(_theta);
   _y = _d * sin(_theta);
   [self updatePosition];
}
-(void)setD:(float)d
{
   _d = d;
   _x = _d * cos(_theta);
   _y = _d * sin(_theta);
   [self updatePosition];
}
-(void)setX:(float)x
{
   _x = x;
    _d = sqrtf(_x * _x + _y * _y);
   _theta = atan2f(_y,_x);
   [self updatePosition];
}
-(void)setY:(float)y
{
   _y = y;
   _d = sqrtf(_x * _x + _y * _y);
   _theta = atan2f(_y,_x);
   [self updatePosition];
}

-(void)updatePosition
{
   self.center = CGPointMake(_x + _cavWidth, _cavHeight -_y );
   [self setNeedsDisplay];
}

//This is where you draw the view's rectangle instead of just
//setting the background colour, it allows you more customization
//drawRect is inherited from UIView and will draw everytime
//setNeedsDisplay is called.

- (void)drawRect:(CGRect)theView{
    
    //Get width and height of the view
    int width  = self.frame.size.width;
    int height = self.frame.size.height;
    //Get the CGContext to draw into
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    //Save the current state
    CGContextSaveGState(myContext);
    //Move position to center in order to...
    CGContextTranslateCTM(myContext, width/2, height/2);
    //Rotate it about it's center with the rotation variable
    //CGContextRotateCTM(myContext, _theta);
    //Move it back into position
    CGContextTranslateCTM(myContext, -width/2, -height/2);
    //Set the fill colour to the colour variable
    CGContextSetFillColorWithColor(myContext, [_colour CGColor]);
    //Draw an ellipse
    CGContextFillEllipseInRect(myContext, CGRectMake(0, 0, width, height));
    //OR draw a rectangle
   // CGContextFillRect(myContext, CGRectMake(0, 0, width, height));
}

- (void)goHome{
    //These values are almost right,
   CGRect bounds = [[self superview] bounds];
   
   float boxWidth = 76;
   float gapWidth = (bounds.size.width - (boxWidth * _numOfObjects)) / (_numOfObjects + 1);
   float yPos = bounds.size.height - (boxWidth *1.5);
   float xoff = self.superview.bounds.size.width/2;
   
   float xIncr = boxWidth + gapWidth;
   float xPos = (_myIndex * xIncr) - xoff + (3*boxWidth/4);
    [self setX:xPos];
    [self setY:-yPos/2];
}

- (void)setHome{
   // CGPoint home = [self convertPoint:self.frame.origin toView:self.superview];
    //NSLog(@"%i",_cavWidth);
    _homePosition.x = _x - (self.superview.frame.size.width);
   _homePosition.y = _y - (self.superview.frame.size.width);
   
}



@end
