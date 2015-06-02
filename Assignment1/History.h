//
//  History.h
//  Assignments
//
//  Created by Amr Lotfy on 6/1/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameAction.h"

@interface History : NSObject

+ (NSArray *)getHistory;
+ (NSArray *)addHistoryEntry:(NSString *)historyEntry;

@end
