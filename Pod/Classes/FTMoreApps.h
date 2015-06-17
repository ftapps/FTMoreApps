//
//  FTMoreApps.h
//  MoreApps
//
//  Created by Felipe Tumonis on 12/05/15.
//  Copyright (c) 2015 FT Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTMoreAppsViewController.h"

typedef void (^FTDismissBlock)();
typedef void (^FTSelectBlock)(NSString *appId);

@interface FTMoreApps : NSObject

@property (nonatomic, copy) FTDismissBlock willDismissBlock, didDismissBlock;
@property (nonatomic, copy) FTSelectBlock didSelectAppBlock;
@property (nonatomic) BOOL showActionButton, showPrice;
@property (nonatomic, strong) NSString *title;

+ (FTMoreApps *)sharedManager;

- (void)presentMoreAppsInViewController:(UIViewController *)viewController
                            developerId:(NSString *)devId
                        descriptionType:(FTDescriptionType)type
                             completion:(void (^)())completion;

- (void)presentMoreAppsInViewController:(UIViewController *)viewController
                                 appIds:(NSArray *)appIds
                        descriptionType:(FTDescriptionType)type
                             completion:(void (^)())completion;



@end
