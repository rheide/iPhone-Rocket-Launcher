//
//  MainViewController.h
//  Rock
//
//  Created by itlsound on 10/02/17.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlipsideViewController.h"

@class LXSocket;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate,UIAccelerometerDelegate> {
	
	IBOutlet UITextField* ipField;
	
	IBOutlet UILabel* statusLabel;
	
	LXSocket* rocketSocket;
}

- (IBAction)showInfo;

- (IBAction)connect;
- (IBAction)disconnect;

-(void)sendCommand:(char)c;


@end
