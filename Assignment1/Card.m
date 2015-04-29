//
//  Card.m
//  Assignment1
//
//  Created by Amr Lotfy on 4/23/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "Card.h"

@implementation Card
@synthesize contents = _contents;

- (NSString *)contents {
  return _contents;
}

- (void)setContents:(NSString *)contents {
  _contents = contents;
}
- (NSUInteger)match:(NSArray *)otherCards {
  NSUInteger score = 0;
  for (Card *card in otherCards) {
    if ([self.contents isEqualToString:card.contents]) {
      score = 1;
    }
  }
  return score;
}

@end
