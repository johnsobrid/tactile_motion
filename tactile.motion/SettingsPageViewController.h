//
//  SettingsPageViewController.h
//  tactile.motion
//
//  Created by Bridget Johnson on 19/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsPageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIStepper *speakersLabelOutlet;
@property (strong, nonatomic) IBOutlet UIStepper *objectLabelOutlet;
@property (strong, nonatomic) IBOutlet UIStepper *distanceLabelOutlet;
@end
