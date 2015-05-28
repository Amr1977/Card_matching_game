//
//  GameAction.h
//  Assignments
//
//  Created by Amr Lotfy on 5/28/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameAction : NSObject

@property (nonatomic) NSString * action;
@property (nonatomic) NSArray * cards;
@property (nonatomic) NSString * actionResult;
@property (nonatomic) NSInteger scoreChange;

@end
