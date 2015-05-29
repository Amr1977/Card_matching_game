//
//  SetCard.m
//  Assignment1
//
//  Created by Amr Lotfy on 5/26/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "ASetCard.h"

@implementation ASetCard

+(NSArray *)getFeatures{
    return  @[ @"symbol", @"color", @"shading", @"count" ];
}

+ (NSArray *)getValidColors {
  NSArray *validColors = @[ @"red", @"green", @"purple" ];
  return validColors;
}

- (instancetype)initWithDictionary:(NSDictionary *)cardAttributes {
  self = [super init];
  if (self) {
    _symbol = (NSString *)[cardAttributes objectForKey:@"symbol"];
    _color = (NSString *)[cardAttributes objectForKey:@"color"];
    _shading = (NSString *)[cardAttributes objectForKey:@"shading"];
    _count = (NSInteger)[cardAttributes objectForKey:@"count"];
  }
  return self;
}

+ (NSArray *)getValidSymbols {
  NSArray *result = @[ @"▲", @"●", @"■" ];
  return result;
}

+ (NSArray *)getValidShades {
  NSArray *validColors = @[ @"solid", @"striped", @"outlined" ];
  return validColors;
}

+ (NSInteger)getMaxSymbolCount {
  static const NSInteger maxCount = 3;
  return maxCount;
}

- (NSUInteger)match:(NSArray *)otherCards {  //

  return 0;
}

+ (BOOL)allHasSameFeature:(NSString *)feature cards:(NSArray *)cards {
    NSArray *features = [ASetCard getFeatures];
  NSInteger index = [features indexOfObject:feature];
  switch (index) {
    case 0:
      // symbol
      return (([[cards[0] symbol] isEqualToString:[cards[1] symbol]]) &&
              ([[cards[2] symbol] isEqualToString:[cards[1] symbol]]));
      break;

    case 1:
      // symbol
      return (([[cards[0] color] isEqualToString:[cards[1] color]]) &&
              ([[cards[2] color] isEqualToString:[cards[1] color]]));
      break;

    case 2:
      // symbol
      return (([[cards[0] shading] isEqualToString:[cards[1] shading]]) &&
              ([[cards[2] shading] isEqualToString:[cards[1] shading]]));
      break;

    case 3:
      // symbol
      return (([cards[0] count] == [cards[1] count]) &&
              ([cards[2] count] == [cards[1] count]));
      break;

    default:
      break;
  }
  return false;
}

+ (BOOL)allHasDifferentFeature:(NSString *)feature cards:(NSArray *)cards {
  NSArray *features = [ASetCard getFeatures];
  NSInteger index = [features indexOfObject:feature];
  switch (index) {
    case 0:
      // symbol
      return ((![[cards[0] symbol] isEqualToString:[cards[1] symbol]]) &&
              (![[cards[2] symbol] isEqualToString:[cards[1] symbol]]) &&
              (![[cards[0] symbol] isEqualToString:[cards[2] symbol]]));
      break;

    case 1:
      // symbol
      return ((![[cards[0] color] isEqualToString:[cards[1] color]]) &&
              (![[cards[2] color] isEqualToString:[cards[1] color]]) &&
              (![[cards[2] color] isEqualToString:[cards[0] color]]));
      break;

    case 2:
      // symbol
      return ((![[cards[0] shading] isEqualToString:[cards[1] shading]]) &&
              (![[cards[2] shading] isEqualToString:[cards[1] shading]]) &&
                  (![[cards[2] shading] isEqualToString:[cards[0] shading]]));
      break;

    case 3:
      // symbol
      return (([cards[0] count] != [cards[1] count]) &&
              ([cards[2] count] != [cards[1] count]) &&
              ([cards[2] count] != [cards[0] count]));
      break;

    default:
      break;
  }
  return false;
}
// each feature either all the same or all different
+ (NSInteger)matcher:(NSArray *)cards {
  NSInteger score=4;
  if ([cards count] != 3) {
    return 0;
  }
 const NSArray *features = [ASetCard getFeatures];

  for (NSString *feature in features) {
    if (!(([ASetCard allHasSameFeature:feature cards:cards]) ||
          ([ASetCard allHasDifferentFeature:feature cards:cards]))) {
      return 0;
    }
  }

  return score;
}

@end
