//
//  WSGameBoard.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/1/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "WSGameBoard.h"
#import "WSPlayer.h"
#import "WSTrick.h"
#import "WSDeck.h"
#import "WSTeam.h"
#import "NSMutableArray+Shuffle.h"
#import "WSStatusView.h"
#import "WSBoardView.h"
#import "WSChooseTrumpsView.h"
#import "WSMessageView.h"
#import <GameKit/GameKit.h>


#define NUMBER_OF_CARDS 32


#define PLAYER_TOP    0
#define PLAYER_RIGHT  1
#define PLAYER_BOTTOM 2
#define PLAYER_LEFT   3


@interface WSGameBoard () <GKMatchmakerViewControllerDelegate, GKMatchDelegate>

@property (nonatomic, strong) NSArray       *players;
@property (nonatomic, strong) WSPlayer      *currentPlayer;
@property (nonatomic, strong) WSTrick       *currentTrick;
@property (nonatomic, assign) WSCardSuit     trumpSuit;
@property (nonatomic, strong) NSArray       *teams;

@property (nonatomic, strong) WSMessageView *messageView;
@property (nonatomic, strong) WSStatusView  *statusView;
@property (nonatomic, strong) WSBoardView   *gameView;
@property (nonatomic, assign) NSUInteger     roundIndex;
@property (nonatomic, assign) NSUInteger     maxRounds;

@property (nonatomic, strong) GKMatch       *currentMatch;
@property (nonatomic, assign) BOOL           matchStarted;

- (void)dealCards;
- (void)playRound:(int)round;
- (WSCardSuit)chooseTrumps;
- (WSPlayer *)nextPlayer;
- (void)moveCardToCenter:(WSCard *)card;
- (void)turnCard:(WSCard *)card;
- (void)moveCards:(NSArray *)cards toPlayer:(WSPlayer *)player;
- (void)addCardsToBoard;
- (void)retrieveFriends;
- (void)loadPlayerData:(NSArray *)identifiers;
- (void)hostMatch;

@end


@implementation WSGameBoard

@synthesize teams         = _teams;
@synthesize players       = _players;
@synthesize currentPlayer = _currentPlayer;
@synthesize trumpSuit     = _trumpSuit;
@synthesize currentTrick  = _currentTrick;
@synthesize messageView   = _messageView;
@synthesize statusView    = _statusView;
@synthesize gameView      = _gameView;
@synthesize thePlayer     = _thePlayer;
@synthesize roundIndex    = _roundIndex;
@synthesize maxRounds     = _maxRounds;

