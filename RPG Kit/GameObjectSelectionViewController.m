//
//  GameObjectSelectionViewController.m
//  RPG Kit
//
//  Created by Philip Regan on 4/18/12.
//  Copyright (c) 2012 Jones & Bartlett Learning. All rights reserved.
//

#import "GameObjectSelectionViewController.h"
#import "TaskMetadataViewController.h"

@interface GameObjectSelectionViewController ()

@end

@implementation GameObjectSelectionViewController

@synthesize gameDataController = _gameDataController;
@synthesize components = _components;
@synthesize targetEntity = _targetEntity;
@synthesize targetRelationship = _targetRelationship;
@synthesize targetParent = _targetParent;
@synthesize tableView = _tableView;

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
    // manage the view
    self.title = [self.gameDataController.currentUniverse valueForKey:OCAttributeTitleStory];
    self.navigationController.delegate = self;
    
    /*
     we have to assess the intent of this instance's use based on what the previous
     view controller put in place.
     */
    
    if ( self.targetRelationship != nil ) {
        if ( [self.targetRelationship isEqualToString:OCRelationshipQuests] ) {
            self.components = [self.gameDataController retrieveQuests];
        }
        // add hook for accomplishments, which means this should be factored out to
        // managing a target entity, relationship, and parent
    } else {
        if ( [self.targetEntity isEqualToString:OCEntityTask] ) {
            self.components = [self.gameDataController retrieveTasks];
        } else if ( [self.targetEntity isEqualToString:OCEntityTask] ) {
            self.components = [self.gameDataController retrieveTasks];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    NSString *localizedString = @"";
    
    // update the back button according to the type of object being selected
    
    if ( self.targetRelationship != nil ) {
        if ( [self.targetRelationship isEqualToString:OCRelationshipQuests] ) {
            
            localizedString = NSLocalizedString(@"OCGameSelectionBackButtonTasks", @"");            
        }
    } else {
        if ( [self.targetEntity isEqualToString:OCEntityTask] ) {
            
            localizedString = NSLocalizedString(@"OCGameSelectionBackButtonTasks", @""); 
            
        } else if ( [self.targetEntity isEqualToString:OCEntityTask] ) {
            //self.components = [self.gameDataController retrieveTasks];
        }
    }
    
    // TODO: Add hook for Equipment CANCELLED
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(localizedString, @"")
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
}

#pragma mark - Table View Stack

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.components count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ObjectSelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // content population typical of a game object
    cell.textLabel.text = [[self.components objectAtIndex:indexPath.row] valueForKey:OCAttributeTitleStory];
    cell.detailTextLabel.text = [[self.components objectAtIndex:indexPath.row] valueForKey:OCAttributeIntroStory];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    // check to see if this is an in-game object that should not be deleted
    if ( [[[self.components objectAtIndex:indexPath.row] valueForKey:OCAttributeInGameObject] boolValue] ) {
        return NO;
    }
    
    return YES;
}
 


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /* 
     the method for doing this is exactly the same as it is with deleting games in 
     MainViewController
     */
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // capture the universe to be deleted
        NSManagedObject *targetTask = [self.components objectAtIndex:indexPath.row];
        
        // delete the object
        if ( [self.gameDataController deleteTask:targetTask] ) {
            
            // update the data source for the table view
            [self.components removeObjectAtIndex:indexPath.row];
            
            // update the rows
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        } else {
            
            // something bad happened
            NSLog(@"ERROR: MainViewController:delete task: NO");
        }
    }
    
    [self.tableView setEditing:NO animated:YES];
    
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( self.targetRelationship != nil ) {
        if ( [self.targetRelationship isEqualToString:OCRelationshipQuests] ) {
            
            TaskMetadataViewController *taskMetadataViewController = [[TaskMetadataViewController alloc] initWithNibName:@"TaskMetadataViewController" bundle:nil];
            taskMetadataViewController.gameDataController = self.gameDataController;
            taskMetadataViewController.targetTask = [self.components objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:taskMetadataViewController animated:YES];
            
        }
        // add hook for accomplishments, which means this should be factored out to
        // managing a target entity, relationship, and parent
    } else {
        if ( [self.targetEntity isEqualToString:OCEntityTask] ) {
            
            TaskMetadataViewController *taskMetadataViewController = [[TaskMetadataViewController alloc] initWithNibName:@"TaskMetadataViewController" bundle:nil];
            taskMetadataViewController.gameDataController = self.gameDataController;
            taskMetadataViewController.targetTask = [self.components objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:taskMetadataViewController animated:YES];

        } else if ( [self.targetEntity isEqualToString:OCEntityTask] ) {
            //self.components = [self.gameDataController retrieveTasks];
        }
    }
    
}

#pragma mark - Action Stack

- (IBAction)newButton:(UIBarButtonItem *)sender {
    if ( [self.gameDataController createNewTask] ) {
        self.components = [self.gameDataController retrieveTasks];
        [self.tableView reloadData];
    } else {
        // something bad happened
        NSLog(@"ERROR: MainViewController:newTask: NO");
    }
}

- (IBAction)editButton:(UIBarButtonItem *)sender {
    if ( self.tableView.editing ) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}
@end
