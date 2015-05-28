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
    for (NSString *color in [ASetCard getValidColors]) {
      for (NSString *shape in [ASetCard getValidShapes]) {
        for (NSString *shading in [ASetCard getValidShades]) {
          for (NSInteger count = 0; count < [ASetCard getMaxShapeCount];
               count++) {
            NSDictionary *cardAttributes = [NSDictionary
                dictionaryWithObjectsAndKeys:color, @"color", shape, @"shape",
                                             shading, @"shading",
                                             [NSNumber numberWithInteger:count],
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
