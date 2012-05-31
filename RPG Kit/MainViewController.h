//
//  MainViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>
#import "OCGameDataController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UINavigationBarDelegate>

#pragma mark - Game Data

// template provided property for interacting with Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
// custom class that manages core user interaction and all interaction with the 
// data store
@property (nonatomic, strong, readwrite) OCGameDataController *gameDataController;

#pragma mark - Interface elements

// list of games
@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Action Stack

/*
 intercepts presses on the '+' button, creates a new game for the player to edit
 and refreshes the view
 */
- (IBAction)newGame:(id)sender;

/*
 initializes the edit mode for the tableview
 */
- (IBAction)editGames:(id)sender;

#pragma mark - Flipside View

/*
 Template-privided code to the flip view */

- (IBAction)showInfo:(id)sender;

@end
