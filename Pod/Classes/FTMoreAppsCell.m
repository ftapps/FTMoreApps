//
//  FTMoreAppsCell.m
//  MoreApps
//
//  Created by Beatriz Juliana Ribeiro on 30/04/15.
//  Copyright (c) 2015 FT Apps. All rights reserved.
//

#import "FTMoreAppsCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface FTMoreAppsCell ()

@property (strong, nonatomic) NSLayoutConstraint *buttonActionWidthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *labelTitleHeightConstraint;

@property (nonatomic) BOOL showButton;

@property (strong, nonatomic) UIView *viewScreenshots;
@property (strong, nonatomic) NSLayoutConstraint *constraintScreenshotsNewAspectRatio;

@property (strong, nonatomic) NSLayoutConstraint *constraintImageViewPortrait1NewAspectRatio;
@property (strong, nonatomic) NSLayoutConstraint *constraintImageViewPortrait2NewAspectRatio;
@property (strong, nonatomic) NSLayoutConstraint *constraintImageViewLandscapeNewAspectRatio;
@property (strong, nonatomic) NSLayoutConstraint *constraintImageViewPortrait1Left;

@end

@implementation FTMoreAppsCell

- (void)awakeFromNib
{
    [self initialSetup];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initialSetup];
    }
    
    return self;
}

