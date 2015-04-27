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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLebel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck * deck;
@property (strong, nonatomic) PlayingCard * selectedPlayingCard;


@end

@implementation ViewController


- (PlayingCardDeck *) deck{
    if(! _deck){
        _deck= [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

-(void) setFlipCount:(int)flipCount{
    _flipCount=flipCount;
    self.flipsLebel.text = [NSString stringWithFormat:@"#Clicks: %d %@",self.flipCount,self.selectedPlayingCard ? @"":@"Out Of cards !"];
    NSLog(@"Clicks: %d",self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSString *title=@"";
    if ([sender.currentTitle length ]){
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    }else{
        
        self.selectedPlayingCard = (PlayingCard *) [[self deck] drawRandomCard];
        if (self.selectedPlayingCard){
            title = [ self.selectedPlayingCard contents];
            [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                              forState:UIControlStateNormal];
            [sender setTitle:title forState:UIControlStateNormal];
        } else{
            NSLog(@"Out of Cards");
        }
    }
    NSLog(@"Title: %@ ", title);
    
            self.flipCount++;
  }
@end
