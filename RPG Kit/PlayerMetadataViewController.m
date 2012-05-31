//
//  PlayerMetadataViewController.m
//  RPG Kit
//
//  Created by Philip Regan on 4/17/12.
//  Copyright (c) 2012 Jones & Bartlett Learning. All rights reserved.
//

#import "PlayerMetadataViewController.h"

@interface PlayerMetadataViewController ()

@end

@implementation PlayerMetadataViewController

@synthesize gameDataController = _gameDataController;
@synthesize scrollView = _scrollView;
@synthesize playerNameField = _playerNameField;
@synthesize playerIntroView = _playerIntroView;

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
}

- (void)viewDidUnload
{
    [self setPlayerNameField:nil];
    [self setPlayerIntroView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark NavigationController Stack

-(void) viewWillAppear:(BOOL)animated {
    // manage the view
    self.title = [self.gameDataController.currentUniverse valueForKey:OCAttributeTitleStory];
    self.navigationController.delegate = self;
    
    // populate the interface items with the latest information
    self.playerNameField.text = [self.gameDataController retrievePlayerName];
    self.playerIntroView.text = [self.gameDataController retrievePlayerIntro];
}

#pragma mark - TextField Stack

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // as soon as the return key (the Done key) is clicked, save and then bail
    if( [string isEqualToString:@"\n"] ) {
        // get rid of the keyboard
        [textField resignFirstResponder];
        // set the text to the managed object
        [self.gameDataController updatePlayerName:self.playerNameField.text];
        // saving is handled for us in the update method
        return NO;
    }
    
    return YES;
}

#pragma mark - TextView Stack

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    // as soon as the return key (the Done key) is clicked, save and then bail
    if( [text isEqualToString:@"\n"] ) {
        // get rid of the keyboard
        [textView resignFirstResponder];
        // set the text to the managed object
        [self.gameDataController updatePlayerIntro:self.playerIntroView.text];
        // saving is handled for us in the update method
        return NO;
    }
    
    return YES;
}

@end