- (void)initialSetup
{
    self.clipsToBounds = YES;
    
    UIColor *blackColor = [UIColor blackColor];
    UIColor *lightBlackColor = [UIColor colorWithRed:64.0 / 255.0 green:64.0 / 255.0 blue:64.0 / 255.0 alpha:1];
    
    _imageViewIcon = [[UIImageView alloc] init];
    _imageViewIcon.layer.masksToBounds = YES;
    _imageViewIcon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imageViewIcon.layer.borderWidth = 0.5f;
    _imageViewIcon.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:_imageViewIcon];
    
    NSLayoutConstraint *imageViewIconLeadingConstraint = [NSLayoutConstraint constraintWithItem:_imageViewIcon
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.contentView
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                     multiplier:1
                                                                                       constant:10];
    [self.contentView addConstraint:imageViewIconLeadingConstraint];
    
    NSLayoutConstraint *imageViewIconTopConstraint = [NSLayoutConstraint constraintWithItem:_imageViewIcon
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1
                                                                                   constant:8];
    
    [self.contentView addConstraint:imageViewIconTopConstraint];
    
    NSLayoutConstraint *imageViewIconHeightConstraint = [NSLayoutConstraint constraintWithItem:_imageViewIcon
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                                    multiplier:1
                                                                                      constant:68];
    [_imageViewIcon addConstraint:imageViewIconHeightConstraint];
    
    NSLayoutConstraint *imageViewIconAspectRatioConstraint = [NSLayoutConstraint constraintWithItem:_imageViewIcon
                                                                                          attribute:NSLayoutAttributeWidth
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:_imageViewIcon
                                                                                          attribute:NSLayoutAttributeHeight
                                                                                         multiplier:1
                                                                                           constant:0];
    [_imageViewIcon addConstraint:imageViewIconAspectRatioConstraint];
    
    
    _buttonAction = [[FTButtonCell alloc] init];
    _buttonAction.translatesAutoresizingMaskIntoConstraints = NO;
    _buttonAction.layer.cornerRadius = 4.0f;
    _buttonAction.layer.borderColor = self.tintColor.CGColor;
    _buttonAction.layer.borderWidth = 1;
    _buttonAction.layer.masksToBounds = YES;
    _buttonAction.backgroundColor = [UIColor clearColor];
    [_buttonAction setTitleColor:_buttonAction.tintColor forState:UIControlStateNormal];
    [_buttonAction setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_buttonAction setBackgroundImage:[self imageWithColor:_buttonAction.tintColor] forState:UIControlStateHighlighted];
    _buttonAction.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [_buttonAction addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_buttonAction];
    
    NSLayoutConstraint *buttonActionCenterYConstraint = [NSLayoutConstraint constraintWithItem:_buttonAction
                                                                                     attribute:NSLayoutAttributeCenterY
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:_imageViewIcon
                                                                                     attribute:NSLayoutAttributeCenterY
                                                                                    multiplier:1
                                                                                      constant:0];
    [self.contentView addConstraint:buttonActionCenterYConstraint];
    
    NSLayoutConstraint *buttonActionTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:_buttonAction
                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                     multiplier:1
                                                                                       constant:10];
    [self.contentView addConstraint:buttonActionTrailingConstraint];
    
    _buttonActionWidthConstraint = [NSLayoutConstraint constraintWithItem:_buttonAction
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1
                                                                 constant:50];
    [_buttonAction addConstraint:_buttonActionWidthConstraint];
    
    NSLayoutConstraint *buttonActionHeightConstraint = [NSLayoutConstraint constraintWithItem:_buttonAction
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                                   multiplier:1
                                                                                     constant:30];
    [_buttonAction addConstraint:buttonActionHeightConstraint];
    
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _labelTitle.font = [UIFont systemFontOfSize:14.0f];
    _labelTitle.textColor = blackColor;
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    _labelTitle.numberOfLines = 2;
    
    [self.contentView addSubview:_labelTitle];
    
    NSLayoutConstraint *labelTitleLeadingConstraint = [NSLayoutConstraint constraintWithItem:_labelTitle
                                                                                   attribute:NSLayoutAttributeLeading
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:_imageViewIcon
                                                                                   attribute:NSLayoutAttributeTrailing
                                                                                  multiplier:1
                                                                                    constant:10];
    [self.contentView addConstraint:labelTitleLeadingConstraint];
    
    NSLayoutConstraint *labelTitleTrailingConstraint = [NSLayoutConstraint constraintWithItem:_labelTitle
                                                                                    attribute:NSLayoutAttributeTrailing
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:_buttonAction
                                                                                    attribute:NSLayoutAttributeLeading
                                                                                   multiplier:1
                                                                                     constant:-10];
    [self.contentView addConstraint:labelTitleTrailingConstraint];
    
    _labelTitleHeightConstraint = [NSLayoutConstraint constraintWithItem:_labelTitle
                                                                                  attribute:NSLayoutAttributeHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:nil
                                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                                 multiplier:1
                                                                                   constant:8];
    [_labelTitle addConstraint:_labelTitleHeightConstraint];
    
    _labelSubtitle = [[UILabel alloc] init];
    _labelSubtitle.translatesAutoresizingMaskIntoConstraints = NO;
    _labelSubtitle.font = [UIFont systemFontOfSize:12];
    _labelSubtitle.textColor = lightBlackColor;
    _labelSubtitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_labelSubtitle];
    
    NSLayoutConstraint *labelSubtitleLeadingConstraint = [NSLayoutConstraint constraintWithItem:_labelSubtitle
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:_labelTitle
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                     multiplier:1
                                                                                       constant:0];
    [self.contentView addConstraint:labelSubtitleLeadingConstraint];
    
    NSLayoutConstraint *labelSubtitleTrailingConstraint = [NSLayoutConstraint constraintWithItem:_labelSubtitle
                                                                                       attribute:NSLayoutAttributeTrailing
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:_labelTitle
                                                                                       attribute:NSLayoutAttributeTrailing
                                                                                      multiplier:1
                                                                                        constant:0];
    [self.contentView addConstraint:labelSubtitleTrailingConstraint];
    
    NSLayoutConstraint *labelSubtitleTopConstraint = [NSLayoutConstraint constraintWithItem:_labelSubtitle
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:_labelTitle
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1
                                                                                   constant:0];
    [self.contentView addConstraint:labelSubtitleTopConstraint];
    
    NSLayoutConstraint *labelSubtitleHeightConstraint = [NSLayoutConstraint constraintWithItem:_labelSubtitle
                                                                                     attribute:NSLayoutAttributeHeight
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:nil
                                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                                    multiplier:1
                                                                                      constant:18];
    
    [_labelSubtitle addConstraint:labelSubtitleHeightConstraint];
    
    _imageViewStar1 = [[FTStarView alloc] initWithFillMode:FTStarViewFillFull];
    _imageViewStar2 = [[FTStarView alloc] initWithFillMode:FTStarViewFillFull];
    _imageViewStar3 = [[FTStarView alloc] initWithFillMode:FTStarViewFillFull];
    _imageViewStar4 = [[FTStarView alloc] initWithFillMode:FTStarViewFillFull];
    _imageViewStar5 = [[FTStarView alloc] initWithFillMode:FTStarViewFillFull];
    
    NSArray *starsArray = @[_imageViewStar1, _imageViewStar2, _imageViewStar3, _imageViewStar4, _imageViewStar5];
    NSInteger count = 0;
    for (FTStarView *starView in starsArray) {

        starView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:starView];
        
        NSLayoutConstraint *starHeightConstraint = [NSLayoutConstraint constraintWithItem:starView
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1
                                                                                 constant:9];
        [starView addConstraint:starHeightConstraint];

        NSLayoutConstraint *starWidthConstraint = [NSLayoutConstraint constraintWithItem:starView
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1
                                                                                constant:9];
        [starView addConstraint:starWidthConstraint];
        
        NSLayoutConstraint *starTopConstraint = [NSLayoutConstraint constraintWithItem:starView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_labelSubtitle
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1
                                                                              constant:3];
        [self.contentView addConstraint:starTopConstraint];
        
        NSLayoutConstraint *starLeadingConstraint = [NSLayoutConstraint constraintWithItem:starView
                                                                                 attribute:NSLayoutAttributeLeading
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:count == 0 ? _labelSubtitle : starsArray[count - 1]
                                                                                 attribute:count == 0 ? NSLayoutAttributeLeading : NSLayoutAttributeTrailing
                                                                                multiplier:1
                                                                                  constant:count == 0 ? 0 : 2];
        [self.contentView addConstraint:starLeadingConstraint];
        
        count++;
    }
    
    UIView *topSpaceView = [[UIView alloc] init];
    topSpaceView.translatesAutoresizingMaskIntoConstraints = NO;
    topSpaceView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:topSpaceView];
    
    NSLayoutConstraint *topSpaceViewTopConstraint = [NSLayoutConstraint constraintWithItem:topSpaceView
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.contentView
                                                                                 attribute:NSLayoutAttributeTop
                                                                                multiplier:1
                                                                                  constant:0];
    [self.contentView addConstraint:topSpaceViewTopConstraint];
    
    NSLayoutConstraint *topSpaceViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:topSpaceView
                                                                                     attribute:NSLayoutAttributeLeading
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:_labelTitle
                                                                                     attribute:NSLayoutAttributeLeading
                                                                                    multiplier:1
                                                                                      constant:0];
    [self.contentView addConstraint:topSpaceViewLeadingConstraint];
    
    NSLayoutConstraint *topSpaceViewTrailingConstraint = [NSLayoutConstraint constraintWithItem:topSpaceView
                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:_labelTitle
                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                     multiplier:1
                                                                                       constant:0];
    [self.contentView addConstraint:topSpaceViewTrailingConstraint];
    
    NSLayoutConstraint *topSpaceViewBottomConstraint = [NSLayoutConstraint constraintWithItem:topSpaceView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:_labelTitle
                                                                                    attribute:NSLayoutAttributeTop
                                                                                   multiplier:1
                                                                                     constant:0];
    [self.contentView addConstraint:topSpaceViewBottomConstraint];

    NSLayoutConstraint *topSpaceViewHeightConstraint = [NSLayoutConstraint constraintWithItem:topSpaceView
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                                   multiplier:1
                                                                                     constant:30];
    topSpaceViewHeightConstraint.priority = UILayoutPriorityDefaultLow;
    [topSpaceView addConstraint:topSpaceViewHeightConstraint];
    
    UIView *bottomSpaceView = [[UIView alloc] init];
    bottomSpaceView.translatesAutoresizingMaskIntoConstraints = NO;
    bottomSpaceView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:bottomSpaceView];

    NSLayoutConstraint *bottomSpaceViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:bottomSpaceView
                                                                                        attribute:NSLayoutAttributeLeading
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:_labelTitle
                                                                                        attribute:NSLayoutAttributeLeading
                                                                                       multiplier:1
                                                                                         constant:0];
    [self.contentView addConstraint:bottomSpaceViewLeadingConstraint];
    
    NSLayoutConstraint *bottomSpaceViewTrailingConstraint = [NSLayoutConstraint constraintWithItem:bottomSpaceView
                                                                                         attribute:NSLayoutAttributeTrailing
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:_labelTitle
                                                                                         attribute:NSLayoutAttributeTrailing
                                                                                        multiplier:1
                                                                                          constant:0];
    [self.contentView addConstraint:bottomSpaceViewTrailingConstraint];
    
    NSLayoutConstraint *bottomSpaceViewTopConstraint = [NSLayoutConstraint constraintWithItem:bottomSpaceView
                                                                                    attribute:NSLayoutAttributeTop
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:_imageViewStar1
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1
                                                                                     constant:0];
    [self.contentView addConstraint:bottomSpaceViewTopConstraint];
    
    NSLayoutConstraint *bottomSpaceViewBottomConstraint = [NSLayoutConstraint constraintWithItem:bottomSpaceView
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:_imageViewIcon
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                      multiplier:1
                                                                                        constant:6];
    [self.contentView addConstraint:bottomSpaceViewBottomConstraint];
    
    NSLayoutConstraint *bottomSpaceViewHeightConstraint = [NSLayoutConstraint constraintWithItem:bottomSpaceView
                                                                                       attribute:NSLayoutAttributeHeight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:nil
                                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                                      multiplier:1
                                                                                        constant:30];
    bottomSpaceViewHeightConstraint.priority = UILayoutPriorityDefaultLow;
    [bottomSpaceView addConstraint:bottomSpaceViewHeightConstraint];
    
    NSLayoutConstraint *spaceViewsHeightConstraint = [NSLayoutConstraint constraintWithItem:topSpaceView
                                                                                  attribute:NSLayoutAttributeHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:bottomSpaceView
                                                                                  attribute:NSLayoutAttributeHeight
                                                                                 multiplier:1
                                                                                   constant:0];
    [self.contentView addConstraint:spaceViewsHeightConstraint];

    _labelReviewsCount = [[UILabel alloc] init];
    _labelReviewsCount.translatesAutoresizingMaskIntoConstraints = NO;
    _labelReviewsCount.font = [UIFont systemFontOfSize:11];
    _labelReviewsCount.textColor = lightBlackColor;
    _labelReviewsCount.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_labelReviewsCount];
    
    NSLayoutConstraint *labelReviewsCountLeadingConstraint = [NSLayoutConstraint constraintWithItem:_labelReviewsCount
                                                                                          attribute:NSLayoutAttributeLeading
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:_imageViewStar5
                                                                                          attribute:NSLayoutAttributeTrailing
                                                                                         multiplier:1
                                                                                           constant:5];
    [self.contentView addConstraint:labelReviewsCountLeadingConstraint];
    
    NSLayoutConstraint *labelReviewsCountTrailingConstraint = [NSLayoutConstraint constraintWithItem:_labelReviewsCount
                                                                                           attribute:NSLayoutAttributeTrailing
                                                                                           relatedBy:NSLayoutRelationEqual
                                                                                              toItem:_buttonAction
                                                                                           attribute:NSLayoutAttributeLeading
                                                                                          multiplier:1
                                                                                            constant:10];
    [self.contentView addConstraint:labelReviewsCountTrailingConstraint];
    
    NSLayoutConstraint *labelReviewsCountCenterYConstraint = [NSLayoutConstraint constraintWithItem:_labelReviewsCount
                                                                                          attribute:NSLayoutAttributeCenterY
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:_imageViewStar5
                                                                                          attribute:NSLayoutAttributeCenterY
                                                                                         multiplier:1
                                                                                           constant:0];
    [self.contentView addConstraint:labelReviewsCountCenterYConstraint];
    
    NSLayoutConstraint *labelReviewsCountHeightConstraint = [NSLayoutConstraint constraintWithItem:_labelReviewsCount
                                                                                         attribute:NSLayoutAttributeHeight
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:_imageViewStar5
                                                                                         attribute:NSLayoutAttributeHeight
                                                                                        multiplier:1
                                                                                          constant:0];
    [self.contentView addConstraint:labelReviewsCountHeightConstraint];

    _labelDescription = [[UILabel alloc] init];
    _labelDescription.translatesAutoresizingMaskIntoConstraints = NO;
    _labelDescription.font = [UIFont systemFontOfSize:13.0f];
    _labelDescription.textAlignment = NSTextAlignmentLeft;
    _labelDescription.textColor = blackColor;
    _labelDescription.numberOfLines = 0;
    [self.contentView addSubview:_labelDescription];
    
    NSLayoutConstraint *labelDescriptionLeadingConstraint = [NSLayoutConstraint constraintWithItem:_labelDescription
                                                                                         attribute:NSLayoutAttributeLeading
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:_imageViewIcon
                                                                                         attribute:NSLayoutAttributeLeading
                                                                                        multiplier:1
                                                                                          constant:0];
    [self.contentView addConstraint:labelDescriptionLeadingConstraint];
    
    NSLayoutConstraint *labelDescriptionTrailingConstraint = [NSLayoutConstraint constraintWithItem:_labelDescription
                                                                                          attribute:NSLayoutAttributeTrailing
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:_buttonAction
                                                                                          attribute:NSLayoutAttributeTrailing
                                                                                         multiplier:1
                                                                                           constant:0];
    [self.contentView addConstraint:labelDescriptionTrailingConstraint];
    
    NSLayoutConstraint *labelDescriptionTopConstraint = [NSLayoutConstraint constraintWithItem:_labelDescription
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:_imageViewIcon
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1
                                                                                      constant:8];
    [self.contentView addConstraint:labelDescriptionTopConstraint];
    
    _labelDescriptionHeightConstraint = [NSLayoutConstraint constraintWithItem:_labelDescription
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:0];
    [_labelDescription addConstraint:_labelDescriptionHeightConstraint];
    
    _viewScreenshots = [[UIView alloc] init];
    _viewScreenshots.translatesAutoresizingMaskIntoConstraints = NO;
    _viewScreenshots.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_viewScreenshots];
    
    NSLayoutConstraint *viewScreenshotsLeadingConstraint = [NSLayoutConstraint constraintWithItem:_viewScreenshots
                                                                                        attribute:NSLayoutAttributeLeading
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:_imageViewIcon
                                                                                        attribute:NSLayoutAttributeLeading
                                                                                       multiplier:1
                                                                                         constant:0];
    [self.contentView addConstraint:viewScreenshotsLeadingConstraint];
    
    NSLayoutConstraint *viewScreenshotsTrailingConstraint = [NSLayoutConstraint constraintWithItem:_viewScreenshots
                                                                                         attribute:NSLayoutAttributeTrailing
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:_buttonAction
                                                                                         attribute:NSLayoutAttributeTrailing
                                                                                        multiplier:1
                                                                                          constant:0];
    [self.contentView addConstraint:viewScreenshotsTrailingConstraint];
    
    NSLayoutConstraint *viewScreenshotsTopConstraint = [NSLayoutConstraint constraintWithItem:_viewScreenshots
                                                                                    attribute:NSLayoutAttributeTop
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:_labelDescription
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1
                                                                                     constant:8];
    [self.contentView addConstraint:viewScreenshotsTopConstraint];
    
    NSLayoutConstraint *viewScreenshotsBottomConstraint = [NSLayoutConstraint constraintWithItem:_viewScreenshots
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self.contentView
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                      multiplier:1
                                                                                        constant:0];
    viewScreenshotsBottomConstraint.priority = UILayoutPriorityDefaultLow;
    [self.contentView addConstraint:viewScreenshotsBottomConstraint];
    
    NSLayoutConstraint *viewScreenshotsAspectRatioConstraint = [NSLayoutConstraint constraintWithItem:_viewScreenshots
                                                                                            attribute:NSLayoutAttributeWidth
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:_viewScreenshots
                                                                                            attribute:NSLayoutAttributeHeight
                                                                                           multiplier:18.0 / 16.0
                                                                                             constant:0];
    viewScreenshotsAspectRatioConstraint.priority = UILayoutPriorityDefaultHigh;
    [_viewScreenshots addConstraint:viewScreenshotsAspectRatioConstraint];
    
    _imageViewScreenshotLandscape = [[UIImageView alloc] init];
    _imageViewScreenshotLandscape.translatesAutoresizingMaskIntoConstraints = NO;
    _imageViewScreenshotLandscape.backgroundColor = [UIColor clearColor];
    [_viewScreenshots addSubview:_imageViewScreenshotLandscape];
    
    NSLayoutConstraint *imageViewScreenshotLandscapeLeadingConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotLandscape
                                                                                                     attribute:NSLayoutAttributeLeading
                                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                                        toItem:_viewScreenshots
                                                                                                     attribute:NSLayoutAttributeLeading
                                                                                                    multiplier:1
                                                                                                      constant:0];
    [_viewScreenshots addConstraint:imageViewScreenshotLandscapeLeadingConstraint];
    
    NSLayoutConstraint *imageViewScreenshotLandscapeTrailingConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotLandscape
                                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                                         toItem:_viewScreenshots
                                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                                     multiplier:1
                                                                                                       constant:0];
    [_viewScreenshots addConstraint:imageViewScreenshotLandscapeTrailingConstraint];
    
    NSLayoutConstraint *imageViewScreenshotLandscapeTopConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotLandscape
                                                                                                 attribute:NSLayoutAttributeTop
                                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                                    toItem:_viewScreenshots
                                                                                                 attribute:NSLayoutAttributeTop
                                                                                                multiplier:1
                                                                                                  constant:0];
    [_viewScreenshots addConstraint:imageViewScreenshotLandscapeTopConstraint];
    
    NSLayoutConstraint *imageViewScreenshotLandscapeAspectRatioConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotLandscape
                                                                                                         attribute:NSLayoutAttributeWidth
                                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                                            toItem:_imageViewScreenshotLandscape
                                                                                                         attribute:NSLayoutAttributeHeight
                                                                                                        multiplier:16.0 / 9.0                                                                                                          constant:0];
    [_imageViewScreenshotLandscape addConstraint:imageViewScreenshotLandscapeAspectRatioConstraint];

    _imageViewScreenshotPortrait1 = [[UIImageView alloc] init];
    _imageViewScreenshotPortrait1.translatesAutoresizingMaskIntoConstraints = NO;
    _imageViewScreenshotPortrait1.backgroundColor = [UIColor clearColor];
    _imageViewScreenshotPortrait1.contentMode = UIViewContentModeScaleAspectFit;
    _imageViewScreenshotPortrait1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imageViewScreenshotPortrait1.layer.borderWidth = 0.5f;
