//
//  SetCard.m
//  Assignment1
//
//  Created by Amr Lotfy on 5/26/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "ASetCard.h"

@implementation ASetCard


+(NSArray *)getValidColors{
    //TODO: do it!
    return nil;
}

-(instancetype) initWithDictionary:(NSDictionary *)cardAttributes{
    self =[super init];
    if(self){
        _shape = (NSString *)[cardAttributes objectForKey:@"shape" ];
        _color = (NSString *)[cardAttributes objectForKey:@"color" ];
        _shading = (NSString *)[cardAttributes objectForKey:@"shading"];
        _count = (NSInteger)[cardAttributes objectForKey:@"count" ];
    }
    return self;
}

+(NSArray *)getValidShapes{
    NSArray * result=@[@"▲",@"●",@"■"];
    return result;
}

+(NSArray *)getValidShades{
    //TODO: do it!
    return nil;
}

+(NSInteger)getMaxShapeCount{
    static const NSInteger maxCount=3;
    return maxCount;
}

- (NSUInteger)match:(NSArray *)otherCards{//
    
    return 0;
}




@end


