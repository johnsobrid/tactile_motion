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

@interface tactileMotionViewController ()
@property (strong, nonatomic) IBOutlet UITextField *ipInputField;
@property (strong, nonatomic) IBOutlet UITextField *portInputField;

@end

@implementation tactileMotionViewController
- (IBAction)playPressed:(id)sender {
   [self oscSend:[NSString stringWithFormat:@"/play/1"]];
}
- (IBAction)stopPressed:(id)sender {
   [self oscSend:[NSString stringWithFormat:@"/play/0"]];
}



- (id) init	{
	if (self = [super init])
   {
      //	by default, the osc manager's delegate will be told when osc messages are received
      [manager setDelegate:self];
   }
   return self;
}


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
   float gapWidth = (bounds.size.width - (boxWidth * kNumAudioObjects)) / (kNumAudioObjects + 1);
   float x = gapWidth;
   float y = bounds.size.height - gapWidth - boxWidth;
   
   float xIncr = boxWidth + gapWidth;
   
   for (int i=0;i< kNumAudioObjects;i++,x+=xIncr) {
      CGRect rect = CGRectMake(x,y,boxWidth,boxWidth);
      audioObjectView *objectView = [[audioObjectView alloc] initWithFrame:rect
                                                                    colour: [self objectColour:i]
                                                                     label:[NSString stringWithFormat:@"%i",i]];
      [objectView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:objectView action:@selector(dragging:)]];
      [_audioObjects addObject:objectView];
      [[self view] addSubview:objectView];
      [objectView setNeedsDisplay];
      [objectView addObserver:self
                 forKeyPath:@"myCenter"
                    options:(NSKeyValueObservingOptionNew |
                             NSKeyValueObservingOptionOld)
                    context:NULL];
   }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"myCenter"]) {
        audioObjectView *theAudioObjectView = object;
        NSString *label = [theAudioObjectView label];
        CGPoint loc = theAudioObjectView.myCenter;
        // get center of control area view
        CGPoint cavcenter = controlArea.center;
       
        loc.x -= cavcenter.x;
        loc.y -= cavcenter.y;
        float d = sqrtf(loc.x*loc.x+loc.y*loc.y);
        d = d/(controlArea.bounds.size.width/2)*MAX_DISTANCE;
        float theta = atan2f(loc.y,loc.x);
        if (theta < 0.0)
        {
           theta = theta + (M_PI *2);
        }
        [self setStatus:[NSString stringWithFormat:@"object %@ xPos %.2f yPos %.2f d %.2f theta%.2f",label,loc.x,loc.y,d,theta]];
       [self oscSend:[NSString stringWithFormat:@"%@/%.2f/%.2f", label, d,theta]]; // should we do this here or from the objects view?
       
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

- (void)setStatus:(NSString*)status {
    [statusField setText:status];
}

-(void)oscSend:(NSString *)messageString
{
   //send the position over OSC
   manager = [[OSCManager alloc]init]; //if this line of code is here then it works, but it doesn't seem to make much sense to me as to why we would put it here, in demo's they put it in the init function but when I place it there it creates errors
   outPort = [manager createNewOutputToAddress:[self.ipInputField text] atPort:[[self.portInputField text]intValue] withLabel:@"Output"];

   
   OSCMessage *newMessage = [OSCMessage createWithAddress:messageString];
   
   [outPort sendThisMessage:newMessage];

}

@end