[_viewScreenshots addSubview:_imageViewScreenshotPortrait1];
    
    NSLayoutConstraint *imageViewScreenshotPortrait1TopConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait1
                                                                                                 attribute:NSLayoutAttributeTop
                                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                                    toItem:_viewScreenshots
                                                                                                 attribute:NSLayoutAttributeTop
                                                                                                multiplier:1
                                                                                                  constant:0];
    [_viewScreenshots addConstraint:imageViewScreenshotPortrait1TopConstraint];
    
    NSLayoutConstraint *imageViewScreenshotPortrait1BottomConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait1
                                                                                                    attribute:NSLayoutAttributeBottom
                                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                                       toItem:_viewScreenshots
                                                                                                    attribute:NSLayoutAttributeBottom
                                                                                                   multiplier:1
                                                                                                     constant:-8];
    
    [_viewScreenshots addConstraint:imageViewScreenshotPortrait1BottomConstraint];
    
    NSLayoutConstraint *imageViewScreenshotPortrait1CenterXConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait1
                                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                                        toItem:_viewScreenshots
                                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                                    multiplier:1
                                                                                                      constant:0];
    imageViewScreenshotPortrait1CenterXConstraint.priority = UILayoutPriorityDefaultLow;
    [_viewScreenshots addConstraint:imageViewScreenshotPortrait1CenterXConstraint];
    
    NSLayoutConstraint *imageViewScreenshotPortrait1AspectRatioConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait1
                                                                                                         attribute:NSLayoutAttributeWidth
                                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                                            toItem:_imageViewScreenshotPortrait1
                                                                                                         attribute:NSLayoutAttributeHeight
                                                                                                        multiplier:9.0 / 16.0
                                                                                                          constant:0];
    imageViewScreenshotPortrait1AspectRatioConstraint.priority = UILayoutPriorityDefaultHigh;
    [_imageViewScreenshotPortrait1 addConstraint:imageViewScreenshotPortrait1AspectRatioConstraint];
    
    _imageViewScreenshotPortrait2 = [[UIImageView alloc] init];
    _imageViewScreenshotPortrait2.translatesAutoresizingMaskIntoConstraints = NO;
    _imageViewScreenshotPortrait2.backgroundColor = [UIColor clearColor];
    _imageViewScreenshotPortrait2.contentMode = UIViewContentModeScaleAspectFit;
    _imageViewScreenshotPortrait2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imageViewScreenshotPortrait2.layer.borderWidth = 0.5f;
