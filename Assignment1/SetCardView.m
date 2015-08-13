//
//  SetCardView.m
//  SetCardProject
//
//  Created by Amr Lotfy on 8/6/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "SetCardView.h"
#import "SetGameViewController.h"

@implementation SetCardView {
  BOOL _draggingView;
  CGPoint _previousTouchPoint;
}

- (void)setColor:(UIColor *)color {
  _color = color;
  [self setNeedsDisplay];
}
- (void)setShading:(SetGameShading)shading {
  _shading = shading;
  [self setNeedsDisplay];
}
- (void)setSymbol:(SetGameSymbols)symbol {
  _symbol = symbol;
  [self setNeedsDisplay];
}

- (void)setCount:(NSInteger)count {
  _count = count;
  [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled {
  _enabled = enabled;
  [self setNeedsDisplay];
}
- (void)setChosen:(BOOL)chosen {
  _chosen = chosen;
  [self setNeedsDisplay];
}

- (void)handleTap {
  [UIView transitionWithView:self
      duration:0.5
      options:UIViewAnimationOptionTransitionFlipFromTop
      animations:^{
        ;
      }
      completion:^(BOOL finish) {
        ;
      }];
  [self.viewControllerDelegate touchCard:self];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
  CGPoint translation = [gesture translationInView:self];
  gesture.view.center = CGPointMake(gesture.view.center.x + translation.x,
                                    gesture.view.center.y + translation.y);
  if (self.viewControllerDelegate.gathered) {
    [self.viewControllerDelegate movePile:translation sender:self];
  }
  [gesture setTranslation:CGPointMake(0, 0) inView:self];
}

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}
- (CGFloat)cornerRadius {
  return CORNER_RADIUS * [self cornerScaleFactor];
}
- (CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

#define RectScaleFactor 0.8  // shrink factor of the original rectagle size

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // need to re-adjust rect size to have margins

  CGRect newRect = CGRectMake(
      rect.origin.x + 0.5 * (1 - RectScaleFactor) * rect.size.width,
      rect.origin.y + 0.5 * (1 - RectScaleFactor) * rect.size.height,
      rect.size.width * RectScaleFactor, rect.size.height * RectScaleFactor);

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  if (self.chosen) {
    self.alpha = 0.5;
  } else {
    self.alpha = 1;
  }
  UIBezierPath *roundedRect =
      [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                 cornerRadius:[self cornerRadius]];
  [roundedRect addClip];

  [self.color setStroke];
  [self.color setFill];

  // find drawing rectangles based on symbol count
  // assuming wide card shape (width > height)
  CGRect rectAtFirstThird =
      CGRectMake(newRect.origin.x + newRect.size.width * 0.05, newRect.origin.y,
                 newRect.size.width * 0.2, newRect.size.height);
  CGRect rectAtMidThird = CGRectMake(
      newRect.origin.x + newRect.size.width * (0.36), newRect.origin.y,
      newRect.size.width * 0.2, newRect.size.height);
  CGRect rectAtLastThird = CGRectMake(
      newRect.origin.x + newRect.size.width * (1 - 0.31), newRect.origin.y,
      newRect.size.width * 0.2, newRect.size.height);

  switch (self.count) {
    case 3:
      [self drawShapeAtRect:rectAtFirstThird];
      [self drawShapeAtRect:rectAtLastThird];
      [self drawShapeAtRect:rectAtMidThird];
      break;

    case 1:
      [self drawShapeAtRect:rectAtMidThird];
      break;

    case 2:
      rectAtFirstThird.origin.x += newRect.size.width / 9;
      rectAtLastThird.origin.x -= newRect.size.width / 9;
      [self drawShapeAtRect:rectAtFirstThird];
      [self drawShapeAtRect:rectAtLastThird];
  }

  CGContextRestoreGState(context);
}

- (void)drawShapeAtRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  if (self.symbol == SetDiamond) {
    [self drawDiamondInRect:rect];
  } else if (self.symbol == SetOval) {  // squiggle
    [self drawOvalInRect:rect];
  } else if (self.symbol == SetSquiggle) {  // oval
    [self drawSquiggleInRect:rect];
  }
  CGContextRestoreGState(context);
}

// pi is approximately equal to 3.14159265359.
#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees) ((pi * degrees) / 180)

- (UIBezierPath *)drawOvalInRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  UIBezierPath *path = [[UIBezierPath alloc] init];
  path.lineWidth = 2.0;

  UIBezierPath *aPath = [UIBezierPath
      bezierPathWithArcCenter:CGPointMake(rect.origin.x + rect.size.width / 2,
                                          rect.origin.y + rect.size.width / 2)
                       radius:rect.size.width / 2
                   startAngle:DEGREES_TO_RADIANS(180)
                     endAngle:0
                    clockwise:YES];
  [aPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,
                                    rect.origin.y + rect.size.height -
                                        rect.size.width / 2)];

  [aPath appendPath:[UIBezierPath
                        bezierPathWithArcCenter:
                            CGPointMake(rect.origin.x + rect.size.width / 2,
                                        rect.origin.y + rect.size.height -
                                            rect.size.width / 2)
                                         radius:rect.size.width / 2
                                     startAngle:0
                                       endAngle:DEGREES_TO_RADIANS(180)
                                      clockwise:YES]];
  [aPath addLineToPoint:CGPointMake(rect.origin.x,
                                    rect.origin.y + rect.size.width / 2)];

  [self strokeAndFillPath:aPath];
  CGContextRestoreGState(context);

  return aPath;
}

#define Point1YLocationHeightratio 0.7
#define Point2YLocationHeightratio 0.2
#define ControlPoint1RatioToWidth 1
#define ControlPoint2RatioToWidth 0.5

