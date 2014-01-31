//
//  WSCard.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/1/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WSPlayer;


typedef enum 
{
    WSCardValue7 = 7,
    WSCardValue8,
    WSCardValue9,
    WSCardValue10,
    WSCardValueJack,
    WSCardValueQueen,
    WSCardValueKing,
    WSCardValueAce,
} WSCardValue;


typedef enum 
{
    WSCardSuitDiamonds = 0,
    WSCardSuitSpades,
    WSCardSuitHearts,
    WSCardSuitClubs,
} WSCardSuit;


@interface WSCard : UIView

+ (WSCard *)cardWithSuit:(WSCardSuit)suit value:(WSCardValue)value;
+ (UIImage *)imageForSuit:(WSCardSuit)suit;

- (void)displayFront;
- (void)displayBack;
- (NSString *)suitString;

@property (nonatomic, assign, readonly) WSCardSuit  suit;
@property (nonatomic, assign, readonly) WSCardValue value;
@property (nonatomic, assign)           WSPlayer   *owner; // will be the card delegate
@property (nonatomic, assign)           CGRect      initalFrame;
@property (nonatomic, assign, readonly) NSInteger   pointValue;
@property (nonatomic, assign, readonly) NSInteger   weight; // how "strong" the card is compared to other cards ...

@end


@protocol WSCardDelegate <NSObject>

- (void)cardPlayed:(WSCard *)card;

@end