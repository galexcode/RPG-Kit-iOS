//
//  GameComponentSelectorViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 The Game Compontent View Controller provides a simple table view for all editable 
 components within a given game.
 */

#import <UIKit/UIKit.h>

#import "OCStrings.h"
#import "OCGameDataController.h"

@interface GameComponentSelectorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UINavigationBarDelegate, UIAlertViewDelegate>

#pragma mark - Game Data

@property (strong, nonatomic, readwrite) OCGameDataController *gameDataController;

#pragma mark - Interface elements

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
