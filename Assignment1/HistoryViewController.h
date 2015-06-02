//
//  HistoryViewController.h
//  Assignments
//
//  Created by Amr Lotfy on 5/31/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameAction.h"

@interface HistoryViewController : UIViewController
@property(nonatomic) NSString *historyText;

- (void)setHistoryEntries:(NSArray *)historyArrayEntries;

@end
