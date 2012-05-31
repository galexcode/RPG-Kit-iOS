//
//  OCGameEngine.m
//  RPG Kit
//
//  Created by Philip Regan on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OCGameEngine.h"
#import "OCStrings.h"

/*
 array to store bonus or penalties for applicable abilities during play. 
 0 = ability score 10
 */
int abilityBonus[18] = { -5, -5, -4, -4, -3, -3, -2, -2, -1, -1, 0, 1, 1, 2, 3, 3, 4, 4 };

@interface OCGameEngine ()

@end

@implementation OCGameEngine

-(BOOL)playPlayer:(NSManagedObject *)player againstAccomplishments:(NSMutableSet *)accomplishments {
    
    /*
     This is the core game mechanic as detailed in Game Engine Notes
     */
    
    // for every accomplishment
    for ( NSManagedObject *accomplishment in accomplishments ) {
        
        // roll d20
        int diceRoll = [self randomInRangeMin:1 max:20];
        
        // calculate the ability bonus
        diceRoll += [self getAbilitiesBonusForPlayer:player withAccomplishment:accomplishment];
        
        // calculate the equipment bonus CANCELLED
        // get the difficultly value of the accomplishment
        int difficultyValue = [self getDifficultyValueOfAccomplishment:accomplishment];
        
        // if the roll is less than the difficulty value, penalize the player and return NO
        // else reward the player and go on to the next one
        if ( diceRoll < difficultyValue ) {
            // penalize the player and kick them out of play
            return NO;
        }
        
        // reward the player and go on to the next accomplishment
        
    }
    return YES;
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

#pragma mark - Abilities Stack

-(int)getAbilitiesBonusForPlayer:(NSManagedObject *)player withAccomplishment:(NSManagedObject *)accomplishment {
    
    // get the abilities scores for each object passed
    NSManagedObject *playerAbilities = [player valueForKey:OCRelationshipPlayerAbilities];
    NSManagedObject *accomplishmentAbilities = [accomplishment valueForKey:OCRelationshipAbilities];
    
    // init the payload
    int bonus = 0;
    
    // check each abilties scores in turn
    // strength
    if ( [[accomplishmentAbilities valueForKey:OCAttributeStrength] intValue] > 0 ) {
        int score = [[playerAbilities valueForKey:OCAttributeStrength] intValue];
        bonus += abilityBonus[score];
    }
    // dexterity
    if ( [[accomplishmentAbilities valueForKey:OCAttributeDexterity] intValue] > 0 ) {
        int score = [[playerAbilities valueForKey:OCAttributeDexterity] intValue];
        bonus += abilityBonus[score];
    }
    // intelligence
    if ( [[accomplishmentAbilities valueForKey:OCAttributeIntelligence] intValue] > 0 ) {
        int score = [[playerAbilities valueForKey:OCAttributeIntelligence] intValue];
        bonus += abilityBonus[score];
    }
    // constitution
    if ( [[accomplishmentAbilities valueForKey:OCAttributeConstitution] intValue] > 0 ) {
        int score = [[playerAbilities valueForKey:OCAttributeConstitution] intValue];
        bonus += abilityBonus[score];
    }
    // wisdom
    if ( [[accomplishmentAbilities valueForKey:OCAttributeWisdom] intValue] > 0 ) {
        int score = [[playerAbilities valueForKey:OCAttributeWisdom] intValue];
        bonus += abilityBonus[score];
    }
    // charisma
    if ( [[accomplishmentAbilities valueForKey:OCAttributeCharisma] intValue] > 0 ) {
        int score = [[playerAbilities valueForKey:OCAttributeCharisma] intValue];
        bonus += abilityBonus[score];
    }
    
    // return the payload
    return bonus;
}

-(int)getDifficultyValueOfAccomplishment:(NSManagedObject *)accomplishment {
    NSManagedObject *abilities = [accomplishment valueForKey:OCRelationshipAbilities];
    return [[abilities valueForKey:OCAttributeDifficultyValue] intValue];
}

@end
