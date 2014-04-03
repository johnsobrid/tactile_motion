//
//  SettingsPageViewController.h
//  tactile.motion
//
//  Created by Bridget Johnson on 19/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsPageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
   NSMutableArray *availableNetworks;
}
@property (strong, nonatomic) IBOutlet UITableView *networkTV;
@property (strong, nonatomic) IBOutlet UIStepper *speakersLabelOutlet;
@property (strong, nonatomic) IBOutlet UIStepper *objectLabelOutlet;
@property (strong, nonatomic) IBOutlet UIStepper *distanceLabelOutlet;
@end
