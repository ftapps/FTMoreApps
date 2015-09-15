//
//  FTMoreAppsViewController.h
//  MoreApps
//
//  Created by Beatriz Juliana Ribeiro on 30/04/15.
//  Copyright (c) 2015 FT Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    FTDescriptionTypeNone = 0,
    FTDescriptionTypeText,
    FTDescriptionTypeScreenshots,
}
FTDescriptionType;

@class FTMoreAppsViewController;

@protocol FTMoreAppsViewControllerDelegate <NSObject>

@optional

- (void)willDismissMoreAppsViewController:(FTMoreAppsViewController *)moreAppsVC;
- (void)didDismissMoreAppsViewController:(FTMoreAppsViewController *)moreAppsVC;
- (void)moreAppsViewController:(FTMoreAppsViewController *)moreAppsVC didSelectApp:(NSString *)appId;

@end

@interface FTMoreAppsViewController : UIViewController

@property (nonatomic, weak) id <FTMoreAppsViewControllerDelegate> delegate;
@property (nonatomic) BOOL showPrice;
@property (nonatomic) BOOL showActionButton;

- (id)initWithDeveloperId:(NSString *)developerId
          descriptionType:(FTDescriptionType)description
                 delegate:(id <FTMoreAppsViewControllerDelegate>)delegate;

- (id)initWithAppIds:(NSArray *)appIds
     descriptionType:(FTDescriptionType)description
            delegate:(id <FTMoreAppsViewControllerDelegate>)delegate;

@end
