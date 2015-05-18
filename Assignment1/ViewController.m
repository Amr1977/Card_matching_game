//
//  ViewController.m
//  Assignment1
//
//  Created by Amr Lotfy on 4/23/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "Playingcard.h"
#import "CardMatchingGame.h"

@interface ViewController ()

@property(strong, nonatomic) PlayingCardDeck *deck;
@property(strong, nonatomic) PlayingCard *selectedPlayingCard;
@property(strong, nonatomic) CardMatchingGame *game;//pointer to the model
@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;//buttons(cards) are put in an array
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentControl;


@end

@implementation ViewController

//deal button
- (IBAction)reset:(id)sender {
    
    [self game:YES];
    [self updateUI];
    //enable segmented control for choosing game mode
    [[self gameModeSegmentControl] setEnabled:YES];
    //reset all cards
}

- (IBAction)gameMode:(id)sender {
    if ([[self gameModeSegmentControl] isEnabled]){
        if ([[self gameModeSegmentControl] selectedSegmentIndex]==1) {
            //three card game mode
            //TODO: do it!
            [[self game] setNumberOfCardsToMatch:3];
        }else{
            //two card game mode
            //TODO: do it!
            [[self game] setNumberOfCardsToMatch:2];
            
        }
       // [[self gameModeSegmentControl] setEnabled:NO];
        
    }
}

- (CardMatchingGame *)game:(BOOL)newGame {
  if ((!_game)||(newGame)) {
    _game = [[CardMatchingGame alloc]
             initWithCardCount:[self.cardButtons count] //number of buttons(cards cells in view)
             
                                              usingDeck:[self createDeck]];//creates full deck
  }
  return _game;
}

- (CardMatchingGame *)game {
    return [self game:NO];
}

//creates a full deck
- (PlayingCardDeck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

//getter
- (PlayingCardDeck *)deck {
  if (!_deck) {
    _deck = [self createDeck];
  }
  return _deck;
}

- (IBAction)touchCardButton:(UIButton *)sender {
  //disable changing of game mode control segment
  [[self gameModeSegmentControl] setEnabled:NO];
  NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardButtons) {
    NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self titleForCard:card]
                forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgrounfImageForCard:card]
                          forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text =
        [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
  }
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgrounfImageForCard:(Card *)card {
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
