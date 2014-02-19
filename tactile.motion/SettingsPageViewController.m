//
//  SettingsPageViewController.m
//  tactile.motion
//
//  Created by Bridget Johnson on 19/02/14.
//  Copyright (c) 2014 bdj. All rights reserved.
//

#import "SettingsPageViewController.h"

@interface SettingsPageViewController ()
- (IBAction)numOfSpeakersSelector:(id)sender;
- (IBAction)numOfObjectsSelector:(id)sender;
@property (strong, nonatomic) IBOutlet UIStepper *speakersLabelOutlet;
@property (strong, nonatomic) IBOutlet UIStepper *objectLabelOutlet;
@property (strong, nonatomic) IBOutlet UILabel *speakersLabel;
@property (strong, nonatomic) IBOutlet UILabel *objectsLabel;


@end

@implementation SettingsPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)numOfSpeakersSelector:(id)sender {
   self.speakersLabel.text = [NSString stringWithFormat:@"%i",(int)[self.speakersLabelOutlet value]];
}

- (IBAction)numOfObjectsSelector:(id)sender {
   self.objectsLabel.text = [NSString stringWithFormat:@"%i",(int)[self.objectLabelOutlet value]];
}
@end
