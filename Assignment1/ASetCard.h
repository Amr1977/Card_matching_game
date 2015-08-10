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

typedef enum { SetDiamond, SetSquiggle, SetOval } SetGameSymbols;

typedef enum { SetSolid, SetStriped, SetOpen } SetGameShading;

typedef enum { SetRed, SetPurple, SetGreen } SetGameColors;

@property(nonatomic) SetGameSymbols symbol;

@property(nonatomic) UIColor *color;

@property(nonatomic) NSInteger count;  // number of tiles

@property(nonatomic) SetGameShading shading;

- (instancetype)initWithSymbol:(SetGameSymbols)symbol
                       shading:(SetGameShading)shading
                         color:(UIColor *)color
                         count:(NSInteger)count;

- (UIColor *)cardColor;
+ (NSDictionary *)cardShading:(NSString *)shadingString
                    withColor:(NSString *)colorString;

+ (NSArray *)getValidColors;
+ (NSArray *)getValidSymbols;
+ (NSArray *)getValidShades;
+ (NSInteger)getMaxSymbolCount;
+ (NSArray *)getFeatures;
+ (UIColor *)colorFromString:(NSString *)colorString;

@end
