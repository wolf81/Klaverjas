//
//  WSTeam.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/26/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "WSTeam.h"


@interface WSTeam ()

@property (nonatomic, strong) NSArray  *tricks;
@property (nonatomic, strong) NSArray  *players;
@property (nonatomic, assign) NSInteger score;

@end


@implementation WSTeam

@synthesize tricks  = _tricks;
@synthesize players = _players;
@synthesize score   = _score;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tricks  = [NSArray array];
        self.players = [NSArray array];
        self.score   = 0;
    }
    return self;
}

+ (WSTeam *)teamWithPlayer:(WSPlayer *)firstPlayer otherPlayer:(WSPlayer *)secondPlayer
{
    WSTeam *team = [[WSTeam alloc] init];
    if (team)
    {
        team.players = [NSArray arrayWithObjects:firstPlayer, secondPlayer, nil];
    }
    return team;
}

#pragma mark - Public instance methods

- (void)addTrick:(WSTrick *)trick
{
    DLog(@"adding trick to team with players: %@", _players);
    
    self.tricks = [_tricks arrayByAddingObject:trick];
    self.score += trick.score;
    
    DLog(@"current score: %d", [self score]);
}

@end
