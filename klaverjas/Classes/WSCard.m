//
//  WSCard.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/1/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import "WSCard.h"
#import "WSGameBoard.h"
#import "WSPlayer.h"
#import "WSTrick.h"


@interface WSCard ()

@property (nonatomic, assign) WSCardSuit  suit;
@property (nonatomic, assign) WSCardValue value;
@property (nonatomic, strong) UIImage    *image;
@property (nonatomic, strong) NSString   *valueString;
@property (nonatomic, assign) BOOL        frontDisplayed;

- (BOOL)isPlayerActive;
- (BOOL)validCardPlayed;

@end


@implementation WSCard

@synthesize suit           = _suit;
@synthesize value          = _value;
@synthesize image          = _image;
@synthesize valueString    = _valueString;
@synthesize owner          = _owner;
@synthesize frontDisplayed = _frontDisplayed;
@synthesize pointValue     = _pointValue;
@synthesize initalFrame    = _initalFrame;
@synthesize weight         = _weight;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, 30.0f, 36.0f);
    }
    return self;
}

+ (WSCard *)cardWithSuit:(WSCardSuit)suit value:(WSCardValue)value
{
    WSCard *card = [[WSCard alloc] init];
    if (card)
    {
        card.suit  = suit;
        card.value = value;
        card.image = [WSCard imageForSuit:suit];
    }
    return card;
}

- (NSString *)description
{
    NSString *string = [NSString string];
    
    switch (self.suit) 
    {
        case WSCardSuitClubs:    string = [string stringByAppendingString:@"c."]; break;
        case WSCardSuitSpades:   string = [string stringByAppendingString:@"s."]; break;
        case WSCardSuitHearts:   string = [string stringByAppendingString:@"h."]; break;
        case WSCardSuitDiamonds: string = [string stringByAppendingString:@"d."]; break;
        default: break;
    }
    
    switch (self.value) 
    {
        case WSCardValue7:     string = [string stringByAppendingString:@"7"];  break;
        case WSCardValue8:     string = [string stringByAppendingString:@"8"];  break;
        case WSCardValue9:     string = [string stringByAppendingString:@"9"];  break;
        case WSCardValue10:    string = [string stringByAppendingString:@"10"]; break;
        case WSCardValueAce:   string = [string stringByAppendingString:@"A"];  break;
        case WSCardValueJack:  string = [string stringByAppendingString:@"J"];  break;
        case WSCardValueKing:  string = [string stringByAppendingString:@"K"];  break;
        case WSCardValueQueen: string = [string stringByAppendingString:@"Q"];  break;
        default:               string = [string stringByAppendingFormat:@"%d", self.value]; break;
    }
    
    return string;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    if (_frontDisplayed)
    {
        [[UIColor blackColor] set];
        
        CGRect frame       = self.bounds;
        frame.size.height -= 10.0f;
        frame.origin.y    += 10.0f;
        
        CGSize image_size = _image.size;
        CGFloat factor    = frame.size.height / image_size.height; 
        CGFloat width     = image_size.width * factor;
        
        frame.origin.x   = (int)((frame.size.width - width) / 2);
        frame.size.width = width;
        
        [_image drawInRect:frame];
        
        UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
        [self.valueString drawInRect:self.bounds withFont:font];
    }
    else 
    {
        [_image drawInRect:self.bounds];
    }
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isPlayerActive] == NO)
    {
        return;
    }

    [super touchesBegan:touches withEvent:event];    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isPlayerActive] == NO)
    {
        return;
    }

    [super touchesMoved:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self.superview];
    self.center    = point;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isPlayerActive] == NO)
    {
        return;
    }
    
    [super touchesEnded:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self.superview];

    CGPoint center = self.superview.center;
    
    
#define CENTER_RECT_SIZE 60.0f
    
    CGFloat x = center.x - CENTER_RECT_SIZE;
    CGFloat y = center.y - CENTER_RECT_SIZE;
    CGFloat width = CENTER_RECT_SIZE * 2;
    CGFloat height = CENTER_RECT_SIZE * 2;
    CGRect centerRect = CGRectMake(x, y, width, height);
    
    
    if (CGRectContainsPoint(centerRect, point))
    {
        // validate played card ...

        if ([self validCardPlayed] == NO)
        {
            [UIView animateWithDuration:0.3f animations:^ {
                
                self.frame = _initalFrame;
                
            }];
            
            return;
        }

        // confirm played card ...
        
        if ([self.owner conformsToProtocol:@protocol(WSCardDelegate)])
        {
            [self.owner cardPlayed:self];
        }
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^ {
            
            self.frame = _initalFrame;
            
        }];
    }
    
    
    DLog(@"%@", self);
}

#pragma mark - Properties

- (NSInteger)pointValue
{
    NSInteger pointValue = 0;

    WSCardSuit trumpSuit = [WSGameBoard sharedGameBoard].trumpSuit;    
    BOOL isTrumpSuit     = (self.suit == trumpSuit);
    
    switch (self.value)
    {
        case WSCardValue7:     pointValue = 0; break;
        case WSCardValue8:     pointValue = 0; break;
        case WSCardValue9:     pointValue = isTrumpSuit ? 14 : 0; break;
        case WSCardValue10:    pointValue = 10; break;
        case WSCardValueJack:  pointValue = isTrumpSuit ? 20 : 2; break;
        case WSCardValueQueen: pointValue = 3; break;
        case WSCardValueKing:  pointValue = 4; break;
        case WSCardValueAce:   pointValue = 11; break;
        default: break;
    }
    
    return pointValue;
}

