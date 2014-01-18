//
//  WSPlayerStatusView.h
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/12/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WSStatusView : UIView

- (void)updateRound:(NSInteger)round;
- (void)updateTeam1Score:(NSInteger)score;
- (void)updateTeam2Score:(NSInteger)score;
- (void)updateTrumpImage:(UIImage *)image;

@end
