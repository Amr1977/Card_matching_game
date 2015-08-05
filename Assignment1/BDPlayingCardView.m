//
//  BDPlayingCardView.m
//  Assignments
//
//  Created by Amr Lotfy on 8/5/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "BDPlayingCardView.h"
#import "PlayingCardsGameViewController.h"
@interface BDPlayingCardView()

@property(nonatomic) CGFloat faceCardScaleFactor;

@end
@implementation BDPlayingCardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;
#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (CGFloat)faceCardScaleFactor {
    if (!_faceCardScaleFactor) {
        _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    }
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

#pragma mark - Properties

- (void)setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

#pragma mark - Drawing

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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *roundedRect =
    [UIBezierPath bezierPathWithRoundedRect:self.bounds
                               cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.faceUp) {
        NSLog(@"Face up.");
        NSLog(@"looking for image: %@",
              [NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]);
        UIImage *faceImage = [UIImage
                              imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString],
                                          self.suit]];
        if (faceImage) {
            NSLog(@"image found.");
            CGRect imageRect = CGRectInset(
                                           self.bounds, self.bounds.size.width * (1 - self.faceCardScaleFactor),
                                           self.bounds.size.height * (1 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        } else {
            NSLog(@"image not found.");
            [self drawPips];
        }
        
        [self drawCorners];
    } else {
        NSLog(@"Face down.");
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

- (void)drawPips {
    
}

- (NSString *)rankAsString {
    return @[
             @"?",
             @"A",
             @"2",
             @"3",
             @"4",
             @"5",
             @"6",
             @"7",
             @"8",
             @"9",
             @"10",
             @"J",
             @"Q",
             @"K"
             ][self.rank];
}

- (void)drawCorners {
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont =
    [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString],
                                                      [self suit]]
                                      attributes:@{
                                                   NSFontAttributeName : cornerFont,
                                                   NSParagraphStyleAttributeName : paragraphStyle
                                                   }];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width,
                          self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    
    [cornerText drawInRect:textBounds];
}

#pragma mark - Initialization
- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // init
       
        
        
    }
    return self;
}


@end
