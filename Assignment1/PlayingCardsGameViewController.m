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
@property(strong, nonatomic)
    Card *selectedPlayingCard;                 // move to model ?
@property(strong, nonatomic) CardMatchingGame *game;  // pointer to the model
@property(strong, nonatomic) IBOutletCollection(UIButton)  NSArray *playingCardsButtons;  // buttons(cards) are put in an array
@property(strong, nonatomic) IBOutletCollection(UIButton)  NSArray *setGameCardsButtons;  // buttons(cards) are put in an array
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property NSInteger numberOfCardsToMatch;
@property(weak, nonatomic) IBOutlet UILabel *lastAction;

@end

@implementation PlayingCardsGameViewController

// deal button
- (IBAction)reset:(id)sender {
    [self newGame:2];
  [self updateUI];
  
}



- (CardMatchingGame *)newGame:(NSInteger)numberOfCardsToMatch {
    self.numberOfCardsToMatch = numberOfCardsToMatch;
    NSArray * buttons;
    if (numberOfCardsToMatch==2){
        buttons=[self playingCardsButtons];
    }else{
        buttons=[self setGameCardsButtons];
    }

  _game = [[CardMatchingGame alloc]
         initWithCardCount:[buttons count]  // number of buttons(cards
                                                     // cells in view)

                 usingDeck:[self createDeck]
      numberOfCardsToMatch:numberOfCardsToMatch];  // creates full deck

  
    return _game;
}

- (CardMatchingGame *)game:(NSInteger)numberOfCardsToMatch {
  if (!_game) {
      _game = [self newGame:numberOfCardsToMatch];
  }
  return _game;
}

// creates a full deck
- (Deck *)createDeck {
    if (self.numberOfCardsToMatch==2){
            return [[PlayingCardDeck alloc] init];
    }else{
        return [[ASetCardDeck alloc] init];
    }
  
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

  NSUInteger chosenButtonIndex = [self.playingCardsButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}

- (void)updateUI {
    
  for (UIButton *cardButton in self.playingCardsButtons) {
    NSUInteger cardButtonIndex = [self.playingCardsButtons indexOfObject:cardButton];
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
    if ([self numberOfCardsToMatch]==2) {//playing cards game
        return card.isChosen ? card.contents : @"";
    }else{//set game
        return card.contents;
    }
}

- (UIImage *)backgrounfImageForCard:(Card *)card {
    if ([self numberOfCardsToMatch]==2) {//playing cards game
        return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
    }else{//set game
        return [UIImage imageNamed: @"cardfront" ];
    }
  
}

@end
