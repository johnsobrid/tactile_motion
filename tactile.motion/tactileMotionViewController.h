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
}
@property (strong, nonatomic) IBOutlet UILabel *testLabel;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
@property (strong) NSMutableArray *audioObjects;
@property (strong, nonatomic) NSString *AddressInUse;
@property (strong,nonatomic) NSString *portInUse;
@end
