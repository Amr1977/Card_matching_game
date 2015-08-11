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


@interface SetGameViewController : UIViewController

- (void)touchCard:(id)sender;
- (void)removeCardSubview:(SetCardView *)card;

@end
