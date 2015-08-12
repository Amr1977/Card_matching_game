//
//  SetGameViewController.m
//  Assignments
//
//  Created by Amr Lotfy on 5/31/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "SetGameViewController.h"



@interface SetGameViewController ()
@property(strong, nonatomic)
    ASetCardDeck *deck;  // this is supposed to be in the model ?
@property(weak, nonatomic) ASetCard *selectedSetCard;  // move to model ?
@property(strong, nonatomic) CardMatchingGame *game;     // pointer to the model

//@property(strong, nonatomic) IBOutletCollection(SetCardView)    NSMutableArray *cardsButtons;
@property (nonatomic) NSMutableArray *cardsButtons;
//@property (nonatomic) NSMutableArray * cardsButtons;
@property (nonatomic) NSMutableDictionary * cardsHash;
@property(weak, nonatomic) IBOutlet UILabel *actionLabel;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation SetGameViewController




-(NSMutableArray *) cardsButtons{
    if (!_cardsButtons) {
        _cardsButtons=[[NSMutableArray alloc] init];
        for (NSInteger i=1; i<=InitialCardNumber; i++) {
            [self addCard];
        }

    }
    return _cardsButtons;
}

-(void) addCard{
    [[self game] addCard];
    SetCardView * newView=[[SetCardView alloc] initWithFrame:CGRectMake(0, 0,SetCardWidth, SetCardHeight)];
    [[self view] addSubview:newView];
    [[self cardsButtons] addObject:newView];
}

- (IBAction)moreCards:(UIButton *)sender {
    NSLog(@"give the user more three cards...");
    //TODO: add 3 cards if possible
    for (NSInteger i=1; i<=3; i++) {
        [self addCard];
    }
    [self updateUI];
}


- (IBAction)deal:(id)sender {
    while ([self.cardsButtons count]<12) {
        [self moreCards:nil];
    }
  [self newGame];
  [self updateUI];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
    
  
  [self newGame];
  [self updateUI];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];

  // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/*
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
*/

- (CardMatchingGame *)newGame {
  NSArray *buttons;
  buttons = [self cardsButtons];
  // have a new deck
  [self setDeck:[self createDeck]];

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
  return [UIImage imageNamed:@"cardfront"];
}

- (void)updateUI {
    for (SetCardView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[SetCardView class]]) {
            [subView setBackgroundColor:[UIColor whiteColor]];
            UITapGestureRecognizer *tapgr =
            [[UITapGestureRecognizer alloc] initWithTarget:subView
                                                    action:@selector(handleTap)];
            UIPanGestureRecognizer * pgr=[[UIPanGestureRecognizer alloc] initWithTarget:subView action:@selector(handlePan:)];
            NSLog(@"Found match.");
            subView.viewControllerDelegate = self;
            [subView addGestureRecognizer:tapgr];
            [subView addGestureRecognizer:pgr];
        }
    }
    NSMutableArray * viewsToBeDeleted=[[NSMutableArray alloc] init];
    NSMutableArray * cardsToBeDeleted=[[NSMutableArray alloc] init];

  for (SetCardView *cardButton in self.cardsButtons) {
    NSUInteger cardButtonIndex = [self.cardsButtons indexOfObject:cardButton];
    ASetCard *card = (ASetCard *)[self.game cardAtIndex:cardButtonIndex];
      
    cardButton.symbol = card.symbol;
    cardButton.shading = card.shading;
    cardButton.color = card.color;
    cardButton.count = card.count;
    cardButton.chosen=card.chosen;

    cardButton.enabled = !card.isMatched;//causes a bug
      if (card.isMatched) {
          [viewsToBeDeleted addObject:cardButton];
          [cardsToBeDeleted addObject:card];
      }
  }
    //clean removed cards from view
    for (SetCardView * cardView in viewsToBeDeleted) {
        [cardView removeFromSuperview];
        [self.cardsButtons removeObject:cardView];
        
    }

    //clean removed cards from model
    for (ASetCard * card in cardsToBeDeleted) {
        [self.game.cards removeObject:card];
    }

    
    self.scoreLabel.text =
    [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    self.actionLabel.text = [[self game] lastAction];
    [self allignCards];
    [[self game] logSolution];
}



-(void) allignCards{
    // arrange each 4 cards at a row
    CGFloat yStart=20;
    CGFloat xStart=20;
    //SetCardView * cardView in self.cardsButtons

    for (NSInteger row=0; row < ([self.cardsButtons count] /NumberOfCardsInRow) ; row++) {
        for (NSInteger col=0; col < NumberOfCardsInRow; col++) {
            CGRect frame;
            frame.origin.x=xStart+col*(SetCardWidth*(1+HGapRatio));
            frame.origin.y=yStart+row*(SetCardHeight*(1+VGapRatio));
            frame.size.height=SetCardHeight;
            frame.size.width=SetCardWidth;
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{(((SetCardView *)[self.cardsButtons objectAtIndex:(row*NumberOfCardsInRow+col)])).frame=frame; } completion:^(BOOL finished){; }];
            NSLog(@"card number [%ld] positioned at [%f,%f]",(row*NumberOfCardsInRow+col),frame.origin.x,frame.origin.y );
            
        }
    }
        NSLog(@"cards count:%ld",[self.cardsButtons count]);
}

- (void)touchCard:(id)sender {
  // disable changing of game mode control segment
  //[[self gameModeSegmentControl] setEnabled:NO];

  NSUInteger chosenButtonIndex = [self.cardsButtons indexOfObject:sender];
  NSLog(@"chosenButtonIndex: %lu", chosenButtonIndex);

  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}

-(void) removeCardSubview:(SetCardView *)card{
    NSInteger index=[self.cardsButtons indexOfObject:card];//get index in view
    [self.game removeCardAtIndex:index];//remove from model
    [self.cardsButtons removeObject:card]; //remove from outlet array
    NSLog(@"remaining [%lu] cards.",[[self cardsButtons] count]);
}

@end
