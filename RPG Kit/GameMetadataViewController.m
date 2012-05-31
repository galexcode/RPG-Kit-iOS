//
//  GameMetadataViewController.m
//  RPG Kit
//
//  Created by Philip Regan on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameMetadataViewController.h"

@interface GameMetadataViewController ()

// buffer variables for managing the active text areas
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) UITextView *activeView;

@end

@implementation GameMetadataViewController

@synthesize gameDataController = _gameDataController;
@synthesize scrollView = _scrollView;
@synthesize titleField = _titleField;
@synthesize introTextView = _introTextView;
@synthesize monetaryUnitField = _monetaryUnitField;
@synthesize temporalUnitField = _temporalUnitField;
@synthesize activeField = _activeField;
@synthesize activeView = _activeView;

#pragma mark - Object Lifecycle Stack

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self registerForKeyboardNotifications];
        
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
    [self unregisterForKeyboardNotifications];
    
    [self setTitleField:nil];
    [self setIntroTextView:nil];
    [self setMonetaryUnitField:nil];
    [self setTemporalUnitField:nil];
    [self setScrollView:nil];
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
    self.titleField.text = [self.gameDataController.currentUniverse valueForKey:OCAttributeTitleStory];
    self.introTextView.text = [self.gameDataController.currentUniverse valueForKey:OCAttributeIntroStory];
    self.monetaryUnitField.text = [self.gameDataController.currentUniverse valueForKey:OCAttributeMonetaryUnit];
    self.temporalUnitField.text = [self.gameDataController.currentUniverse valueForKey:OCAttributeTemporalUnit];
}

#pragma mark - TextField Stack

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // as soon as the return key (the Done key) is clicked, save and then bail
    if( [string isEqualToString:@"\n"] ) {
        // get rid of the keyboard
        [textField resignFirstResponder];
        // sort out which text field was updated and set the text to the managed object
        if ( textField == self.titleField) {
            [self.gameDataController.currentUniverse setValue:textField.text forKey:OCAttributeTitleStory];
        } else if ( textField == self.monetaryUnitField ) {
            [self.gameDataController.currentUniverse setValue:textField.text forKey:OCAttributeMonetaryUnit];
        } else if ( textField == self.temporalUnitField ) {
            [self.gameDataController.currentUniverse setValue:textField.text forKey:OCAttributeTemporalUnit];
        }
        // save the changes
        [self.gameDataController updateChanges];
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
        [self.gameDataController.currentUniverse setValue:textView.text forKey:OCAttributeIntroStory];
        // save the changes
        [self.gameDataController updateChanges];
        return NO;
    }
    
    return YES;
}

#pragma mark - ScrollView Stack

/*
 This stack is entirely focused on view management when the keyboard comes into view
 and hides from view. All code is directly per Apple's specs found here: 
 http://developer.apple.com/library/ios/#documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
 
 Modifications were made for handling both text fields and text views.
 
 Of course, this code was originally written for iOS 3.x and has not been updated 
 since then, and it no longer works, nor do any of the snippets on the web. Brilliant.
 */

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.activeView = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.activeView = nil;
}


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)unregisterForKeyboardNotifications {
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil]; 
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    self.scrollView.contentSize = CGSizeMake(320.0f, 920.0f);
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = self.activeField.frame.origin;
    origin.y -= self.scrollView.contentOffset.y;
    
        if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height);
            [self.scrollView setContentOffset:scrollPoint animated:YES];
            [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
        }
    
        if (!CGRectContainsPoint(aRect, self.activeView.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, self.activeView.frame.origin.y-kbSize.height);
            [self.scrollView setContentOffset:scrollPoint animated:YES];
            [self.scrollView scrollRectToVisible:self.activeView.frame animated:YES];
        }
    
    // this causes erratic behavior
    //[self.view setFrame:self.activeView.frame];
    //[self.view setFrame:self.activeField.frame];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
