//
//  WSGameBoard.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/1/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSCard.h"


@class WSTrick;


@interface WSGameBoard : UIViewController

+ (WSGameBoard *)sharedGameBoard;
- (void)newGame;

@property (nonatomic, strong, readonly) NSArray   *players;
@property (nonatomic, strong, readonly) WSTrick   *currentTrick;
@property (nonatomic, strong, readonly) WSPlayer  *currentPlayer;
@property (nonatomic, assign, readonly) WSCardSuit trumpSuit;
@property (nonatomic, assign, readonly) WSPlayer  *thePlayer; // the player behind this device ...
@property (nonatomic, assign, readonly) NSUInteger roundIndex;
@property (nonatomic, assign, readonly) NSUInteger maxRounds;

@end
