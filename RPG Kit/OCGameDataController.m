//
//  OCGameDataController.m
//  RPG KIT
//
//  Created by Philip Regan on 4/12/12.
//  Copyright (c) 2012 Jones & Bartlett Learning. All rights reserved.
//

#import "OCGameDataController.h"
#import "OCStrings.h"

#pragma mark - Game Controller Constants

enum SAMPLE_GAME_TYPE {
    SAMPLE_AUTO = 0,
    SAMPLE_OFFICE = 1,
    SAMPLE_SCIFI = 2,
    SAMPLE_FANTASY = 3,
    SAMPLE_GENERIC = 4
};

enum SAMPLE_LOCATIONS {
    LOC_HOME = 0,
    LOC_EASY,
    LOC_HARD,
    LOC_BOSS
};

@interface OCGameDataController ()

@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;

@end

@implementation OCGameDataController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize currentUniverse = _currentUniverse;

#pragma mark - Object Lifecycle Stack

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc
{
    self = [super init];
    if (self) {
        if ( !moc ) {
            // without the moc we are useless
            NSLog(@"ERROR: OCGameDataController \nmoc = nil\n");
            return nil;
        }
        self.managedObjectContext = moc;
    }
        
    return self;
}

- (void)dealloc
{
    
    //[super dealloc];
}

#pragma mark - Content Lifecycle Stack

- (BOOL)dataStoreIsPopulated {
    
    /*
     This is an abbreviated version of the code in retrieveEntity:withPredicate:. We are only
     checking the existance of an entity, not an entity with a particular quality
     */
    
    // starting with the context, drill down to the model
    NSPersistentStoreCoordinator *psc = [self.managedObjectContext persistentStoreCoordinator];
    NSManagedObjectModel *mom = [psc managedObjectModel];
    
    // create the fetch request and declare the entity sought
	NSFetchRequest *fetchRequestTemplate = [[NSFetchRequest alloc] init];
	NSEntityDescription *targetEntity = [[mom entitiesByName] objectForKey:OCEntityUniverse];
	[fetchRequestTemplate setEntity:targetEntity];
    
    // we only need 1 hit to show that the data store has been populated
    [fetchRequestTemplate setFetchLimit:1];
    
    // execute the request
	NSError *fetchError;
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequestTemplate error:&fetchError];
    
    if ( !fetchResults ) {
        //NSLog(@"Warning: OCGameDataController:dataStoreIsPopulated: \nfetchResults == nil");
        return NO;
    }
    
    // one quick check
    if ( [fetchResults count] == 0 ) {
        //NSLog(@"Warning: OCGameDataController:dataStoreIsPopulated: \nfetchResults == 0");
        return NO;
    }
    return YES;
    
}

- (BOOL) populateDefaults {
    
    if ( ![self populateSampleGame:SAMPLE_AUTO] ) {
        NSLog(@"OCGameDatController:populateDefaults:SAMPLE_AUTO: NO");
        return NO;
    }
    
    if ( ![self populateSampleGame:SAMPLE_OFFICE] ) {
        NSLog(@"OCGameDatController:populateDefaults:SAMPLE_OFFICE NO");
        return NO;
    }
    
    if ( ![self createWumpus] ) {
        NSLog(@"OCGameDatController:createWumpus: NO");
        return NO;
    }

    
    return YES;
}

