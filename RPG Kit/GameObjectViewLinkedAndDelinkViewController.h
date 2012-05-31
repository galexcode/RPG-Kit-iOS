//
//  GameObjectViewLinkedAndDelinkViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 The Game Object View Linked and Delinked View Controller helps sort through potentially
 long lists of entity objects, and manage their relationships to each other. Much 
 like the Object Linker View Controller, the overall class is as content agnostic
 as possible for better reuse. The view controller calling this class handle the 
 logic needed to get what is needed
 */

#import <UIKit/UIKit.h>
#import "OCStrings.h"
#import "OCGameDataController.h"

@interface GameObjectViewLinkedAndDelinkViewController : UIViewController <UINavigationControllerDelegate, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate>

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

- (IBAction)editAction:(UIBarButtonItem *)sender;


@end
