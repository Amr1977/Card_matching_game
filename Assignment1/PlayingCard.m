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

- (NSUInteger)match:(NSArray *)otherCards numberOfCardsToMatch:(NSUInteger) numberOfCardsToMatch{
    NSUInteger score = 0;
    if ([otherCards count] == numberOfCardsToMatch) {
        for (NSInteger i=0; i < numberOfCardsToMatch; i++) {
            PlayingCard *otherCard = otherCards[i];
            if (otherCard.rank == self.rank) {
                //In 3-card-match mode, it should be possible to get some (although a significantly lesser amount of) points for picking 3 cards of which only 2 match in some way.
                score = 4-numberOfCardsToMatch+1;
            } else if ([otherCard.suit isEqualToString:self.suit]) {
                score = 1;
            }
        }
    }
    return score;
}

- (NSUInteger)match:(NSArray *)otherCards {
    return [self match:otherCards numberOfCardsToMatch:1];
}

@end

/*



*/