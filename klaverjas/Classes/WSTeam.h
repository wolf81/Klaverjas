//
//  WSTeam.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/26/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSTrick.h"
#import "WSPlayer.h"


@interface WSTeam : NSObject

@property (nonatomic, strong, readonly) NSArray  *tricks;
@property (nonatomic, strong, readonly) NSArray  *players;
@property (nonatomic, assign, readonly) NSInteger score;

+ (WSTeam *)teamWithPlayer:(WSPlayer *)firstPlayer otherPlayer:(WSPlayer *)secondPlayer;
- (void)addTrick:(WSTrick *)trick;

@end
