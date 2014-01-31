//
//  WSDeck.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 5/3/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "WSDeck.h"
#import "WSStack.h"
#import "NSMutableArray+Shuffle.h"


@interface WSDeck ()

@property (nonatomic, strong) WSStack *deckInternal;

@end


@implementation WSDeck

@synthesize deckInternal = _deckInternal;
@synthesize size         = _size;

+ (WSDeck *)deck
{
    WSDeck *deck = [[WSDeck alloc] init];
    if (deck)
    {
        NSMutableArray *cards = [NSMutableArray array];
        
        
        // add spades to deck ...
        
        WSCard *s7  = [WSCard cardWithSuit:WSCardSuitSpades value:WSCardValue7];   
        WSCard *s8  = [WSCard cardWithSuit:WSCardSuitSpades value:WSCardValue8];   
        WSCard *s9  = [WSCard cardWithSuit:WSCardSuitSpades value:WSCardValue9];   
        WSCard *s10 = [WSCard cardWithSuit:WSCardSuitSpades value:WSCardValue10];   
        WSCard *sJ  = [WSCard cardWithSuit:WSCardSuitSpades value:WSCardValueJack];   
        WSCard *sK  = [WSCard cardWithSuit:WSCardSuitSpades value:WSCardValueKing];   
        WSCard *sQ  = [WSCard cardWithSuit:WSCardSuitSpades value:WSCardValueQueen];   
        WSCard *sA  = [WSCard cardWithSuit:WSCardSuitSpades value:WSCardValueAce];   
        [cards addObjectsFromArray:[NSArray arrayWithObjects:s7, s8, s9, s10, sJ, sQ, sK, sA, nil]];

    
        // add diamonds to deck ...

        WSCard *d7  = [WSCard cardWithSuit:WSCardSuitDiamonds value:WSCardValue7];   
        WSCard *d8  = [WSCard cardWithSuit:WSCardSuitDiamonds value:WSCardValue8];   
        WSCard *d9  = [WSCard cardWithSuit:WSCardSuitDiamonds value:WSCardValue9];   
        WSCard *d10 = [WSCard cardWithSuit:WSCardSuitDiamonds value:WSCardValue10];   
        WSCard *dJ  = [WSCard cardWithSuit:WSCardSuitDiamonds value:WSCardValueJack];   
        WSCard *dQ  = [WSCard cardWithSuit:WSCardSuitDiamonds value:WSCardValueQueen];   
        WSCard *dK  = [WSCard cardWithSuit:WSCardSuitDiamonds value:WSCardValueKing];   
        WSCard *dA  = [WSCard cardWithSuit:WSCardSuitDiamonds value:WSCardValueAce];   
        [cards addObjectsFromArray:[NSArray arrayWithObjects:d7, d8, d9, d10, dJ, dQ, dK, dA, nil]];
        
        
        // add clubs to deck ...
        
        WSCard *c7  = [WSCard cardWithSuit:WSCardSuitClubs value:WSCardValue7];   
        WSCard *c8  = [WSCard cardWithSuit:WSCardSuitClubs value:WSCardValue8];   
        WSCard *c9  = [WSCard cardWithSuit:WSCardSuitClubs value:WSCardValue9];   
        WSCard *c10 = [WSCard cardWithSuit:WSCardSuitClubs value:WSCardValue10];   
        WSCard *cJ  = [WSCard cardWithSuit:WSCardSuitClubs value:WSCardValueJack];   
        WSCard *cQ  = [WSCard cardWithSuit:WSCardSuitClubs value:WSCardValueQueen];   
        WSCard *cK  = [WSCard cardWithSuit:WSCardSuitClubs value:WSCardValueKing];   
        WSCard *cA  = [WSCard cardWithSuit:WSCardSuitClubs value:WSCardValueAce];   
        [cards addObjectsFromArray:[NSArray arrayWithObjects:c7, c8, c9, c10, cJ, cQ, cK, cA, nil]];
        
        
        // add hearts to deck ...
        
        WSCard *h7  = [WSCard cardWithSuit:WSCardSuitHearts value:WSCardValue7];   
        WSCard *h8  = [WSCard cardWithSuit:WSCardSuitHearts value:WSCardValue8];   
        WSCard *h9  = [WSCard cardWithSuit:WSCardSuitHearts value:WSCardValue9];   
        WSCard *h10 = [WSCard cardWithSuit:WSCardSuitHearts value:WSCardValue10];   
        WSCard *hJ  = [WSCard cardWithSuit:WSCardSuitHearts value:WSCardValueJack];   
        WSCard *hQ  = [WSCard cardWithSuit:WSCardSuitHearts value:WSCardValueQueen];   
        WSCard *hK  = [WSCard cardWithSuit:WSCardSuitHearts value:WSCardValueKing];   
        WSCard *hA  = [WSCard cardWithSuit:WSCardSuitHearts value:WSCardValueAce];   
        [cards addObjectsFromArray:[NSArray arrayWithObjects:h7, h8, h9, h10, hJ, hQ, hK, hA, nil]];
        

        deck.deckInternal = [WSStack stackWithItems:cards];
    }
    return deck;
}

#pragma mark - Public instance methods

- (void)shuffle
{
    NSMutableArray *cards = [_deckInternal.items mutableCopy];
    
    [cards shuffle];
    
    self.deckInternal = [WSStack stackWithItems:cards];
    
    DLog(@"%@", cards);
}

- (NSInteger)size
{
    return _deckInternal.items.count;
}

#pragma mark - Private

- (WSCard *)dealCard
{
    return [_deckInternal pop];
}

@end











