//
//  FlipsideViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OCGameDataController.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

@property (strong, nonatomic, readwrite) OCGameDataController *gameDataController;

- (IBAction)done:(id)sender;
- (IBAction)resetGames:(id)sender;

@end
