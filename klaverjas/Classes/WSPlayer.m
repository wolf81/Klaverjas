//
//  WSPlayer.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/1/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import "WSPlayer.h"
#import "NSArray+RandomObject.h"
#import "WSChooseTrumpsView.h"


@interface WSPlayer ()

@property (nonatomic, copy)   void (^playCardHandler)(WSCard *);
@property (nonatomic, copy)   void (^acceptTrumpsHandler)(BOOL);
@property (nonatomic, copy)   NSString     *name;
@property (nonatomic, assign) WSPlayerKind  kind;

- (NSUInteger)handValueWithTrumpsSuit:(WSCardSuit)trumpSuit;
- (WSCard *)bestCardOfHandWithPlayedCards:(NSArray *)playedCards trumpSuit:(WSCardSuit)trumpSuit;
- (void)beginTurn;
- (void)endTurnWithCardPlayed:(WSCard *)card;

@end


@implementation WSPlayer

@synthesize acceptTrumpsHandler = _acceptTrumpsHandler;
@synthesize playCardHandler     = _playCardHandler;
@synthesize hand                = _hand;
@synthesize name                = _name;
@synthesize kind                = _kind;
@synthesize isActive            = _isActive;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.hand = [NSArray array];
    }
    return self;
}

+ (WSPlayer *)playerWithName:(NSString *)name kind:(WSPlayerKind)kind
{
    WSPlayer *player = [[WSPlayer alloc] init];
    if (player)
    {
        player.name = name;
        player.kind = kind;
    }
    return player;
}

- (NSString *)description
{
    return _name;
}

#pragma mark - Card delegate

- (void)cardPlayed:(WSCard *)card
{
    [self endTurnWithCardPlayed:card];
}

#pragma mark - Public instance methods

- (BOOL)removeCardFromHand:(WSCard *)card
{    
    BOOL didRemoveCard = NO;
    
    if ([_hand containsObject:card])
    {
        NSMutableArray *hand = [NSMutableArray arrayWithArray:_hand];
        [hand removeObject:card];
        
        self.hand  = hand;
        card.owner = nil;
        
        didRemoveCard = YES;
    }
    
    return didRemoveCard;
}

- (void)playCardWithPlayedCards:(NSArray *)playedCards trumpSuit:(WSCardSuit)trumpSuit completionHandler:(void (^)(WSCard *))playCardHandler
{
    self.isActive        = YES;
    self.playCardHandler = playCardHandler;
    
    
    if (_kind == WSPlayerKindComputer)
    {        
        WSCard *card = [self bestCardOfHandWithPlayedCards:playedCards trumpSuit:trumpSuit];
        
        DLog(@"%@ - play card: %@", _name, card);
        
        
        // remove card from hand ...
        
        NSMutableArray *hand = [_hand mutableCopy];
        [hand removeObject:card];
        self.hand = hand;
        
        
        [NSThread sleepForTimeInterval:0.3f];
        
        [self endTurnWithCardPlayed:card];
    }    
}

- (void)acceptTrumpSuit:(WSCardSuit)trumpSuit withCompletionHandler:(void (^)(BOOL))acceptTrumpsHandler
{
    if (_kind == WSPlayerKindHuman)
    {
        UIImage *image = [WSCard imageForSuit:trumpSuit];
      
        WSChooseTrumpsView *dialog = [WSChooseTrumpsView chooseTrumpsViewWithImage:image completionHandler:^ (BOOL accepted) {

            DLog(@"player accepted trumps?: %d", accepted);
            
            if (acceptTrumpsHandler)
            {
                acceptTrumpsHandler(accepted);
            }
 
        }];
        
        [dialog show];
    }
    else
    {
        NSUInteger handValue = [self handValueWithTrumpsSuit:trumpSuit];
        
        DLog(@"%@ - hand value: %d",  _name, handValue);

        if (acceptTrumpsHandler)
        {
            acceptTrumpsHandler(handValue > CPU_MINIMUM_ACCEPTED_HAND_VALUE);
        }
    }    
}

#pragma mark - Private instance methods

- (void)beginTurn
{
    self.isActive = YES;
}

- (void)endTurnWithCardPlayed:(WSCard *)card
{
    self.isActive = NO;
    
    if (_playCardHandler)
    {
        _playCardHandler(card);
    }
}

- (NSUInteger)handValueWithTrumpsSuit:(WSCardSuit)trumpSuit
{
    NSUInteger totalValue = 0;
    
    for (WSCard *card in _hand)
    {
        switch (card.value)
        {
            case WSCardValue7:     totalValue += 0;  break;
            case WSCardValue8:     totalValue += 0;  break;
            case WSCardValue9:     totalValue += (card.suit == trumpSuit) ? 14 : 0; break;
            case WSCardValue10:    totalValue += 10; break;
            case WSCardValueJack:  totalValue += (card.suit == trumpSuit) ? 20 : 2; break;
            case WSCardValueQueen: totalValue += 3;  break;
            case WSCardValueKing:  totalValue += 4;  break;
            case WSCardValueAce:   totalValue += 11; break;
            default: break;
        }
    }
    
    return totalValue;
}

- (WSCard *)bestCardOfHandWithPlayedCards:(NSArray *)playedCards trumpSuit:(WSCardSuit)trumpSuit
{
    WSCard *topCard = (playedCards.count > 0) ? [playedCards objectAtIndex:0] : nil;
    WSCard *bestCard = nil;
    
    
    // step 0: if there's no first card yet, figure out the best card to play 
    //  from own cards ...
    
    if (!topCard)
    {
        bestCard = [_hand randomObject];
    }
    
    
    // step 1: check if hand contains any card of same kind as top card ...
    
    if (!bestCard && topCard.suit != trumpSuit)
    {
        NSArray *cards = [NSArray array];
        
        for (WSCard *card in _hand)
        {
            if (card.suit == topCard.suit) // follow leading suit ...
            {
                cards = [cards arrayByAddingObject:card];
            }
        }
        
        
        // step 1.1: if at least 1 card was found of same kind as the leading 
        //  suit, figure out best card to play from this stack ...
        
        if (cards.count > 0) 
        {
            for (WSCard *card in cards)
            {
                for (WSCard *playedCard in playedCards)
                {
                    
                }
            }
            
            bestCard = [cards objectAtIndex:0];
        }    
    }
    
    
    
    // step 2: check if hand contains any trump card ...
    
    if (!bestCard)
    {
        NSArray *cards = [NSArray array];
        
        for (WSCard *card in _hand)
        {
            if (card.suit == trumpSuit)
            {
                cards = [cards arrayByAddingObject:card];
            }
        }
        
        
        // step 2.1: if at least 1 card was found of trump suit, figure out
        //  best card to play from this stack ...

        if (cards.count > 0)
        {
            bestCard = [cards objectAtIndex:0];
        }
    }
    
    
    // step 3: play random remaining card ...
    //  if we might win this round and there's a big chance we'll lose a high 
    //  value card in the coming rounds, play the high value card, otherwise 
    //  play a low value card
    
    if (!bestCard)
    {
        bestCard = [_hand randomObject];
    }
    
    
    return bestCard;
}

@end
