//
//  FTMoreAppsViewController.m
//  MoreApps
//
//  Created by Beatriz Juliana Ribeiro on 30/04/15.
//  Copyright (c) 2015 FT Apps. All rights reserved.
//

#import "FTMoreAppsViewController.h"
#import "FTMoreAppsCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "FTMoreAppsNavigationController.h"

@import StoreKit;

@interface FTMoreAppsViewController () <UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate, FTMoreAppsCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;

@property (strong, nonatomic) NSString *developerName;
@property (strong, nonatomic) NSArray *appIds;

@property (nonatomic) FTDescriptionType descriptionType;

@property (strong, nonatomic) UIRefreshControl *refControl;
@property (strong, nonatomic) NSMutableDictionary *heightsDict;

@end

@implementation FTMoreAppsViewController

- (id)initWithDeveloperId:(NSString *)developerId
          descriptionType:(FTDescriptionType)description
                 delegate:(id<FTMoreAppsViewControllerDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        
        _developerName = [developerId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _showActionButton = YES;
        _showPrice = NO;
        _descriptionType = description;
        _delegate = delegate;
        
        _heightsDict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (id)initWithAppIds:(NSArray *)appIds
     descriptionType:(FTDescriptionType)description
            delegate:(id<FTMoreAppsViewControllerDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        
        _appIds = appIds;
        _showActionButton = YES;
        _showPrice = NO;
        _descriptionType = description;
        _delegate = delegate;
        
        _heightsDict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.presentingViewController) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDonePressed:)];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    _tableView.layoutMargins = _tableView.separatorInset;
//    [_tableView registerNib:[UINib nibWithNibName:@"FTMoreAppsCell" bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:@"AppCell"];

    _refControl = [[UIRefreshControl alloc] init];
    [_refControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_tableView addSubview:_refControl];
    
    [self.view addSubview:_tableView];
    
    _tableView.contentOffset = CGPointMake(0, -_refControl.frame.size.height);
    [self generateDatasource];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleDidChangeStatusBarOrientationNotification:)
//                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
//                                               object:nil];
}

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self handleSizeChange:self.view.frame.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Generic methods

- (void)refreshControlValueChanged:(UIRefreshControl *)refControl
{
    [self generateDatasource];
}

- (void)generateDatasource
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_refControl.isRefreshing) {
            [_refControl beginRefreshing];
        }
    });
    
    NSURL *url = nil;
    if (_developerName) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@&entity=software&country=%@", _developerName, [self getUserCountry]]];
    }
    else if (_appIds) {
        NSMutableString *string = [NSMutableString string];
        for (NSString *appdId in _appIds) {
            if ([_appIds indexOfObject:appdId] == 0) {
                [string appendString:appdId];
            }
            else {
                [string appendFormat:@",%@", appdId];
            }
        }
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@&entity=software&country=%@", string, [self getUserCountry]]];
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            _datasource = [dict[@"results"] mutableCopy];
            
            if ((_developerName && _datasource.count > 1) || (_appIds && _datasource.count > 0)) {
                if (_developerName && _datasource.count > 1) {
                    _datasource = [[_datasource subarrayWithRange:(NSRange){1, _datasource.count - 1}] mutableCopy];
                }
                    
                NSMutableArray *dictsToRemove = [NSMutableArray array];
                BOOL isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
                for (NSDictionary *dict in _datasource) {
                    if ((isIpad && ((NSArray *)dict[@"ipadScreenshotUrls"]).count == 0) ||
                        (isIpad == NO && ((NSArray *)dict[@"screenshotUrls"]).count == 0) ||
                        ([dict[@"bundleId"] isEqualToString:[[NSBundle mainBundle] bundleIdentifier]])) {
                        [dictsToRemove addObject:dict];
                    }
                }
                [_datasource removeObjectsInArray:dictsToRemove];
            }
            else {
                _datasource = nil;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_refControl endRefreshing];
            [self.tableView reloadData];
        });
    }];
    
    [task resume];
}

- (NSString *)getUserCountry
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale objectForKey: NSLocaleCountryCode];
    
    return (country ? country : @"us");
}

- (void)showStoreForAppId:(NSString *)appId
{
    SKStoreProductViewController *productVC = [[SKStoreProductViewController alloc] init];
    
    productVC.delegate = self;
    [productVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : appId,
                                           SKStoreProductParameterAffiliateToken : @"10lwC5",
                                           SKStoreProductParameterCampaignToken : @"More Apps Screen"}
                         completionBlock:nil];
    
    [self presentViewController:productVC animated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(moreAppsViewController:didSelectApp:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate moreAppsViewController:self didSelectApp:appId];
            });
        }
    }];
}

- (void)buttonDonePressed:(UIBarButtonItem *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FTMoreAppsInterruptLoadingKey" object:nil];
    
    if ([_delegate respondsToSelector:@selector(willDismissMoreAppsViewController:)]) {
        [_delegate willDismissMoreAppsViewController:self];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(didDismissMoreAppsViewController:)]) {
            [_delegate didDismissMoreAppsViewController:self];
        }
        
        self.delegate = nil;
    }];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) || self.presentingViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular)
    
    NSNumber *cellHeight = _heightsDict[@(indexPath.row)];
    if (cellHeight && self.view.frame.size.width < self.view.frame.size.height) {
        return cellHeight.floatValue;
    }
    
