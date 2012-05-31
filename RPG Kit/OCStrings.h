//
//  OCStrings.h
//  RPG Kit
//
//  Created by Philip Regan on 4/16/12.
//  Copyright (c) 2012 Jones & Bartlett Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Core Data Constants

/*
 These are the strings used to build predicates for Core Data for the CRUD operations. 
 All strings need to be unique as they pertain to Core Data.
 */

#pragma mark Game Object

extern NSString * const OCEntityGameObject;

extern NSString * const OCAttributeID;
extern NSString * const OCAttributeTitleStory;
extern NSString * const OCAttributeIntroStory;
extern NSString * const OCAttributeActionStory;
extern NSString * const OCAttributeWinStory;
extern NSString * const OCAttributeLoseStory;
extern NSString * const OCAttributeInGameObject;

extern NSString * const OCRelationshipParent;

#pragma mark Abilities

extern NSString * const OCEntityAbilities;

extern NSString * const OCAttributeBaseModifier;
extern NSString * const OCAttributeCharisma;
extern NSString * const OCAttributeConstitution;
extern NSString * const OCAttributeDexterity;
extern NSString * const OCAttributeDifficultyValue;
extern NSString * const OCAttributeIntelligence;
extern NSString * const OCAttributeStrength;
extern NSString * const OCAttributeWisdom;

extern NSString * const OCRelationshipTask;
extern NSString * const OCRelationshipAbilitiesPlayer;

#pragma mark Universe

extern NSString * const OCEntityUniverse;

extern NSString * const OCAttributeTemporalUnit;
extern NSString * const OCAttributeTemporalUnitsPassed;
extern NSString * const OCAttributeMonetaryUnit;

extern NSString * const OCRelationshipPlayer;
extern NSString * const OCRelationshipHome;
extern NSString * const OCRelationshipQuests;

#pragma mark Task (Quests and Accomplishments)

extern NSString * const OCEntityTask;

extern NSString * const OCAttributeIncome;
extern NSString * const OCAttributeCost;
extern NSString * const OCAttributeGateway;

extern NSString * const OCRelationshipRequiredObjects;
extern NSString * const OCRelationshipReward;
extern NSString * const OCRelationshipRisk;
extern NSString * const OCRelationshipAttributes;

extern NSString * const OCRelationshipAbilities;
extern NSString * const OCRelationshipPlayerAbilities;

extern NSString * const OCRelationshipTasks;
extern NSString * const OCRelationshipChildAccomplishment;
extern NSString * const OCRelationshipParentLocation;
extern NSString * const OCRelationshipSiblingLocation;
extern NSString * const OCRelationshipUniverse;

#pragma mark Player

extern NSString * const OCEntityPlayer;

extern NSString * const OCAttributeELO;

extern NSString * const OCRelationshipWallet;
extern NSString * const OCRelationshipAbilities;

#pragma mark Equipment

extern NSString * const OCEntityEquipment;

/* All attributes are common/shared values used in other classes */ 