- (UIBezierPath *)drawSquiggleInRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  UIBezierPath *path = [[UIBezierPath alloc] init];
  path.lineWidth = 2.0;

  CGPoint pointA = CGPointMake(
      rect.origin.x,
      rect.origin.y + rect.size.height * Point1YLocationHeightratio);
  [path moveToPoint:pointA];  // start of curve

  CGPoint pointB = CGPointMake(
      rect.origin.x,
      rect.origin.y + rect.size.height * Point2YLocationHeightratio);

  CGPoint pointControlPoint1 =
      CGPointMake(rect.origin.x - rect.size.width * ControlPoint1RatioToWidth,
                  rect.origin.y + rect.size.height / 2);

  CGPoint pointControlPoint2 =
      CGPointMake(rect.origin.x + rect.size.width * ControlPoint2RatioToWidth,
                  rect.origin.y + rect.size.height / 2);

  CGLine *line1 =
      [[CGLine alloc] initWithPoint1:pointA point2:pointControlPoint1];

  [path addCurveToPoint:pointB
          controlPoint1:pointControlPoint1
          controlPoint2:pointControlPoint2];  // left curve

  CGPoint pointBControl =
      [self getThirdPointOnLineWithFirstPoint:pointControlPoint2
                                  secondPoint:pointB];

  CGPoint pointC = CGPointMake(
      rect.origin.x + rect.size.width,
      rect.origin.y + rect.size.height * Point2YLocationHeightratio);

  [path addQuadCurveToPoint:pointC controlPoint:pointBControl];

  CGPoint controlPoint3 = CGPointMake(
      rect.origin.x + rect.size.width * (1 - ControlPoint2RatioToWidth),
      rect.origin.y + rect.size.height / 2);
  CGPoint controlPoint4 =
      [self getThirdPointOnLineWithFirstPoint:pointBControl secondPoint:pointC];

  CGPoint pointD = CGPointMake(
      rect.origin.x + rect.size.width,
      rect.origin.y + rect.size.height * Point1YLocationHeightratio);

  [path addCurveToPoint:pointD
          controlPoint1:controlPoint4
          controlPoint2:controlPoint3];

  CGLine *line2 = [[CGLine alloc] initWithPoint1:pointD point2:controlPoint3];

  CGPoint lastControlPoint = [line1 interceptWithLine:line2];

  [path addQuadCurveToPoint:pointA controlPoint:lastControlPoint];

  [self strokeAndFillPath:path];
  CGContextRestoreGState(context);
  return path;
}

#define ThirdPointDistanceRatio 0.75

- (CGPoint)getThirdPointOnLineWithFirstPoint:(CGPoint)firstPoint
                                 secondPoint:(CGPoint)secondPoint {
  CGFloat x1 = firstPoint.x;
  CGFloat y1 = firstPoint.y;

  CGFloat x2 = secondPoint.x;
  CGFloat y2 = secondPoint.y;

  CGFloat x3 = x2 + (x2 - x1) * ThirdPointDistanceRatio;  // I choosed second
                                                          // point to be in the
                                                          // middle of the line

  CGFloat y3 = y2 + (y2 - y1) * (x3 - x2) / (x2 - x1);

  CGPoint result = CGPointMake(x3, y3);

  return result;
}

- (void)strokeAndFillPath:(UIBezierPath *)path {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  [path stroke];
  path.lineWidth = 1.0;
  if (self.shading == SetSolid) {
    [self fillPath:path];
  } else if (self.shading == SetStriped) {
    [self shadePath:path];
  }
  CGContextRestoreGState(context);
}

- (UIBezierPath *)drawDiamondInRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  UIBezierPath *path = [[UIBezierPath alloc] init];
  path.lineWidth = 2.0;
  CGFloat ax = rect.origin.x + rect.size.width / 2;
  CGFloat ay = rect.origin.y + 0.2 * (rect.size.height);

  CGFloat bx = rect.origin.x + rect.size.width;
  CGFloat by = rect.origin.y + rect.size.height / 2;

  CGFloat cx = rect.origin.x + rect.size.width / 2;
  CGFloat cy = rect.origin.y + rect.size.height * 0.8;

  CGFloat dx = rect.origin.x;
  CGFloat dy = rect.origin.y + rect.size.height / 2;

  [path moveToPoint:CGPointMake(ax, ay)];
  [path addLineToPoint:CGPointMake(bx, by)];
  [path addLineToPoint:CGPointMake(cx, cy)];
  [path addLineToPoint:CGPointMake(dx, dy)];
  [path closePath];

  [self strokeAndFillPath:path];

  CGContextRestoreGState(context);
  return path;
}

- (void)fillPath:(UIBezierPath *)path {
  if (path) {
    [path fill];
  }
}

#define NumberOfShadinglines 9

- (void)shadePath:(UIBezierPath *)path {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  [path addClip];
  UIBezierPath *lines = [[UIBezierPath alloc] init];
  lines.lineWidth = 1;
  CGFloat dy = path.bounds.size.height / NumberOfShadinglines;

  for (NSInteger i = 1; i <= NumberOfShadinglines; i++) {
    CGFloat newY = path.bounds.origin.y + i * dy;
    [lines moveToPoint:CGPointMake(path.bounds.origin.x, newY)];
    [lines addLineToPoint:CGPointMake(
                              path.bounds.origin.x + path.bounds.size.width,
                              newY)];
  }
  [lines stroke];
  CGContextRestoreGState(context);
}

- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
  self.enabled = true;
}

- (void)awakeFromNib {
  [self setup];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tapgr =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleTap)];
    UIPanGestureRecognizer *pgr =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handlePan:)];
    [self addGestureRecognizer:tapgr];
    [self addGestureRecognizer:pgr];
    // init
  }
  return self;
}

@end