[_viewScreenshots addSubview:_imageViewScreenshotPortrait2];
    
    NSLayoutConstraint *imageViewScreenshotPortrait2TrailingConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait2
                                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                                         toItem:_viewScreenshots
                                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                                     multiplier:1
                                                                                                       constant:0];
    [_viewScreenshots addConstraint:imageViewScreenshotPortrait2TrailingConstraint];
    
    NSLayoutConstraint *imageViewScreenshotPortrait2TopConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait2
                                                                                                 attribute:NSLayoutAttributeTop
                                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                                    toItem:_viewScreenshots
                                                                                                 attribute:NSLayoutAttributeTop
                                                                                                multiplier:1
                                                                                                  constant:0];
    [_viewScreenshots addConstraint:imageViewScreenshotPortrait2TopConstraint];
    
    NSLayoutConstraint *imageViewScreenshotPortrait2BottomConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait2
                                                                                                    attribute:NSLayoutAttributeBottom
                                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                                       toItem:_viewScreenshots
                                                                                                    attribute:NSLayoutAttributeBottom
                                                                                                   multiplier:1
                                                                                                     constant:-8];
    [_viewScreenshots addConstraint:imageViewScreenshotPortrait2BottomConstraint];
    
    NSLayoutConstraint *imageViewScreenshotPortrait2AspectRatioConstraint = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait2
                                                                                                         attribute:NSLayoutAttributeWidth
                                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                                            toItem:_imageViewScreenshotPortrait2
                                                                                                         attribute:NSLayoutAttributeHeight
                                                                                                        multiplier:9.0 / 16.0
                                                                                                          constant:0];
    imageViewScreenshotPortrait2AspectRatioConstraint.priority = UILayoutPriorityDefaultHigh;
    [_imageViewScreenshotPortrait2 addConstraint:imageViewScreenshotPortrait2AspectRatioConstraint];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellInterruptLoading:) name:@"FTMoreAppsInterruptLoadingKey" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FTMoreAppsInterruptLoadingKey" object:nil];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [_viewScreenshots removeConstraint:_constraintImageViewPortrait1Left];
    _constraintImageViewPortrait1Left = nil;
}

