//
//  tactileMotionViewController.h
//  tactile.motion
//
//  Created by Bridget Johnson on 4/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleGestureRecognizer.h"
#import "controlAreaView.h"
#import "SettingsPageViewController.h"
#import <VVOSC/VVOSC.h>

#define MAX_DISTANCE 5


@interface tactileMotionViewController : UIViewController {
    IBOutlet UITextField *statusField;
    IBOutlet controlAreaView *controlArea;
   
   IBOutlet UILabel *testingField;
   OSCManager *manager;
   OSCOutPort *outPort;
   OSCInPort *inPort;

//circle
   NSMutableArray *points;
   CGPoint _firstTouch;
   NSTimeInterval _firstTouchTime;
   BOOL circleDetected;
   BOOL vertDragDetected;
   BOOL horoDragDetected;
   NSTimer *animationTimer;
}
@property (strong, nonatomic) IBOutlet UILabel *testLabel;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
@property (strong) NSMutableArray *audioObjects;

@property int numOfSpeakers;
@property int maxDistance;
@property int numOfObjects;

//OSC
@property (strong, nonatomic) NSString *AddressInUse;
@property (strong,nonatomic) NSString *portInUse;


//circleChecks
@property CGFloat circleClosureAngleVariance;
/// Maximum distance allowed between the two end points, in pixels
@property CGFloat circleClosureDistanceVariance;
/// Maximum time allowed to complete a circle, in seconds
@property CGFloat maximumCircleTime;
@property CGFloat radiusVariancePercent;
@property NSInteger overlapTolerance;
/// The minimum number of points that should make up a circle
@property NSInteger minimumNumPoints;

@property (readonly) CGPoint center;
@property (readonly) CGFloat radius;
@property (readonly) NSArray *points;

@property (nonatomic) float circleVelocity;


@end
