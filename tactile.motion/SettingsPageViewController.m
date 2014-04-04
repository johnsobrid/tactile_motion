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
   availableNetworks = [[NSMutableArray alloc]init];
   manager = [[OSCManager alloc]init];
   [manager setDelegate:self];
   [self setupNetwork];
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

-(void)setupNetwork
{
   NSString		*ipFieldString;
	id				anObj = nil;
	
	//	tell the osc manager to make an input to receive from a given port
	inport = [manager createNewInput];
	
	//	make an out port to my machine's dedicated in port
	anObj = [manager createNewOutputToAddress:@"127.0.0.1" atPort:[inport port] withLabel:@"This app"];
	if (anObj == nil)
		NSLog(@"\t\terror creating output A");
	//	make another out port to hold the manual settings
	manualOutport = [manager createNewOutputToAddress:@"127.0.0.1" atPort:[inport port] withLabel:@"Manual Output"];
	if (manualOutport == nil)
		NSLog(@"\t\terror creating output B");
	
	
	//	populate the IP field string with  this machine's IP and the port of my dedicated input
	NSArray			*ips = [OSCManager hostIPv4Addresses];
	if (ips!=nil && [ips count]>0)	{
		ipFieldString = [NSString stringWithFormat:@"%@, port",[ips objectAtIndex:0]];
		[receivingAddressField setText:ipFieldString];
	}
	//	populate the receiving port field with the in port's port
	[receivingPortField setText:[NSString stringWithFormat:@"%d",[inport port]]];
	
   //	populate the sending port field from the current manual out port
	[portField setText:[NSString stringWithFormat:@"%d",[manualOutport port]]];
	
	//	register to receive notifications that the list of osc outputs has changed
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oscOutputsChangedNotification:) name:OSCOutPortsChangedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oscOutputsChangedNotification:) name:OSCInPortsChangedNotification object:nil];
	
	//	fake an outputs-changed notification to make sure my list of destinations updates (in case it refreshes before i'm awake)
	[self oscOutputsChangedNotification:nil];
}
//tableView stuff
-(NSInteger)numberOfSectionsInTableView:networkTV
{
   return 1;
}

-(NSInteger)tableView:networkTV numberOfRowsInSection:(NSInteger)section
{
   return 2;
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
  // NSLog([availableNetworks objectAtIndex:indexPath.row]);
   cell.textLabel.text = [availableNetworks objectAtIndex:indexPath.row];
   return cell;
}

-(void)oscOutputsChangedNotification:(NSNotification *)note
{
   //NSLog(@"%s",__func__);
	NSArray			*portLabelArray = nil;
   
	//	remove the items in the pop-up button
	[availableNetworks removeAllObjects];
	//	get an array of the out port labels
	portLabelArray = [manager outPortLabelArray];
	//	push the labels to the pop-up button of destinations
	[availableNetworks addObjectsFromArray:portLabelArray];
}
//seque functions
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([[segue identifier]isEqualToString:@"testSegue"]) {
      if ([segue.destinationViewController isKindOfClass:[tactileMotionViewController class]]) {
         tactileMotionViewController *tmvc = segue.destinationViewController;
         tmvc.portInputField.text = [NSString stringWithFormat:@"working!"];
         [tmvc.ipInputField setText:[NSString stringWithFormat:@"ipfield"]];
         tmvc.testLabel.text = [availableNetworks objectAtIndex:1];
      }
   }
}
- (IBAction)testSeguePushed:(id)sender {
   
}
@end
