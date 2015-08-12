//
//  SetGameViewController.m
//  Assignments
//
//  Created by Amr Lotfy on 5/31/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "SetGameViewController.h"
#define NumberOfCardsInRow 4
#define SetCardCardToSuperViewWidthRatio 1/(NumberOfCardsInRow+1)
#define SetCardHeightToWidthRatio 0.60
#define HGapRatio 0.2
#define VGapRatio 0.2

#define InitialCardNumber 12

@interface SetGameViewController ()
@property(strong, nonatomic)
    ASetCardDeck *deck;  // this is supposed to be in the model ?
@property(weak, nonatomic) ASetCard *selectedSetCard;  // move to model ?
@property(strong, nonatomic) CardMatchingGame *game;     // pointer to the model

@property (nonatomic) NSMutableArray *cardsButtons;

@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) CGFloat reservedHeaderSpace;
@property (nonatomic) BOOL gathered;



@end

@implementation SetGameViewController

-(CGFloat) cardWidth{
    return self.view.superview.frame.size.width * SetCardCardToSuperViewWidthRatio;
}

-(CGFloat) cardHeight{
    return [self cardWidth]*SetCardHeightToWidthRatio;
}


-(void) viewDidAppear:(BOOL)animated{
    [self newGame];
    [self updateUI];
}

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
    SetCardView * newView=[[SetCardView alloc] initWithFrame:CGRectMake(0, 0,[self cardWidth]  , [self cardHeight])];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{ newView.frame=CGRectMake(0, 0, [self cardWidth], [self cardHeight]);} completion:^(BOOL finish){;}];
    
    
    newView.viewControllerDelegate=self;
                           
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
    self.gathered=false;
    for (UIView * subview in self.cardsButtons) {
        //delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           
            subview.frame=CGRectMake(self.view.superview.bounds.size.width, 0, subview.frame.size.width, subview.frame.size.height); } completion:^(BOOL finished){ if(finished){
                [subview removeFromSuperview];
            }; }];
        
        
    }
    [self.cardsButtons removeAllObjects];
    
    while ([self.cardsButtons count]<InitialCardNumber) {
        [self moreCards:nil];
    }
  [self newGame];
  [self updateUI];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(allignCards)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    UIPinchGestureRecognizer * pgr=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch)];;
    [self.view addGestureRecognizer:pgr];
}

-(void)handlePinch{
    NSLog(@"handlePinch.");
    if (![self gathered]) {
       [self gatherCards];
    }
}

-(void)gatherCards{
    self.gathered=TRUE;
    NSLog(@"gathering cards.");
    
    NSInteger shift=0;
    CGFloat centerX=self.view.superview.frame.origin.x+self.view.superview.frame.size.width/2-[self cardWidth]/2;
    CGFloat centerY=self.view.superview.frame.origin.y+self.view.superview.frame.size.height/2-[self cardHeight]/2;
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior * gravity=[[UIGravityBehavior alloc] init];
    [animator addBehavior:gravity];
    [gravity addItem:self.view];
    UIAttachmentBehavior *attacher= [[UIAttachmentBehavior alloc] initWithItem:(UIView *)(self.cardsButtons[0]) attachedToAnchor:CGPointMake(centerX, centerY)];
    [animator addBehavior:attacher];
    
    
    for (UIView * card in [self cardsButtons]) {
        CGRect frame=CGRectMake(centerX+shift,centerY+shift, [self cardWidth], [self cardHeight]);
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            card.frame=frame;
        } completion:^(BOOL finish){;}];
        
        if (shift>5) {
            UIAttachmentBehavior *attacher= [[UIAttachmentBehavior alloc] initWithItem:card attachedToItem:(UIView *)(self.cardsButtons[0])];
            attacher.damping = 1.6;
            attacher.frequency = 10;
            [animator addBehavior:attacher];
        }
         
        
        shift+=5;
        
    }
    
    
    
    

    
    
    //todo attach them all, remember to deattch them on tap
    
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

- (void)updateUI {
    
    NSMutableArray * viewsToBeDeleted=[[NSMutableArray alloc] init];
    NSMutableArray * cardsToBeDeleted=[[NSMutableArray alloc] init];

    //linking model cards to view cards
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
    [self allignCards];
    [[self game] logSolution];
}



-(void) allignCards{
    // arrange each 4 cards at a row
    self.gathered=false;
    CGFloat yStart=self.scoreLabel.frame.origin.y+self.scoreLabel.frame.size.height+10;
    CGFloat xStart=[self cardWidth]*HGapRatio;
    //SetCardView * cardView in self.cardsButtons

    for (NSInteger cardNumber=0; cardNumber < ([self.cardsButtons count]) ; cardNumber++) {
            CGRect frame;
            NSInteger row= cardNumber/NumberOfCardsInRow;
            NSInteger col= cardNumber-row*NumberOfCardsInRow;
            frame.origin.x=xStart+col*(([self cardWidth])*(1+HGapRatio));
            frame.origin.y=yStart+row*([self cardHeight]*(1+VGapRatio));
            frame.size.height=[self cardHeight];
            frame.size.width=[self cardWidth];
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{(((SetCardView *)[self.cardsButtons objectAtIndex:(row*NumberOfCardsInRow+col)])).frame=frame; } completion:^(BOOL finished){; }];
            NSLog(@"card number [%ld] positioned at [%f,%f]",(row*NumberOfCardsInRow+col),frame.origin.x,frame.origin.y );
    }
        NSLog(@"cards count:%ld",[self.cardsButtons count]);
}



- (void)touchCard:(id)sender {
  // disable changing of game mode control segment
  //[[self gameModeSegmentControl] setEnabled:NO];
    if (!self.gathered) {
        NSUInteger chosenButtonIndex = [self.cardsButtons indexOfObject:sender];
        NSLog(@"chosenButtonIndex: %lu", chosenButtonIndex);
        
        [self.game chooseCardAtIndex:chosenButtonIndex];
        [self updateUI];
    }else{
        [self allignCards];
    }
  
}

-(void) removeCardSubview:(SetCardView *)card{
    NSInteger index=[self.cardsButtons indexOfObject:card];//get index in view
    [self.game removeCardAtIndex:index];//remove from model
    [self.cardsButtons removeObject:card]; //remove from outlet array
    NSLog(@"remaining [%lu] cards.",[[self cardsButtons] count]);
}

@end
