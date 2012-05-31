//
//  GameMetadataViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 The Game Metadata View Controller provides an interface for editing the relevant
 content for a given game (universe in the data store). The architecture for this
 class is the standard for all component editors within the app.
 */

#import <UIKit/UIKit.h>

#import "OCStrings.h"
#import "OCGameDataController.h"

@interface GameMetadataViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate,  UINavigationControllerDelegate, UINavigationBarDelegate>

#pragma mark - Game Data

@property (strong, nonatomic, readwrite) OCGameDataController *gameDataController;

#pragma mark - Interface elements

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;
@property (weak, nonatomic) IBOutlet UITextField *monetaryUnitField;
@property (weak, nonatomic) IBOutlet UITextField *temporalUnitField;

@end