- (void)buttonPressed:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(moreAppsCell:buttonPressed:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate moreAppsCell:self buttonPressed:button];
        });
    }
}

- (void)setNumberOfStars:(CGFloat)stars
{
    _labelReviewsCount.hidden = NO;
    _imageViewStar1.hidden = NO;
    _imageViewStar2.hidden = NO;
    _imageViewStar3.hidden = NO;
    _imageViewStar4.hidden = NO;
    _imageViewStar5.hidden = NO;
    
    if (stars == 1) {
        [_imageViewStar1 setFillMode:FTStarViewFillFull];
        [_imageViewStar2 setFillMode:FTStarViewFillEmpty];
        [_imageViewStar3 setFillMode:FTStarViewFillEmpty];
        [_imageViewStar4 setFillMode:FTStarViewFillEmpty];
        [_imageViewStar5 setFillMode:FTStarViewFillEmpty];
    }
    else if (stars == 1.5f) {
        [_imageViewStar1 setFillMode:FTStarViewFillFull];
        [_imageViewStar2 setFillMode:FTStarViewFillHalf];
        [_imageViewStar3 setFillMode:FTStarViewFillEmpty];
        [_imageViewStar4 setFillMode:FTStarViewFillEmpty];
        [_imageViewStar5 setFillMode:FTStarViewFillEmpty];
    }
    else if (stars == 2) {
        [_imageViewStar1 setFillMode:FTStarViewFillFull];
        [_imageViewStar2 setFillMode:FTStarViewFillFull];
        [_imageViewStar3 setFillMode:FTStarViewFillEmpty];
        [_imageViewStar4 setFillMode:FTStarViewFillEmpty];
        [_imageViewStar5 setFillMode:FTStarViewFillEmpty];
    }
    else if (stars == 2.5f) {
        [_imageViewStar1 setFillMode:FTStarViewFillFull];
        [_imageViewStar2 setFillMode:FTStarViewFillFull];
        [_imageViewStar3 setFillMode:FTStarViewFillHalf];
        [_imageViewStar4 setFillMode:FTStarViewFillEmpty];
        [_imageViewStar5 setFillMode:FTStarViewFillEmpty];
    }
    else if (stars == 3) {
        [_imageViewStar1 setFillMode:FTStarViewFillFull];
        [_imageViewStar2 setFillMode:FTStarViewFillFull];
        [_imageViewStar3 setFillMode:FTStarViewFillFull];
        [_imageViewStar4 setFillMode:FTStarViewFillEmpty];
        [_imageViewStar5 setFillMode:FTStarViewFillEmpty];
    }
    else if (stars == 3.5f) {
        [_imageViewStar1 setFillMode:FTStarViewFillFull];
        [_imageViewStar2 setFillMode:FTStarViewFillFull];
        [_imageViewStar3 setFillMode:FTStarViewFillFull];
        [_imageViewStar4 setFillMode:FTStarViewFillHalf];
        [_imageViewStar5 setFillMode:FTStarViewFillEmpty];
    }
    else if (stars == 4) {
        [_imageViewStar1 setFillMode:FTStarViewFillFull];
        [_imageViewStar2 setFillMode:FTStarViewFillFull];
        [_imageViewStar3 setFillMode:FTStarViewFillFull];
        [_imageViewStar4 setFillMode:FTStarViewFillFull];
        [_imageViewStar5 setFillMode:FTStarViewFillEmpty];
    }
    else if (stars == 4.5f) {
        [_imageViewStar1 setFillMode:FTStarViewFillFull];
        [_imageViewStar2 setFillMode:FTStarViewFillFull];
        [_imageViewStar3 setFillMode:FTStarViewFillFull];
        [_imageViewStar4 setFillMode:FTStarViewFillFull];
        [_imageViewStar5 setFillMode:FTStarViewFillHalf];
    }
    else if (stars == 5) {
        [_imageViewStar1 setFillMode:FTStarViewFillFull];
        [_imageViewStar2 setFillMode:FTStarViewFillFull];
        [_imageViewStar3 setFillMode:FTStarViewFillFull];
        [_imageViewStar4 setFillMode:FTStarViewFillFull];
        [_imageViewStar5 setFillMode:FTStarViewFillFull];
    }
    else {
        _labelReviewsCount.hidden = YES;
        _imageViewStar1.hidden = YES;
        _imageViewStar2.hidden = YES;
        _imageViewStar3.hidden = YES;
        _imageViewStar4.hidden = YES;
        _imageViewStar5.hidden = YES;
    }
}

