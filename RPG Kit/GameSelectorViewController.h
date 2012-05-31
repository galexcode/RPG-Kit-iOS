//
//  GameSelectorViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCGameDataController.h"

@interface GameSelectorViewController : UIViewController <UINavigationControllerDelegate, UINavigationBarDelegate>

#pragma mark - Game Data

@property (nonatomic, strong, readwrite) OCGameDataController *gameDataController;

#pragma mark - Interface elements

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleIntro;

#pragma mark - Action Stack

- (IBAction)playButton:(id)sender;
- (IBAction)editButton:(id)sender;

@end
