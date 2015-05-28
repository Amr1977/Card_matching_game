//
//  SetDeck.m
//  Assignment1
//
//  Created by Amr Lotfy on 5/26/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "ASetCardDeck.h"

@implementation ASetCardDeck
-(instancetype) init{
    self = [super init];
    
    if (self){
        NSLog(@"ASetCardDeck: super initialize ok, creating full deck...");
        for (NSNumber *colorIndex in [ASetCard getValidColors]) {
            
        }
        for (NSInteger shapeIndex=1;shapeIndex<=[[ASetCard getValidShapes] count];shapeIndex++) {
            for (NSInteger colorIndex=1;colorIndex<=[[ASetCard getValidColors] count];colorIndex++) {
                for (NSInteger shadeIndex=1;shadeIndex<=[[ASetCard getValidShades] count];shadeIndex++) {
                    for (NSInteger countIndex=1;countIndex<=[ASetCard getMaxCount] ;countIndex++) {
                        
                        
                    }
                    
                }
                
            }
            
            
        }
        
    } else{
        NSLog(@"**** Error initializing ASetCardDeck.");
    }
    
    return self;
}

@end
