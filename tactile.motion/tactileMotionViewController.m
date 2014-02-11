//
//  tactileMotionViewController.m
//  tactile.motion
//
//  Created by Bridget Johnson on 4/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import "tactileMotionViewController.h"
#import "audioObjectView.h"

#define kNumAudioObjects 8

@implementation tactileMotionViewController


- (void)viewDidLoad
{
       [super viewDidLoad];
       [self audioObjectInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)audioObjectInit
{
   _audioObjects = [NSMutableArray arrayWithCapacity:0];
   CGRect bounds = [[self view] bounds];
   
   float boxWidth = 76;
   float gapWidth = (bounds.size.width - (boxWidth*kNumAudioObjects)) / (kNumAudioObjects + 1);
   
   float x = gapWidth;
   float y = bounds.size.height - gapWidth - boxWidth;
   
   float xIncr = boxWidth + gapWidth;
   
   for (int i=0;i<kNumAudioObjects;i++,x+=xIncr) {
      CGRect rect = CGRectMake(x,y,boxWidth,boxWidth);
      audioObjectView *objectView = [[audioObjectView alloc] initWithFrame:rect
                                                                    colour: [self objectColour:i]
                                                                     label:@"Bob"];
      [objectView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:objectView action:@selector(dragging:)]];
      [_audioObjects addObject:objectView];
      [[self view] addSubview:objectView];
      [objectView setNeedsDisplay];
      
   }
}

-(UIColor *)objectColour: (NSInteger) position
{
   NSMutableArray *colourPallete = [[NSMutableArray alloc] initWithObjects:
                                    [UIColor colorWithRed:67/255.0 green:245/255.0 blue:86/255.0 alpha:0.8],
                                    [UIColor colorWithRed:211/255.0 green:81/255.0 blue:81/255.0 alpha:0.8],
                                    [UIColor colorWithRed:48/255.0 green:118/255.0 blue:191/255.0 alpha:0.8],
                                    [UIColor colorWithRed:143/255.0 green:79/255.0 blue:229/255.0 alpha:0.8],
                                    [UIColor colorWithRed:240/255.0 green:229/255.0 blue:22/255.0 alpha:0.8],
                                    [UIColor colorWithRed:75/255.0 green:142/255.0 blue:72/255.0 alpha:0.8],
                                    [UIColor colorWithRed:201/255.0 green:43/255.0 blue:93/255.0 alpha:0.8],
                                    [UIColor colorWithRed:15/255.0 green:206/255.0 blue:205/255.0 alpha:0.8], nil];

   return [ colourPallete objectAtIndex:position];

}

@end
