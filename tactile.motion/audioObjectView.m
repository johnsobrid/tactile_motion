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
      //here we need to also find a way to make this reset
   }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*- (void)drawRect:(CGRect)rect
{
 
}*/
@synthesize myCenter;
@end
