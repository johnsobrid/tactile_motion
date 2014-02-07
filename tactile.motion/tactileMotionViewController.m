//
//  tactileMotionViewController.m
//  tactile.motion
//
//  Created by Bridget Johnson on 4/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import "tactileMotionViewController.h"
#import "audioObjectView.h"

#define kNumAudioObjects 4

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
                                                                    colour:[UIColor whiteColor]
                                                                     label:@"Bob"];
      [objectView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:objectView action:@selector(dragging:)]];
      [_audioObjects addObject:objectView];
      [[self view] addSubview:objectView];
      [objectView setNeedsDisplay];
      
   }
}

@end
