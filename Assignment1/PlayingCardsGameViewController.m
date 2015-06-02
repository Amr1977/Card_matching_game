//
//  ViewController.m
//  Assignment1
//
//  Created by Amr Lotfy on 4/23/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "PlayingCardsGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "Playingcard.h"
#import "CardMatchingGame.h"

@interface PlayingCardsGameViewController ()

@property(strong, nonatomic)
    Deck *deck;  // this is supposed to be in the model ?
@property(strong, nonatomic) Card *selectedPlayingCard;  // move to model ?
@property(strong, nonatomic) CardMatchingGame *game;     // pointer to the model
@property(strong, nonatomic) IBOutletCollection(UIButton)
    NSArray *playingCardsButtons;  // buttons(cards) are put in an array
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
//@property NSInteger numberOfCardsToMatch;
@property(weak, nonatomic) IBOutlet UILabel *lastAction;

@end

@implementation PlayingCardsGameViewController

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
// preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  NSLog(@"prepareForSegue launched. segue id: %@", [segue identifier]);
  HistoryViewController *hvc =
      ((HistoryViewController *)[segue destinationViewController]);
  if (hvc) {
    NSLog(@" hvc not nil");

    [hvc setHistoryEntries:self.game.gameActionsHistory];

  } else {
    NSLog(@" hvc is nil");
  }
}
// deal button
- (IBAction)reset:(id)sender {
  [self newGame];
  [self updateUI];
}

- (CardMatchingGame *)newGame {
  NSLog(@"newGame: creating a new game...");
  NSArray *buttons;
  buttons = [self playingCardsButtons];
  NSLog(@"newGame: number of buttons %lul", (unsigned long)[buttons count]);

  _game = [[CardMatchingGame alloc]
         initWithCardCount:[buttons count]  // number of buttons(cards
                                            // cells in view)

                 usingDeck:[self createDeck]
      numberOfCardsToMatch:2];  // creates full deck

  return _game;
}

- (CardMatchingGame *)game {
  if (!_game) {
    NSLog(@"game: creating a new game...");
    _game = [self newGame];
  }
  return _game;
}

// creates a full deck
- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

// getter
- (Deck *)deck {
  if (!_deck) {
    _deck = [self createDeck];
  }
  return _deck;
}

- (IBAction)touchCardButton:(UIButton *)sender {
  // disable changing of game mode control segment
  //[[self gameModeSegmentControl] setEnabled:NO];

  NSUInteger chosenButtonIndex =
      [self.playingCardsButtons indexOfObject:sender];
  NSLog(@"chosenButtonIndex: %lu", chosenButtonIndex);

  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}

- (void)updateUI {
  for (UIButton *cardButton in self.playingCardsButtons) {
    NSUInteger cardButtonIndex =
        [self.playingCardsButtons indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self titleForCard:card]
                forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgrounfImageForCard:card]
                          forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text =
        [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    self.lastAction.text = [[self game] lastAction];
  }
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgrounfImageForCard:(Card *)card {
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
