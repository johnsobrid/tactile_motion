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
   //   _currentD = [self getObjectD:self.center];
      [self updateFrame];
      if (_d < _cavWidth) {
         [self setMyCenter:self.center];
      }
   }
   if (pan.state == UIGestureRecognizerStateBegan)
   {
      [self setStartPoint:self.center];
   }
   if(pan.state == UIGestureRecognizerStateEnded)
   {
       _endPoint = self.center;
      [self setEndPoint:self.center];
      //NSLog([NSString stringWithFormat:@"veloc %f %f", _dragVelocity.x, _dragVelocity.y]);
      //here we need to also find a way to make this reset
   }
}
-(void)doubleTapOccured:(UITapGestureRecognizer *)doubleTap
{
//send a message to return the animator back to zero
   [doubleTap setNumberOfTapsRequired:2];
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
   [self setMyCenter:self.center];
}

-(void)vertDragWithDT:(float)dt
{
   float newY;
   //hard coding is bad -- the area limit should be the edge of the control area
   
   if (_endPoint.y < _startPoint.y) {
      newY = _y + _angularVelocity * dt;
   } else
   {
      newY = _y - _angularVelocity * dt;
   }      //if you are less than the old x you are going towards the left therefore take away from value
    newY = [self constrainDistance:newY];
   [self setY:newY];
   [self setMyCenter:self.center];
}
-(void)horoDragWithDT:(float)dt
{
   float newX;
   if (_endPoint.x > _startPoint.x) {
      //you are going right so add to the value
      newX = _x +_angularVelocity * dt;
   } else
   {
      newX = _x -_angularVelocity * dt;
   }   //if you are less than the old x you are going towards the left therefore take away from value
    newX = [self constrainDistance:newX];
    [self setX:newX];
   [self setMyCenter:self.center];
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
    CGContextRotateCTM(myContext, _theta);
    //Move it back into position
    CGContextTranslateCTM(myContext, -width/2, -height/2);
    //Set the fill colour to the colour variable
    CGContextSetFillColorWithColor(myContext, [_colour CGColor]);
    //Draw an ellipse
    CGContextFillEllipseInRect(myContext, CGRectMake(0, 0, width, height));
    //OR draw a rectangle
   // CGContextFillRect(myContext, CGRectMake(0, 0, width, height));
   _objectNumber.textColor = [UIColor whiteColor];
   
}
//This part was tricky because it has to return a value to
//make sure the newX and newY will be updated to make sure
//the distance encoding is done correctly.
- (float)constrainDistance:(float)value{
    float w = self.frame.size.width;
    if (_d > _cavWidth - w){
        _angularVelocity *= -1.0;
        value = floorf(value);
        value += (0.1 * _angularVelocity);
    }
    return value;
}



@end
