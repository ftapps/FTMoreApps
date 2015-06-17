//
//  FTMoreAppsCell.h
//  MoreApps
//
//  Created by Beatriz Juliana Ribeiro on 30/04/15.
//  Copyright (c) 2015 FT Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTButtonCell.h"
#import "FTStarView.h"

#define SPACE_BETWEEN_CELLS 20.0f

@class FTMoreAppsCell;

@protocol FTMoreAppsCellDelegate <NSObject>

@optional

- (void)moreAppsCell:(FTMoreAppsCell *)cell buttonPressed:(UIButton *)button;
- (void)moreAppsCell:(FTMoreAppsCell *)cell heightCalculated:(CGFloat)height tag:(NSInteger)tag;

@end

@interface FTMoreAppsCell : UITableViewCell

@property (strong, nonatomic) UIImageView *imageViewIcon;
@property (strong, nonatomic) UILabel *labelTitle;
@property (strong, nonatomic) UILabel *labelSubtitle;
@property (strong, nonatomic) UILabel *labelReviewsCount;
@property (strong, nonatomic) FTButtonCell *buttonAction;
@property (strong, nonatomic) FTStarView *imageViewStar1;
@property (strong, nonatomic) FTStarView *imageViewStar2;
@property (strong, nonatomic) FTStarView *imageViewStar3;
@property (strong, nonatomic) FTStarView *imageViewStar4;
@property (strong, nonatomic) FTStarView *imageViewStar5;

@property (strong, nonatomic) UIImageView *imageViewScreenshotLandscape;
@property (strong, nonatomic) UIImageView *imageViewScreenshotPortrait1;
@property (strong, nonatomic) UIImageView *imageViewScreenshotPortrait2;

@property (strong, nonatomic) UILabel *labelDescription;
@property (strong, nonatomic) NSLayoutConstraint *labelDescriptionHeightConstraint;

@property (assign, nonatomic) id <FTMoreAppsCellDelegate> delegate;

- (void)setNumberOfStars:(CGFloat)stars;
- (void)showButton:(BOOL)show;

- (void)setPortraitScreenshot:(UIImage *)image position:(NSInteger)position;
- (void)setLandscapeScreenshot:(UIImage *)screenshot;

- (void)setTextDescription:(NSString *)text;

@end
