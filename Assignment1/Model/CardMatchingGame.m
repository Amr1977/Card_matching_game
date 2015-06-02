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

// could be used in both games
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

// ok
- (NSMutableArray *)cards {
  if (!_cards) {
    _cards = [[NSMutableArray alloc] init];
  }

  return _cards;
}

// playing cards game
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
  return [self initWithCardCount:count usingDeck:deck numberOfCardsToMatch:2];
}

// ok for both
- (id)cardAtIndex:(NSUInteger)index {
  if (index < [self.cards count]) {
    return self.cards[index];
  } else {
    NSLog(@"card not found with index: %lu", index);
    return nil;
  }
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

// ok for both games
- (NSArray *)gameActionsHistory {
  if (!_gameActionsHistory) {
    _gameActionsHistory = [[NSMutableArray alloc] init];
  }
  return _gameActionsHistory;
}

// ok for both
- (NSMutableArray *)getChosenCards:(NSArray *)cards {
  NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
  // get all chosen cards in an array
  for (Card *card in cards) {
    if (card.isChosen && !card.isMatched) {
      [chosenCards addObject:card];
    }
  }
  return chosenCards;
}

// ok for both
- (NSString *)concatenateCardsContents:(NSArray *)cards {
  NSString *result;
  NSMutableArray *contents = [[NSMutableArray alloc] init];

  for (Card *card in cards) {
    [contents addObject:[card contents]];
  }

  result = [contents componentsJoinedByString:@" "];

  return result;
}

+ (BOOL)allHasSameFeature:(NSString *)feature cards:(NSArray *)cards {
  NSArray *features = [ASetCard getFeatures];
  NSInteger index = [features indexOfObject:feature];
  switch (index) {
    case 0:
      // symbol
      return (([[cards[0] symbol] isEqualToString:[cards[1] symbol]]) &&
              ([[cards[2] symbol] isEqualToString:[cards[1] symbol]]));
      break;

    case 1:
      // symbol
      return (([[((ASetCard *)cards[0])color]
                  isEqualToString:[((ASetCard *)cards[1])color]]) &&
              ([[((ASetCard *)cards[2])color]
                  isEqualToString:[((ASetCard *)cards[1])color]]));
      break;

    case 2:
      // symbol
      return (([[cards[0] shading] isEqualToString:[cards[1] shading]]) &&
              ([[cards[2] shading] isEqualToString:[cards[1] shading]]));
      break;

    case 3:
      // symbol
      return (([cards[0] count] == [cards[1] count]) &&
              ([cards[2] count] == [cards[1] count]));
      break;

    default:
      break;
  }
  return false;
}

+ (BOOL)allHasDifferentFeature:(NSString *)feature cards:(NSArray *)cards {
  NSArray *features = [ASetCard getFeatures];
  NSInteger index = [features indexOfObject:feature];
  switch (index) {
    case 0:
      // symbol
      return ((![[cards[0] symbol] isEqualToString:[cards[1] symbol]]) &&
              (![[cards[2] symbol] isEqualToString:[cards[1] symbol]]) &&
              (![[cards[0] symbol] isEqualToString:[cards[2] symbol]]));
      break;

    case 1:
      // symbol
      return ((![[((ASetCard *)cards[0])color]
                   isEqualToString:[((ASetCard *)cards[1])color]]) &&
              (![[((ASetCard *)cards[2])color]
                   isEqualToString:[((ASetCard *)cards[1])color]]) &&
              (![[((ASetCard *)cards[2])color]
                   isEqualToString:[((ASetCard *)cards[0])color]]));
      break;

    case 2:
      // symbol
      return ((![[cards[0] shading] isEqualToString:[cards[1] shading]]) &&
              (![[cards[2] shading] isEqualToString:[cards[1] shading]]) &&
              (![[cards[2] shading] isEqualToString:[cards[0] shading]]));
      break;

    case 3:
      // symbol
      return (([cards[0] count] != [cards[1] count]) &&
              ([cards[2] count] != [cards[1] count]) &&
              ([cards[2] count] != [cards[0] count]));
      break;

    default:
      break;
  }
  return false;
}
// each feature either all the same or all different
+ (NSInteger)setGameMatcher:(NSArray *)cards {
  NSInteger score = 4;
  if ([cards count] != 3) {
    return 0;
  }
  const NSArray *features = [ASetCard getFeatures];

  for (NSString *feature in features) {
    if (!(([CardMatchingGame allHasSameFeature:feature cards:cards]) ||
          ([CardMatchingGame allHasDifferentFeature:feature cards:cards]))) {
      return 0;
    }
  }

  return score;
}

+ (NSUInteger)playingCardsMatcher:(NSArray *)cardsToMatch {
  NSLog(@"playingCardsMatcher: number of cards to check for matching is %lu",
        (unsigned long)[cardsToMatch count]);
  if ([cardsToMatch count] < 2) {
    return 0;
  }
  NSInteger score = 0;
  for (NSInteger i = 0; i < ([cardsToMatch count] - 1); i++) {
    PlayingCard *cardi = (PlayingCard *)cardsToMatch[i];
    for (NSInteger j = (i + 1); j < [cardsToMatch count]; j++) {
      PlayingCard *cardj = (PlayingCard *)cardsToMatch[j];
      if (cardi.rank == cardj.rank) {
        NSLog(@"Rank matched :) %@ %@", [cardi contents], [cardj contents]);
        score += 4;
      } else {
        NSLog(@"Rank mismatch %@ %@", [cardi contents], [cardj contents]);
      }
      if ([cardi.suit caseInsensitiveCompare:cardj.suit] == NSOrderedSame) {
        NSLog(@"suit matched :) %@ %@", [cardi contents], [cardj contents]);
        score += 1;
      } else {
        NSLog(@"suit mismatch  %@ %@", [cardi contents], [cardj contents]);
      }
    }
  }
  return score;
}

- (NSInteger)match:(NSArray *)chosenCards {
  if ([self numberOfCardsToMatch] == 2) {
    return [CardMatchingGame playingCardsMatcher:chosenCards];
  } else {  // set game
    return [CardMatchingGame setGameMatcher:chosenCards];
  }
}

- (void)chooseCardAtIndex:(NSUInteger)index {
  NSLog(@"entered chooseCardAtIndex:");
  Card *card = (Card *)[self cardAtIndex:index];
  if (!card || (card.isMatched)) {
    NSLog(@"card not exist or matched, exiting chooseCardAtIndex");
    return;
  } else {
    NSLog(@"selceted card: %@", [card contents]);
  }

  GameAction *gameAction = [[GameAction alloc] init];

  [gameAction setCard:card];

  if (card.isChosen) {  // if already chosen then toggle
    card.chosen = NO;  // deselect
    [gameAction setAction:@"unselect"];  // record this action
  } else {
    [gameAction setAction:@"select"];  // record this action
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    // get all chosen cards in an array
    chosenCards = [self getChosenCards:self.cards];
    [chosenCards addObject:card];

    NSLog(@"Other chosen cards: %lu , game mode: %lu", [chosenCards count],
          [self numberOfCardsToMatch]);

    // only if reached the needed number of cards to match
    if ([chosenCards count] == ([self numberOfCardsToMatch])) {
      // calculate the score
      NSUInteger matchScore = [self match:chosenCards];

      // if we have a match
      if (matchScore) {
        // Adjusted for matching more than two cards: divide by number of
        // cards to match
        NSInteger addedScore =
            (matchScore * MATCH_BONUS) / ([self numberOfCardsToMatch] - 1);

        self.score += addedScore;
        [gameAction setScoreChange:addedScore];

        NSLog(@"Added score: %ld", (long)addedScore);
        // turn all other cards to be matched (get them out of game)
        for (Card *chosenCard in chosenCards) {
          chosenCard.matched = YES;
        }
        [gameAction setActionResult:@"Rewarded"];

      } else {
        [gameAction setActionResult:@"Penalized"];

        self.score -= MISMATCH_PENALTY;
        [gameAction setScoreChange:((-1) * MISMATCH_PENALTY)];
        // turn back the other cards
        if ([self numberOfCardsToMatch] == 2) {
          for (Card *chosenCard in chosenCards) {
            chosenCard.chosen = NO;
          }
        }
      }
    }
    self.score -= COST_TO_CHOOSE;
    // in all cases last choosen card will be face up
    card.chosen = YES;
  }
  [gameAction setScore:self.score];
  [self setLastAction:[gameAction description]];
  [[self gameActionsHistory] addObject:gameAction];
}

@end
