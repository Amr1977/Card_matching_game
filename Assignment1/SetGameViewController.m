//
//  SetGameViewController.m
//  Assignments
//
//  Created by Amr Lotfy on 5/31/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "SetGameViewController.h"

@interface SetGameViewController ()
@property(strong, nonatomic) ASetCardDeck * deck;  // this is supposed to be in the model ?
@property(strong, nonatomic) ASetCard *selectedSetCard;                 // move to model ?
@property(strong, nonatomic) CardMatchingGame *game;  // pointer to the model

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardsButtons;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation SetGameViewController
- (IBAction)deal:(id)sender {
    [self newGame];
    [self updateUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CardMatchingGame *)newGame {
    
    NSArray * buttons;
    buttons=[self cardsButtons];
    
    
    _game = [[CardMatchingGame alloc]
             initWithCardCount:[buttons count]  // number of buttons(cards
             // cells in view)
             
             usingDeck:[self deck]
             numberOfCardsToMatch:3];  // creates full deck
    
    
    return _game;
}

- (CardMatchingGame *)game {
    if (!_game) {
        NSLog(@"game: creating a new game...");
        _game = [self newGame];
    }
    return _game;
}

- (ASetCardDeck *)createDeck {
    return [[ASetCardDeck alloc] init];
}

// getter
- (ASetCardDeck *)deck {
    if (!_deck) {
        NSLog(@"creating new deck...");
        _deck = [self createDeck];
    }
    return _deck;
}

- (NSString *)titleForCard:(Card *)card {
    return card.contents;
}

- (UIImage *)backgrounfImageForCard:(Card *)card {
    return [UIImage imageNamed:@"cardfront" ];
}

- (void)updateUI {
    
    for (UIButton *cardButton in self.cardsButtons) {
        NSUInteger cardButtonIndex = [self.cardsButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgrounfImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text =
        [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
        self.actionLabel.text = [[self game] lastAction];
    }
}

- (IBAction)touchCardButton:(UIButton *)sender {
    // disable changing of game mode control segment
    //[[self gameModeSegmentControl] setEnabled:NO];
    
    NSUInteger chosenButtonIndex = [self.cardsButtons indexOfObject:sender];
    NSLog(@"chosenButtonIndex: %lu",chosenButtonIndex);
    
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

@end
