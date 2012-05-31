//
//  OCStrings.m
//  RPG Kit
//
//  Created by Philip Regan on 4/16/12.
//  Copyright (c) 2012 Jones & Bartlett Learning. All rights reserved.
//

#import "OCStrings.h"

#pragma mark - Core Data Constants

/*
 These are the strings used to build predicates for Core Data for the CRUD operations. 
 All strings need to be unique as they pertain to Core Data.
 */

#pragma mark Game Object

NSString * const OCEntityGameObject = @"GameObject";

NSString * const OCAttributeID = @"id";
NSString * const OCAttributeTitleStory = @"titleStory";
NSString * const OCAttributeIntroStory = @"introStory";
NSString * const OCAttributeActionStory = @"actionStory";
NSString * const OCAttributeWinStory = @"winStory";
NSString * const OCAttributeLoseStory = @"loseStory";
NSString * const OCAttributeInGameObject = @"inGameObject";

NSString * const OCRelationshipParent = @"parent";

#pragma mark Abilities

NSString * const OCEntityAbilities = @"Abilities";

NSString * const OCAttributeBaseModifier = @"baseModifier";
NSString * const OCAttributeCharisma = @"charisma";
NSString * const OCAttributeConstitution = @"constitution";
NSString * const OCAttributeDexterity = @"dexterity";
NSString * const OCAttributeDifficultyValue = @"difficultyValue";
NSString * const OCAttributeIntelligence = @"intelligence";
NSString * const OCAttributeStrength = @"strength";
NSString * const OCAttributeWisdom = @"wisdom";

NSString * const OCRelationshipTask = @"task";
NSString * const OCRelationshipAbilitiesPlayer = @"abilitiesPlayer";

#pragma mark Universe

NSString * const OCEntityUniverse = @"Universe";

NSString * const OCAttributeTemporalUnit = @"temporalUnit";
NSString * const OCAttributeTemporalUnitsPassed = @"temporalUnitsPassed";
NSString * const OCAttributeMonetaryUnit = @"monetaryUnit";

NSString * const OCRelationshipPlayer = @"player";
NSString * const OCRelationshipHome = @"home";
NSString * const OCRelationshipQuests = @"quests";

#pragma mark Task (Quests and Accomplishments)

NSString * const OCEntityTask = @"Task";

NSString * const OCAttributeIncome = @"income";
NSString * const OCAttributeCost = @"cost";
NSString * const OCAttributeGateway = @"gateway";

NSString * const OCRelationshipRequiredObjects = @"requiredObjects";
NSString * const OCRelationshipReward = @"reward";
NSString * const OCRelationshipRisk = @"risk";
NSString * const OCRelationshipAttributes = @"attributes";

NSString * const OCRelationshipAbilities = @"abilities";

NSString * const OCRelationshipTasks = @"tasks";
NSString * const OCRelationshipChildAccomplishment = @"accomplishments";
NSString * const OCRelationshipParentLocation = @"location";
NSString * const OCRelationshipSiblingLocation = @"locations";
NSString * const OCRelationshipUniverse = @"universe";

#pragma mark Player

NSString * const OCEntityPlayer = @"Player";

NSString * const OCAttributeELO = @"elo";

NSString * const OCRelationshipWallet = @"wallet";
NSString * const OCRelationshipPlayerAbilities = @"playerAbilities";

#pragma mark Equipment

NSString * const OCEntityEquipment = @"Equipment";

/* All attributes are common/shared values used in other classes */ 
