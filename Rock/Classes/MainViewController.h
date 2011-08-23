//
//  MainViewController.h
//  Rock
//
//  Created by itlsound on 10/02/17.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlipsideViewController.h"

@class LXSocket;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	
	IBOutlet UITextField* ipField;
	
	IBOutlet UISwitch* fireSwitch;
	
	IBOutlet UILabel* statusLabel;
	
	IBOutlet UISegmentedControl *speedSwitch;
	
	LXSocket* rocketSocket;
}

- (IBAction)showInfo;

- (IBAction)connect;
- (IBAction)disconnect;

- (IBAction)btnUpStart;
- (IBAction)btnUpStop;

- (IBAction)btnDnStart;
- (IBAction)btnDnStop;

- (IBAction)btnLtStart;
- (IBAction)btnLtStop;

- (IBAction)btnRtStart;
- (IBAction)btnRtStop;

- (IBAction)btnFire;

-(void)sendCommand:(char)c;


@end
