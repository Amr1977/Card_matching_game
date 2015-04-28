//
//  PlayingCard.m
//  Assignment1
//
//  Created by Amr Lotfy on 4/23/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard


@synthesize suit=_suit;


- (NSString *)contents
{
    NSString *result = @"";
    NSArray *rankStrings= [PlayingCard rankStrings];
    result = [rankStrings[self.rank] stringByAppendingString:self.suit];
    NSLog(@"PlayingCard contents: %@",result);
    return result;
    
}



- (NSString *)suit{
    return _suit? _suit:@"?";
}


+(NSArray *) validSuits{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

+(NSArray *) rankStrings{
    return @[@"?", @"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}


- (void) setSuit: (NSString *) suit{
    if ([ [ PlayingCard validSuits] containsObject:suit]){
        _suit=suit;
    }
}




+(NSInteger) maxRank{
    
    return [[self rankStrings] count]-1;
}

-(int) match:(NSArray*) otherCards{
    int score=0;
    if ([otherCards count]==1) {
        PlayingCard *otherCard= [otherCards firstObject];
        if (otherCard.rank==self.rank) {
            score=4;
        }else if([otherCard.suit isEqualToString:self.suit ]){
            score=1;
        }
        
        
    }
    return score;
}


@end

/*

 

*/