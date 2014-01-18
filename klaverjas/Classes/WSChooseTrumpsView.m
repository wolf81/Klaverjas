//
//  WSDialogView.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/12/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import "WSChooseTrumpsView.h"
#import <QuartzCore/QuartzCore.h>


#define ANIMATION_DURATION 0.3f


@interface WSChooseTrumpsView ()

@property (nonatomic, copy)   void (^completionHandler)(BOOL);
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton    *acceptButton;
@property (nonatomic, strong) UIButton    *cancelButton;

- (void)okButtonTouched:(id)sender;
- (void)cancelButtonTouched:(id)sender;

@end


@implementation WSChooseTrumpsView

@synthesize completionHandler = _completionHandler;
@synthesize titleLabel        = _titleLabel;
@synthesize imageView         = _imageView;
@synthesize acceptButton      = _acceptButton;
@synthesize cancelButton      = _cancelButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.dialogView addSubview:_imageView];
        
        self.acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 30.0f)];
        _acceptButton.backgroundColor = [UIColor lightGrayColor];
        _acceptButton.titleLabel.font = FONT_BIG;
        [_acceptButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_acceptButton addTarget:self action:@selector(okButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.dialogView addSubview:_acceptButton];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 30.0f)];
        _cancelButton.backgroundColor = [UIColor lightGrayColor];
        _cancelButton.titleLabel.font = FONT_BIG;
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.dialogView addSubview:_cancelButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 190.0f, 30.0f)];
        _titleLabel.backgroundColor = [UIColor lightGrayColor];
        _titleLabel.text = NSLocalizedString(@"Title", nil);
        _titleLabel.font = FONT_BIG;
        _titleLabel.textAlignment = UITextAlignmentCenter;
        [self.dialogView addSubview:_titleLabel];
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
    
    const CGRect bounds = self.dialogView.bounds;
    
#define PADDING 6.0f
    
    CGFloat x = bounds.size.width / 2;
    CGFloat y = PADDING + (_titleLabel.frame.size.height / 2);
    _titleLabel.center = CGPointMake(x, y);
    
    x = PADDING + (_cancelButton.frame.size.width / 2);
    y = bounds.size.height - PADDING - (_cancelButton.frame.size.height / 2);
    _cancelButton.center = CGPointMake(x, y);
    
    x = bounds.size.width - PADDING - (_acceptButton.frame.size.width / 2);
    _acceptButton.center = CGPointMake(x, y);
    
    y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + PADDING;
    CGFloat height = _acceptButton.frame.origin.y - PADDING - y;
    CGFloat width = bounds.size.width - (PADDING * 2);
    _imageView.frame = CGRectMake(PADDING, y, width, height);
}

- (void)okButtonTouched:(id)sender
{
    if (_completionHandler)
    {
        _completionHandler(YES);
    }
    
    [self removeFromSuperview];
}

- (void)cancelButtonTouched:(id)sender
{
    if (_completionHandler)
    {
        _completionHandler(NO);
    }

    [self removeFromSuperview];
}

#pragma mark - Public instance methods

+ (WSChooseTrumpsView *)chooseTrumpsViewWithImage:(UIImage *)image completionHandler:(void (^)(BOOL))completionHandler
{
    WSChooseTrumpsView *view = [[WSChooseTrumpsView alloc] init];
    if (view)
    {
        view.completionHandler = completionHandler;
        view.titleLabel.text   = NSLocalizedString(@"Accept trumps?", nil);
        view.imageView.image   = image;
        
        [view.acceptButton setTitle:NSLocalizedString(@"Yes", nil) forState:UIControlStateNormal];
        [view.cancelButton setTitle:NSLocalizedString(@"No", nil) forState:UIControlStateNormal];
    }
    return view;
}

@end