- (void)showButton:(BOOL)show
{
    _showButton = show;
    [self layoutIfNeeded];
}

- (void)setPortraitScreenshot:(UIImage *)image position:(NSInteger)position
{
    _imageViewScreenshotLandscape.image = nil;

    if (position == 0) {
        _imageViewScreenshotPortrait1.image = image;
        _imageViewScreenshotPortrait1.hidden = NO;
    }
    else if (position == 1) {
        _imageViewScreenshotPortrait2.image = image;
        _imageViewScreenshotPortrait2.hidden = NO;
        
        _constraintImageViewPortrait1Left = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait1
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_viewScreenshots
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0f
                                                                          constant:0];
        [_viewScreenshots addConstraint:_constraintImageViewPortrait1Left];
    }
    
    CGFloat ratio = 2 * image.size.width / image.size.height;
    CGFloat ratio2 = image.size.width / image.size.height;
    
    [_viewScreenshots.superview removeConstraint:_constraintScreenshotsNewAspectRatio];
    
    _constraintScreenshotsNewAspectRatio = [NSLayoutConstraint constraintWithItem:_viewScreenshots
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_viewScreenshots
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:ratio
                                                                         constant:0];
    
    [_viewScreenshots.superview addConstraint:_constraintScreenshotsNewAspectRatio];
    
    [_imageViewScreenshotPortrait1.superview removeConstraint:_constraintImageViewPortrait1NewAspectRatio];
    [_imageViewScreenshotPortrait2.superview removeConstraint:_constraintImageViewPortrait2NewAspectRatio];
    
    _constraintImageViewPortrait1NewAspectRatio = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait1
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_imageViewScreenshotPortrait1
                                                                               attribute:NSLayoutAttributeHeight
                                                                              multiplier:ratio2
                                                                                constant:0];
    
    _constraintImageViewPortrait2NewAspectRatio = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotPortrait2
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_imageViewScreenshotPortrait2
                                                                               attribute:NSLayoutAttributeHeight
                                                                              multiplier:ratio2
                                                                                constant:0];
    
    [_imageViewScreenshotPortrait1.superview addConstraint:_constraintImageViewPortrait1NewAspectRatio];
    [_imageViewScreenshotPortrait2.superview addConstraint:_constraintImageViewPortrait2NewAspectRatio];
    
    [_viewScreenshots setNeedsLayout];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [self.contentView convertRect:_imageViewScreenshotPortrait1.frame fromView:_imageViewScreenshotPortrait1.superview];
        
        NSLog(@"set portrait tag: %d", (int)self.tag);

        if ([self.delegate respondsToSelector:@selector(moreAppsCell:heightCalculated:tag:)]) {
            [self.delegate moreAppsCell:self heightCalculated:rect.origin.y + rect.size.height + SPACE_BETWEEN_CELLS tag:self.tag];
        }
    });
}

