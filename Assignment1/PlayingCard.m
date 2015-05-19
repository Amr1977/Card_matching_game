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

- (NSUInteger)match:(NSArray *)otherCards
    numberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch {
  NSUInteger score = 0;
  // make sure number of cards in othercards array is as expected
  if ([otherCards count] == (numberOfCardsToMatch - 1)) {
    NSLog(@"matching: %@, rank: %lu, suit: %@", [self contents],
          (unsigned long)[self rank], [self suit]);
    NSLog(@"match set completed %lu", [otherCards count] + 1);
    for (NSInteger i = 0; i < (numberOfCardsToMatch - 1); i++) {
      PlayingCard *otherCard = otherCards[i];
      NSLog(@"matching: %@, rank: %lu, suit: %@", [otherCard contents],
            (unsigned long)[otherCard rank], [otherCard suit]);
      if (otherCard.rank == self.rank) {
        NSLog(@"Rank matched :)");

        // In 3-card-match mode, it should be possible to get some (although a
        // significantly lesser amount of) points for picking 3 cards of which
        // only 2 match in some way.
        score += 4;
      } else if ([otherCard.suit caseInsensitiveCompare:self.suit] ==
                 NSOrderedSame) {
        NSLog(@"suit matched :)");
        score += 1;
      }
    }

    for (NSInteger i = 0; i < (numberOfCardsToMatch - 2); i++) {
      for (NSInteger j = (i + 1); i < (numberOfCardsToMatch - 1); i++) {
        if ([otherCards[i] rank] == [otherCards[j] rank]) {
          NSLog(@"Rank matched :)");
          score += 4;
        } else if ([[otherCards[i] suit]
                       caseInsensitiveCompare:[otherCards[i] suit]] ==
                   NSOrderedSame) {
          NSLog(@"suit matched :)");
          score += 1;
        }
      }
    }
    NSLog(@"Returned score: %lu", score);
  } else {
    NSLog(@"match: game mode: %lu, other cards count: %lu",
          numberOfCardsToMatch, (unsigned long)[otherCards count]);
  }

  return score;
}

- (NSUInteger)match:(NSArray *)otherCards {
  return [self match:otherCards numberOfCardsToMatch:1];
}

@end

/*



*/