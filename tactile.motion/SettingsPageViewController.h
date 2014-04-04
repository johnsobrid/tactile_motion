//
//  SettingsPageViewController.h
//  tactile.motion
//
//  Created by Bridget Johnson on 19/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tactileMotionViewController.h"
#import <VVOSC/VVOSC.h>

@interface SettingsPageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
   NSMutableArray *availableNetworks;
   OSCInPort *inport;
   OSCManager *manager;
   OSCOutPort *manualOutport;
   
   
   IBOutlet UILabel *receivingAddressField;
   IBOutlet UILabel *receivingPortField;
   IBOutlet UILabel *ipField;
   IBOutlet UILabel *portField;
}
@property (strong, nonatomic) IBOutlet UITableView *networkTV;
@property (strong, nonatomic) IBOutlet UIStepper *speakersLabelOutlet;
@property (strong, nonatomic) IBOutlet UIStepper *objectLabelOutlet;
@property (strong, nonatomic) IBOutlet UIStepper *distanceLabelOutlet;




@end
