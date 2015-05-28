//
//  PlayingCard.h
//  Assignment1
//
//  Created by Amr Lotfy on 4/23/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property(strong, nonatomic) NSString *suit;

@property(nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSInteger)maxRank;
@end
