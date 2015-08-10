//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Amr Lotfy on 8/2/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardsGameViewController.h"

@interface PlayingCardView : UIView

@property(nonatomic) NSInteger rank;
@property(nonatomic) NSString *suit;
@property(nonatomic) BOOL faceUp;
@property(nonatomic, weak) id gameDelegate;
@property(nonatomic) BOOL enabled;

- (void)handleTap;

@end
