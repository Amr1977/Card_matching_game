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

- (NSMutableArray *)cards {
  if (!_cards) {
    _cards = [[NSMutableArray alloc] init];
  }

  return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
  self = [super init];  // initializer for super
  if (self) {
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

- (Card *)cardAtIndex:(NSUInteger)index {
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
  Card *card = [self cardAtIndex:index];
  if (!card.isMatched) {
    if (card.isChosen) {
      card.chosen = NO;
    } else {
      // match against other chosen cards
      for (Card *otherCard in self.cards) {
        if (otherCard.isChosen && !otherCard.isMatched) {
          NSUInteger matchScore = [card match:@[ otherCard ]];
          if (matchScore) {
            self.score += matchScore * MATCH_BONUS;
            otherCard.matched = YES;
            card.matched = YES;
          } else {
            self.score -= MISMATCH_PENALTY;
            otherCard.chosen = NO;
          }
          break;  // can only choose 2 cards for now
        }
      }

      self.score -= COST_TO_CHOOSE;

      card.chosen = YES;
    }
  }
}

@end
