//
//  PlayingCardDeck.m
//  Assignment1
//
//  Created by Amr Lotfy on 4/23/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init {
  self = [super init];
  NSLog(@"initializing PlayingCardDeck...");
  if (self) {
    NSLog(@"PlayingCardDeck: super initialize ok, creating full deck...");
    for (NSString *suit in [PlayingCard validSuits]) {
      for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
        PlayingCard *card = [[PlayingCard alloc] init];
        card.rank = rank;
        card.suit = suit;
        [self addCard:card];
        NSLog(@"Suit: %@ , Rank: %lu", [card suit], (unsigned long)[card rank]);
      }
    }
  }
  return self;
}

@end
