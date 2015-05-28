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

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
             numberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch {
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
  Card *card = (PlayingCard *)[self cardAtIndex:index];
    if (!card){
        return;
    }
  if (!card.isMatched) {  // if not previously matched (not out of the game)
    if (card.isChosen) {  // if already chosen then toggle
      card.chosen = NO;
        [self setLastAction:@""];
    } else {
        [self setLastAction:[card contents]];
      // match against other chosen cards
      // create an array to hold other chosen cards pointers
      NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
      NSMutableArray *contents = [[NSMutableArray alloc] init];
      [contents addObject:[card contents]];
      // get all chosen cards in an array
      for (Card *otherCard in self.cards) {
        if (otherCard.isChosen && !otherCard.isMatched) {
          [chosenCards addObject:otherCard];
          [contents addObject:[otherCard contents]];
          // if reached the allowed number of chosen cards
          if ([chosenCards count] == ([self numberOfCardsToMatch] - 1)) {
            break;
          }
        }
      }
      NSLog(@"Other chosen cards: %lu , game mode: %lu",
            [chosenCards count] + 1, [self numberOfCardsToMatch]);
      // only if reached the needed number of cards to match
      if ([chosenCards count] == ([self numberOfCardsToMatch] - 1)) {
        // calculate the score
        NSUInteger matchScore = [card match:chosenCards];

        // if we have a match
        if (matchScore) {
          // Adjusted for matching more than two cards: divide by number of
          // cards to match
          NSInteger addedScore =
              (matchScore * MATCH_BONUS) / ([self numberOfCardsToMatch] - 1);
          if (!addedScore) {
            addedScore += 1;
          }
          self.score += addedScore;
          [self setLastAction:[NSString
                                  stringWithFormat:
                                      @"Matched %@ for %lu",
                                      [contents componentsJoinedByString:@" "],
                                      addedScore]];
          NSLog(@"Added score: %ld", (long)addedScore);
          // turn all other cards to be matched (get them out of game)
          for (PlayingCard *chosenCard in chosenCards) {
            chosenCard.matched = YES;
          }
          // and turn this card out of game too
          card.matched = YES;

        } else {
          self.score -= MISMATCH_PENALTY;
          [self setLastAction:[NSString
                                  stringWithFormat:
                                      @"Mismatched %@ for -%d",
                                      [contents componentsJoinedByString:@" "],
                                      MISMATCH_PENALTY]];
          // turn back the other cards
          for (PlayingCard *chosenCard in chosenCards) {
            chosenCard.chosen = NO;
          }
        }
      }
      self.score -= COST_TO_CHOOSE;
      // in all cases last choosen card will be face up
      card.chosen = YES;
    }
  }
}

@end
