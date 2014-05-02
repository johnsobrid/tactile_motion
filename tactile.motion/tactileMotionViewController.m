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
#define kAnimationInterval 0.1

@interface tactileMotionViewController ()


@end

@implementation tactileMotionViewController


- (IBAction)playPressed:(id)sender {
   [self oscSendState:@"/play" withState:1];
}
- (IBAction)stopPressed:(id)sender {
   [self oscSendState:@"/play" withState:0];
}

- (void)viewDidLoad
{
       [super viewDidLoad];
       [self audioObjectInit];
   //	by default, the osc manager's delegate will be told when osc messages are received
   [manager setDelegate:self];
   
   //use these settings to adjust the circle recogniser
   _circleClosureAngleVariance = 45.0;
   _circleClosureDistanceVariance = 200.0;
   _maximumCircleTime = 3.0;
   _radiusVariancePercent = 25.0;
   _overlapTolerance = 3;
   _minimumNumPoints = 6;
   points = [[NSMutableArray alloc] init];
   _firstTouch = CGPointZero;
   _firstTouchTime = 0.0;
   _center = CGPointZero;
   _radius = 0.0;
   animationTimer = [NSTimer scheduledTimerWithTimeInterval:kAnimationInterval target:self selector:@selector(animateAudioObjects:) userInfo:nil repeats:YES];
   
}
-(void)viewWillAppear:(BOOL)animated
{
   manager = [[OSCManager alloc]init]; //if this line of code is here then it works, but it doesn't seem to make much sense to me as to why we would put it here, in demo's they put it in the init function but when I place it there it creates errors
   outPort = [manager createNewOutputToAddress:_AddressInUse atPort:[_portInUse intValue] withLabel:@"Output"];
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
      [objectView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:objectView action:@selector(doubleTapOccured:)]];

      [_audioObjects addObject:objectView];
      [[self view] addSubview:objectView];
      [objectView setNeedsDisplay];
      [objectView addObserver:self
                 forKeyPath:@"myCenter"
                    options:(NSKeyValueObservingOptionNew |
                             NSKeyValueObservingOptionOld)
                    context:NULL];
      [objectView addObserver:self
                   forKeyPath:@"endPoint"
                      options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                      context:NULL];
      [objectView addObserver:self
                   forKeyPath:@"startPoint"
                      options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                      context:NULL];
   }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
   audioObjectView *theAudioObjectView = object;
   
   if ([keyPath isEqual:@"myCenter"]) {
      NSString *label = [theAudioObjectView label];
      CGPoint loc = theAudioObjectView.myCenter;
      [self updateCircle:loc];
      
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
      //this prints the data to the screen, we probably don't need it any more
      //  [self setStatus:[NSString stringWithFormat:@"object %@ xPos %.2f yPos %.2f d %.2f theta%.2f",label,loc.x,loc.y,d,theta]];
      
      [self oscSend:[NSString stringWithFormat:@"object%@", label] withD:d withTheta:theta];
   }
   else if ([keyPath isEqual:@"startPoint"]) {
      [self firstTouch:theAudioObjectView.startPoint];
      
   }
   else if ([keyPath isEqual:@"endPoint"]) {

      //this should be changed to a switch statement so it only checks the others if the first is not true
      circleDetected = [self checkCircle:theAudioObjectView.endPoint];
      if (circleDetected) {
         //then start the timer that calls the spin function
         [theAudioObjectView beginSpinWithAngularVelocity:M_PI/2];
      }
         vertDragDetected = [self checkDragVert:theAudioObjectView.endPoint];
      NSLog(vertDragDetected ? @"vertYes" : @"vertNO");
         if (vertDragDetected)
         {
            [theAudioObjectView beginVertDrag:100];
         }
         horoDragDetected = [self checkDragHoro:theAudioObjectView.endPoint];
      NSLog(horoDragDetected ? @"vertYes" : @"vertNO");

         if (horoDragDetected)
         {
            [theAudioObjectView beginHoroDrag:100];
         }
      [self circleReset];
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

-(void)oscSend:(NSString *)messageString withD:(float)d withTheta:(float)theta
{
   //send the position over OSC
   
   OSCMessage *newMessage = [OSCMessage createWithAddress:messageString];
   [newMessage addFloat:d];
   [newMessage addFloat:theta];
   [outPort sendThisMessage:newMessage];
}
-(void)oscSendState:(NSString *)messageString withState:(int)state
{
   //send the position over OSC
   
   OSCMessage *newMessage = [OSCMessage createWithAddress:messageString];
   [newMessage addInt:state];
   [outPort sendThisMessage:newMessage];
}

//animation

-(void)animateAudioObjects:(NSTimer *)animationTimer
{
   for (audioObjectView *object in _audioObjects) {
      // apply global physics, (gravity eg)
      
      //apply interactive animation (attractors ect)
      
      //apply autonmous animation
      [object animateWithDT:kAnimationInterval];
      
   }
}
//circle stuff
- (NSArray *) points
{
   NSMutableArray *allPoints = [points mutableCopy];
   [allPoints insertObject:NSStringFromCGPoint(_firstTouch) atIndex:0];
   return [NSArray arrayWithArray:allPoints];
}

// reset at the end of touch event
- (void) circleReset
{
   [points removeAllObjects];
   _firstTouch = CGPointZero;
   _firstTouchTime = 0.0;
   _center = CGPointZero;
   _radius = 0.0;
}

-(void)firstTouch:(CGPoint)position
{
   _firstTouch = position;
   _firstTouchTime = [NSDate timeIntervalSinceReferenceDate];
}
-(void)updateCircle:(CGPoint)position
{
   CGPoint startPoint = position;
   [points addObject:NSStringFromCGPoint(startPoint)];
}

-(BOOL)checkCircle:(CGPoint)endPoint
{
  // NSLog(@"checkingTheCircle");
   [points addObject:NSStringFromCGPoint(endPoint)];
   
   CGPoint leftMost = _firstTouch;
   NSUInteger leftMostIndex = NSUIntegerMax;
   CGPoint topMost = _firstTouch;
   NSUInteger topMostIndex = NSUIntegerMax;
   CGPoint rightMost = _firstTouch;
   NSUInteger  rightMostIndex = NSUIntegerMax;
   CGPoint bottomMost = _firstTouch;
   NSUInteger bottomMostIndex = NSUIntegerMax;
   
   // Loop through touches and find out if outer limits of the circle
   int index = 0;
   for ( NSString *onePointString in points ) {
      CGPoint onePoint = CGPointFromString(onePointString);
      if ( onePoint.x > rightMost.x ) {
         rightMost = onePoint;
         rightMostIndex = index;
      }
      if ( onePoint.x < leftMost.x ) {
         leftMost = onePoint;
         leftMostIndex = index;
      }
      if ( onePoint.y > topMost.y ) {
         topMost = onePoint;
         topMostIndex = index;
      }
      if ( onePoint.y < bottomMost.y ) {
         onePoint = bottomMost;
         bottomMostIndex = index;
      }
      index++;
   }
   
   // If startPoint is one of the extreme points, take set it
   if ( rightMostIndex == NSUIntegerMax ) {
      rightMost = _firstTouch;
   }
   if ( leftMostIndex == NSUIntegerMax ) {
      leftMost = _firstTouch;
   }
   if ( topMostIndex == NSUIntegerMax ) {
      topMost = _firstTouch;
   }
   if ( bottomMostIndex == NSUIntegerMax ) {
      bottomMost = _firstTouch;
   }
   
   // Figure out the approx middle of the circle
   _center = CGPointMake(leftMost.x + (rightMost.x - leftMost.x) / 2.0, bottomMost.y + (topMost.y - bottomMost.y) / 2.0);
   
   // check if the centre point is the centre of the speaker array if it's not then no circle and return no circle
   if ((_center.x > controlArea.center.x + 100) ||  (_center.x < controlArea.center.x - 100) || (_center.y > controlArea.center.y + 300) ||  (_center.y < controlArea.center.y - 300)) {
     return NO;
   } else
   {
      _center = CGPointMake(controlArea.center.x, controlArea.center.y);
   }
   
   
   // Calculate the radius by looking at the first point and the center
   _radius = fabsf(distanceBetweenPoints(_center, _firstTouch));
   
   CGFloat currentAngle = 0.0;
   BOOL    hasSwitched = NO;
   
   // Start Circle Check=========================================================
   // Make sure all points on circle are within a certain percentage of the radius from the center
   // Make sure that the angle switches direction only once. As we go around the circle,
   //    the angle between the line from the start point to the end point and the line from  the
   //    current point and the end point should go from 0 up to about 180.0, and then come
   //    back down to 0 (the function returns the smaller of the angles formed by the lines, so
   //    180° is the highest it will return, 0 the lowest. If it switches direction more than once,
   //    then it's not a circle
   CGFloat minRadius = _radius - (_radius * _radiusVariancePercent);
   CGFloat maxRadius = _radius + (_radius * _radiusVariancePercent);
   
   index = 0;
   for ( NSString *onePointString in points ) {
      CGPoint onePoint = CGPointFromString(onePointString);
      CGFloat distanceFromRadius = fabsf(distanceBetweenPoints(_center, onePoint));
      if ( distanceFromRadius < minRadius || distanceFromRadius > maxRadius ) {
           NSLog(@"radiusError");
         return NO;
      }
      
      CGFloat pointAngle = angleBetweenLines(_firstTouch, _center, onePoint, _center);
      
      if ( (pointAngle > currentAngle && hasSwitched) && (index < [points count] - _overlapTolerance) ) {
           NSLog(@"angleError");
         return NO;
      }
      
      if ( pointAngle < currentAngle ) {
         if ( !hasSwitched )
            hasSwitched = YES;
      }
      
      currentAngle = pointAngle;
      index++;
   }
   NSLog(@"ENDED");
   return YES;
}

-(BOOL)checkDragVert:(CGPoint)endPoint
{
   [points addObject:NSStringFromCGPoint(endPoint)];
   CGPoint checker = endPoint;
   float varianceAlowed = 80;
   
   for ( NSString *onePointString in points ) {
      CGPoint onePoint = CGPointFromString(onePointString);
      if ( onePoint.x > checker.x + varianceAlowed  || onePoint.x < checker.x - varianceAlowed) {
         //if any of the points are out of the range then return NO and kick us out of the checker
      return NO;
      }
   }
   return YES;
}
-(BOOL)checkDragHoro:(CGPoint)endPoint
{
   [points addObject:NSStringFromCGPoint(endPoint)];
   CGPoint checker = endPoint;
   float varianceAlowed = 80;
   
   for ( NSString *onePointString in points ) {
      CGPoint onePoint = CGPointFromString(onePointString);
      if ( onePoint.y > checker.y + varianceAlowed  || onePoint.y < checker.y - varianceAlowed) {
         return NO;
      }
   }
   return YES;
}

@end

