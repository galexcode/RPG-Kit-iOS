//
//  GameObjectSelectionViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/18/12.
//  Copyright (c) 2012 Jones & Bartlett Learning. All rights reserved.
//

/*
 The GameObjectSelectorViewController is a generic class used to help select objects
 that tend to come in long lists---locations and accomplishments---where a static 
 interface is too unwieldly. 
 
 Component selectors turn on the name of the entity and push to the metadata view
 controller for that entity.
 */


#import <UIKit/UIKit.h>

#import "OCStrings.h"
#import "OCGameDataController.h"

@interface GameObjectSelectionViewController : UIViewController <UINavigationControllerDelegate, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate>

#pragma mark - Game Data

@property (nonatomic, strong, readwrite) OCGameDataController *gameDataController;
@property (nonatomic, strong, readwrite) NSMutableArray *components;
@property (nonatomic, strong, readwrite) NSString *targetEntity;
@property (nonatomic, strong, readwrite) NSString *targetRelationship;
@property (nonatomic, strong, readwrite) NSManagedObject *targetParent;

#pragma mark - Interface elements

@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Action Stack

- (IBAction)newButton:(UIBarButtonItem *)sender;
- (IBAction)editButton:(UIBarButtonItem *)sender;
@end
