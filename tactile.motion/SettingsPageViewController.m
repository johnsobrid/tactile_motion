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
- (IBAction)distanceSelector:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *speakersLabel;
@property (strong, nonatomic) IBOutlet UILabel *objectsLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation SettingsPageViewController
int saveSpeakers;
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

- (IBAction)distanceSelector:(id)sender {
   self.distanceLabel.text = [NSString stringWithFormat:@"%i",(int)[self.distanceLabelOutlet value]];
}
-(void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:NO];
   [self saveSettings];
   
}
-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:NO];
   [self.speakersLabelOutlet setValue:saveSpeakers];
}
-(void)saveSettings
{
   saveSpeakers = [self.speakersLabelOutlet value];
}

//tableView stuff
-(NSInteger)numberOfSectionsInTableView:networkTV
{
   return 1;
}

-(NSInteger)tableView:networkTV numberOfRowsInSection:(NSInteger)section
{
   return 6;
}
-(UITableViewCell *)tableView:networkTV cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"Cell";
   UITableViewCell *cell = [networkTV dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil)
   {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      cell.textLabel.textColor = [UIColor redColor];
   }
   cell.textLabel.text = [NSString stringWithFormat:@"Hello %d", indexPath.row];
   return cell;
}
@end
