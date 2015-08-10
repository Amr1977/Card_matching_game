//
//  SetCardView.h
//  SetCardProject
//
//  Created by Amr Lotfy on 8/6/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASetCard.h"
#import "CGLine.h"
#import "SetGameViewController.h"

@interface SetCardView : UIView

@property(nonatomic) SetGameSymbols symbol;
@property(nonatomic) UIColor *color;
@property(nonatomic) NSInteger count;
@property(nonatomic) SetGameShading shading;
@property(nonatomic) BOOL enabled;

@property(nonatomic, weak) id gameDelegate;

- (void)handleTap;

@end