- (void)setLandscapeScreenshot:(UIImage *)screenshot
{
    _imageViewScreenshotPortrait1.image = nil;
    _imageViewScreenshotPortrait2.image = nil;
    _imageViewScreenshotLandscape.image = screenshot;
    _imageViewScreenshotLandscape.hidden = NO;
    
    CGFloat ratio = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 16.0f / 9.0f : screenshot.size.width / screenshot.size.height;
    
    [_imageViewScreenshotLandscape.superview removeConstraint:_constraintImageViewLandscapeNewAspectRatio];
    
    _constraintImageViewLandscapeNewAspectRatio = [NSLayoutConstraint constraintWithItem:_imageViewScreenshotLandscape
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_imageViewScreenshotLandscape
                                                                               attribute:NSLayoutAttributeHeight
                                                                              multiplier:ratio
                                                                                constant:0];
    
    [_imageViewScreenshotLandscape.superview addConstraint:_constraintImageViewLandscapeNewAspectRatio];

    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [self.contentView convertRect:_imageViewScreenshotLandscape.frame fromView:_imageViewScreenshotLandscape.superview];
        NSLog(@"set landscape tag: %d", (int)self.tag);
        if ([self.delegate respondsToSelector:@selector(moreAppsCell:heightCalculated:tag:)]) {
            [self.delegate moreAppsCell:self heightCalculated:rect.origin.y + rect.size.height + SPACE_BETWEEN_CELLS tag:self.tag];
        }
    });
}

