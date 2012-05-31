//
//  TaskMetadataViewController.m
//  RPG Kit
//
//  Created by Philip Regan on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaskMetadataViewController.h"
#import "GameObjectSelectionViewController.h"
#import "GameObjectLinkerViewController.h"
#import "GameObjectViewLinkedAndDelinkViewController.h"

@interface TaskMetadataViewController ()

@property (strong, nonatomic, readwrite) NSArray *linkingMenuItems;

@end

@implementation TaskMetadataViewController

@synthesize gameDataController = _gameDataController;
@synthesize targetTask = _targetTask;
@synthesize tableView = _tableView;
@synthesize titleField = _titleField;
@synthesize introView = _introView;
@synthesize linkingMenuItems = _linkingMenuItems;

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
    [self setTitleField:nil];
    [self setIntroView:nil];
    [self setTableView:nil];
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
    
    self.title = [self.targetTask valueForKey:OCAttributeTitleStory];
    self.navigationController.delegate = self;
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    self.titleField.text = [self.targetTask valueForKey:OCAttributeTitleStory];
    self.introView.text = [self.targetTask valueForKey:OCAttributeIntroStory];
    
    self.linkingMenuItems = [NSArray arrayWithObjects:@"View Linked Locations", @"Link Locations", @"View Linked Accomplishments", @"Link Accomplishments", nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OCQuestMetadataBackButton", @"")
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
}

#pragma mark - TextField Stack

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // as soon as the return key (the Done key) is clicked, save and then bail
    if( [string isEqualToString:@"\n"] ) {
        // get rid of the keyboard
        [textField resignFirstResponder];
        // set the text to the managed object
        [self.targetTask setValue:textField.text forKey:OCAttributeTitleStory];
        // save the store
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
        [self.targetTask setValue:textView.text forKey:OCAttributeIntroStory];
        // save the store
        [self.gameDataController updateChanges];
        return NO;
    }
    
    return YES;
}

#pragma mark - TableView Stack

#pragma mark Hierarchy Stack

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.linkingMenuItems count];
}

#pragma mark Viewing and Selecting Stack

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LinkObjectdCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.linkingMenuItems objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LinkObjectdCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.linkingMenuItems objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ( indexPath.row ) {
        case 0:
            // @"View Linked Locations" Object Selection
            [self pushToViewLinkedLocations];
            break;
        case 1:
            // @"Link Locations" Object Linker
            [self pushToLinkLocations];
            break;
        case 2:
            // @"View Linked Accomplishments" Object Selection
            [self pushToViewLinkedAccomplishments];
            break;
        case 3:
            // @"Link Accomplishments" Object Linker
            [self pushToLinkAccomplishments];
            break;
        default:
            break;
    }    
}

#pragma mark - Action Stack

/*
 Helper methods to push to the view needed to accoomplish certain tasks.
 */

-(void)pushToViewLinkedLocations {
    GameObjectViewLinkedAndDelinkViewController *vc = [[GameObjectViewLinkedAndDelinkViewController alloc] initWithNibName:@"GameObjectViewLinkedAndDelinkViewController" bundle:nil];
    vc.gameDataController = self.gameDataController;
    vc.targetEntity = OCEntityTask;
    vc.targetParent = self.targetTask;
    vc.childParentRelationship = OCRelationshipSiblingLocation;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushToLinkLocations {
    GameObjectLinkerViewController *vc = [[GameObjectLinkerViewController alloc] initWithNibName:@"GameObjectLinkerViewController" bundle:nil];
    vc.gameDataController = self.gameDataController;
    vc.targetEntity = OCEntityTask;
    vc.targetParent = self.targetTask;
    vc.childParentRelationship = OCRelationshipSiblingLocation;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushToViewLinkedAccomplishments {
    GameObjectViewLinkedAndDelinkViewController *vc = [[GameObjectViewLinkedAndDelinkViewController alloc] initWithNibName:@"GameObjectViewLinkedAndDelinkViewController" bundle:nil];
    vc.gameDataController = self.gameDataController;
    vc.targetEntity = OCEntityTask;
    vc.targetParent = self.targetTask;
    vc.childParentRelationship = OCRelationshipChildAccomplishment;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushToLinkAccomplishments {
    GameObjectLinkerViewController *vc = [[GameObjectLinkerViewController alloc] initWithNibName:@"GameObjectLinkerViewController" bundle:nil];
    vc.gameDataController = self.gameDataController;
    vc.targetEntity = OCEntityTask;
    vc.targetParent = self.targetTask;
    vc.childParentRelationship = OCRelationshipChildAccomplishment;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
