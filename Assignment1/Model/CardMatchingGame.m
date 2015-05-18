//
//  CardMatchingGame.m
//  Assignment1
//
//  Created by Amr Lotfy on 4/28/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property(nonatomic, readwrite) NSInteger score;
@property(nonatomic, strong) NSMutableArray *cards;  // make sure they are cards
@end

@implementation CardMatchingGame

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck numberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch{
    self = [super init];  // initializer for super
    if (self) {
        _numberOfCardsToMatch = numberOfCardsToMatch;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
    
    
}

- (NSMutableArray *)cards {
  if (!_cards) {
    _cards = [[NSMutableArray alloc] init];
  }

  return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    return [self initWithCardCount:count usingDeck:deck numberOfCardsToMatch:2];
}

- (id)cardAtIndex:(NSUInteger)index {
  if (index < [self.cards count]) {
    return self.cards[index];
  } else {
    return nil;
  }
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index {
    
  PlayingCard * card =  (PlayingCard *) [self cardAtIndex:index];
    
  if (!card.isMatched) {//if not previously matched (not out of the game)
    if (card.isChosen) {//if already chosen then toggle
      card.chosen = NO;
    } else {
      // match against other chosen cards
      //create an array to hold other chosen cards pointers
      NSMutableArray *chosenCards=[[NSMutableArray alloc] init];
      for (Card *otherCard in self.cards) {
        if (otherCard.isChosen && !otherCard.isMatched) {
            [chosenCards addObject:otherCard];
            // if reached the allowed number of chosen cards
            if([chosenCards count]==([self numberOfCardsToMatch]-1)){
                break;
            }
        }
      }
        //only if reached the needed number of cards to match
        if([chosenCards count]==([self numberOfCardsToMatch]-1)){
            //calculate the score
            NSUInteger matchScore = [card match:chosenCards numberOfCardsToMatch: [self numberOfCardsToMatch]];
            
            //if we have a match
            if (matchScore) {
                self.score += matchScore * MATCH_BONUS;
                for (PlayingCard * chosenCard in chosenCards) {
                    chosenCard.matched = YES;
                }
                card.matched = YES;
                
            } else {
                self.score -= MISMATCH_PENALTY;
                for (PlayingCard * chosenCard in chosenCards) {
                    chosenCard.chosen = NO;
                }
                
            }
            //break;  // can only choose 2 cards for now
            
            self.score -= COST_TO_CHOOSE;
            
            card.chosen = YES;
        }
        
    }
  }
}

@end
