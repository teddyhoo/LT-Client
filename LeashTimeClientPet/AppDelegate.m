//
//  AppDelegate.m
//  LeashTimePetOwner
//
//  Created by Ted Hooban on 5/4/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "FrontViewController.h"
#import "RearViewController.h"
#import "RightViewController.h"
#import "CustomAnimationController.h"
#import "PhotoGallery.h"
#import "VisitsAndTracking.h"

@interface AppDelegate()<SWRevealViewControllerDelegate>
@end



@implementation AppDelegate


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@synthesize window = _window;
@synthesize viewController = _viewController;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    _sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    
    if (IS_IPHONE_6P) {
        NSLog(@"is iphone6p app delegate");
        [_sharedVisitsTracking setDeviceType:@"iPhone6P"];
        
    } else if (IS_IPHONE_6) {
        NSLog(@"is iphone6");
        
        [_sharedVisitsTracking setDeviceType:@"iPhone6"];
        
    } else if (IS_IPHONE_5) {
        
        NSLog(@"is iphone5");
        
        [_sharedVisitsTracking setDeviceType:@"iPhone5"];
        
    } else if (IS_IPHONE_4_OR_LESS) {
        
        [_sharedVisitsTracking setDeviceType:@"iPhone6P"];
        
    } else if (IS_IPAD) {
        
        [_sharedVisitsTracking setDeviceType:@"iPhone6P"];
    }
    
    
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    
    FrontViewController *frontViewController = [[FrontViewController alloc] init];
    RearViewController *rearViewController = [[RearViewController alloc] init];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    frontNavigationController.toolbarHidden = YES;
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc]
                                                initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    
    
    RightViewController *rightViewController = rightViewController = [[RightViewController alloc] init];
    rightViewController.view.backgroundColor = [UIColor greenColor];
    
    PhotoGallery *photoViewController = [[PhotoGallery alloc]init];
    photoViewController.view.backgroundColor = [UIColor whiteColor];
    revealController.rightViewController = photoViewController;
    
    
    self.viewController = revealController;
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {

    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
 


}

- (void)applicationWillTerminate:(UIApplication *)application {

    
    
    
}

@end
