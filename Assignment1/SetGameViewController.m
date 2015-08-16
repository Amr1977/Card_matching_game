//
//  SetGameViewController.m
//  Assignments
//
//  Created by Amr Lotfy on 5/31/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "SetGameViewController.h"
//#define NumberOfCardsInRow 4
#define SetCardCardToSuperViewWidthRatio 1 / (NumberOfCardsInRow + 1)
#define SetCardHeightToWidthRatio 0.60
#define HGapRatio 0.2
#define VGapRatio 0.2

#define InitialCardNumber 12

@interface SetGameViewController ()<UIDynamicAnimatorDelegate>
@property(strong, nonatomic)
    ASetCardDeck *deck;  // this is supposed to be in the model ?
@property(weak, nonatomic) ASetCard *selectedSetCard;  // move to model ?
@property(strong, nonatomic) CardMatchingGame *game;   // pointer to the model

@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(nonatomic) CGFloat reservedHeaderSpace;

@end

@implementation SetGameViewController

#pragma mark - cardWidth
- (CGFloat)cardWidth {
    
    CGFloat width= (self.view.superview.frame.size.width/((([self numberOfCardsPerRow]))*(1+HGapRatio)+HGapRatio));//here is the magic point.
    NSLog(@"card width :%f",width);
    return width;
}

- (CGFloat)cardHeight {
  return [self cardWidth] * SetCardHeightToWidthRatio;
}

- (void)viewDidAppear:(BOOL)animated {
  [self newGame];
  [self updateUI];
}

- (NSMutableArray *)cardsButtons {
  if (!_cardsButtons) {
    _cardsButtons = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i <= InitialCardNumber; i++) {
      [self addCard];
    }
  }

  return _cardsButtons;
}

- (void)addCard {
  [[self game] addCard];
  SetCardView *newView = [[SetCardView alloc]
      initWithFrame:CGRectMake(0, 0, [self cardWidth], [self cardHeight])];
  [UIView animateWithDuration:0.5
      delay:0.0
      options:UIViewAnimationOptionCurveLinear
      animations:^{
        newView.frame = CGRectMake(0, 0, [self cardWidth], [self cardHeight]);
      }
      completion:^(BOOL finish) {
        ;
      }];

  newView.viewControllerDelegate = self;

  [[self view] addSubview:newView];

  [[self cardsButtons] addObject:newView];
}

- (IBAction)moreCards:(UIButton *)sender {
  NSLog(@"give the user more three cards...");
  for (NSInteger i = 1; i <= 3; i++) {
    [self addCard];
  }
  [self updateUI];
}

- (IBAction)deal:(id)sender {
  self.gathered = false;
  for (UIView *subview in self.cardsButtons) {
    // delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
    [UIView animateWithDuration:0.5
        delay:0.0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{

          subview.frame =
              CGRectMake(self.view.superview.bounds.size.width, 0,
                         subview.frame.size.width, subview.frame.size.height);
        }
        completion:^(BOOL finished) {
          if (finished) {
            [subview removeFromSuperview];
          };
        }];
  }
  [self.cardsButtons removeAllObjects];

  while ([self.cardsButtons count] < InitialCardNumber) {
    [self moreCards:nil];
  }
  [self newGame];
  [self updateUI];
}
#pragma mark - view did load
- (void)viewDidLoad {
  [super viewDidLoad];
  self.viewsToBeDeleted = [[NSMutableArray alloc] init];

  // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(layoutCards)
             name:UIDeviceOrientationDidChangeNotification
           object:nil];
  UIPinchGestureRecognizer *pgr =
      [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handlePinch)];
  ;
  [self.view addGestureRecognizer:pgr];
  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
  self.gravity = [[UIGravityBehavior alloc] init];
  self.collision = [[UICollisionBehavior alloc] init];
  // self.attachment=[[UIAttachmentBehavior alloc] init];
  self.collision.translatesReferenceBoundsIntoBoundary = YES;
  self.animator.delegate = self;
  [self.animator addBehavior:self.gravity];
  [self.animator addBehavior:self.collision];
  self.itemBehaviour.elasticity = 1.0;
  [self.animator addBehavior:self.itemBehaviour];
}

- (void)handlePinch {
  NSLog(@"handlePinch.");
  if (![self gathered]) {
    [self gatherCards];
  }
}

#pragma mark - gather cards

- (void)gatherCards {
  self.gathered = TRUE;
  NSLog(@"gathering cards.");

  NSInteger shift = 0;
  CGFloat centerX = self.view.superview.frame.origin.x +
                    self.view.superview.frame.size.width / 2 -
                    [self cardWidth] / 2;
  CGFloat centerY = self.view.superview.frame.origin.y +
                    self.view.superview.frame.size.height / 2 -
                    [self cardHeight] / 2;

  for (UIView *card in [self cardsButtons]) {
    CGRect frame = CGRectMake(centerX + shift, centerY + shift,
                              [self cardWidth], [self cardHeight]);

    [UIView animateWithDuration:0.5
        delay:0.0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
          card.frame = frame;
        }
        completion:^(BOOL finish) {
          ;
        }];
    shift += 5;
  }
}

