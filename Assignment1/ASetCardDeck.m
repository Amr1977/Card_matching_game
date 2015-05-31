//
//  SetDeck.m
//  Assignment1
//
//  Created by Amr Lotfy on 5/26/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "ASetCardDeck.h"

@implementation ASetCardDeck
- (instancetype) init {
    NSLog(@"ASetCardDeck: init...");
  self = [super init];
  if (self) {
    NSLog(@"ASetCardDeck: super initialize ok, creating full deck...");
    for (NSString *color in [ASetCard getValidColors]) {
      for (NSString *symbol in [ASetCard getValidSymbols]) {
        for (NSString *shading in [ASetCard getValidShades]) {
            for (NSInteger count = 1; count <= [ASetCard getMaxSymbolCount];count++) {
                NSDictionary *cardAttributes = [NSDictionary
                                                dictionaryWithObjectsAndKeys: color, @"color",
                                                symbol, @"symbol",
                                                shading, @"shading",
                                                [NSNumber numberWithInteger:count],
                                                @"count", nil];
                ASetCard *aSetCard =
                [[ASetCard alloc] initWithDictionary:cardAttributes];
                [self addCard:aSetCard];
                NSLog(@"Added card: %@, dictionary: %@ ",[aSetCard contents], cardAttributes );
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