//    if (_descriptionType == FTDescriptionTypeText) {
//        return 84.0f + 125.0f;
//    }
    
    return 84.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FTMoreAppsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell"];
    if (!cell) {
        cell = [[FTMoreAppsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppCell"];
    }
    
    cell.delegate = self;
    cell.tag = indexPath.row;

    NSDictionary *appDict = _datasource[indexPath.row];

    [cell showButton:_showActionButton];

    if (_descriptionType == FTDescriptionTypeNone || _descriptionType == FTDescriptionTypeText || (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && self.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClassRegular)) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if (_descriptionType == FTDescriptionTypeText) {
            [cell setTextDescription:appDict[@"description"]];
        }
        else {
            cell.labelDescriptionHeightConstraint.constant = 0;
        }
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelDescriptionHeightConstraint.constant = 0;
    }
    
    cell.labelTitle.text = appDict[@"trackName"];
    cell.labelSubtitle.text = appDict[@"artistName"];
    cell.labelReviewsCount.text = [NSString stringWithFormat:@"(%d)", appDict[@"userRatingCountForCurrentVersion"] ? (int)[appDict[@"userRatingCountForCurrentVersion"] intValue] : (int)[appDict[@"userRatingCount"] intValue]];
    NSURL *artworkURL = [NSURL URLWithString:appDict[@"artworkUrl512"]];
    
    [cell.imageViewIcon sd_setImageWithURL:artworkURL];
    
    if (_showPrice) {
        [cell.buttonAction setTitle:[appDict[@"formattedPrice"] uppercaseString] forState:UIControlStateNormal];
    }
    else {
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"FTMoreApps" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle mainBundle];
        
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        }
        
        NSString *buttonTitle = NSLocalizedStringFromTableInBundle(@"Get", @"FTMoreAppsLocalizable", bundle, nil);
        [cell.buttonAction setTitle:[buttonTitle uppercaseString] forState:UIControlStateNormal];
    }
    
    CGFloat averageUserRating = appDict[@"averageUserRatingForCurrentVersion"] ? [appDict[@"averageUserRatingForCurrentVersion"] floatValue] : [appDict[@"averageUserRating"] floatValue];
    [cell setNumberOfStars:averageUserRating];
    
    if (_descriptionType == FTDescriptionTypeScreenshots) {
        cell.imageViewScreenshotLandscape.image = nil;
        cell.imageViewScreenshotPortrait1.image = nil;
        cell.imageViewScreenshotPortrait2.image = nil;
        cell.imageViewScreenshotLandscape.hidden = YES;
        cell.imageViewScreenshotPortrait1.hidden = YES;
        cell.imageViewScreenshotPortrait2.hidden = YES;
        
        NSArray *screenshots = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? appDict[@"ipadScreenshotUrls"] : appDict[@"screenshotUrls"];
        
        if (screenshots.count > 0) {
            for (int i = 0; i < MIN(2, screenshots.count); i++) {
                NSString *urlString = screenshots[i];
                NSURL *url = [NSURL URLWithString:urlString];
                
                [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageContinueInBackground progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        if (image.size.width > image.size.height) {
                            if (i == 0) {
                                [cell setLandscapeScreenshot:image];
                            }
                        }
                        else {
                            [cell setPortraitScreenshot:image position:i];
                        }
                    }
                }];
            }
        }
    }
    
    [cell setNeedsLayout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *appDict = _datasource[indexPath.row];
    [self showStoreForAppId:appDict[@"trackId"]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    viewController.delegate = nil;
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FTMoreAppsCellDelegate methods

- (void)moreAppsCell:(FTMoreAppsCell *)cell buttonPressed:(UIButton *)button
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    NSDictionary *appDict = _datasource[indexPath.row];
    [self showStoreForAppId:appDict[@"trackId"]];
}

- (void)moreAppsCell:(FTMoreAppsCell *)cell heightCalculated:(CGFloat)height tag:(NSInteger)tag
{
    void (^refreshTable)() = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            if (self.view.frame.size.height > self.view.frame.size.width) {
                [_tableView reloadData];
            }
         });
    };

    NSNumber *heightCache = _heightsDict[@(tag)];
    if (heightCache) {
        if (roundf(heightCache.floatValue) != roundf(height)) {
            _heightsDict[@(tag)] = @(height);
            refreshTable();
        }
    }
    else {
        _heightsDict[@(tag)] = @(height);
        refreshTable();
    }
}

#pragma mark - Orientation change notification

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self handleSizeChange:self.view.frame.size];

    NSLog(@"will transition to trait collection: %@", newCollection);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self handleSizeChange:size];
}

- (void)handleSizeChange:(CGSize)size
{
    if (size.width < size.height && _descriptionType == FTDescriptionTypeScreenshots) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    [_tableView reloadData];
}

@end
