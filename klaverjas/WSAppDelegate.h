//
//  WSAppDelegate.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/1/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSGameBoard;

@interface WSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) WSGameBoard *gameBoard;

@end
