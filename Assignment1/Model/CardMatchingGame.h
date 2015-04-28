//
//  CardMatchingGame.h
//  Assignment1
//
//  Created by Amr Lotfy on 4/28/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

//designated initializer
-(instancetype) initWithCardCount: (NSUInteger)count
                        usingDeck: (Deck *)deck;

-(void) chooseCardAtIndex: (NSUInteger) index;
-(Card *)cardAtIndex: (NSUInteger) index;

@property (nonatomic, readonly) NSInteger score;

@end
