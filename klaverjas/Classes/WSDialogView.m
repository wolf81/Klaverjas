//
//  WSDialogView.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 12/4/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import "WSDialogView.h"
#import <QuartzCore/QuartzCore.h>


#define ANIMATION_DURATION 0.3f


@interface WSDialogView ()

@property (nonatomic, strong) UIView *dialogView;

- (void)doPopInAnimation;
- (void)doFadeInAnimation;
- (void)doPopOutAnimation;

@end


@implementation WSDialogView

@synthesize dialogView = _dialogView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        
        self.dialogView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 160.0f)];
        _dialogView.backgroundColor = [UIColor grayColor];
        [self addSubview:_dialogView];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Animation

- (void)doPopInAnimation
{
    CALayer *viewLayer = _dialogView.layer;
    CAKeyframeAnimation* popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    popInAnimation.duration = ANIMATION_DURATION;
    popInAnimation.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.6],
                             [NSNumber numberWithFloat:1.1],
                             [NSNumber numberWithFloat:.9],
                             [NSNumber numberWithFloat:1],
                             nil];
    popInAnimation.keyTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.6],
                               [NSNumber numberWithFloat:0.8],
                               [NSNumber numberWithFloat:1.0],
                               nil];
    popInAnimation.delegate = nil;
    
    [viewLayer addAnimation:popInAnimation forKey:@"transform.scale"];
}

- (void)doFadeInAnimation
{
    CALayer *viewLayer = self.layer;
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.duration = ANIMATION_DURATION;
    fadeInAnimation.delegate = nil;
    [viewLayer addAnimation:fadeInAnimation forKey:@"opacity"];
}

- (void)doPopOutAnimation
{
    
}

#pragma mark - Public

- (void)show
{
    dispatch_async(dispatch_get_main_queue(), ^ {

        id appDelegate   = [[UIApplication sharedApplication] delegate];
        UIWindow *window = [appDelegate window];
        self.frame       = window.frame;
        self.center      = window.center;
        [window addSubview:self];
        
        _dialogView.center = window.center;
        
        [self doPopInAnimation];
        [self doFadeInAnimation];
        
    });
}

@end
