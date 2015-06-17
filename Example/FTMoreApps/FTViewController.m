//
//  FTViewController.m
//  FTMoreApps
//
//  Created by Felipe Tumonis on 06/12/2015.
//  Copyright (c) 2014 Felipe Tumonis. All rights reserved.
//

#import "FTViewController.h"
#import <FTMoreApps/FTMoreApps.h>

@interface FTViewController ()

@end

@implementation FTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    
    FTMoreApps *moreAppsManager = [FTMoreApps sharedManager];
    
    [moreAppsManager presentMoreAppsInViewController:self
                                         developerId:@"318226300"
                                     descriptionType:FTDescriptionTypeScreenshots
                                          completion:nil];

    
    moreAppsManager.showActionButton = NO;
    moreAppsManager.showPrice = NO;
    moreAppsManager.title = NSLocalizedString(@"More apps", nil);
    
    moreAppsManager.willDismissBlock = ^{
        NSLog(@"will dismiss more apps view controller");
    };
    
    moreAppsManager.didDismissBlock = ^{
        NSLog(@"did dismiss more apps view controller");
    };
    
    moreAppsManager.didSelectAppBlock = ^(NSString *appId){
        NSLog(@"did select app id: %@", appId);
    };
}

@end
