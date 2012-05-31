//
//  OCGameEngine.h
//  RPG Kit
//
//  Created by Philip Regan on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 The Game Engine contains the actual d20 logic needed to calculate success or
 failure. It is, for the most part, stateless, with only the necessary game data
 being contained within the scope of the methods and not in the class as a whole.
 
 Outside of the objects being passed to it---player and accomplishments---it makes
 no assumptions about intent, where the user is, what as pushed when, and the like.
 It does not maintain any game state outside the needed values for action calculations
 */

#import <Foundation/Foundation.h>

@interface OCGameEngine : NSObject

/*
 Core routine for game play
 */
-(BOOL)playPlayer:(NSManagedObject *)player againstAccomplishments:(NSMutableSet *)accomplishments;

@end
