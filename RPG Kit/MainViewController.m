//
//  MainViewController.m
//  RPG Kit
//
//  Created by Philip Regan on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "GameSelectorViewController.h"

@interface MainViewController ()

// list of games driving the table view
@property (strong, nonatomic, readwrite) NSMutableArray *games;

@end

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize gameDataController = _gameDataController;
@synthesize tableView = _tableView;
@synthesize games = _games;

#pragma mark - Object Lifecycle Stack

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ( [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self prepareViewController];
   
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark NavigationController Stack

- (void)viewWillAppear:(BOOL)animated {
    // deselect the last row selected by the user so we don't get things confused
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    [self prepareViewController];
}



- (void)viewDidDisappear:(BOOL)animated {
    
    // we want the back button to state the intent of the previous screen and not just
    // "Back". To do this, we have to create a new button before the next screen is
    // pushed into view
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Games" 
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
    
    // the other way to do this is to change the title of this screen, which, while
    // shorter, requires the name be visibly changed every time the screen changes. 
    // This at least lets the values get cached by the navigation controller as needed.
    
}

/*
 private convenience method for managing the prep of the interface
 */

-(void)prepareViewController {
    self.games = [self.gameDataController retrieveGames];
    self.title = NSLocalizedString(@"OCAppName", @"");
    self.navigationController.delegate = self;
    [self.tableView reloadData];
}

#pragma mark - Table View Stack

/*
 required by UITableViewDelegate and UITableViewDataSource
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.games count];
}

/*
 required by UITableViewDelegate and UITableViewDataSource
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"GameSelectorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [[self.games objectAtIndex:indexPath.row] valueForKey:@"titleStory"];
    //cell.detailTextLabel.text = [[self.games objectAtIndex:indexPath.row] valueForKey:@"introStory"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

/*
 required by UITableViewDelegate to capture clicks
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    // get the universe for this row and set it to the game data controller
    self.gameDataController.currentUniverse = [self.games objectAtIndex:indexPath.row];
    
    // set up the Game Selector View
    GameSelectorViewController *gsvc = [[GameSelectorViewController alloc] initWithNibName:@"GameSelectorViewController" bundle:nil];
    gsvc.gameDataController = self.gameDataController;
    
    // push
    [self.navigationController pushViewController:gsvc animated:YES];
}

/*
 required by UITableViewDelegate to move and delete rows, the latter being what
 we want here.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
    
        // capture the universe to be deleted
        NSManagedObject *targetUniverse = [self.games objectAtIndex:indexPath.row];
        
        // delete the object
        if ( [self.gameDataController deleteUniverse:targetUniverse] ) {
            
            // update the data source for the table view
            [self.games removeObjectAtIndex:indexPath.row];
                        
            // update the rows
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        } else {
            
            // something bad happened
            NSLog(@"ERROR: MainViewController:newGame: NO");
        }
         
    }
    // update the table
    self.games = [self.gameDataController retrieveGames];
    [self.tableView setEditing:NO animated:YES];
}

#pragma mark - Action Stack

- (IBAction)newGame:(id)sender {
    // check to be sure the new universe was made
    if ( [self.gameDataController createNewUniverse] ) {
        // update the list
        self.games = [self.gameDataController retrieveGames];
        [self.tableView reloadData];
    } else {
        // something bad happened
        NSLog(@"ERROR: MainViewController:newGame: NO");
    }
}

- (IBAction)editGames:(id)sender {
    
    if ( self.tableView.editing ) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self prepareViewController];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    controller.gameDataController = self.gameDataController;
    [self presentModalViewController:controller animated:YES];
}

@end
