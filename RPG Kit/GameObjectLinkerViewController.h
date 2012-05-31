//
//  GameObjectLinkerViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 The Game Object Linker View is designed to help manage the linking of a given parent
 object to any number of potential child object. Much like the Game Object Selection
 View Controller it is based on, it is designed to be object type agnostic and instead
 facilitates the setting of values by key in managed objects pulled from the Core
 Data store. The view controller calling this class handle the logic needed to get
 what is needed
 */

#import <UIKit/UIKit.h>
#import "OCGameDataController.h"

@interface GameObjectLinkerViewController : UIViewController <UINavigationControllerDelegate, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate>

#pragma mark - Game Data

@property (strong, nonatomic, readwrite) OCGameDataController *gameDataController;

// the object we are going to couple with
@property (strong, nonatomic, readwrite) NSManagedObject *targetParent;
// the type of objects we want to couple with the intended parent
@property (strong, nonatomic, readwrite) NSString *targetEntity;
// the child to parent relationship between the two
@property (strong, nonatomic, readwrite) NSString *childParentRelationship;

#pragma mark - Interface elements

@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Action Stack

- (IBAction)doneAction:(UIBarButtonItem *)sender;

@end
