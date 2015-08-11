//
//  SetDeck.m
//  Assignment1
//
//  Created by Amr Lotfy on 5/26/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "ASetCardDeck.h"

@implementation ASetCardDeck
- (instancetype)init {
  NSLog(@"ASetCardDeck: init...");
  self = [super init];
  if (self) {
    NSLog(@"ASetCardDeck: super initialize ok, creating full deck...");
    NSInteger index = 1;
    for (UIColor *color in [ASetCard getValidColors]) {
      for (NSNumber *symbol in [ASetCard getValidSymbols]) {
        for (NSNumber *shading in [ASetCard getValidShades]) {
          for (NSInteger count = 1; count <= [ASetCard getMaxSymbolCount];
               count++) {
            ASetCard *aSetCard =
                [[ASetCard alloc] initWithSymbol:[symbol intValue]
                                         shading:[shading intValue]
                                           color:color
                                           count:count];
              aSetCard.chosen=NO;
              aSetCard.matched=NO;
            [self addCard:aSetCard];
            /*
              NSLog(@"%ld - Added card: %@ , chosen: %d , matched: %d",
                  (long)index, [aSetCard contents], [aSetCard isChosen],
                  [aSetCard isMatched]);
              */
            index++;
          }
        }
      }
    }

  } else {
    NSLog(@"**** Error initializing ASetCardDeck.");
  }

  return self;
}

@end
