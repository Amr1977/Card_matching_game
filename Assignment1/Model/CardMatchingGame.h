//
//  CardMatchingGame.h
//  Assignment1
//
//  Created by Amr Lotfy on 4/28/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCardDeck.h"
#import "ASetCardDeck.h"
#import "PlayingCard.h"
#import "ASetCard.h"
#import "GameAction.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
             numberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

- (void)removeCard:(Card *)card;

- (void)removeCardAtIndex:(NSInteger)index;

- (Card *)addCard;

- (void)logSolution;

@property(nonatomic, readonly) NSInteger score;

@property(nonatomic) NSString *lastAction;

@property(nonatomic) NSUInteger numberOfCardsToMatch;

@property(nonatomic) NSMutableArray *gameActionsHistory;

@property(nonatomic, strong) NSMutableArray *cards;  // make sure they are cards

@end
