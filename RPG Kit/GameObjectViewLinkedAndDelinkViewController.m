//
//  GameObjectViewLinkedAndDelinkViewController.m
//  RPG Kit
//
//  Created by Philip Regan on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObjectViewLinkedAndDelinkViewController.h"

@interface GameObjectViewLinkedAndDelinkViewController ()

// the data source for the table view
@property (strong, nonatomic, readwrite) NSMutableArray *components;
// buffer for those objects selected
@property (strong, nonatomic, readwrite) NSMutableSet *selectedComponents;

@end

@implementation GameObjectViewLinkedAndDelinkViewController

@synthesize gameDataController = _gameDataController;

@synthesize tableView = _tableView;

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
    
    // manage needed properties
    self.components = [NSMutableArray array];
    self.selectedComponents = [NSMutableSet set];
    
    // manage the view
    self.title = [self.gameDataController.currentUniverse valueForKey:OCAttributeTitleStory];
    self.navigationController.delegate = self;
    
    // get all of the desired target entity to link
    self.components = [NSMutableArray arrayWithArray:[self.gameDataController retrieveEntities:self.targetEntity 
                                                relatedToObject:self.targetParent 
                                                viaRelationship:self.childParentRelationship]];
    
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
    
    // update the table
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // delink any selected object to the target parent
        [self.gameDataController delinkObjects:[NSMutableSet setWithObject:[self.components objectAtIndex:indexPath.row]] fromParent:self.targetParent viaRelationship:self.childParentRelationship];
        
        // update the data source for the table view
        [self.components removeObjectAtIndex:indexPath.row];
        
        // update the rows
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
    [tableView setEditing:NO animated:YES];
}

#pragma mark - Action Stack

- (IBAction)editAction:(UIBarButtonItem *)sender {
    if ( self.tableView.editing ) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}
@end
