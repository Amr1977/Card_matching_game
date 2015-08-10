//
//  CGLine.m
//  SetCardProject
//
//  Created by Amr Lotfy on 8/10/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "CGLine.h"

@implementation CGLine
- (instancetype)initWithPoint1:(CGPoint)point1 point2:(CGPoint)point2 {
  self = [super init];
  if (self) {
    _slope = (point2.y - point1.y) / (point2.x - point1.x);
    _interceptWithYAxis = point1.y - point1.x * _slope;
  }
  return self;
}
- (instancetype)initWithSlope:(CGFloat)slope intercept:(CGFloat)intercept {
  self = [super init];
  if (self) {
    _slope = slope;
    _interceptWithYAxis = intercept;
  }

  return self;
}
- (CGPoint)interceptWithLine:(CGLine *)line {
  CGPoint intercept;
  intercept.x = (line.interceptWithYAxis - self.interceptWithYAxis) /
                (self.slope - line.slope);
  intercept.y = self.slope * intercept.x + self.interceptWithYAxis;
  return intercept;
}

@end
