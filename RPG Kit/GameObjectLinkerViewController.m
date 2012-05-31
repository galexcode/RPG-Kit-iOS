//
//  GameObjectLinkerViewController.m
//  RPG Kit
//
//  Created by Philip Regan on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObjectLinkerViewController.h"
#import "OCGameDataController.h"
#import "OCStrings.h"
#import "TaskMetadataViewController.h"

@interface GameObjectLinkerViewController ()

// the data source for the table view
@property (strong, nonatomic, readwrite) NSMutableArray *components;
// buffer for those objects selected
@property (strong, nonatomic, readwrite) NSMutableSet *selectedComponents;

@end

@implementation GameObjectLinkerViewController

@synthesize tableView = _tableView;
@synthesize gameDataController = _gameDataController;
@synthesize targetParent = _targetParent;
@synthesize targetEntity = _targetEntity;
@synthesize childParentRelationship = _childParentRelationship;
@synthesize components = _components;
@synthesize selectedComponents = _selectedComponents;

#pragma mark - Object Lifecycle Stack

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    // manage needed properties
    self.components = [NSMutableArray array];
    self.selectedComponents = [NSMutableSet set];
    
    // manage the view
    self.title = [self.gameDataController.currentUniverse valueForKey:OCAttributeTitleStory];
    self.navigationController.delegate = self;
    
    // get all of the given target entity to link
    
    if (    [self.childParentRelationship isEqualToString:OCRelationshipParentLocation] || 
            [self.childParentRelationship isEqualToString:OCRelationshipSiblingLocation] || 
            [self.childParentRelationship isEqualToString:OCRelationshipChildAccomplishment] ) {
        self.components = [self.gameDataController retrieveTasks];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    NSString *localizedString = @"";
    
        if ( [self.targetEntity isEqualToString:OCEntityTask] ) {

            localizedString = NSLocalizedString(@"OCGameSelectionBackButtonTasks", @"");
        }
    
    // TODO: Add hook for Equipment CANCELLED
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(localizedString, @"")
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
}

#pragma mark - Table View Stack

#pragma mark Hierarchy Stack

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.components count];
}

#pragma mark Viewing and Selecting Stack

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ObjectLinkerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.components objectAtIndex:indexPath.row] valueForKey:OCAttributeTitleStory];
    cell.detailTextLabel.text = [[self.components objectAtIndex:indexPath.row] valueForKey:OCAttributeIntroStory];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedComponents addObject:[self.components objectAtIndex:indexPath.row]];
}

#pragma mark Editing Stack

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setEditing:NO animated:YES];
}

#pragma mark - Action Stack

- (IBAction)doneAction:(UIBarButtonItem *)sender {
    // apply the selected object to the target parent
    [self.gameDataController linkObjects:self.selectedComponents toParent:self.targetParent viaRelationship:self.childParentRelationship];
    // go back to the previous view 
    [self.navigationController popViewControllerAnimated:YES];
}
@end
