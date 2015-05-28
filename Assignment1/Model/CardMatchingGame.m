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

-(NSArray *)getGameActionsHistory{
    if (!_gameActionsHistory) {
        _gameActionsHistory= [[NSMutableArray alloc] init];
    }
    return _gameActionsHistory;
}

-(NSMutableArray *) getChosenCards:(NSArray *)cards{
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    // get all chosen cards in an array
    for (Card *card in cards) {
        if (card.isChosen && !card.isMatched) {
            [chosenCards addObject:card];
        }
    }
    return chosenCards;
}




- (NSString *) concatenateCardsContents:(NSArray *)cards{
    NSString * result;
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    
    // get all chosen cards in an array
    for (Card *card in cards) {
        if (card.isChosen && !card.isMatched) {
            [contents addObject:[card contents]];
        }
    }
    
    result=[contents componentsJoinedByString:@" "];
    
    return result;
}

- (void)chooseCardAtIndex:(NSUInteger)index {
  Card *card = (Card *)[self cardAtIndex:index];
    if (!card || (card.isMatched)){
        return;
    }
    
    GameAction * gameAction=[[GameAction alloc] init];
    
    [gameAction setCard:card];
    
    if (card.isChosen) {  // if already chosen then toggle
      card.chosen = NO;     //deselect
        [gameAction setAction:@"unselect"];     //record this action
    } else {
        [gameAction setAction:@"select"];       //record this action
         NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
        // get all chosen cards in an array
        chosenCards = [self getChosenCards:self.cards];
        [chosenCards addObject:self];
      
        
      NSLog(@"Other chosen cards: %lu , game mode: %lu",
      [chosenCards count] + 1, [self numberOfCardsToMatch]);
      // only if reached the needed number of cards to match
      if ([chosenCards count] == ([self numberOfCardsToMatch] - 1)) {
        // calculate the score
        NSUInteger matchScore = [card match:chosenCards];//TODO implement for set game cards

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
          [gameAction setScoreChange:((-1)*MISMATCH_PENALTY)];
          // turn back the other cards
            if ([self numberOfCardsToMatch]==2){
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
