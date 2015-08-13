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

@property (nonatomic) BOOL gathered;
@property (nonatomic) UIDynamicAnimator * animator;
@property (nonatomic) UIGravityBehavior * gravity;
@property (nonatomic) UICollisionBehavior * collision;
@property (nonatomic) UIAttachmentBehavior * attachment;
@property (nonatomic) UIDynamicItemBehavior* itemBehaviour;
@property (nonatomic) NSMutableArray * viewsToBeDeleted;
@property (nonatomic) NSMutableArray *cardsButtons;

-(void)touchCard:(id)sender;
-(void)removeCardSubview:(SetCardView *)card;
-(void) handlePilePan:(UIPanGestureRecognizer *) recognizer;
-(void) movePile:(CGPoint)translation sender:(UIView *)sender;

@end
