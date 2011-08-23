//
//  MainViewController.m
//  Rock
//
//  Created by itlsound on 10/02/17.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "LXSocket.h"

@implementation MainViewController

const static int PORT = 21007;

const int STOP = 0x00;
const int UP = 0x01;
const int DOWN = 0x02;
const int LEFT = 0x04;
const int UP_LEFT = 0x05;
const int DOWN_LEFT = 0x06;
const int RIGHT = 0x08;
const int UP_RIGHT = 0x09;
const int FIRE = 0x10;
const int DOWN_RIGHT = 0x0A;
const int SLOW_LEFT =0x07;
const int SLOW_RIGHT = 0x0B;
const int SLOW_UP = 0x0D;
const int SLOW_DOWN = 0x0E;
const int FIRE_LEFT = 0x14;
const int FIRE_RIGHT = 0x18;
const int FIRE_UP_LEFT = 0x15;
const int FIRE_UP_RIGHT = 0x19;
const int FIRE_DOWN_RIGHT = 0x1A;
const int REQUEST = 0x0000009;
const int REQUEST_TYPE = 0x21;
const int REQUEST_VAL = 0x0000200;

BOOL connected;
int lastCommand;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		connected = NO;
		lastCommand = STOP;
    }
    return self;
}



 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
	 
	 //let's connect  immediately (should store last ip in file somewhere)
	 [self connect];
	 
	 
	 UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	 accel.updateInterval = 0.1f;
	 accel.delegate = self;
	 
	 
 }

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
	if (!connected) return;
	
	double defaultY = -0.5;
	double defaultX = 0; //+- 0.5
	
	double marginSlow = 0.30;
	double marginFast = 0.45;
	
	double marginSlowX = 0.15;
	double marginFastX = 0.35;
	
	int sendValue = STOP;
	
	if (acceleration.y < defaultY - marginFast)
		sendValue = UP;
	else if (acceleration.y < defaultY - marginSlow)
		sendValue = SLOW_UP;
	else if (acceleration.y > defaultY + marginFast)
		sendValue = DOWN;
	else if (acceleration.y > defaultY + marginSlow)
		sendValue = SLOW_DOWN;
	
	
	if (acceleration.x < defaultX - marginFastX)
		sendValue = LEFT;
	else if (acceleration.x < defaultX - marginSlowX)
		sendValue = SLOW_LEFT;
	else if (acceleration.x > defaultX + marginFastX)
		sendValue = RIGHT;
	else if (acceleration.x > defaultX + marginSlowX)
		sendValue = SLOW_RIGHT;
	
	
	if (lastCommand != sendValue)
	{
		lastCommand = sendValue;
		[self sendCommand:sendValue];
	}
	
	
    NSLog(@"(%.02f, %.02f, %.02f)", acceleration.x, acceleration.y, acceleration.z);
	
	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)disconnect
{
	//send disconnect command!
	char disco[2];
	disco[0] = 0;
	disco[1] = 0;
	
	[rocketSocket sendBytes:disco length:2];
	
	[rocketSocket release];
	rocketSocket = nil; 
	
	statusLabel.text = @"Disconnected";
	connected = NO;
}

- (IBAction)connect
{
	NSString* ip = ipField.text;
	
	if (rocketSocket != nil)
	{
		[self disconnect];
	}
	
	NSLog(@"Connecting to: %@:%i", ip, PORT);
	LXSocket* tmpSocket = [[LXSocket alloc] init];
	if ([tmpSocket connect:ip port:PORT])
	{
		rocketSocket = tmpSocket;
		statusLabel.text = [NSString stringWithFormat:@"Connected to %@",ip];
		connected = YES;
	}
	else 
	{
		statusLabel.text = @"Connection failed";
		NSLog(@"Could not connect to server! %@ : %i", ip, PORT);
		connected = NO;
	}
}

/*
- (IBAction)btnUpStart
{
	if (speedSwitch.selectedSegmentIndex == 0)
		[self sendCommand:UP];
	else 
		[self sendCommand:SLOW_UP];

}

- (IBAction)btnUpStop
{
	[self sendCommand:STOP];
}

- (IBAction)btnDnStart
{
	if (speedSwitch.selectedSegmentIndex == 0)
		[self sendCommand:DOWN];
	else
		[self sendCommand:SLOW_DOWN];

}

- (IBAction)btnDnStop
{
	[self sendCommand:STOP];
}

- (IBAction)btnLtStart
{
	if (speedSwitch.selectedSegmentIndex == 0)
		[self sendCommand:LEFT];
	else
		[self sendCommand:SLOW_LEFT];

}

- (IBAction)btnLtStop
{
	[self sendCommand:STOP];
}

- (IBAction)btnRtStart
{
	if (speedSwitch.selectedSegmentIndex == 0)
		[self sendCommand:RIGHT];
	else
		[self sendCommand:SLOW_RIGHT];

}

- (IBAction)btnRtStop
{
	[self sendCommand:STOP];
}


- (IBAction)btnFire
{
	NSLog(@"Fire! - fireswitch: %i", [fireSwitch isOn]);
	
	if (![fireSwitch isOn])
	{
		statusLabel.text = @"Unlock before firing!";
		return;
	}
	
	[self sendCommand:FIRE];
	
	//don't forget to stop again!!!
	usleep(1000 * 200); //200ms
	
	[self sendCommand:STOP];
	
}*/


-(void)sendCommand:(char)c
{
	char cmd[2];
	cmd[0] = 2; //default cmd code
	cmd[1] = c;
	[rocketSocket sendBytes:cmd length:2];
	
	statusLabel.text = [NSString stringWithFormat:@"Sending command: %i",cmd[1]];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