- (BOOL)populateSampleGame:(int)type {
    
    /* CREATE THE UNIVERSE */
    
    // create a dictionary to hold the content for the universe object
    NSMutableDictionary *universeData = [NSMutableDictionary dictionary];
    
    // create a unique ID for this future object so that we may retrieve it easily later
    NSString *uuid = [self createUUID];
    
    // set the id for the object's id property
    [universeData setValue:uuid forKey:OCAttributeID];
    
    // populate the dictionary per the type of game desired
    switch ( type ) {
        case  SAMPLE_AUTO:
            [universeData setValue:NSLocalizedString(@"OCUniverseTitleAuto", @"") forKey:OCAttributeTitleStory];
            [universeData setValue:NSLocalizedString(@"OCUniverseIntroAuto", @"") forKey:OCAttributeIntroStory];
            [universeData setValue:NSLocalizedString(@"OCTemporalUnitWeek", @"") forKey:OCAttributeTemporalUnit];
            [universeData setValue:NSLocalizedString(@"OCMonetaryUnitCredit", @"") forKey:OCAttributeMonetaryUnit];
            break;
        case  SAMPLE_OFFICE:
            [universeData setValue:NSLocalizedString(@"OCUniverseTitleOffice", @"") forKey:OCAttributeTitleStory];
            [universeData setValue:NSLocalizedString(@"OCUniverseIntroOffice", @"") forKey:OCAttributeIntroStory];
            [universeData setValue:NSLocalizedString(@"OCTemporalUnitHour", @"") forKey:OCAttributeTemporalUnit];
            [universeData setValue:NSLocalizedString(@"OCMonetaryUnitDollar", @"") forKey:OCAttributeMonetaryUnit];
            break;
        case SAMPLE_GENERIC:
            [universeData setValue:NSLocalizedString(@"OCUniverseTitleGeneric", @"") forKey:OCAttributeTitleStory];
            [universeData setValue:NSLocalizedString(@"OCUniverseIntroGeneric", @"") forKey:OCAttributeIntroStory];
            [universeData setValue:NSLocalizedString(@"OCTemporalUnitExample", @"") forKey:OCAttributeTemporalUnit];
            [universeData setValue:NSLocalizedString(@"OCMonetaryUnitGoldPiece", @"") forKey:OCAttributeMonetaryUnit];
            break;
        default:
            break;
    }
    [universeData setValue:0 forKey:OCAttributeTemporalUnitsPassed];
    
    // create the universe and check for its existance
    NSManagedObject *universe = [self createEntity:OCEntityUniverse withData:universeData];
    
    if ( universe == nil ) {
        NSLog(@"ERROR: OCGameDataController: \nUniverse could not be created");
        return NO;
    }
    
    [self updateChanges];
        
    /* CREATE THE LOCATIONS */
    
    NSManagedObject *home = nil;
    NSManagedObject *easy = nil;
    NSManagedObject *hard = nil;
    NSManagedObject *boss = nil;
    
    for ( int loc = 0, lastLoc = 4 ; loc < lastLoc ; loc++ ) {
        
        NSMutableDictionary *locationData = [NSMutableDictionary dictionary];
        
        // create the remaining locations
        switch ( loc ) {
            case LOC_HOME:
                                
                // populate the dictionary per the type of game desired
                switch ( type ) {
                    case  SAMPLE_AUTO:
                        [locationData setValue:NSLocalizedString(@"OCHomeTitleAuto", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCHomeIntroAuto", @"") forKey:OCAttributeIntroStory];
                        break;
                    case  SAMPLE_OFFICE:
                        [locationData setValue:NSLocalizedString(@"OCHomeTitleOffice", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCHomeIntroOffice", @"") forKey:OCAttributeIntroStory];
                        break;
                    case  SAMPLE_GENERIC:
                        [locationData setValue:NSLocalizedString(@"OCHomeTitleGeneric", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCHomeIntroGeneric", @"") forKey:OCAttributeIntroStory];
                        break;
                }
                
                // create the home 
                home = [self createEntity:OCEntityTask withData:locationData];
                
                // sanity check
                if ( home == nil ) {
                    NSLog(@"ERROR: OCGameDataController: \nHome could not be created");
                    return NO;
                }
                
                // set the home to the universe and capture the change
                [universe setValue:home forKey:OCRelationshipHome];
                [self updateChanges];
                
                break;
                
            case LOC_EASY:
                                
                // populate the dictionary per the type of game desired
                switch ( type ) {
                    case  SAMPLE_AUTO:
                        [locationData setValue:NSLocalizedString(@"OCEasyTaskTitleAuto", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCEasyTaskIntroAuto", @"") forKey:OCAttributeIntroStory];
                        break;
                    case  SAMPLE_OFFICE:
                        [locationData setValue:NSLocalizedString(@"OCEasyTaskTitleOffice", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCEasyTaskIntroOffice", @"") forKey:OCAttributeIntroStory];
                        break;
                    case  SAMPLE_GENERIC:
                        [locationData setValue:NSLocalizedString(@"OCEasyTaskTitleGeneric", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCEasyTaskIntroGeneric", @"") forKey:OCAttributeIntroStory];
                        break;
                }
                
                // create the easy task
                easy = [self createEntity:OCEntityTask withData:locationData];
                
                // sanity check
                if ( easy == nil ) {
                    NSLog(@"ERROR: OCGameDataController: \nEasy could not be created");
                    return NO;
                }
                
                break;
                
            case LOC_HARD:
                
                // populate the dictionary per the type of game desired
                switch ( type ) {
                    case  SAMPLE_AUTO:
                        [locationData setValue:NSLocalizedString(@"OCHardTaskTitleAuto", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCHardTaskIntroAuto", @"") forKey:OCAttributeIntroStory];
                        break;
                    case  SAMPLE_OFFICE:
                        [locationData setValue:NSLocalizedString(@"OCHardTaskTitleOffice", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCHardTaskIntroOffice", @"") forKey:OCAttributeIntroStory];
                        break;
                    case  SAMPLE_GENERIC:
                        [locationData setValue:NSLocalizedString(@"OCHardTaskTitleGeneric", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCHardTaskIntroGeneric", @"") forKey:OCAttributeIntroStory];
                        break;
                }
                
                // create the hard task
                hard = [self createEntity:OCEntityTask withData:locationData];
                
                // sanity check
                if ( hard == nil ) {
                    NSLog(@"ERROR: OCGameDataController: \nHard could not be created");
                    return NO;
                }
                
                break;
                
            case LOC_BOSS:
                
                // populate the dictionary per the type of game desired
                switch ( type ) {
                    case  SAMPLE_AUTO:
                        [locationData setValue:NSLocalizedString(@"OCBossTaskTitleAuto", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCBossTaskIntroAuto", @"") forKey:OCAttributeIntroStory];
                        break;
                    case  SAMPLE_OFFICE:
                        [locationData setValue:NSLocalizedString(@"OCBossTaskTitleOffice", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCBossTaskIntroOffice", @"") forKey:OCAttributeIntroStory];
                        break;
                    case  SAMPLE_GENERIC:
                        [locationData setValue:NSLocalizedString(@"OCBossTaskTitleGeneric", @"") forKey:OCAttributeTitleStory];
                        [locationData setValue:NSLocalizedString(@"OCBossTaskIntroGeneric", @"") forKey:OCAttributeIntroStory];
                        break;
                 }
                
                // create the boss task
                boss = [self createEntity:OCEntityTask withData:locationData];
                
                // sanity check
                if ( boss == nil ) {
                    NSLog(@"ERROR: OCGameDataController: \nBoss could not be created");
                    return NO;
                }
                
                break;
        }
    }
    
    // set the core locations to the universe as quests and vice versa
    [universe setValue:[NSMutableSet setWithObjects:home, easy, hard, boss, nil] forKey:OCRelationshipQuests];
    
    [home setValue:universe forKey:OCRelationshipUniverse];
    [easy setValue:universe forKey:OCRelationshipUniverse];
    [hard setValue:universe forKey:OCRelationshipUniverse];
    [boss setValue:universe forKey:OCRelationshipUniverse];
    
    // mark the home location as being un-deletable
    [home setValue:[NSNumber numberWithBool:YES] forKey:OCAttributeInGameObject];
    
    /* RECORD LOCATION LINKS */
    
    /* 
     * Linking is hard, but Core Data makes it much easier than SQLite3 in Android.
     *
     * Just like in the original Android implementation, we are targeting the 
     * following configuration...
     *
     *   1
     *  /|\
     * 0 | 3
     *  \|/
     *   2
     *
     * All tasks link back to their universe
     * Locations link to other Locations
     * Accomplishments link to Locations
     * Tasks link to Tasks just as a generic hook
     */
    
    [home setValue:[NSMutableSet setWithObjects:easy, hard, nil] forKey:OCRelationshipSiblingLocation];
    [easy setValue:[NSMutableSet setWithObjects:home, hard, boss, nil] forKey:OCRelationshipSiblingLocation];
    [hard setValue:[NSMutableSet setWithObjects:home, easy, boss, nil] forKey:OCRelationshipSiblingLocation];
    [boss setValue:[NSMutableSet setWithObjects:easy, hard, nil] forKey:OCRelationshipSiblingLocation];
    
    [self updateChanges];
    
    /* ADD THE ACCOMPLISHMENTS */
    
    // init some dictionaries with the now ubiquitous universe link
    NSMutableDictionary *easyAccompData = [NSMutableDictionary dictionaryWithObject:universe forKey:OCRelationshipUniverse];
    NSMutableDictionary *hardAccompData = [NSMutableDictionary dictionaryWithObject:universe forKey:OCRelationshipUniverse];
    NSMutableDictionary *bossAccompData = [NSMutableDictionary dictionaryWithObject:universe forKey:OCRelationshipUniverse];
    
    // populate the dictionaries by the type of game we are creating
    switch ( type ) {
        case SAMPLE_AUTO:
            [easyAccompData setValue:NSLocalizedString(@"OCEasyAccomplishmentTitleAuto", @"") forKey:OCAttributeTitleStory];
            [easyAccompData setValue:NSLocalizedString(@"OCEasyAccomplishmentIntroAuto", @"") forKey:OCAttributeIntroStory];
            [hardAccompData setValue:NSLocalizedString(@"OCHardAccomplishmentTitleAuto", @"") forKey:OCAttributeTitleStory];
            [hardAccompData setValue:NSLocalizedString(@"OCHardAccomplishmentIntroAuto", @"") forKey:OCAttributeIntroStory];
            [bossAccompData setValue:NSLocalizedString(@"OCBossAccomplishmentTitleAuto", @"") forKey:OCAttributeTitleStory];
            [bossAccompData setValue:NSLocalizedString(@"OCBossAccomplishmentIntroAuto", @"") forKey:OCAttributeIntroStory];
            break;
        case SAMPLE_OFFICE:
            [easyAccompData setValue:NSLocalizedString(@"OCEasyAccomplishmentTitleOffice", @"") forKey:OCAttributeTitleStory];
            [easyAccompData setValue:NSLocalizedString(@"OCEasyAccomplishmentIntroOffice", @"") forKey:OCAttributeIntroStory];
            [hardAccompData setValue:NSLocalizedString(@"OCHardAccomplishmentTitleOffice", @"") forKey:OCAttributeTitleStory];
            [hardAccompData setValue:NSLocalizedString(@"OCHardAccomplishmentIntroOffice", @"") forKey:OCAttributeIntroStory];
            [bossAccompData setValue:NSLocalizedString(@"OCBossAccomplishmentTitleOffice", @"") forKey:OCAttributeTitleStory];
            [bossAccompData setValue:NSLocalizedString(@"OCBossAccomplishmentIntroOffice", @"") forKey:OCAttributeIntroStory];
            break;
        case SAMPLE_GENERIC:
            [easyAccompData setValue:NSLocalizedString(@"OCAccomplishmentTitleGeneric", @"") forKey:OCAttributeTitleStory];
            [easyAccompData setValue:NSLocalizedString(@"OCAccomplishmentIntroGeneric", @"") forKey:OCAttributeIntroStory];
            [hardAccompData setValue:NSLocalizedString(@"OCAccomplishmentTitleGeneric", @"") forKey:OCAttributeTitleStory];
            [hardAccompData setValue:NSLocalizedString(@"OCAccomplishmentIntroGeneric", @"") forKey:OCAttributeIntroStory];
            [bossAccompData setValue:NSLocalizedString(@"OCAccomplishmentTitleGeneric", @"") forKey:OCAttributeTitleStory];
            [bossAccompData setValue:NSLocalizedString(@"OCAccomplishmentIntroGeneric", @"") forKey:OCAttributeIntroStory];
            break;
        default:
            break;
    }
    
    // generate the managed objects and sanity check
    
    NSManagedObject *easyAccomplishment = [self createEntity:OCEntityTask withData:easyAccompData];
    
    if ( easyAccomplishment == nil ) {
        NSLog(@"ERROR: OCGameDataController: \nEasy accomplishment could not be created");
        return NO;
    }
    
    NSManagedObject *hardAccomplishment = [self createEntity:OCEntityTask withData:hardAccompData];
    
    if ( hardAccomplishment == nil ) {
        NSLog(@"ERROR: OCGameDataController: \nHard accomplishment could not be created");
        return NO;
    }
    
    NSManagedObject *bossAccomplishment = [self createEntity:OCEntityTask withData:bossAccompData];
    
    if ( bossAccomplishment == nil ) {
        NSLog(@"ERROR: OCGameDataController: \nBoss accomplishment could not be created");
        return NO;
    }
    
    // couple the intended accomplishments to their respective locations
    
    [easyAccomplishment setValue:[NSSet setWithObject:easy] forKey:OCRelationshipParentLocation];
    [easy setValue:[NSSet setWithObject:easyAccomplishment] forKey:OCRelationshipChildAccomplishment];
    [hardAccomplishment setValue:[NSSet setWithObject:hard] forKey:OCRelationshipParentLocation];
    [hard setValue:[NSSet setWithObject:hardAccomplishment] forKey:OCRelationshipChildAccomplishment];
    [bossAccomplishment setValue:[NSSet setWithObject:boss] forKey:OCRelationshipParentLocation];
    [boss setValue:[NSSet setWithObject:bossAccomplishment] forKey:OCRelationshipChildAccomplishment];
    
    // create and couple abilties for the accomplishments to be used during game play
    NSManagedObject *easyAbilities = [self createAbilitiesForAccomplishment];
    [easyAbilities setValue:easyAccomplishment forKey:OCRelationshipTask];
    [easyAccomplishment setValue:easyAbilities forKey:OCRelationshipAbilities];
    
    NSManagedObject *hardAbilities = [self createAbilitiesForAccomplishment];
    [hardAbilities setValue:hardAccomplishment forKey:OCRelationshipTask];
    [hardAccomplishment setValue:hardAbilities forKey:OCRelationshipAbilities];
    
    NSManagedObject *bossAbilities = [self createAbilitiesForAccomplishment];
    [bossAbilities setValue:bossAccomplishment forKey:OCRelationshipTask];
    [bossAccomplishment setValue:bossAbilities forKey:OCRelationshipAbilities];

    
    [self updateChanges];
    
    /* CREATE THE PLAYER */
    
    // now that we have a destination location within the game, we insert 
    // the player
    
    NSMutableDictionary *playerData = [NSMutableDictionary dictionary];
    
    // general atributes
    [playerData setValue:home forKey:OCRelationshipHome];
    [playerData setValue:universe forKey:OCRelationshipUniverse];
    
    // game-specific attributes
    switch ( type ) {
        case SAMPLE_AUTO:
            [playerData setValue:NSLocalizedString(@"OCPlayerTitleAuto", @"") forKey:OCAttributeTitleStory];
            [playerData setValue:NSLocalizedString(@"OCPlayerIntroAuto", @"") forKey:OCAttributeIntroStory];
            break;
        case SAMPLE_OFFICE:
            [playerData setValue:NSLocalizedString(@"OCPlayerTitleOffice", @"") forKey:OCAttributeTitleStory];
            [playerData setValue:NSLocalizedString(@"OCPlayerIntroOffice", @"") forKey:OCAttributeIntroStory];
            break;
        case SAMPLE_GENERIC:
            [playerData setValue:NSLocalizedString(@"OCPlayerTitleGeneric", @"") forKey:OCAttributeTitleStory];
            [playerData setValue:NSLocalizedString(@"OCPlayerIntroGeneric", @"") forKey:OCAttributeIntroStory];
            break;
        default:
            break;
    }
    
    NSManagedObject* player = [self createEntity:OCEntityPlayer withData:playerData];
    
    // sanity check
    if ( player == nil ) {
        NSLog(@"ERROR: OCGameDataController: \nPlayer could not be created");
        return NO;
    }
    
    // link the player to the universe
    [universe setValue:player forKey:OCRelationshipPlayer];
    [player setValue:universe forKey:OCRelationshipUniverse];
    
    // create abilities for the player
    NSManagedObject *playerAbilities = [self createAbilitiesForPlayer];
    [player setValue:playerAbilities forKey:OCRelationshipPlayerAbilities];
    [playerAbilities setValue:player forKey:OCRelationshipAbilitiesPlayer];
    
    /* TODO CREATE THE ANCILLARY OBJECTS */
    
    // create a couple widgets for equipment, one for the player and one 
    // for a location
    
    // create a wallet for the player
        
    /* SAVE THE DATA STORE */
    
    [self updateChanges];
    
    return YES;

}

/*
 last minute implementation of a complex map just to see if we can do it. We break
 some rules here
 */

-(BOOL)createWumpus {
    // create a dictionary to hold the content for the universe object
    NSMutableDictionary *universeData = [NSMutableDictionary dictionary];
    
    // create a unique ID for this future object so that we may retrieve it easily later
    NSString *uuid = [self createUUID];
    
    // set the id for the object's id property
    [universeData setValue:uuid forKey:OCAttributeID];
    
    [universeData setValue:@"Hunt The Wumpus" forKey:OCAttributeTitleStory];
    [universeData setValue:@"Only problem is...there's no Wumpus"forKey:OCAttributeIntroStory];
    [universeData setValue:@"hour" forKey:OCAttributeTemporalUnit];
    [universeData setValue:@"gold piece" forKey:OCAttributeMonetaryUnit];
    [universeData setValue:0 forKey:OCAttributeTemporalUnitsPassed];
    
    // create the universe and check for its existance
    NSManagedObject *universe = [self createEntity:OCEntityUniverse withData:universeData];
    
    if ( universe == nil ) {
        NSLog(@"ERROR: OCGameDataController: \nUniverse could not be created");
        return NO;
    }
    
    /* Locations */
    
    NSMutableArray *locations = [NSMutableArray array];
    
    for ( int loc = 1, lastLoc = 20 ; loc <= lastLoc ; loc++ ) {
        
        NSMutableDictionary *locationData = [NSMutableDictionary dictionary];
        
        [locationData setValue:[NSString stringWithFormat:@"Location %i", loc] forKey:OCAttributeTitleStory];
        [locationData setValue:@"No Wumpus here." forKey:OCAttributeIntroStory];
        
        NSManagedObject *location = [self createEntity:OCEntityTask withData:locationData];
        
        // sanity check
        if ( location == nil ) {
            NSLog(@"ERROR: OCGameDataController: \nLocation could not be created");
            return NO;
        }
        
        // set the home to the universe and capture the change
        if ( loc == 1 ) {
            [universe setValue:location forKey:OCRelationshipHome];
        }
        
        // bind the universe and locatipn
        [location setValue:universe forKey:OCRelationshipUniverse];
        [universe setValue:[self mergeNewSet:[NSMutableSet setWithObject:location] withOriginalSet:[universe valueForKey:OCRelationshipQuests]] forKey:OCRelationshipQuests];
        
        [locations addObject:location];
        
        [self updateChanges];
        
    }
    
    /* Linking */
    
    // Wumpus's map is a flattened 12-sided object, where each node links to 3 nodes
    
    for ( int loc = 0, lastLoc = 20 ; loc < lastLoc ; loc++ ) {
        NSManagedObject *parentLocation = [locations objectAtIndex:loc];
        NSMutableSet *childSet = [NSMutableSet set];
        
        switch ( loc ) {
            case 0:
                [childSet addObject:[locations objectAtIndex:1]];
                [childSet addObject:[locations objectAtIndex:4]];
                [childSet addObject:[locations objectAtIndex:5]];
                break;
            case 1:
                [childSet addObject:[locations objectAtIndex:0]];
                [childSet addObject:[locations objectAtIndex:2]];
                [childSet addObject:[locations objectAtIndex:6]];
                break;
            case 2:
                [childSet addObject:[locations objectAtIndex:1]];
                [childSet addObject:[locations objectAtIndex:3]];
                [childSet addObject:[locations objectAtIndex:7]];
                break;
            case 3:
                [childSet addObject:[locations objectAtIndex:2]];
                [childSet addObject:[locations objectAtIndex:4]];
                [childSet addObject:[locations objectAtIndex:8]];
                break;    
            case 4:
                [childSet addObject:[locations objectAtIndex:0]];
                [childSet addObject:[locations objectAtIndex:3]];
                [childSet addObject:[locations objectAtIndex:9]];
                break;    
            case 5:
                [childSet addObject:[locations objectAtIndex:0]];
                [childSet addObject:[locations objectAtIndex:10]];
                [childSet addObject:[locations objectAtIndex:11]];
                break;    
            case 6:
                [childSet addObject:[locations objectAtIndex:1]];
                [childSet addObject:[locations objectAtIndex:11]];
                [childSet addObject:[locations objectAtIndex:12]];
                break;    
            case 7:
                [childSet addObject:[locations objectAtIndex:2]];
                [childSet addObject:[locations objectAtIndex:12]];
                [childSet addObject:[locations objectAtIndex:13]];
                break;    
            case 8:
                [childSet addObject:[locations objectAtIndex:3]];
                [childSet addObject:[locations objectAtIndex:13]];
                [childSet addObject:[locations objectAtIndex:14]];
                break;    
            case 9:
                [childSet addObject:[locations objectAtIndex:4]];
                [childSet addObject:[locations objectAtIndex:10]];
                [childSet addObject:[locations objectAtIndex:14]];
                break;    
            case 10:
                [childSet addObject:[locations objectAtIndex:5]];
                [childSet addObject:[locations objectAtIndex:9]];
                [childSet addObject:[locations objectAtIndex:16]];
                break;    
            case 11:
                [childSet addObject:[locations objectAtIndex:5]];
                [childSet addObject:[locations objectAtIndex:6]];
                [childSet addObject:[locations objectAtIndex:17]];
                break;    
            case 12:
                [childSet addObject:[locations objectAtIndex:6]];
                [childSet addObject:[locations objectAtIndex:7]];
                [childSet addObject:[locations objectAtIndex:18]];
                break;    
            case 13:
                [childSet addObject:[locations objectAtIndex:7]];
                [childSet addObject:[locations objectAtIndex:8]];
                [childSet addObject:[locations objectAtIndex:19]];
                break;
            case 14:
                [childSet addObject:[locations objectAtIndex:8]];
                [childSet addObject:[locations objectAtIndex:9]];
                [childSet addObject:[locations objectAtIndex:15]];
                break;    
            case 15:
                [childSet addObject:[locations objectAtIndex:14]];
                [childSet addObject:[locations objectAtIndex:16]];
                [childSet addObject:[locations objectAtIndex:19]];
                break;    
            case 16:
                [childSet addObject:[locations objectAtIndex:10]];
                [childSet addObject:[locations objectAtIndex:15]];
                [childSet addObject:[locations objectAtIndex:17]];
                break;    
            case 17:
                [childSet addObject:[locations objectAtIndex:11]];
                [childSet addObject:[locations objectAtIndex:16]];
                [childSet addObject:[locations objectAtIndex:18]];
                break;    
            case 18:
                [childSet addObject:[locations objectAtIndex:12]];
                [childSet addObject:[locations objectAtIndex:17]];
                [childSet addObject:[locations objectAtIndex:19]];
                break;  
            case 19:
                [childSet addObject:[locations objectAtIndex:13]];
                [childSet addObject:[locations objectAtIndex:15]];
                [childSet addObject:[locations objectAtIndex:18]];
                break;
            default:
                break;
        }
        
        [parentLocation setValue:childSet forKey:OCRelationshipSiblingLocation];
        
        [self updateChanges];

    }
    
    /* CREATE THE PLAYER */
    
    // now that we have a destination location within the game, we insert 
    // the player
    
    NSMutableDictionary *playerData = [NSMutableDictionary dictionary];
    
    // general atributes
    [playerData setValue:[locations objectAtIndex:0] forKey:OCRelationshipHome];
    [playerData setValue:universe forKey:OCRelationshipUniverse];
    [playerData setValue:@"John Q. Taxpayer" forKey:OCAttributeTitleStory];
    [playerData setValue:@"You are not the Wumpus" forKey:OCAttributeIntroStory];
    
    NSManagedObject* player = [self createEntity:OCEntityPlayer withData:playerData];
    
    // sanity check
    if ( player == nil ) {
        NSLog(@"ERROR: OCGameDataController: \nPlayer could not be created");
        return NO;
    }
    
    // link the player to the universe
    [universe setValue:player forKey:OCRelationshipPlayer];
    [player setValue:universe forKey:OCRelationshipUniverse];
    
    // create abilities for the player
    NSManagedObject *playerAbilities = [self createAbilitiesForPlayer];
    [player setValue:playerAbilities forKey:OCRelationshipPlayerAbilities];
    [playerAbilities setValue:player forKey:OCRelationshipAbilitiesPlayer];
    

    [self updateChanges];
    return YES;
    
}

- (void)updateChanges {
    
    /*
     Core Data makes the saving of changes a trivial task, but there are no hooks in 
     the API to save only those managed objects that have changed.
     */
    
    NSError *saveError;
    [self.managedObjectContext save:&saveError];
    if ( saveError ) {
        NSLog(@"ERROR: OCGameDataController:updateChanges: \nerror:%@ \n", saveError);
    }
}

-(void)resetGames {
    
    /*
     We could have duplicated the code required in the AppDelegate class to simply
     nuke the data store and ster fresh, but that would be overkill and this is 
     much easier to maintain.
     */
    NSMutableArray *games = [self retrieveGames];
    for ( NSManagedObject *game in games ) {
        [self deleteUniverse:game];
    }
    
    [self populateDefaults];
    
}

#pragma mark - MainViewController Stack

- (BOOL)createNewUniverse {
    return [self populateSampleGame:SAMPLE_GENERIC];
}

- (NSMutableArray *)retrieveGames {
    NSArray *games = [self retrieveAllObjectsForEntity:OCEntityUniverse];

    if ( !games ) {
        return [NSMutableArray array];
    } else {
        return [NSMutableArray arrayWithArray:games];
    }
    
    return nil;
}

- (BOOL)deleteUniverse:(NSManagedObject *)targetUniverse {
    
    // we are sending NO for the deep deletion flag because that will be taken care
    // of by the store. All relationships from universe are set to cascade, which
    // means the linked object will be deleted as well. *Everything* in a universe is
    // tied to the parent universe
    
    if ( ![self deleteInstanceOfEntity:targetUniverse deepDelete:NO] ) {
        NSLog(@"ERROR: OCGameDataController:deleteUniverse: NO");
        return NO;
    }
    [self updateChanges];
    return YES;
}

#pragma mark - Player Metadata Stack

#pragma mark Name Stack

- (NSString *)retrievePlayerName {
    // get the player for the current game
    NSManagedObject *player = [self retrieveCurrentPlayer];
    if ( !player ) {
        // something bad happened, but we want the game or editing to continue with
        // little issue to the user so we pass something even if it is empty
        return @"";
    }
    // get the value for the key. bam.
    return [player valueForKey:OCAttributeTitleStory];
}

- (void)updatePlayerName:(NSString *)playerName {
     // get the player for the current game
    NSManagedObject *player = [self retrieveCurrentPlayer];
    if ( !player ) {
        // something bad happened that is reported elsewhere but we cannot continue
        return;
    }
    // apply the new string to the entity
    [player setValue:playerName forKey:OCAttributeTitleStory];
    // save the changes
    [self updateChanges];
}

#pragma mark Intro Stack

/* comments in the name stack apply here as well */

- (NSString *)retrievePlayerIntro {
    NSManagedObject *player = [self retrieveCurrentPlayer];
    if ( !player ) {
        return @"";
    }    
    return [player valueForKey:OCAttributeIntroStory];
}

- (void)updatePlayerIntro:(NSString *)playerIntro {
    NSManagedObject *player = [self retrieveCurrentPlayer];
    if ( !player ) {
        return;
    }
    [player setValue:playerIntro forKey:OCAttributeIntroStory];
    [self updateChanges];
}

/*
 Convenience method for getting the player object linked to the current universe. 
 Will return nil on any error. Errors are reported to the console.
 */
- (NSManagedObject *)retrieveCurrentPlayer {
    
    // get the player for the current universe by getting all of those player entities
    // that have the current universe set to the relationship
    NSArray *players = [self retrieveEntity:OCEntityPlayer 
                              withPredicate:[NSPredicate predicateWithFormat:@"universe = %@", self.currentUniverse]];
    
    // this is set in the populateDefaults method and we do not allow for creation
    // or deletion but we do a sanity check anyway because something else may have 
    // happened along the way
    
    if ( !players || [players count] <= 0 ) {
        NSLog(@"ERROR: OCGameDataController:retrieveCurrentPlayer: no players were found");
        return nil;
    }
    
    // we know we have something so we are safe to return it
    return [players objectAtIndex:0];
}

#pragma mark - Game Object Selection Stack

- (BOOL)createNewTask {
    
    /* 
     this parallels what happens in populateSampleGame, and should just call this here,
     but was written long after
     */
    
    NSMutableDictionary *taskData = [NSMutableDictionary dictionary];
    
    // set the core information and relationships needed for a new task
    [taskData setValue:self.currentUniverse forKey:OCRelationshipUniverse];
    [taskData setValue:NSLocalizedString(@"OCGenericTaskTitleGeneric", @"") forKey:OCAttributeTitleStory];
    [taskData setValue:NSLocalizedString(@"OCGenericTaskIntroGeneric", @"") forKey:OCAttributeIntroStory];
    
    // create the task 
    if ( ![self createEntity:OCEntityTask withData:taskData] ) {
        NSLog(@"ERROR: OCGameDataController: \nnewTask could not be created");
        return NO;
    }
    
    NSManagedObject *newTask = [self retrieveLastObjectCreatedByEntity:OCEntityTask];
    
    // sanity check
    if ( !newTask ) {
        NSLog(@"ERROR: OCGameDataController: \nnewTask could not be retrieved");
        return NO;
    }
    
    [self updateChanges];
    return YES;
}

- (NSMutableArray *)retrieveTasks {
    NSArray *tasks = [self retrieveEntity:OCEntityTask
                              withPredicate:[NSPredicate predicateWithFormat:@"universe = %@", self.currentUniverse]];
    
    if ( !tasks || [tasks count] <= 0 ) {
         NSLog(@"ERROR: OCGameDataController: \nNo tasks were retrieved");
        return [NSMutableArray array];
    } else {
        return [NSMutableArray arrayWithArray:tasks];
    }
    
    return nil;
}

- (BOOL)deleteTask:(NSManagedObject *)targetTask {
    
    /*
     this is where a simple yes/no is failing us and a better design needs to be 
     implemented to accomodate what to do with child tasks (accomplishments) and 
     linked objects (universe, player).
     */
    
    if ( [[targetTask valueForKey:OCAttributeInGameObject] boolValue] == YES ) {
        // fail silently because returning YES causes the table view to remove the item
        return NO;
    }
    
    if ( ![self deleteInstanceOfEntity:targetTask deepDelete:NO] ) {
        NSLog(@"ERROR: OCGameDataController:deleteTask: NO");
        return NO;
    }
    [self updateChanges];
    return YES;
}

#pragma mark Quest Stack
/*
 CRUD convenience methods for quests
 */
- (BOOL)createNewQuest {
    /* 
     this parallels what happens in populateSampleGame, and should just call this here,
     but was written long after
     */
    
    NSMutableDictionary *taskData = [NSMutableDictionary dictionary];
    
    // set the core information and relationships needed for a new task
    [taskData setValue:self.currentUniverse forKey:OCRelationshipUniverse];
    [taskData setValue:NSLocalizedString(@"OCGenericTaskTitleGeneric", @"") forKey:OCAttributeTitleStory];
    [taskData setValue:NSLocalizedString(@"OCGenericTaskIntroGeneric", @"") forKey:OCAttributeIntroStory];
    
    // create the task 
    if ( ![self createEntity:OCEntityTask withData:taskData] ) {
        NSLog(@"ERROR: OCGameDataController: \nnewTask could not be created");
        return NO;
    }
    
    NSManagedObject *newTask = [self createEntity:OCEntityTask withData:taskData];
    
    // sanity check
    if ( newTask == nil ) {
        NSLog(@"ERROR: OCGameDataController: \nnewTask could not be retrieved");
        return NO;
    }
    
    // fold in the new task, ultimately destined to be a quest, and in with the other quests
    [self.currentUniverse setValue:[self mergeNewSet:[NSSet setWithObject:newTask] withOriginalSet:[self.currentUniverse valueForKey:OCRelationshipQuests]] forKey:OCRelationshipQuests];
    
    [self updateChanges];
    return YES;

}

- (NSMutableArray *)retrieveQuests {
        
    NSArray *tasks = [self retrieveEntity:OCEntityTask
                            withPredicate:[NSPredicate predicateWithFormat:@"universe = %@", self.currentUniverse]];
    
    if ( !tasks || [tasks count] <= 0 ) {
        NSLog(@"ERROR: OCGameDataController: \nNo tasks were retrieved");
        return [NSMutableArray array];
    } else {
        return [NSMutableArray arrayWithArray:tasks];
    }
    
    return nil;
    
}

- (BOOL)deleteQuest:(NSManagedObject *)targetQuest {
    /*
     this is where a simple yes/no is failing us and a better design needs to be 
     implemented to accomodate what to do with child tasks (accomplishments) and 
     linked objects (universe, player).
     */
    
    if ( ![self deleteInstanceOfEntity:targetQuest deepDelete:NO] ) {
        NSLog(@"ERROR: OCGameDataController:deleteQuest: NO");
        return NO;
    }
    [self updateChanges];
    return YES;

}

#pragma mark - Game Object Linking Stack

- (NSArray *)retrieveEntities:(NSString *)entity relatedToObject:(NSManagedObject *)sourceObject viaRelationship:(NSString *)targetRelationship {
    return [[sourceObject valueForKey:targetRelationship] allObjects];
}

- (void)linkObjects:(NSMutableSet *)childObjects toParent:(NSManagedObject *)targetParent viaRelationship:(NSString *)relationship {
    
        // sort out the child and parent keys based on the relationship
    
    NSString *childKey = OCRelationshipParent;
    NSString *parentKey = OCRelationshipParent;
    
    if ( [relationship isEqualToString:OCRelationshipSiblingLocation] ) {
        childKey = OCRelationshipSiblingLocation;
        parentKey = OCRelationshipSiblingLocation;
    } else if ( [relationship isEqualToString:OCRelationshipParentLocation] ) {
        childKey = OCRelationshipParentLocation;
        parentKey = OCRelationshipChildAccomplishment;
    } else if ( [relationship isEqualToString:OCRelationshipChildAccomplishment] ) {
        childKey = OCRelationshipParentLocation;
        parentKey = OCRelationshipChildAccomplishment;
    }
    
    for ( NSManagedObject *childObject in childObjects ) {
        
        // merge the child object into the parent object's object set and vice versa
        NSMutableSet *childSet = [NSMutableSet setWithObject:childObject];
        NSMutableSet *mergedChildWithParentsChildren = [self mergeNewSet:childSet withOriginalSet:[targetParent valueForKey:parentKey]];
        [targetParent setValue:mergedChildWithParentsChildren forKey:parentKey];
        
        NSMutableSet *parentSet = [NSMutableSet setWithObject:targetParent];
        NSMutableSet *mergedParentWithChildrensParents = [self mergeNewSet:parentSet withOriginalSet:[childObject valueForKey:childKey]];
        [childObject setValue:mergedParentWithChildrensParents forKey:childKey];
    }
    
    [self updateChanges];
}

- (void)delinkObjects:(NSMutableSet *)childObjects fromParent:(NSManagedObject *)targetParent viaRelationship:(NSString *)relationship {
    // sort out the child and parent keys based on the relationship
    
    NSString *childKey = OCRelationshipParent;
    NSString *parentKey = OCRelationshipParent;
    
    if ( [relationship isEqualToString:OCRelationshipSiblingLocation] ) {
        childKey = OCRelationshipSiblingLocation;
        parentKey = OCRelationshipSiblingLocation;
    } else if ( [relationship isEqualToString:OCRelationshipParentLocation] ) {
        childKey = OCRelationshipParentLocation;
        parentKey = OCRelationshipChildAccomplishment;
    } else if ( [relationship isEqualToString:OCRelationshipChildAccomplishment] ) {
        childKey = OCRelationshipParentLocation;
        parentKey = OCRelationshipChildAccomplishment;
    }

    for ( NSManagedObject *childObject in childObjects ) {
        NSMutableSet *childSet = [childObject valueForKey:childKey];
        [childSet removeObject:targetParent];
        NSMutableSet *parentSet = [targetParent valueForKey:parentKey];
        [parentSet removeObject:childObject];
    }
    
    [self updateChanges];

}

#pragma mark - Abilities Stack

-(NSManagedObject *)createAbilitiesForPlayer {
    
    NSMutableDictionary *abilitiesData = [NSMutableDictionary dictionary];

    [abilitiesData setValue:[NSNumber numberWithInt:[self randomInRangeMin:10 max:18]] forKey:OCAttributeStrength];
    [abilitiesData setValue:[NSNumber numberWithInt:[self randomInRangeMin:10 max:18]] forKey:OCAttributeDexterity];
    [abilitiesData setValue:[NSNumber numberWithInt:[self randomInRangeMin:10 max:18]] forKey:OCAttributeIntelligence];
    [abilitiesData setValue:[NSNumber numberWithInt:[self randomInRangeMin:10 max:18]] forKey:OCAttributeConstitution];
    [abilitiesData setValue:[NSNumber numberWithInt:[self randomInRangeMin:10 max:18]] forKey:OCAttributeWisdom];
    [abilitiesData setValue:[NSNumber numberWithInt:[self randomInRangeMin:10 max:18]] forKey:OCAttributeCharisma];
    
    [abilitiesData setValue:[NSNumber numberWithInt:0] forKey:OCAttributeBaseModifier];
    [abilitiesData setValue:[NSNumber numberWithInt:0] forKey:OCAttributeDifficultyValue];
    
    return [self createEntity:OCEntityAbilities withData:abilitiesData];
    
}

-(NSManagedObject *)createAbilitiesForAccomplishment {
    NSMutableDictionary *abilitiesData = [NSMutableDictionary dictionary];
    
    [abilitiesData setValue:[NSNumber numberWithInt:[self randomInRangeMin:5 max:15]] forKey:OCAttributeDifficultyValue];

    [abilitiesData setValue:[NSNumber numberWithInt:0] forKey:OCAttributeStrength];
    [abilitiesData setValue:[NSNumber numberWithInt:1] forKey:OCAttributeDexterity];
    [abilitiesData setValue:[NSNumber numberWithInt:1] forKey:OCAttributeIntelligence];
    [abilitiesData setValue:[NSNumber numberWithInt:0] forKey:OCAttributeConstitution];
    [abilitiesData setValue:[NSNumber numberWithInt:0] forKey:OCAttributeWisdom];
    [abilitiesData setValue:[NSNumber numberWithInt:0] forKey:OCAttributeCharisma];
    
    [abilitiesData setValue:[NSNumber numberWithInt:0] forKey:OCAttributeBaseModifier];
    
    return [self createEntity:OCEntityAbilities withData:abilitiesData];
    
}

#pragma mark - Game Play Stack

/*
 For the time being, these methods just query the passed managed object for the array
 of objects, which could be done just as easily in the Game Play View Controller, but 
 that would violate a clear separation of responsibilities.
 
 When the method of retrieving changes then we can absorb the change here in this 
 class than trying to update disparate view controllers which should only get back 
 the objects they expect.
 
 location tasks link to sibling location tasks via locations
 location tasks link to child accomplishment tasks via accomplishments
 accomplishment tasks link to parent location tasks via location
 */

-(NSManagedObject *)getHomeLocation {
    return [self.currentUniverse valueForKey:OCRelationshipHome];
}

-(NSArray *)getAccomplishmentsForLocation:(NSManagedObject *)location {
    
    /*
     Managed objects return an NSSet, but we can't use that as a data source for
     UITableView, so this converts the content from NSSet to NSArray.
     */
    
    return [[location valueForKey:OCRelationshipChildAccomplishment] allObjects];
}

-(NSArray *)getLinkedLocationsForLocation:(NSManagedObject *)location {
    return [[location valueForKey:OCRelationshipSiblingLocation] allObjects];
}

#pragma mark - Create Stack

/*
 Helper method that manages the creation of a given object type with new data. Keys 
 in the dictionary need to match with attributes in the Core Data store. Returns NO
 on any error.
 */

- (NSManagedObject *)createEntity:(NSString *)entity withData:(NSDictionary *)data {
    
    // create the Core Data object to capture the values
    NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.managedObjectContext];
        
    if ( !mo ) {
        NSLog(@"ERROR: OCGameDataController \ncreateEntity:%@ \nwithData:%@ \n", entity, data);
        return nil;
    }
    
    // if there is data provided for the given entity type, set the values for its 
    // properties
    if ( data ) {
        NSArray *keys = [data allKeys];
        for ( NSString *key in keys ) {
            // while we do have to qualify the key so we know what format we can add, 
            // we still just pass whatever is in the dictionary
            [mo setValue:[data objectForKey:key] forKey:key];
        }
    }
    
    [self updateChanges];
    
    return mo;

}

#pragma mark - Retrieve Stack

/*
 Private helper method that most retrieve calls eventually call so that all of the 
 needed code for any retrieval is managed. Calling methods are responsible for creating 
 the required predicates, managing result, and handling any errors. Will return NIL 
 on errors, and errors are reported to the console.
 */

- (NSArray *)retrieveEntity:(NSString *)entity withPredicate:(NSPredicate *)predicate {
    
    // starting with the context, drill down to the model
    NSPersistentStoreCoordinator *psc = [self.managedObjectContext persistentStoreCoordinator];
    NSManagedObjectModel *mom = [psc managedObjectModel];
    
    // create the fetch request and declare the entity sought
	NSFetchRequest *fetchRequestTemplate = [[NSFetchRequest alloc] init];
	NSEntityDescription *targetEntity = [[mom entitiesByName] objectForKey:entity];
	[fetchRequestTemplate setEntity:targetEntity];
    
	// create the predicate (search parameters) and set into the model for later use
	[fetchRequestTemplate setPredicate:predicate];
	[mom setFetchRequestTemplate:fetchRequestTemplate forName:entity];
    
	// declare any variables we are searching against and the proposed values and 
    // set into the model for later use against the previously declared template
	// NB: since we are not using any variables here, we create a dictionary with 
    // nothing in it to dodge an exception
	NSDictionary *targetValuesDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
	NSFetchRequest *fetchRequest = [mom fetchRequestFromTemplateWithName:entity substitutionVariables:targetValuesDict];
    
	// execute the request
	NSError *fetchError;
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    // report the error, but we still pass back the results and let the caller handle 
    // since we do not know the intent of the request in this method
    
    if ( fetchError ) {
        NSLog(@"ERROR: OCGameDataController \nretrieveEntity:%@ \nwithPredicate:%@ \nerror:%@ \n", entity, predicate, fetchError);
    }
    
    return fetchResults;    
}

/*
 Private convenience method to get the last object added of a particular entity type
 */

- (NSManagedObject *)retrieveLastObjectCreatedByEntity:(NSString *)entity {
    
    /*
     This is an abbreviated version of the code in retrieveEntity:withPredicate:. 
     */
    
    // starting with the context, drill down to the model
    NSPersistentStoreCoordinator *psc = [self.managedObjectContext persistentStoreCoordinator];
    NSManagedObjectModel *mom = [psc managedObjectModel];
    
    // create the fetch request and declare the entity sought
	NSFetchRequest *fetchRequestTemplate = [[NSFetchRequest alloc] init];
	NSEntityDescription *targetEntity = [[mom entitiesByName] objectForKey:entity];
	[fetchRequestTemplate setEntity:targetEntity];
    
    // we only want 1
    [fetchRequestTemplate setFetchLimit:1];
    
    // execute the request
	NSError *fetchError;
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequestTemplate error:&fetchError];
    
    if ( !fetchResults ) {
        NSLog(@"Warning: OCGameDataController:getLastObjectCreatedByEntity: \nfetchResults == nil");
        return nil;
    }
    
    // one quick check
    if ( [fetchResults count] == 0 ) {
        NSLog(@"Warning: OCGameDataController:getLastObjectCreatedByEntity: \nfetchResults == 0");
        return nil;
    }
    
    return [fetchResults objectAtIndex:0];

}

/*
 Private convenience method to get the all objects added of a particular entity type
 */

- (NSArray *)retrieveAllObjectsForEntity:(NSString *)entity {
    /*
     This is an abbreviated version of the code in retrieveEntity:withPredicate:. 
     */
    
    // starting with the context, drill down to the model
    NSPersistentStoreCoordinator *psc = [self.managedObjectContext persistentStoreCoordinator];
    NSManagedObjectModel *mom = [psc managedObjectModel];
    
    // create the fetch request and declare the entity sought
	NSFetchRequest *fetchRequestTemplate = [[NSFetchRequest alloc] init];
	NSEntityDescription *targetEntity = [[mom entitiesByName] objectForKey:entity];
	[fetchRequestTemplate setEntity:targetEntity];
    
    // execute the request
	NSError *fetchError;
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequestTemplate error:&fetchError];
    
    if ( !fetchResults ) {
        NSLog(@"Warning: OCGameDataController:getAllObjectsForEntity: \nfetchResults == nil");
        return nil;
    }
    
    // one quick check
    if ( [fetchResults count] == 0 ) {
        NSLog(@"Warning: OCGameDataController:getAllObjectsForEntity: \nfetchResults == 0");
        return nil;
    }
    
    return fetchResults;

}

#pragma mark - Delete Stack


/*
 Private convenience method that handled the deletion of a given object pulled from 
 the data store. The deepDelete flag takes the deletion process a step further and 
 deletes all objects that are linked to the given object.
 */
- (BOOL)deleteInstanceOfEntity:(NSManagedObject *)targetEntity deepDelete:(BOOL)deepFlag {
    
    // we need to delete all of those objects that have a direct relationship to 
    // the target
    if ( deepFlag ) {
        // get all of the objects with the target entity as a relationship
        
        // delete those objects
    }
    
    // delete the target entity
    [self.managedObjectContext deleteObject:targetEntity];
            
    return YES;
}

#pragma mark - Helper Stack

/*
 This is a collection of private helper methods for a variety of uses.
 */

/*
 Returns a UUID string per http://developer.apple.com/library/ios/#documentation/CoreFoundation/Reference/CFUUIDRef/Reference/reference.html
 */
- (NSString *)createUUID {
    // create a UUID object
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if ( uuid == NULL ) {
        // if we can't a true UUID, we still really need something here to identify 
        // the universe for the time being so we use a data object to give us a time stamp
        if ( uuid == nil ) {
            return [NSString stringWithFormat:@"%@", [NSDate dateWithTimeIntervalSinceNow:NSTimeIntervalSince1970]];
        }

    }
    // get the string representation of the UUID object
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    
    // convert the crunchy CFString into a more compatible NSString
    return [NSString stringWithFormat:@"%@", uuidStr];
}

/*
 Convenience method to help manage the integration of new objects into an entity's relationship
 */
- (NSMutableSet *)mergeNewSet:(NSMutableSet *)newSet withOriginalSet:(NSMutableSet *)originalSet {
    [originalSet unionSet:newSet];
    return originalSet;
}

/*
 helper method that safely returns a random value between two arbitrary ints 
 */

- (int) randomInRangeMin:(int)min max:(int)max {
    // avoid any divide-by-zero-like errors
    if ( min == 0 && max == 0 ) {
        return 0;
    }
    
	return ( arc4random() % abs( max - min ) ) + min;
}

@end
