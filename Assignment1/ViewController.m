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

@property (weak, nonatomic) IBOutlet UILabel *flipsLebel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck * deck;
@property (strong, nonatomic) PlayingCard * selectedPlayingCard;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;


@end

@implementation ViewController

-(CardMatchingGame *) game{
    if (!_game){
        _game=[[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    }
    return _game;
}

-(PlayingCardDeck *) createDeck{
    return [[PlayingCardDeck alloc] init];
}

- (PlayingCardDeck *) deck{
    if(! _deck){
        _deck= [self createDeck];
    }
    return _deck;
}

-(void) setFlipCount:(int)flipCount{
    _flipCount=flipCount;
    self.flipsLebel.text = [NSString stringWithFormat:@"#Clicks: %d %@",self.flipCount,self.selectedPlayingCard ? @"":@"Out Of cards !"];
    NSLog(@"Clicks: %d",self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex=[self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    self.flipCount++;
    
  }
@end
