//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Amr Lotfy on 8/2/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property(nonatomic) NSInteger rank;
@property(strong, nonatomic) NSString *suit;
@property(nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
