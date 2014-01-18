//
//  WSMessageView.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/15/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import "WSMessageView.h"


#define ANIMATION_DURATION 0.3f


@interface WSMessageView ()

@property (nonatomic, strong) UILabel *messageLabel;

- (void)fadeOutWithCompletionHandler:(void (^)(void))handler;
- (void)fadeIn;

@end


@implementation WSMessageView

@synthesize messageLabel = _messageLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.contentMode     = UIViewContentModeCenter;
        _messageLabel.textAlignment   = UITextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font            = FONT_NORMAL;
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGRect bounds = self.bounds;
    
#define PADDING 5.0f
    
    CGFloat width = bounds.size.width - (PADDING * 2);
    CGFloat height = bounds.size.height - (PADDING * 2);
    _messageLabel.frame = CGRectMake(PADDING, PADDING, width, height);
}

#pragma mark - Private instance methods

- (void)fadeOutWithCompletionHandler:(void (^)(void))handler
{
    [UIView animateWithDuration:ANIMATION_DURATION animations:^ {
    
        _messageLabel.alpha = 0.0f;
    
    } completion:^ (BOOL finished) {
    
        if (handler)
        {
            handler();
        }
        
    }];
}

- (void)fadeIn
{
    [UIView animateWithDuration:ANIMATION_DURATION animations:^ {
    
        _messageLabel.alpha = 1.0f;
        
    }];
}

#pragma mark - Public instance methods

- (void)setMessage:(NSString *)string
{
    dispatch_async(dispatch_get_main_queue(), ^ {
    
        [self fadeOutWithCompletionHandler:^ {
        
            _messageLabel.text = string;
            [self fadeIn];
            
        }];        
    });    
}

@end
