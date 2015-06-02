//
//  HistoryViewController.m
//  Assignments
//
//  Created by Amr Lotfy on 5/31/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property(strong, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

static NSString *historyText;
static NSArray *entries;

- (void)setHistoryText:(NSString *)aText {
  historyText = aText;
}
- (NSString *)historyText {
  return self.historyTextView.text;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.historyTextView.text = @"initialization test";
  NSLog(@"HistoryViewController loaded.");
  self.historyTextView.text = historyText;
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setHistoryEntries:(NSArray *)historyArrayEntries {
  NSLog(@"recieved history actions, count: %lu",
        (unsigned long)[historyArrayEntries count]);
  entries = historyArrayEntries;
  [self formatEntries];
}
- (void)formatEntries {
  NSMutableString *result = [NSMutableString stringWithString:@""];
  NSLog(@"formatting history actions, number of actions: %lu", [entries count]);
  NSInteger i = 0;
  for (GameAction *action in entries) {
    [result appendString:[NSString
                             stringWithFormat:
                                 @"%lu Action: %@ \n Card: %@\n ActionResult: "
                                 @"%@\n Score Change: %ld\n Score: %ld \n\n\n",
                                 ++i, action.action, action.card.description,
                                 action.actionResult, (long)action.scoreChange,
                                 (long)action.score]];
  }
  historyText = [result copy];
}

/**
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSArray * historyTextArray;//TODO: create by appending all action entries

    [ text:];
}
*/

@end
