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
		ipFieldString = [NSString stringWithFormat:@"%@",[ips objectAtIndex:0]];
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
   [_networkTV reloadData];
   
}

//tableView stuff
-(NSInteger)numberOfSectionsInTableView:networkTV
{
   return 1;
}

-(NSInteger)tableView:networkTV numberOfRowsInSection:(NSInteger)section
{
   return [availableNetworks count];
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
   cell.textLabel.text = [NSString stringWithFormat:@" %@",[availableNetworks objectAtIndex:indexPath.row]];
   return cell;
}


-(void)tableView:networkTV didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // UITableViewCell *selectedCell = [networkTV cellForRowAtIndexPath:indexPath];
  
   
   long				selectedIndex = indexPath.row;
	OSCOutPort		*selectedPort = nil;
	//	figure out the index of the selected item
	if (selectedIndex == -1)
		return;
	//	find the output port corresponding to the index of the selected item
	selectedPort = [manager findOutputForIndex:selectedIndex];
	if (selectedPort == nil)
		return;
	//	push the data of the selected output to the fields
	[ipField setText:[selectedPort addressString]];
	[portField setText:[NSString stringWithFormat:@"%d",[selectedPort port]]];
	//	bump the fields (which updates the manualOutPort, which is the only out port sending data)
  
   //	populate the sending port field from the current manual out port
	//NSLog(@"%s",__func__);
	//	first take care of the port (there's only one) which is receiving data
	//	push the settings in the port field to the in port
   
	[inport setPort:[receivingPortField.text intValue]];
	
   //	push the actual port i'm receiving on to the text field (if anything went wrong when changing the port, it should revert to the last port #)
   [receivingPortField setText:[NSString stringWithFormat:@"%d",[inport port]]];
   
	//	now take care of the ports which relate to sending data
	//	push the settings on the ui items to the manualOutPort, which is the only out port actually sending data
	[manualOutport setAddressString:ipField.text];
	[ipField setText:[manualOutport addressString]];
	[manualOutport setPort:[portField.text intValue]];
	[portField setText:[NSString stringWithFormat:@"%d",[manualOutport port]]];
	
   //	since the port this app receives on may have changed, i have to adjust the out port for the "This app" output so it continues to point to the correct address
	id			anObj = [manager findOutputWithLabel:@"This app"];
	if (anObj != nil)	{
		//[anObj setPort:[receivingPortField.text intValue]];
	}
   
   [testingLabel setText:[availableNetworks objectAtIndex:selectedIndex]];
   
}


//seque functions
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([[segue identifier]isEqualToString:@"testSegue"]) {
      if ([segue.destinationViewController isKindOfClass:[tactileMotionViewController class]]) {
         tactileMotionViewController *tmvc = segue.destinationViewController;
         tmvc.AddressInUse = [ipField text];
         tmvc.portInUse =[portField text];
         tmvc.numOfObjects = (int)[self.objectLabelOutlet value];
         tmvc.numOfSpeakers = (int)[self.speakersLabelOutlet value];
         tmvc.maxDistance = (int)[self.distanceLabelOutlet value];
      }
   }
}

@end
