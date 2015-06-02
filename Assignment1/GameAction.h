//
//  GameAction.h
//  Assignments
//
//  Created by Amr Lotfy on 5/28/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface GameAction : NSObject

@property(nonatomic) NSString* action;  // select or deselect
@property(nonatomic) Card* card;
@property(nonatomic) NSString* actionResult;  // reward or penalize or nothing
@property(nonatomic) NSInteger scoreChange;
@property(nonatomic) NSInteger score;  // new score

@end