@synthesize currentMatch  = _currentMatch;
@synthesize matchStarted  = _matchStarted;

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    self.view.backgroundColor = [UIColor greenColor];
    
    const CGRect bounds = self.view.bounds;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.center = CGPointMake(bounds.size.width - 20.0f, bounds.origin.y + 20.0f);
    [self.view addSubview:infoButton];    
    
    self.statusView = [[WSStatusView alloc] init];
    _statusView.center = CGPointMake(bounds.size.width / 2, bounds.size.height - (_statusView.frame.size.height / 2));
    [self.view addSubview:_statusView];    
    
    self.messageView = [[WSMessageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bounds.size.width, 40.0f)];
    [self.view addSubview:_messageView];
    
    CGFloat y = _messageView.frame.origin.y + _messageView.frame.size.height;
    CGFloat height = bounds.size.height - _statusView.frame.size.height - _messageView.frame.size.height;
    CGRect frame = CGRectMake(0.0f, y, bounds.size.width, height);
    self.gameView = [[WSBoardView alloc] initWithFrame:frame];
    [self.view addSubview:_gameView];    


    [self newGame];
    
    /*
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^ (NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            
            
            [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
                // Insert application-specific code here to clean up any games in progress.
                if (acceptedInvite)
                {
                    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite];
                    mmvc.matchmakerDelegate = self;
                    [self presentModalViewController:mmvc animated:YES];
                }
                else if (playersToInvite)
                {
                    GKMatchRequest *request = [[GKMatchRequest alloc] init];
                    request.minPlayers = 2;
                    request.maxPlayers = 4;
                    request.playersToInvite = playersToInvite;
                    
                    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
                    mmvc.matchmakerDelegate = self;
                    [self presentModalViewController:mmvc animated:YES];
                }
            };
            
            
            
            // Perform additional tasks for the authenticated player.
            
            [self retrieveFriends];
            
            [self hostMatch];            
        }
        else
        {
            // TODO: handle error ...
            
            DLog(@"%@", error);
        }
    }];  
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}

#pragma mark - Public instance methods

+ (WSGameBoard *)sharedGameBoard
{
    static WSGameBoard *gameBoard;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameBoard = [[WSGameBoard alloc] init];
    });
    
    return gameBoard;
}

- (void)newGame
{
    dispatch_queue_t gameQueue = dispatch_queue_create("com.felis.klaverjas.main", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(gameQueue, ^ {
        
        // TODO: let player choose between 3 or 4 player game, for now we just create a 4 player game
        
        WSPlayer *player1 = [WSPlayer playerWithName:@"Al   " kind:WSPlayerKindComputer];
        WSPlayer *player2 = [WSPlayer playerWithName:@"Bill " kind:WSPlayerKindComputer];
        WSPlayer *player3 = [WSPlayer playerWithName:@"Carol" kind:WSPlayerKindHuman];
        WSPlayer *player4 = [WSPlayer playerWithName:@"Dee  " kind:WSPlayerKindComputer];
        
        self.players = [NSArray arrayWithObjects:player1, player2, player3, player4, nil];
        
        
        // in case of 3 player game, either have 3 teams or no teams at all ...
        
        WSTeam *team1 = [WSTeam teamWithPlayer:player1 otherPlayer:player3];
        WSTeam *team2 = [WSTeam teamWithPlayer:player2 otherPlayer:player4];
        
        self.teams = [NSArray arrayWithObjects:team1, team2, nil];
        
        
        
        [self dealCards];
        
        
        
        self.trumpSuit = [self chooseTrumps];
        
        UIImage *trumpImage = [WSCard imageForSuit:_trumpSuit];        
        [_statusView updateTrumpImage:trumpImage];
        
        
        
        // play 8 rounds (when with 4 players) or 10 rounds in case or 3 players ...
        
        self.maxRounds = NUMBER_OF_CARDS / _players.count;
        for (int i = 0; i < _maxRounds; i++)
        {
            [self playRound:(i + 1)];
            [NSThread sleepForTimeInterval:1.0f];
        }
        
    });    
}

#pragma mark - Properties

- (WSPlayer *)thePlayer
{    
    return (_players.count >= 3) ? [_players objectAtIndex:PLAYER_BOTTOM] : nil;
}

- (WSPlayer *)currentPlayer
{
    if (!_currentPlayer && _players.count > 0)
    {
        _currentPlayer = [_players objectAtIndex:0];
    }
    
    return _currentPlayer;
}

#pragma mark - Private instance methods

- (void)dealCards
{
    WSDeck *deck = [WSDeck deck];
    [deck shuffle];
    
    
    // in klaverjas we deal cards in the order 3-2-3 to each player ...
    
    for (WSPlayer *player in _players)
    {
        WSCard *card1 = [deck dealCard];    
        card1.owner = player;
        
        WSCard *card2 = [deck dealCard];
        card2.owner = player;
        
        WSCard *card3 = [deck dealCard];
        card3.owner = player;
        
        NSArray *cards = [NSArray arrayWithObjects:card1, card2, card3, nil];
        player.hand = [player.hand arrayByAddingObjectsFromArray:cards];
    }
    
    DLog(@"%d", deck.size);
    
    
    for (WSPlayer *player in _players)
    {
        WSCard *card1 = [deck dealCard];
        card1.owner = player;
        
        WSCard *card2 = [deck dealCard];
        card2.owner = player;
        
        NSArray *cards = [NSArray arrayWithObjects:card1, card2, nil];
        player.hand = [player.hand arrayByAddingObjectsFromArray:cards];
    }
    
    DLog(@"%d", deck.size);
    
    
    for (WSPlayer *player in _players)
    {   
        WSCard *card1 = [deck dealCard];
        card1.owner = player;
        
        WSCard *card2 = [deck dealCard];
        card2.owner = player;
        
        WSCard *card3 = [deck dealCard];
        card3.owner = player;
        
        NSArray *cards = [NSArray arrayWithObjects:card1, card2, card3, nil];
        player.hand = [player.hand arrayByAddingObjectsFromArray:cards];
    }
    
    DLog(@"%d", deck.size);    
    
    
    [self addCardsToBoard];    
}

- (void)playRound:(int)round
{        
    self.roundIndex = round;

    [_statusView updateRound:round];
    
    self.currentTrick = [WSTrick trickWithSize:4];
    
    // current player is player that won last round ...
    
    for (int i = 0; i < _players.count; i++)
    {
        
        // a semaphore is used to prevent execution until the asynchronous task is completed ...
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        
        // player chooses a card - once card is chosen, animate choice by moving card to center of board ...
        
        [self.currentPlayer playCardWithPlayedCards:_currentTrick.cards trumpSuit:_trumpSuit completionHandler:^ (WSCard *card) {
            
            BOOL success = [self.currentTrick addCard:card];
            
            DLog(@"did add card to trick? %@", success ? @"YES" : @"NO");
            
            NSString *message = [NSString stringWithFormat:@"Card played by %@", _currentPlayer.name];
            [_messageView setMessage:message];
            
            [self turnCard:card];
            [self moveCardToCenter:card];
                    
            
            // send a signal that indicates that this asynchronous task is completed ...
            
            dispatch_semaphore_signal(sema);
            
            DLog(@"<<< signal dispatched >>>");
        }];
        
        
        // execution is halted, until a signal is received from another thread ...

        DLog(@"<<< wait for signal >>>");
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
        

        DLog(@"<<< signal received >>>");
        
        
        self.currentPlayer = self.nextPlayer;
    }
    
    
    // determine winner ...
    
    WSPlayer *winner = _currentTrick.winner;
    
    
    // add trick to team from winner ...
    
    for (WSTeam *team in _teams)
    {
        [team.players enumerateObjectsUsingBlock:^ (WSPlayer *player, NSUInteger idx, BOOL *stop) {
        
            if (player == winner)
            {
                *stop = YES;
                [team addTrick:_currentTrick];                
            }
        }];
    }
    
    
    // update score display for both teams ...
    
    if (_teams.count == 2)
    {
        WSTeam *team1 = [_teams objectAtIndex:0];
        [_statusView updateTeam1Score:team1.score];
        
        WSTeam *team2 = [_teams objectAtIndex:1];
        [_statusView updateTeam2Score:team2.score];
     }
    
    
    // remove played cards from board ...
    
    [NSThread sleepForTimeInterval:1.0f];
        
    [self moveCards:_currentTrick.cards toPlayer:winner];
    
    
    // TODO if all cards have been played, show winner, otherwise the winning player may start next round ...
    
    // the winning player may start next round ...
    
    self.currentPlayer = winner;
}

- (WSPlayer *)nextPlayer
{
    WSPlayer *nextPlayer = nil;
    
    switch (_players.count)
    {
        case 0: nextPlayer = nil;                break;
        case 1: nextPlayer = self.currentPlayer; break;
        default: 
        {
            NSUInteger playerIndex = [_players indexOfObject:self.currentPlayer];
            nextPlayer = (++playerIndex < _players.count) ? [_players objectAtIndex:playerIndex] : [_players objectAtIndex:0];
            break;
        }
    }
    
    return nextPlayer;
}

- (WSCardSuit)chooseTrumps
{
    __block WSCardSuit trumpSuit = WSCardSuitSpades;
    
    WSCard *cardClubs    = [WSCard cardWithSuit:WSCardSuitClubs    value:WSCardValueAce];
    WSCard *cardSpades   = [WSCard cardWithSuit:WSCardSuitSpades   value:WSCardValueAce];
    WSCard *cardHearts   = [WSCard cardWithSuit:WSCardSuitHearts   value:WSCardValueAce];
    WSCard *cardDiamonds = [WSCard cardWithSuit:WSCardSuitDiamonds value:WSCardValueAce];
    
    NSMutableArray *trumpCards = [NSMutableArray arrayWithObjects:cardClubs, cardSpades, cardHearts, cardDiamonds, nil];
    
    
    __block BOOL trumpAccepted = NO;
    
    while (trumpAccepted == NO)
    {
        [trumpCards shuffle];
        
        
        // if trumps is rejected for all kinds by all players, reshuffle and deal cards again ...
        
                
        [trumpCards enumerateObjectsUsingBlock:^ (WSCard *trumpCard, NSUInteger idx, BOOL *stop) {
        
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            
            for (int i = 0; i < _players.count; i++)
            {
                
                [self.currentPlayer acceptTrumpSuit:trumpCard.suit withCompletionHandler:^ (BOOL accepted) {
                    
                    trumpAccepted = accepted;
                    
                    if (accepted)
                    {
                        DLog(@"%@ - accepted trumps: %@", _currentPlayer, trumpCard);

                        NSString *suitString = [trumpCard suitString];
                        NSString *message = [NSString stringWithFormat:@"%@ accepted trump kind %@", _currentPlayer.name, suitString];
                        [_messageView setMessage:message];
                    }
                    else
                    {
                        DLog(@"%@ - didn't accept trumps: %@", _currentPlayer, trumpCard);

                        NSString *suitString = [trumpCard suitString];
                        NSString *message = [NSString stringWithFormat:@"%@ did not accept trump kind %@", _currentPlayer.name, suitString];
                        [_messageView setMessage:message];
                    }
                    
                    
                    dispatch_semaphore_signal(sema);                
                }];
                
                
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                
                
                if (trumpAccepted)
                {
                    trumpSuit = trumpCard.suit;
                    break;
                }
                else
                {
                    [NSThread sleepForTimeInterval:1.0f];
                    
                    self.currentPlayer = [self nextPlayer];                
                }                
            }            
        
            *stop = trumpAccepted; 
        }];
        
    }

    
    return trumpSuit;
}

- (void)turnCard:(WSCard *)card
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        [card displayFront];
        
    });
}

- (void)moveCardToCenter:(WSCard *)card
{
    CGRect frame   = _gameView.bounds;
    CGPoint center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    
    
#define SPACING 35.0f
    
    NSUInteger playerIndex = [_players indexOfObject:_currentPlayer];
    switch (playerIndex) 
    {
        case PLAYER_TOP:    center.y -= SPACING; break;
        case PLAYER_RIGHT:  center.x += SPACING; break;
        case PLAYER_BOTTOM: center.y += SPACING; break;
        case PLAYER_LEFT:   center.x -= SPACING; break;
        default: break;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        [self.view bringSubviewToFront:card];
        
        [UIView animateWithDuration:0.3f animations:^ {
            
            card.center = center;   
            
        }];
    });
}

- (void)addCardsToBoard
{
    dispatch_async(dispatch_get_main_queue(), ^ {
    
        [_players enumerateObjectsUsingBlock:^ (WSPlayer *player, NSUInteger idx, BOOL *stop) {
            
            const CGRect bounds = _gameView.bounds;
            
            CGFloat x, y;
            
            switch (idx)
            {
                case PLAYER_TOP:    x = bounds.size.width / 2,  y = 10.0f;  break;
                case PLAYER_RIGHT:  x = 280.0f, y = bounds.size.height / 2;  break;
                case PLAYER_BOTTOM: x = 19.0f,  y = 300.0f; break;
                case PLAYER_LEFT:   x = 10.0f,  y = bounds.size.height / 2;  break;
                default: break;
            }
            
            for (WSCard *card in player.hand)
            {
                CGFloat mod_x = (idx == PLAYER_TOP) ? card.frame.size.width / 2 : 0.0f;
                CGFloat mod_y = (idx == PLAYER_LEFT || idx == PLAYER_RIGHT) ? card.frame.size.height / 2 : 0.0f;
                
                CGRect frame     = card.frame;
                frame.origin     = CGPointMake(x - mod_x, y - mod_y);
                card.frame       = frame;
                card.initalFrame = frame;
                
                idx != PLAYER_BOTTOM ? [card displayBack] : [card displayFront];            
                
                [_gameView addSubview:card];
                
                if (idx == PLAYER_BOTTOM)
                {
                    x += (idx == 0 || idx == 2) ? 36.0f : 0.0f;
                    y += (idx == 0 || idx == 2) ? 0.0f  : 41.0f;
                }
            }
        }];    
        
    });
}

- (void)moveCards:(NSArray *)cards toPlayer:(WSPlayer *)player
{
    
#define PADDING 20.0f
    
    const CGRect bounds  = _gameView.bounds;
    const CGFloat width  = bounds.size.width;
    const CGFloat height = bounds.size.height;
    CGPoint point        = CGPointZero;
    
    switch ([_players indexOfObject:player]) 
    {
        case PLAYER_TOP:    point = CGPointMake(width / 2, 0.0f - PADDING);   break;
        case PLAYER_RIGHT:  point = CGPointMake(width + PADDING, height / 2); break;
        case PLAYER_BOTTOM: point = CGPointMake(width / 2, height + PADDING); break;
        case PLAYER_LEFT:   point = CGPointMake(0.0f - PADDING, height / 2);  break;
        default: break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        for (WSCard *card in cards)
        {   
            [UIView animateWithDuration:0.3f animations:^ {       
                
                card.center = point;
                
            } completion:^ (BOOL finished) {
                
                [card removeFromSuperview];
                
            }];
        }
    });

}

#pragma mark - Game center

- (void)retrieveFriends
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (localPlayer.authenticated)
    {
        [localPlayer loadFriendsWithCompletionHandler:^ (NSArray *friends, NSError *error) {
            if (friends != nil)
            {
                [self loadPlayerData: friends];
            }
        }];
    }
}

- (void)loadPlayerData:(NSArray *)identifiers
{
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^ (NSArray *players, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        if (players != nil)
        {
            // Process the array of GKPlayer objects.
            
            for (GKPlayer *player in players)
            {
                DLog(@"%@", player.alias);
            }
        }
        
        // TODO: if there are no friend, offer a game against the computer or tutorial?
    }];
}

- (void)hostMatch;
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    
    [self presentModalViewController:mmvc animated:YES];
}

#pragma mark - 

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    DLog(@"%@", error);
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [self dismissModalViewControllerAnimated:YES];

    self.currentMatch = match; // Use a retaining property to retain the match.
    match.delegate    = self;
    
    if (!self.matchStarted && match.expectedPlayerCount == 0)
    {
        self.matchStarted = YES;
        // Insert application-specific code to begin the match.
        
        [self newGame];
    }    
}

// Players have been found for a server-hosted game, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindPlayers:(NSArray *)playerIDs
{
    [self newGame];
}

// An invited player has accepted a hosted invite.  Apps should connect through the hosting server and then update the player's connected state (using setConnected:forHostedPlayer:)
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didReceiveAcceptFromHostedPlayer:(NSString *)playerID
{

}

#pragma mark - Game kit match delegate

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{

}


@end















