//
//  SetGameViewController.h
//  Assignments
//
//  Created by Amr Lotfy on 5/31/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "SetCardView.h"


#define SetCardWidth 80
#define SetCardHeight 50
#define HGapRatio 0.2
#define VGapRatio 0.2
#define NumberOfCardsInRow 4
#define InitialCardNumber 12

@interface SetGameViewController : UIViewController

- (void)touchCard:(id)sender;
- (void)removeCardSubview:(SetCardView *)card;

@end
