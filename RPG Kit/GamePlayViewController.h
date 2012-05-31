//
//  GamePlayViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCStrings.h"
#import "OCGameDataController.h"
#import "OCGameEngine.h"

@interface GamePlayViewController : UIViewController <UINavigationBarDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

#pragma mark - Game Data

@property (strong, nonatomic, readwrite) OCGameDataController *gameDataController;
@property (strong, nonatomic, readwrite) OCGameEngine *gameEngine;
@property (strong, nonatomic, readwrite) NSManagedObject *currentLocation;

#pragma mark - Interface elements

@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationIntroLabel;
@property (weak, nonatomic) IBOutlet UIButton *accomplishmentsButton;
@property (weak, nonatomic) IBOutlet UITableView *accomplishmentsTable;
@property (weak, nonatomic) IBOutlet UILabel *locationsLabel;
@property (weak, nonatomic) IBOutlet UITableView *locationsTable;

#pragma mark - Action Stack

- (IBAction)attemptAccomplishments;

@end
