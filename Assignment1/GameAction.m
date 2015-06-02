//
//  GameAction.m
//  Assignments
//
//  Created by Amr Lotfy on 5/28/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "GameAction.h"

@implementation GameAction

- (NSString *)description {
  NSString *result;
  result = [NSString
      stringWithFormat:
          @"Action: %@, Card: %@, Result: %@, ScoreChange: %ld, Score: %ld ",
          self.action, self.card.description, self.actionResult,
          self.scoreChange, self.score];
  return result;
}

@end
