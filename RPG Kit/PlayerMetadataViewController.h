//
//  PlayerMetadataViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/17/12.
//  Copyright (c) 2012 Jones & Bartlett Learning. All rights reserved.
//

/*
 The Player Metadata View Controller provides the interface needed to update player
 information. Its design follows closely to the Game Metadata View Controller
 */

#import <UIKit/UIKit.h>

#import "OCStrings.h"
#import "OCGameDataController.h"

@interface PlayerMetadataViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate,  UINavigationControllerDelegate, UINavigationBarDelegate>

#pragma mark - Game Data

@property (strong, nonatomic, readwrite) OCGameDataController *gameDataController;

#pragma mark - Interface elements

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *playerNameField;
@property (weak, nonatomic) IBOutlet UITextView *playerIntroView;

@end
