////
//  phantomView.m
//  tactile.motion
//
//  Created by Timothy J on 9/05/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import "phantomView.h"
#import "UIKit/UIKit.h"

@implementation phantomView

- (id)initWithFrame:(CGRect)frame
             colour:(UIColor*)col
              label:(NSString*)str
{
   self = [super initWithFrame:frame];
   if (self) {
      // Initialization code
   }
   self.layer.opacity = 0.3;
   [self setBackgroundColor:[UIColor clearColor]];
   //Set variable colour to the intended colour
   _colour = col;
   
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

   return self;
}

-(void)doubleTapOccured:(UITapGestureRecognizer *)doubleTap{
   doubleTap.numberOfTapsRequired = 2;
   _doubletapflag = TRUE;
   
}

-(void)singleTapOccured:(UITapGestureRecognizer *)singleTap{
   singleTap.numberOfTapsRequired = 1;
   _singletapflag = TRUE;
   NSLog(@"Single Tap flag has been set");
   
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   int width  = self.frame.size.width;
   int height = self.frame.size.height;
   //Get the CGContext to draw into
   CGContextRef myContext = UIGraphicsGetCurrentContext();
   //Save the current state
   CGContextSaveGState(myContext);
   //Move position to center in order to...
   CGContextSetFillColorWithColor(myContext, [_colour CGColor]);
   //Draw an ellipse
   CGContextFillEllipseInRect(myContext, CGRectMake(0, 0, width, height));
   //OR draw a rectangle
   
}


@end