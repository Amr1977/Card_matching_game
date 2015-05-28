//
//  SetCard.h
//  Assignment1
//
//  Created by Amr Lotfy on 5/26/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "Card.h"

@interface ASetCard : Card



@property (nonatomic) NSString *shape;

@property (nonatomic) NSString *color;

@property (nonatomic) NSInteger count;//number of tiles

@property (nonatomic) NSString *shading;


+(NSArray *)getValidColors;
+(NSArray *)getValidShapes;
+(NSArray *)getValidShades;
+(NSInteger)getMaxShapeCount;



@end
