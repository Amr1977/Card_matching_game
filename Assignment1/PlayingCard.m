//
//  PlayingCard.m
//  Assignment1
//
//  Created by Amr Lotfy on 4/23/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *)description {
  return [self contents];
}

- (NSString *)contents {
  NSString *result = @"";
  NSArray *rankStrings = [PlayingCard rankStrings];
  result = [rankStrings[self.rank] stringByAppendingString:self.suit];
  NSLog(@"PlayingCard contents: %@", result);
  return result;
}

- (NSString *)suit {
  return _suit ? _suit : @"?";
}

+ (NSArray *)validSuits {
  return @[ @"♥", @"♦", @"♠", @"♣" ];
}

+ (NSArray *)rankStrings {
  return @[
    @"?",
    @"A",
    @"2",
    @"3",
    @"4",
    @"5",
    @"6",
    @"7",
    @"8",
    @"9",
    @"10",
    @"J",
    @"Q",
    @"K"
  ];
}

- (void)setSuit:(NSString *)suit {
  if ([[PlayingCard validSuits] containsObject:suit]) {
    _suit = suit;
  }
}

+ (NSInteger)maxRank {
  return [[self rankStrings] count] - 1;
}

- (NSUInteger)matcher:(NSArray *)cardsToMatch {
  NSInteger score = 0;
  for (NSInteger i = 0; i < ([cardsToMatch count] - 1); i++) {
    for (NSInteger j = (i + 1); j < [cardsToMatch count]; j++) {
      PlayingCard *cardi = (PlayingCard *)cardsToMatch[i];
      PlayingCard *cardj = (PlayingCard *)cardsToMatch[j];
      if (cardi.rank == cardj.rank) {
        NSLog(@"Rank matched :) %@ %@", [cardi contents], [cardj contents]);
        score += 4;
      }
      if ([cardi.suit caseInsensitiveCompare:cardj.suit] == NSOrderedSame) {
        NSLog(@"suit matched :) %@ %@", [cardi contents], [cardj contents]);
        score += 1;
      }
    }
  }
  return score;
}

- (NSUInteger)match:(NSArray *)otherCards {
  if (!([otherCards count] == 2)) {
    return 0;
  }

  NSUInteger score = 0;
  NSMutableArray *allCards = [NSMutableArray array];
  [allCards addObjectsFromArray:otherCards];
  [allCards addObject:self];

  score = [self matcher:[NSArray arrayWithArray:allCards]];
  NSLog(@"Returned score: %lu", score);

  return score;
}

@end
