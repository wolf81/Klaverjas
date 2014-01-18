//
//  WSPlayer.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/1/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSCard.h"


typedef enum {
    WSPlayerKindComputer = 0,
    WSPlayerKindHuman,
} WSPlayerKind;


@interface WSPlayer : NSObject <WSCardDelegate>

+ (WSPlayer *)playerWithName:(NSString *)name kind:(WSPlayerKind)kind;

- (void)playCardWithPlayedCards:(NSArray *)playedCards trumpSuit:(WSCardSuit)trumpSuit completionHandler:(void (^)(WSCard *))playCardHandler;
- (void)acceptTrumpSuit:(WSCardSuit)trumpSuit withCompletionHandler:(void (^)(BOOL))acceptTrumpsHandler;
- (BOOL)removeCardFromHand:(WSCard *)card;

@property (nonatomic, copy)             NSArray      *hand;
@property (nonatomic, copy, readonly)   NSString     *name;
@property (nonatomic, assign, readonly) WSPlayerKind  kind;
@property (nonatomic, assign)           BOOL          isActive;

@end
