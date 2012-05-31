//
//  TaskMetadataViewController.h
//  RPG Kit
//
//  Created by Philip Regan on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OCStrings.h"
#import "OCGameDataController.h"

@interface TaskMetadataViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate,  UINavigationControllerDelegate, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource>

#pragma mark - Game Data

@property (strong, nonatomic, readwrite) OCGameDataController *gameDataController;
@property (strong, nonatomic, readwrite) NSManagedObject *targetTask;

#pragma mark - Interface elements

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *introView;

@end
