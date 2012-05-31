//
//  GameSelectorViewController.m
//  RPG Kit
//
//  Created by Philip Regan on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameSelectorViewController.h"
#import "OCStrings.h"
#import "GamePlayViewController.h"
#import "GameComponentSelectorViewController.h"

@interface GameSelectorViewController ()

@end

@implementation GameSelectorViewController

@synthesize gameDataController = _gameDataController;
@synthesize titleLabel = _titleLabel;
@synthesize titleIntro = _titleIntro;

#pragma mark - Object Lifecycle Stack

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewController];
}

- (void)viewDidUnload
{
    // auto-generated calls
    // navigationControll call commented out per Xcode
    //[self setNavigationController:nil];
    [self setTitleLabel:nil];
    [self setTitleIntro:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark NavigationController Stack

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    [self prepareViewController];

}

- (void)viewDidDisappear:(BOOL)animated {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OCGameSelectorBackButton", @"")
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
 private convenience method for managing the prep of the interface
 */

-(void)prepareViewController {
    self.title = NSLocalizedString(@"OCAppName", @"");
    // get the text needed to populate the interface
    self.titleLabel.text = [self.gameDataController.currentUniverse valueForKey:OCAttributeTitleStory];
    self.titleIntro.text = [self.gameDataController.currentUniverse valueForKey:OCAttributeIntroStory];
}

#pragma mark - Action Stack

- (IBAction)playButton:(id)sender {
    // kick off the play stack (such as it is)
    GamePlayViewController *gamePlayViewController = [[GamePlayViewController alloc] initWithNibName:@"GamePlayViewController" bundle:nil];
    gamePlayViewController.gameDataController = self.gameDataController;
    gamePlayViewController.currentLocation = [self.gameDataController getHomeLocation];
    // push
    [self.navigationController pushViewController:gamePlayViewController animated:YES];
}

- (IBAction)editButton:(id)sender {
    // kick off the edit stack
    GameComponentSelectorViewController *gcsvc = [[GameComponentSelectorViewController alloc] initWithNibName:@"GameComponentSelectorViewController" bundle:nil];
    gcsvc.gameDataController = self.gameDataController;
    // push
    [self.navigationController pushViewController:gcsvc animated:YES];
    
}
@end
