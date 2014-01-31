//
//  WSMenuView.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 7/13/12.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "WSMenuView.h"


@interface WSMenuView ()

@property (nonatomic, strong) UIView   *dialogView;
@property (nonatomic, strong) UIButton *startMatchButton;
@property (nonatomic, strong) UIButton *startTutorialButton;

@end


@implementation WSMenuView

@synthesize dialogView          = _dialogView;
@synthesize startMatchButton    = _startMatchButton;
@synthesize startTutorialButton = _startTutorialButton;;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        
        self.dialogView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 160.0f)];
        
        self.startMatchButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_startMatchButton];

        self.startTutorialButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_startTutorialButton];
    }
    return self;
}

- (void)dealloc
{
    self.startTutorialButton = nil;
    self.startMatchButton    = nil;
}

#pragma mark -

- (void)layoutSubviews
{    
    [super layoutSubviews];
    
    const CGRect bounds = _dialogView.bounds;
    
#define PADDING 6.0f
    
//    CGFloat x = bounds.size.width / 2;
//    CGFloat y = PADDING + (_titleLabel.frame.size.height / 2);
//    _titleLabel.center = CGPointMake(x, y);
//    
//    x = PADDING + (_cancelButton.frame.size.width / 2);
//    y = bounds.size.height - PADDING - (_cancelButton.frame.size.height / 2);
//    _cancelButton.center = CGPointMake(x, y);
//    
//    x = bounds.size.width - PADDING - (_acceptButton.frame.size.width / 2);
//    _acceptButton.center = CGPointMake(x, y);
//    
//    y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + PADDING;
//    CGFloat height = _acceptButton.frame.origin.y - PADDING - y;
//    CGFloat width = bounds.size.width - (PADDING * 2);
//    _imageView.frame = CGRectMake(PADDING, y, width, height);
}

@end
