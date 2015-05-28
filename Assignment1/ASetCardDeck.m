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
  self = [super init];
  if (self) {
    NSLog(@"ASetCardDeck: super initialize ok, creating full deck...");
    for (NSString *colorIndex in [ASetCard getValidColors]) {
      for (NSString *shapeIndex in [ASetCard getValidSymbols]) {
        for (NSString *shadingIndex in [ASetCard getValidShades]) {
            for (NSInteger countIndex = 0; countIndex < [ASetCard getMaxSymbolCount];countIndex++) {
                NSDictionary *cardAttributes = [NSDictionary
                                                dictionaryWithObjectsAndKeys: colorIndex, @"color",
                                                shapeIndex, @"symbol",
                                                shadingIndex, @"shading",
                                                [NSNumber numberWithInteger:countIndex],
                                                @"count", nil];
                ASetCard *aSetCard =
                [[ASetCard alloc] initWithDictionary:cardAttributes];
                [self addCard:aSetCard];
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
