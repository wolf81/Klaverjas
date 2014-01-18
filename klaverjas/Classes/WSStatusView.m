//
//  WSPlayerStatusView.m
//  klaverjas
//
//  Created by Wolfgang Schreurs on 6/12/12.
//  Copyright (c) 2012 Sound of Data. All rights reserved.
//

#import "WSStatusView.h"


@interface WSStatusView()

@property (nonatomic, strong) UILabel     *roundTitleLabel;
@property (nonatomic, strong) UILabel     *roundValueLabel;
@property (nonatomic, strong) UILabel     *team1TitleLabel;
@property (nonatomic, strong) UILabel     *team1ValueLabel;
@property (nonatomic, strong) UILabel     *team2TitleLabel;
@property (nonatomic, strong) UILabel     *team2ValueLabel;
@property (nonatomic, strong) UILabel     *trumpTitleLabel;
@property (nonatomic, strong) UIImageView *trumpView;

@end


@implementation WSStatusView

@synthesize roundTitleLabel = _roundTitleLabel;
@synthesize roundValueLabel = _roundValueLabel;
@synthesize team1TitleLabel = _team1TitleLabel;
@synthesize team1ValueLabel = _team1ValueLabel;
@synthesize team2TitleLabel = _team2TitleLabel;
@synthesize team2ValueLabel = _team2ValueLabel;
@synthesize trumpView       = _trumpView;
@synthesize trumpTitleLabel = _trumpTitleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.roundTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _roundTitleLabel.contentMode = UIViewContentModeCenter;
        _roundTitleLabel.text = NSLocalizedString(@"Round:", nil); 
        _roundTitleLabel.textAlignment = UITextAlignmentRight;
        _roundTitleLabel.backgroundColor = [UIColor clearColor];
        _roundTitleLabel.font = FONT_NORMAL;
        [self addSubview:_roundTitleLabel];

        self.roundValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _roundValueLabel.contentMode = UIViewContentModeCenter;
        _roundValueLabel.textAlignment = UITextAlignmentLeft;
        _roundValueLabel.backgroundColor = [UIColor clearColor];
        _roundValueLabel.font = FONT_NORMAL;
        [self addSubview:_roundValueLabel];

        self.team1TitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _team1TitleLabel.contentMode = UIViewContentModeCenter;
        _team1TitleLabel.text = NSLocalizedString(@"Team 1:", nil); 
        _team1TitleLabel.textAlignment = UITextAlignmentRight;
        _team1TitleLabel.backgroundColor = [UIColor clearColor];
        _team1TitleLabel.font = FONT_NORMAL;
        [self addSubview:_team1TitleLabel];

        self.team1ValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _team1ValueLabel.contentMode = UIViewContentModeCenter;
        _team1ValueLabel.textAlignment = UITextAlignmentLeft;
        _team1ValueLabel.backgroundColor = [UIColor clearColor];
        _team1ValueLabel.font = FONT_NORMAL;
        _team1ValueLabel.text = [NSString stringWithFormat:@"%d", 0];
        [self addSubview:_team1ValueLabel];

        self.team2TitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _team2TitleLabel.contentMode = UIViewContentModeCenter;
        _team2TitleLabel.text = NSLocalizedString(@"Team 2:", nil);
        _team2TitleLabel.textAlignment = UITextAlignmentRight;
        _team2TitleLabel.backgroundColor = [UIColor clearColor];
        _team2TitleLabel.font = FONT_NORMAL;
        [self addSubview:_team2TitleLabel];
        
        self.team2ValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _team2ValueLabel.contentMode = UIViewContentModeCenter;
        _team2ValueLabel.textAlignment = UITextAlignmentLeft;
        _team2ValueLabel.backgroundColor = [UIColor clearColor];
        _team2ValueLabel.font = FONT_NORMAL;
        _team2ValueLabel.text = [NSString stringWithFormat:@"%d", 0];
        [self addSubview:_team2ValueLabel];
        
        self.trumpTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _trumpTitleLabel.contentMode = UIViewContentModeCenter;
        _trumpTitleLabel.textAlignment = UITextAlignmentRight;
        _trumpTitleLabel.backgroundColor = [UIColor clearColor];
        _trumpTitleLabel.font = FONT_NORMAL;
        _trumpTitleLabel.text = NSLocalizedString(@"Trumps:", nil);
        [self addSubview:_trumpTitleLabel];

        self.trumpView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _trumpView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_trumpView];
                
        [self updateRound:0];
        [self updateTeam1Score:0];
        [self updateTeam2Score:0];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 70.0f)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];    

#define PADDING 5.0f
    
    const CGRect bounds = self.bounds;
        
    const CGFloat seg_width = bounds.size.width / 4;
    const CGFloat seg_height = bounds.size.height / 2;
    const CGFloat col_width = seg_width - (PADDING * 2);
    const CGFloat row_height = seg_height - (PADDING * 2);

    CGFloat x_col_0 = 0 * seg_width + PADDING;
    CGFloat x_col_1 = 1 * seg_width + PADDING;
    CGFloat x_col_2 = 2 * seg_width + PADDING;
    CGFloat x_col_3 = 3 * seg_width + PADDING;
    
    CGFloat y_row_0 = 0 * seg_height + PADDING;
    CGFloat y_row_1 = 1 * seg_height + PADDING;
        
    CGSize imageSize = _trumpView.image.size;
    CGFloat factor = imageSize.height > 0 ? imageSize.height / row_height : 1;
    CGFloat width = imageSize.width / factor;
    _trumpView.frame       = CGRectMake(x_col_1, y_row_1, width, row_height);

    _trumpTitleLabel.frame = CGRectMake(x_col_0, y_row_1, col_width, row_height);
    _roundTitleLabel.frame = CGRectMake(x_col_0, y_row_0, col_width, row_height);
    _roundValueLabel.frame = CGRectMake(x_col_1, y_row_0, col_width, row_height);
    _team1TitleLabel.frame = CGRectMake(x_col_2, y_row_0, col_width, row_height);
    _team1ValueLabel.frame = CGRectMake(x_col_3, y_row_0, col_width, row_height);
    _team2TitleLabel.frame = CGRectMake(x_col_2, y_row_1, col_width, row_height);
    _team2ValueLabel.frame = CGRectMake(x_col_3, y_row_1, col_width, row_height);
}  

#pragma mark - Public instance methods

- (void)updateTrumpImage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^ {
    
        _trumpView.image = image;
        
        [self setNeedsLayout];
    
    });
}

- (void)updateRound:(NSInteger)round
{
    dispatch_async(dispatch_get_main_queue(), ^ {

        _roundValueLabel.text = [NSString stringWithFormat:@"%d", round];        
        [self setNeedsLayout];

    });    
}

- (void)updateTeam1Score:(NSInteger)score
{
    dispatch_async(dispatch_get_main_queue(), ^ {
    
        _team1ValueLabel.text = [NSString stringWithFormat:@"%d", score];
        [self setNeedsLayout];

    });    
}

- (void)updateTeam2Score:(NSInteger)score
{
    dispatch_async(dispatch_get_main_queue(), ^ {
    
        _team2ValueLabel.text = [NSString stringWithFormat:@"%d", score];
        [self setNeedsLayout];

    });    
}

@end
