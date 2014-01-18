//
//  WSTrick.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/14/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import "WSTrick.h"
#import "WSCard.h"
#import "WSPlayer.h"
#import "WSGameBoard.h"


@interface WSTrick ()

@property (nonatomic, strong) NSArray  *cards;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) WSPlayer *winner;
@property (nonatomic, assign) NSInteger score;

- (BOOL)trickContainsValue:(WSCardValue)value ofSuit:(WSCardSuit)suit;
- (NSMutableArray *)sortedCardsWithSuit:(WSCardSuit)suit;
- (WSRoemType)roemInTrick;

@end


@implementation WSTrick

@synthesize cards   = _cards;
@synthesize size    = _size;
@synthesize winner  = _winner;
@synthesize topCard = _topCard;
@synthesize score   = _score;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.cards = [NSArray array];
        self.score = 0;
    }
    return self;
}

+ (WSTrick *)trickWithSize:(NSInteger)size
{
    WSTrick *trick = [[WSTrick alloc] init];
    if (trick)
    {
        trick.size = size;
    }
    return trick;
}

- (NSString *)description
{
    return [_cards componentsJoinedByString:@"\t"];
}

#pragma mark - Public instance methods

- (BOOL)addCard:(WSCard *)card
{
    BOOL success = NO;
    
    DLog(@"card count: %d", _cards.count);
    
    if (_cards.count < _size)
    {        
        self.cards = [_cards arrayByAddingObject:card];   
        self.score += card.pointValue;
        
        WSPlayer *player = card.owner;        
        success = [player removeCardFromHand:card];
        
        
        // if the current card is the "strongest" card in the trick, make the 
        //  owner of the card the current winner ...
        
        NSArray *sortedCards = [_cards sortedArrayUsingSelector:@selector(compare:)];
        if ([sortedCards objectAtIndex:0] == card)
        {
            self.winner = player;
        }        
    }
    
        
    if (_cards.count == _size)
    {
        // last trick gets 10 bonus points ...
        
        NSUInteger maxRounds  = [WSGameBoard sharedGameBoard].maxRounds;
        NSUInteger roundIndex = [WSGameBoard sharedGameBoard].roundIndex;
        BOOL isLastRound      = roundIndex == (maxRounds - 1);
        
        if (isLastRound)
        {
            self.score += 10;
        }
        
        
        // check for other bonus points, e.g. 'roem', e.g.:
        // - 7, 8, 9, 10
        // - J, Q, K, A
        
        for (WSCard *card in _cards)
        {
        
        }
        
        [self roemInTrick];
    }
    
    return success;
}

- (WSRoemType)roemInTrick
{
    WSRoemType roem = WSRoemTypeNone;
    
    NSArray *cards = [NSArray array];
    
    NSMutableArray *hearts = [self sortedCardsWithSuit:WSCardSuitHearts];    
    cards = [cards arrayByAddingObjectsFromArray:hearts];

    NSMutableArray *spades = [self sortedCardsWithSuit:WSCardSuitSpades];
    cards = [cards arrayByAddingObjectsFromArray:spades];
    
    NSMutableArray *clubs = [self sortedCardsWithSuit:WSCardSuitClubs];
    cards = [cards arrayByAddingObjectsFromArray:clubs];
        
    NSMutableArray *diamonds = [self sortedCardsWithSuit:WSCardSuitDiamonds];
    cards = [cards arrayByAddingObjectsFromArray:diamonds];
    
    DLog(@"%@", cards);
    
    WSCard *card = [cards objectAtIndex:0];
    WSCardSuit currentSuit   = card.suit;
    WSCardSuit previousValue = card.value;
    NSInteger counter = 1;
    
    for (int i = 1; i < cards.count; i++)
    {
        card = [cards objectAtIndex:i];
        if (card.suit == currentSuit)
        {
            if (card.value - previousValue == 1)
            {
                counter++;            
            }
            else 
            {
                counter = 1;
            }
            
            if (counter == 4)
            {
                roem = WSRoemTypeFourCardsSameSuit;
            }
            else if (counter == 3)
            {
                roem = WSRoemTypeThreeCardsSameSuit;
            }
            
            previousValue = card.value;
        }
        else
        {
            counter = 1;
            currentSuit = card.suit;
            previousValue = card.value;
        }
    }
    
    for (card in cards)
    {
        if (card.suit == currentSuit)
        {
        
        }
    }
    
    /*
     TODO: calculate if other roem types are part of this trick ...
     */
    
    return roem;
}

- (NSMutableArray *)sortedCardsWithSuit:(WSCardSuit)suit
{
    NSMutableArray *cards = [NSMutableArray array];
    for (WSCard *card in _cards)
    {
        if (card.suit == suit)
        {
            [cards addObject:card];
        }
    }    
    
    [cards sortUsingComparator:^ (WSCard *card1, WSCard *card2) {
        if (card1.value < card2.value) return NSOrderedAscending;
        else if (card1.value > card2.value) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    return cards;
}

#pragma mark - Private instance methods

- (BOOL)trickContainsValue:(WSCardValue)value ofSuit:(WSCardSuit)suit
{
    BOOL hasCard = NO;
    
    for (WSCard *card in _cards)
    {
        if (card.value == value && card.suit == suit)
        {
            hasCard = YES;
            break;
        }
    }
    
    return hasCard;
}

#pragma mark - Properties

- (WSCard *)topCard
{
    WSCard *topCard = nil;
    
    if (_cards.count > 0)
    {
        topCard = [_cards objectAtIndex:0];
    }
    
    return topCard;
}

@end
