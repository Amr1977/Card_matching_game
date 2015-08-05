//
//  SetCard.m
//  Assignment1
//
//  Created by Amr Lotfy on 5/26/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "ASetCard.h"
@import UIKit;

@implementation ASetCard

+ (UIColor *)colorFromString:(NSString *)colorString {
  if ([colorString isEqualToString:@"green"]) {
    return [UIColor greenColor];
  } else if ([colorString isEqualToString:@"red"]) {
    return [UIColor redColor];
  } else if ([colorString isEqualToString:@"purple"]) {
    return [UIColor purpleColor];
  } else {
    return [UIColor blackColor];
  }
}

- (NSString *)description {
  return [NSString stringWithFormat:@"content: %@ , color: %@ , sahding: %@",
                                    [self contents], self.color, self.shading];
}

+ (NSDictionary *)cardShading:(NSString *)shadingString
                    withColor:(NSString *)colorString {
  UIColor *color = [ASetCard colorFromString:colorString];
  NSMutableDictionary *attributes = [NSMutableDictionary new];

  if ([shadingString isEqualToString:@"solid"]) {  // ok
    [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
  } else if ([shadingString isEqualToString:@"striped"]) {
    [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
    [attributes setObject:color forKey:NSStrokeColorAttributeName];
    [attributes setObject:[color colorWithAlphaComponent:0.1]
                   forKey:NSForegroundColorAttributeName];

    // colorWithAlphaComponent:0.1

  } else if ([shadingString isEqualToString:@"outlined"]) {  // ok
    [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
  }
  return [attributes copy];
}

+ (NSArray *)getFeatures {
  return @[ @"symbol", @"color", @"shading", @"count" ];
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
    _count = [(NSNumber *)[cardAttributes objectForKey:@"count"] integerValue];
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
      return (([[((ASetCard *)cards[0])color]
                  isEqualToString:[((ASetCard *)cards[1])color]]) &&
              ([[((ASetCard *)cards[2])color]
                  isEqualToString:[((ASetCard *)cards[1])color]]));
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
      return ((![[((ASetCard *)cards[0])color]
                   isEqualToString:[((ASetCard *)cards[1])color]]) &&
              (![[((ASetCard *)cards[2])color]
                   isEqualToString:[((ASetCard *)cards[1])color]]) &&
              (![[((ASetCard *)cards[2])color]
                   isEqualToString:[((ASetCard *)cards[0])color]]));
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
  NSInteger score = 4;
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

- (UIColor *)cardColor {
  return [ASetCard colorFromString:[self color]];
}

- (NSString *)contents {
  NSMutableString *string =
      [NSMutableString stringWithFormat:@"%@", [self symbol]];
  // ([self count]-1) because we already have 1 in the string
  for (NSInteger i = 1; i <= ([self count] - 1); i++) {
    [string appendString:[self symbol]];
  }

  NSMutableAttributedString *attributedString =
      [[NSMutableAttributedString alloc] initWithString:string];

  [attributedString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:NSMakeRange(0, [string length] - 1)];

  NSLog(@"content: %@ , color: %@ , sahding: %@ , chosen: %d , matched: %d",
        string, self.color, self.shading, [self isChosen], [self isMatched]);
  return [string copy];
}

@end
