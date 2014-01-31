//
//  WSTrick.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/14/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WSCard;
@class WSPlayer;


typedef enum {
    WSRoemTypeNone = 0,
    WSRoemTypeThreeCardsSameSuit,                       // 20 points
    WSRoemTypeFourCardsSameSuit,                        // 50 points
    WSRoemTypeThreeCardsSameSuitWithKingQueenOfTrumps,  // 40 points
    WSRoemTypeFourCardsSameSuitWithKingQueenOfTrumps,   // 70 points
    WSRoemTypeFourKings,                                // 100 points
    WSRoemTypeFourQueens,                               // 100 points
    WSRoemTypeFourAces,                                 // 100 points
    WSRoemTypeFourTens,                                 // 100 points
    WSRoemTypeFourJacks,                                // 200 points
    WSRoemTypeTrumpQueenKing,                           // 20 points, "stuk"
} WSRoemType;


@interface WSTrick : NSObject

+ (WSTrick *)trickWithSize:(NSInteger)size;
- (BOOL)addCard:(WSCard *)card;

@property (nonatomic, strong, readonly) WSCard   *topCard;
@property (nonatomic, strong, readonly) WSPlayer *winner;
@property (nonatomic, strong, readonly) NSArray  *cards;
@property (nonatomic, assign, readonly) NSInteger size;
@property (nonatomic, assign, readonly) NSInteger score;

@end
