//
//  RockAppDelegate.h
//  Rock
//
//  Created by itlsound on 10/02/17.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@class MainViewController;

@interface RockAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