- (void)movePile:(CGPoint)translation sender:(UIView *)sender {
  for (UIView *view in self.cardsButtons) {
    if (view != sender) {
      view.center = CGPointMake(view.center.x + translation.x,
                                view.center.y + translation.y);
    }
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];

  // Dispose of any resources that can be recreated.
}

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
#pragma mark - updateUI
- (void)updateUI {
  NSMutableArray *cardsToBeDeleted = [[NSMutableArray alloc] init];

  // linking model cards to view cards
  for (SetCardView *cardButton in self.cardsButtons) {
    NSUInteger cardButtonIndex = [self.cardsButtons indexOfObject:cardButton];
    ASetCard *card = (ASetCard *)[self.game cardAtIndex:cardButtonIndex];

    cardButton.symbol = card.symbol;
    cardButton.shading = card.shading;
    cardButton.color = card.color;
    cardButton.count = card.count;
    cardButton.chosen = card.chosen;

    cardButton.enabled = !card.isMatched;
    if (card.isMatched) {
      [self.viewsToBeDeleted addObject:cardButton];
      [cardsToBeDeleted addObject:card];
    }
  }

  if ([self.viewsToBeDeleted count]) {
    NSLog(@"%lu cards are registered for deletion.",
          (unsigned long)[self.viewsToBeDeleted count]);
    // clean removed cards from model
    for (ASetCard *card in cardsToBeDeleted) {
      [self.game.cards removeObject:card];
    }

    // clean removed cards from view
    for (SetCardView *cardView in self.viewsToBeDeleted) {
      [self.gravity addItem:cardView];
      [self.collision addItem:cardView];
      [self.itemBehaviour addItem:cardView];
      [self.cardsButtons removeObject:cardView];
    }
  }
  self.scoreLabel.text =
      [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
  [self layoutCards];
  [[self game] logSolution];
}

-(NSInteger) numberOfCardsPerRow{
    NSInteger numberOfCards=1;
    while (![self fitsInScreenHeight:numberOfCards]) {
        numberOfCards+=1;
    }
    NSLog(@"Selected Number of cards per row: %ld",(long)numberOfCards);
    return  numberOfCards;
}

- (void)layoutCards {
    
  // arrange each 4 cards at a row
  self.gathered = false;
    CGFloat cardWidth= [self cardWidth];
    CGFloat cardHeight=[self cardHeight];
    NSInteger numberOfCardsInRow=[self numberOfCardsPerRow];//

    CGFloat yStart =
      self.scoreLabel.frame.origin.y + self.scoreLabel.frame.size.height + cardHeight * (VGapRatio);
  CGFloat xStart = cardWidth * HGapRatio;
  // SetCardView * cardView in self.cardsButtons

    
  for (NSInteger cardNumber = 0; cardNumber < ([self.cardsButtons count]);
       cardNumber++) {
    CGRect frame;
    NSInteger row = cardNumber / numberOfCardsInRow;
    NSInteger col = cardNumber - row * numberOfCardsInRow;
    frame.origin.x = xStart + col * ((cardWidth) * (1 + HGapRatio));//needs considering trailing space
    frame.origin.y = yStart + row * (cardHeight * (1 + VGapRatio));
    frame.size.height = cardHeight;
    frame.size.width = cardWidth;
    [UIView animateWithDuration:0.5
        delay:0.0
        options:UIViewAnimationOptionTransitionCurlDown
        animations:^{
          (((SetCardView *)[self.cardsButtons
               objectAtIndex:(row * numberOfCardsInRow + col)]))
              .frame = frame;
        }
        completion:^(BOOL finished) {//NSLog(@"animation completed.<<<<<<<<<<<<<<<<<<<<<<<<<<");
        }];
  }
}

-(BOOL) fitsInScreenHeight:(NSInteger)cardsPerRow{
    
    CGFloat width = ((self.view.frame.size.width/(cardsPerRow)))/(1+HGapRatio);
    CGFloat height = width * SetCardHeightToWidthRatio;
    NSInteger numberOfRows = [self.cardsButtons count]/cardsPerRow +1;
    BOOL result = ((numberOfRows*(height* (1 + VGapRatio))+self.scoreLabel.frame.size.height+self.tabBarController.tabBar.frame.size.height+height * (VGapRatio)) < self.view.superview.frame.size.height);
    NSLog(@"fitsInScreenHeight(%lu), result: %@, cards count: %lu",(long)cardsPerRow, result?@"pass":@"fail", (unsigned long)[self.cardsButtons count]);
    return result;
}


- (void)touchCard:(id)sender {
  // disable changing of game mode control segment
  //[[self gameModeSegmentControl] setEnabled:NO];
  if (!self.gathered) {
    NSUInteger chosenButtonIndex = [self.cardsButtons indexOfObject:sender];
    NSLog(@"chosenButtonIndex: %lu", (unsigned long)chosenButtonIndex);

    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
  } else {
    [self layoutCards];
  }
}

- (void)removeCardSubview:(SetCardView *)card {
  NSInteger index = [self.cardsButtons indexOfObject:card];  // get index in
                                                             // view
  [self.game removeCardAtIndex:index];  // remove from model
  [self.cardsButtons removeObject:card];  // remove from outlet array
  NSLog(@"remaining [%lu] cards.", (unsigned long)[[self cardsButtons] count]);
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
  NSLog(@">>>>>>>>>>>>>>>>>>>>>>>dynamicAnimatorDidPause ");
  for (SetCardView *cardView in self.viewsToBeDeleted) {
    [self.gravity removeItem:cardView];
    [self.collision removeItem:cardView];
    [UIView animateWithDuration:0.5
        delay:0.0
        options:UIViewAnimationOptionCurveLinear
        animations:^{
          cardView.alpha = 0.0;
        }
        completion:^(BOOL finish) {
          if (finish) {
            [cardView removeFromSuperview];
          }
        }];
  }
  [self.viewsToBeDeleted removeAllObjects];
}

@end
