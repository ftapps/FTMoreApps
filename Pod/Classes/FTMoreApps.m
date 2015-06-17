//
//  FTMoreApps.m
//  MoreApps
//
//  Created by Felipe Tumonis on 12/05/15.
//  Copyright (c) 2015 FT Apps. All rights reserved.
//

#import "FTMoreApps.h"
#import "FTMoreAppsNavigationController.h"

@interface FTMoreApps() <FTMoreAppsViewControllerDelegate>

@property (nonatomic, strong) FTMoreAppsViewController *moreAppsVC;

@end

@implementation FTMoreApps

+ (FTMoreApps *)sharedManager
{
    static FTMoreApps *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FTMoreApps alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [[UINavigationBar appearanceWhenContainedIn:[FTMoreAppsNavigationController class], nil] setBarTintColor:nil];
        [[UINavigationBar appearanceWhenContainedIn:[FTMoreAppsNavigationController class], nil] setTintColor:nil];
        [[UINavigationBar appearanceWhenContainedIn:[FTMoreAppsNavigationController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearanceWhenContainedIn:[FTMoreAppsNavigationController class], nil] setShadowImage:nil];
        [[UINavigationBar appearanceWhenContainedIn:[FTMoreAppsNavigationController class], nil] setTitleTextAttributes:nil];
        [[UIBarButtonItem appearanceWhenContainedIn:[FTMoreAppsNavigationController class], nil] setTintColor:nil];
    }
    
    return self;
}

- (void)presentMoreAppsInViewController:(UIViewController *)viewController
                            developerId:(NSString *)devId
                        descriptionType:(FTDescriptionType)type
                             completion:(void (^)())completion
{
    _moreAppsVC = [[FTMoreAppsViewController alloc] initWithDeveloperId:devId
                                                        descriptionType:type
                                                               delegate:self];

    [self presentMoreAppsViewController:_moreAppsVC inViewController:viewController completion:completion];
}

- (void)presentMoreAppsInViewController:(UIViewController *)viewController
                                 appIds:(NSArray *)appIds
                        descriptionType:(FTDescriptionType)type
                             completion:(void (^)())completion
{
    _moreAppsVC = [[FTMoreAppsViewController alloc] initWithAppIds:appIds
                                                   descriptionType:type
                                                          delegate:self];

    [self presentMoreAppsViewController:_moreAppsVC inViewController:viewController completion:completion];
}

- (void)presentMoreAppsViewController:(FTMoreAppsViewController *)moreAppsVC inViewController:(UIViewController *)viewController completion:(void (^)())completion
{
    FTMoreAppsNavigationController *navController = [[FTMoreAppsNavigationController alloc] initWithRootViewController:moreAppsVC];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    moreAppsVC.title = _title;
    moreAppsVC.showActionButton = _showActionButton;
    moreAppsVC.showPrice = _showPrice;

    [viewController presentViewController:navController animated:YES completion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)setShowActionButton:(BOOL)showActionButton
{
    _showActionButton = showActionButton;
    if (_moreAppsVC) {
        [_moreAppsVC setShowActionButton:showActionButton];
    }
}

- (void)setShowPrice:(BOOL)showPrice
{
    _showPrice = showPrice;
    if (_moreAppsVC) {
        [_moreAppsVC setShowPrice:showPrice];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (_moreAppsVC) {
        [_moreAppsVC setTitle:title];
    }
}

#pragma mark - FTMoreAppsViewControllerDelegate methods

- (void)willDismissMoreAppsViewController:(FTMoreAppsViewController *)moreAppsVC
{
    if (_willDismissBlock) {
        _willDismissBlock();
    }
}

- (void)didDismissMoreAppsViewController:(FTMoreAppsViewController *)moreAppsVC
{
    if (_didDismissBlock) {
        _didDismissBlock();
    }
    
    _moreAppsVC = nil;
}

- (void)moreAppsViewController:(FTMoreAppsViewController *)moreAppsVC didSelectApp:(NSString *)appId
{
    if (_didSelectAppBlock) {
        _didSelectAppBlock(appId);
    }
}

@end
