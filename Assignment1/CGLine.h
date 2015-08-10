//
//  CGLine.h
//  SetCardProject
//
//  Created by Amr Lotfy on 8/10/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CGLine : NSObject

@property(nonatomic) CGFloat slope;
@property(nonatomic) CGFloat interceptWithYAxis;

- (instancetype)initWithPoint1:(CGPoint)point1 point2:(CGPoint)point2;
- (instancetype)initWithSlope:(CGFloat)slope intercept:(CGFloat)intercept;
- (CGPoint)interceptWithLine:(CGLine *)line;

@end
