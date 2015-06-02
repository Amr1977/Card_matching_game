//
//  History.m
//  Assignments
//
//  Created by Amr Lotfy on 6/1/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "History.h"

static History *history;

@implementation History

- (id)init {
  self = [super init];
  if (self) {
    if (!history) {
      history = [[History alloc] init];
    }
  }
  return self;
}

+ (NSArray *)getHistory {
  // TODO: do it !
  if (!history) {
  }
  return nil;
}

+ (NSArray *)addHistoryEntry:(NSString *)historyEntry {
  // TODO: do it !
  return nil;
}

@end
