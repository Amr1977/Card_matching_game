//
//  SetCard.h
//  Assignment1
//
//  Created by Amr Lotfy on 5/26/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "Card.h"
@import UIKit;

@interface ASetCard : Card

@property(nonatomic) NSString *symbol;

@property(nonatomic) NSString *color;

@property(nonatomic) NSInteger count;  // number of tiles

@property(nonatomic) NSString *shading;

- (instancetype)initWithDictionary:(NSDictionary *)cardAttributes;

- (UIColor *)cardColor;
+ (NSDictionary *)cardShading:(NSString *)shadingString
                    withColor:(NSString *)colorString;

+ (NSArray *)getValidColors;
+ (NSArray *)getValidSymbols;
+ (NSArray *)getValidShades;
+ (NSInteger)getMaxSymbolCount;
+ (NSArray *)getFeatures;

@end
