//
//  GameComponentSelectorViewController.m
//  RPG Kit
//
//  Created by Philip Regan on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameComponentSelectorViewController.h"
#import "GameMetadataViewController.h"
#import "PlayerMetadataViewController.h"
#import "GameObjectSelectionViewController.h"

#pragma mark - Interface Constants

enum COMPONENT_INDEX {
    GAME_INDEX = 0,
    PLAYER_INDEX,
    TASKS_INDEX
};

@interface GameComponentSelectorViewController ()

@property (strong, nonatomic, readwrite) NSMutableArray *gameComponents;

@end

@implementation GameComponentSelectorViewController

@synthesize gameDataController = _gameDataController;
@synthesize tableView = _tableView;
@synthesize gameComponents = _gameComponents;

#pragma mark - Object Lifecycle Stack

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // this is largely a manual task since the data shown isn't dynamic
        self.gameComponents = [NSMutableArray arrayWithObjects:
                               @"Game", 
                               @"Player",
                               @"Tasks",
                               nil];
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

#pragma mark NavigationController Stack

-(void) viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    self.title = [self.gameDataController.currentUniverse valueForKey:OCAttributeTitleStory];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OCGameComponentBackButton", @"")
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil 
                                                                            action:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View Stack

/*
 required by UITableViewDelegate and UITableViewDataSource
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.gameComponents count];
}

/*
 required by UITableViewDelegate and UITableViewDataSource
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"GameComponentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // set the label for the cell by the index
    switch ( indexPath.row ) {
        case GAME_INDEX:
            cell.textLabel.text = NSLocalizedString(@"OCGameComponentGame", @"");
            break;
        case PLAYER_INDEX:
            cell.textLabel.text = NSLocalizedString(@"OCGameComponentPlayer", @"");
            break;
        case TASKS_INDEX:
            cell.textLabel.text = NSLocalizedString(@"OCGameComponentTask", @"");
            break;
        default:
            break;
    }
    
    
    return cell;
    
}

/*
 required by UITableViewDelegate to capture clicks
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
                                                    
    // set up the appropriate view by the row clicked
    switch ( indexPath.row ) {
        case GAME_INDEX:
            [self pushGameMetadataView];
            break;
        case PLAYER_INDEX:
            [self pushPlayerMetadataView];
            break;
        case TASKS_INDEX:
            [self pushTasksMetadataView];
            break;
        default:
            break;
    }
}

#pragma mark - Action Stack

/*
 since we can't have object instantiation within a switch statement (I know, right?)
 we have the below helper methods for pushing views according to the component
 selected by the user
 */

/*
 Helper method to push to the game metadata view 
*/
- (void)pushGameMetadataView {
    GameMetadataViewController *gameMetadataViewController = [[GameMetadataViewController alloc] initWithNibName:@"GameMetadataViewController" bundle:nil];
    gameMetadataViewController.gameDataController = self.gameDataController;
    [self.navigationController pushViewController:gameMetadataViewController animated:YES];
}

/*
 Helper method to push to the player metadata view 
 */
- (void)pushPlayerMetadataView {
    PlayerMetadataViewController *playerMetadataViewController = [[PlayerMetadataViewController alloc] initWithNibName:@"PlayerMetadataViewController" bundle:nil];
    playerMetadataViewController.gameDataController = self.gameDataController;
    [self.navigationController pushViewController:playerMetadataViewController animated:YES];
}

/*
 DEPRECATED AS EQUIPMENT NOT IMPLEMENTED
 Helper method to push to the equipment metadata view
 */
- (void)pushEquipmentMetadataView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" 
                                                        message:@"Equipment has not been implemented yet" 
                                                       delegate:self 
                                              cancelButtonTitle:@"Bummer" 
                                              otherButtonTitles:nil];
    [alertView show];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

/*
 Helper method to push to the tasks metadata view
 */
- (void)pushTasksMetadataView {
    GameObjectSelectionViewController *gameObjectSelectionViewController = [[GameObjectSelectionViewController alloc] initWithNibName:@"GameObjectSelectionViewController" bundle:nil];
    gameObjectSelectionViewController.gameDataController = self.gameDataController;
    // because
    gameObjectSelectionViewController.targetEntity = nil;
    gameObjectSelectionViewController.targetRelationship = OCRelationshipQuests;
    gameObjectSelectionViewController.targetParent = self.gameDataController.currentUniverse;
    [self.navigationController pushViewController:gameObjectSelectionViewController animated:YES];
}

@end