- (void)setTextDescription:(NSString *)text
{
    _labelDescription.text = text;
    _labelDescription.numberOfLines = 1000.0f;
    
    CGFloat height = [text boundingRectWithSize:CGSizeMake(_labelDescription.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _labelDescription.font} context:NULL].size.height + 5.0f;
    
    _labelDescriptionHeightConstraint.constant = height;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [self.contentView convertRect:_labelDescription.frame fromView:_labelDescription.superview];
        if ([_delegate respondsToSelector:@selector(moreAppsCell:heightCalculated:tag:)]) {
            [_delegate moreAppsCell:self heightCalculated:rect.origin.y + rect.size.height + SPACE_BETWEEN_CELLS tag:self.tag];
        }
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageViewIcon.layer.cornerRadius = _imageViewIcon.frame.size.width / 4.5f;

    CGFloat width = [_buttonAction.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _buttonAction.titleLabel.font} context:NULL].size.width + 15.0f;
    
    _buttonActionWidthConstraint.constant = _showButton ? MAX(width, 50) : 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat width2 = [_labelTitle.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _labelTitle.font} context:NULL].size.width;
        
        if (width2 > _labelTitle.frame.size.width) {
            _labelTitleHeightConstraint.constant = 34.0f;
        }
        else {
            _labelTitleHeightConstraint.constant = 18.0f;
        }
    });
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Notification methods

- (void)cellInterruptLoading:(NSNotification *)note
{
    self.delegate = nil;
}


@end