- (NSString *)valueString
{
    NSString *valueString = @"";
    
    switch (self.value)
    {
        case WSCardValueAce:   valueString = @"A"; break;
        case WSCardValueKing:  valueString = @"K"; break;
        case WSCardValueQueen: valueString = @"Q"; break;
        case WSCardValueJack:  valueString = @"J"; break;
        default: valueString = [NSString stringWithFormat:@"%d", self.value]; break;
    }
    
    return valueString;
}

- (NSInteger)weight
{
    NSInteger weight = 0;

    WSCardSuit trumpSuit = [WSGameBoard sharedGameBoard].trumpSuit;
    WSCard    *topCard   = [[WSGameBoard sharedGameBoard].currentTrick.cards objectAtIndex:0];
    WSCardSuit trickSuit = topCard.suit;
        
    if (self.suit == trumpSuit)
    {
        weight += 20;
        
        switch (self.value)
        {
            case WSCardValue7:     weight += 1; break;
            case WSCardValue8:     weight += 2; break;
            case WSCardValueQueen: weight += 3; break;
            case WSCardValueKing:  weight += 4; break;
            case WSCardValue10:    weight += 5; break;
            case WSCardValueAce:   weight += 6; break;
            case WSCardValue9:     weight += 7; break;
            case WSCardValueJack:  weight += 8; break;
            default: break;
        }
    }
    else 
    {
        weight += (self.suit == trickSuit) ? 10 : 0;
        
        switch (self.value)
        {
            case WSCardValue7:     weight += 1; break;
            case WSCardValue8:     weight += 2; break;
            case WSCardValue9:     weight += 3; break;
            case WSCardValueJack:  weight += 4; break;
            case WSCardValueQueen: weight += 5; break;
            case WSCardValueKing:  weight += 6; break;
            case WSCardValue10:    weight += 7; break;
            case WSCardValueAce:   weight += 8; break;
            default: break;
        }    
    }
    
    return weight;
}

#pragma mark - Public instance methods

- (NSString *)suitString
{
    NSString *suitString = nil;
    
    switch (_suit) 
    {
        case WSCardSuitClubs:    suitString = @"Clubs";    break;
        case WSCardSuitDiamonds: suitString = @"Diamonds"; break;
        case WSCardSuitHearts:   suitString = @"Hearts";   break;
        case WSCardSuitSpades:   suitString = @"Spades";   break;
        default: break;
    }
    
    return suitString;
}

- (void)displayFront
{
    self.frontDisplayed = YES;

    self.image = [WSCard imageForSuit:self.suit];
        
    [self setNeedsDisplay];
}

- (void)displayBack
{
    self.frontDisplayed = NO;
    
    self.image = [UIImage imageNamed:@"card_back.png"];
    
    [self setNeedsDisplay];
}

- (NSComparisonResult)compare:(WSCard *)otherCard
{
    if (self.weight > otherCard.weight)
    {
        return NSOrderedAscending;
    }
    else if (self.weight < otherCard.weight)
    {
        return NSOrderedDescending;
    }
    else // should never happen, as every card is unique ...
    {
        return NSOrderedSame;
    }
}

#pragma mark - Public class methods

+ (UIImage *)imageForSuit:(WSCardSuit)suit
{
    UIImage *image = nil;
    
    switch (suit) 
    {
        case WSCardSuitClubs:    image = [UIImage imageNamed:@"clubs.png"];    break;
        case WSCardSuitDiamonds: image = [UIImage imageNamed:@"diamonds.png"]; break;
        case WSCardSuitHearts:   image = [UIImage imageNamed:@"hearts.png"];   break;
        case WSCardSuitSpades:   image = [UIImage imageNamed:@"spades.png"];   break;
        default: break;
    }
    
    return image;
}

#pragma mark - Private instance methods

- (BOOL)isPlayerActive
{
    return (_owner == [WSGameBoard sharedGameBoard].thePlayer && _owner.isActive);
}

- (BOOL)validCardPlayed
{
    __block BOOL validated = YES;
    
    NSArray *hand  = self.owner.hand;
    WSTrick *trick = [WSGameBoard sharedGameBoard].currentTrick;
    
    WSCard *topCard = trick.topCard;
    
    if (topCard)
    {
        WSCardSuit trickSuit  = topCard.suit;
        BOOL didPlayTrickSuit = (self.suit == trickSuit);
        
        if (!didPlayTrickSuit)
        {
            // make sure our hand doesn't contain cards of same suit as trickSuit ...

            [hand enumerateObjectsUsingBlock:^ (WSCard *card, NSUInteger idx, BOOL *stop) {
           
                if (card.suit == topCard.suit)
                {
                    DLog(@"%@ - %@", card, topCard);
                    
                    validated = NO;
                }
                
            }];
        }
    }
    
    return validated;
}

@end
