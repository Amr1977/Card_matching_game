//
//  BDPlayingCardView.h
//  Assignments
//
//  Created by Amr Lotfy on 8/5/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDPlayingCardView : UIView

@property(nonatomic) NSInteger rank;
@property(nonatomic) NSString *suit;
@property(nonatomic) BOOL faceUp;
@property(nonatomic) BOOL enabled;

@end
