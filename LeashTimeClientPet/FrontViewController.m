/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
*/

#import <CoreLocation/CoreLocation.h> 
#import "FrontViewController.h"
#import "SWRevealViewController.h"
#import "VisitsAndTracking.h"

@interface FrontViewController() <NSURLSessionDelegate> {
    
    NSMutableData *_responseData;
    VisitsAndTracking *sharedVisitsTracking;
    CLLocationManager *locationManager;
}

@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *passWord;

@end



@implementation FrontViewController

#pragma mark - View lifecycle
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
BOOL isIphone6P;
BOOL isIphone6;
BOOL isIphone5;
BOOL isIphone4;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"BG-login"]];
    background.alpha = 0.8;
    [self.view addSubview:background];
    
    UIImageView *logoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 48, 36)];
    [logoIcon setImage:[UIImage imageNamed:@"dog-LTText"]];
    [self.view addSubview:logoIcon];
    
    
    UILabel *userNameLabel;
    UILabel *passwordLabel;
    
    sharedVisitsTracking = [[VisitsAndTracking alloc]init];
    NSString *deviceType = [sharedVisitsTracking tellDeviceType];
    
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"Login-Button-504x90"] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (isIphone5){
        
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, width,height)];
        [backgroundView setImage:[UIImage imageNamed:@"BG-login"]];
        [self.view addSubview:backgroundView];
        
        UIImageView *logoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 98, 76)];
        
        [logoIcon setImage:[UIImage imageNamed:@"dog-LTText"]];
        [self.view addSubview:logoIcon];
        
        NSLog(@"is iphone 5");
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-150, height -340, 100, 20)];
        passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-150, height -290, 100, 20)];
        _loginButton.frame = CGRectMake(width/2-75, height - 230, 190,48);
        
        
        UIImageView *loginField = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-70, userNameLabel.frame.origin.y, 180, 46)];
        [loginField setImage:[UIImage imageNamed:@"login-button-gray"]];
        [self.view addSubview:loginField];
        
        UIImageView *passwordField = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-70, passwordLabel.frame.origin.y, 180, 46)];
        [passwordField setImage:[UIImage imageNamed:@"password-gray"]];
        [self.view addSubview:passwordField];
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(width/2-20,height- 340,150,26)];
        [_userName setClearsOnBeginEditing:YES];
        [_userName setTextColor:[UIColor whiteColor]];
        
        [self.view addSubview:_userName];
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(width/2-20, height- 290, 150, 26)];
        [_passWord setClearsOnBeginEditing:YES];
        [_passWord setSecureTextEntry:YES];
        [self.view addSubview:_passWord];
        
        
    } else if (isIphone4) {
        
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, width,height)];
        [backgroundView setImage:[UIImage imageNamed:@"login-bg-iphone4"]];
        [self.view addSubview:backgroundView];
        
        UIImageView *logoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 68,46)];
        [logoIcon setImage:[UIImage imageNamed:@"dog-LTText"]];
        [self.view addSubview:logoIcon];
        
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-160, height - 390, 90, 40)];
        passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-160, height - 340, 90, 40)];
        _loginButton.frame = CGRectMake(width/2-65, height - 280, 190,48);
        
        UIImageView *loginField = [[UIImageView alloc]initWithFrame:CGRectMake(userNameLabel.frame.origin.x + 100, userNameLabel.frame.origin.y, 180, 46)];
        [loginField setImage:[UIImage imageNamed:@"login-button-gray"]];
        [self.view addSubview:loginField];
        
        UIImageView *passwordField = [[UIImageView alloc]initWithFrame:CGRectMake(passwordLabel.frame.origin.x + 100, passwordLabel.frame.origin.y, 180, 46)];
        [passwordField setImage:[UIImage imageNamed:@"password-gray"]];
        [self.view addSubview:passwordField];
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(width/2,height - 390,180,26)];
        [_userName setClearsOnBeginEditing:YES];
        [_userName setTextColor:[UIColor whiteColor]];
        [self.view addSubview:_userName];
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(width/2, height - 340, 180, 26)];
        [_passWord setClearsOnBeginEditing:YES];
        [_passWord setSecureTextEntry:YES];
        [self.view addSubview:_passWord];
        
        
    } else {
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, width,height)];
        [backgroundView setImage:[UIImage imageNamed:@"BG-login"]];
        [self.view addSubview:backgroundView];
        
        UIImageView *logoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 90, 68, 56)];
        [logoIcon setImage:[UIImage imageNamed:@"dog-LTText"]];
        [self.view addSubview:logoIcon];
        
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-160, height - 400, 100, 30)];
        passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-160, height - 350, 100, 30)];
        
        UIImageView *loginField = [[UIImageView alloc]initWithFrame:CGRectMake(userNameLabel.frame.origin.x + 100, userNameLabel.frame.origin.y, 220, 46)];
        
        [loginField setImage:[UIImage imageNamed:@"login-button-gray"]];
        [self.view addSubview:loginField];
        
        UIImageView *passwordField = [[UIImageView alloc]initWithFrame:CGRectMake(passwordLabel.frame.origin.x + 100, passwordLabel.frame.origin.y, 220, 46)];
        [passwordField setImage:[UIImage imageNamed:@"password-gray"]];
        [self.view addSubview:passwordField];
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(width/2,height - 400,160,46)];
        [_userName setClearsOnBeginEditing:YES];
        [_userName setTextColor:[UIColor whiteColor]];
        
        [self.view addSubview:_userName];
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(width/2, height - 350, 160, 46)];
        [_passWord setClearsOnBeginEditing:YES];
        [_passWord setSecureTextEntry:YES];
        [self.view addSubview:_passWord];
        
        
        _loginButton.frame = CGRectMake(width/2-65, height - 300, 230,48);
        [self.view addSubview:_loginButton];
    }
    
    [userNameLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Bold" size:12]];
    [userNameLabel setText:@"USERNAME"];
    [self.view addSubview:userNameLabel];
    
    [passwordLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Bold" size:12]];
    [passwordLabel setText:@"PASSWORD"];
    [self.view addSubview:passwordLabel];
    
    NSUserDefaults *loginSettings = [NSUserDefaults standardUserDefaults];
    
    if ([loginSettings objectForKey:@"username"] != NULL) {
        
        _userName.text = [loginSettings objectForKey:@"username"];
        
        
    }
    
	self.title = NSLocalizedString(@"My Pet App", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
        style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
        style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }

}


- (void)startLocationTracking {
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:@"You currently have all location services for this device disabled"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
        
    } else {
        
        
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            
        } else {
            
            if(IS_OS_8_OR_LATER) {
                [locationManager requestAlwaysAuthorization];
            }
            
            [locationManager startUpdatingLocation];

        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

            
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
            
            break;
            
        default:
        {
            
        }
            break;
    }
}



-(void)loginButtonClick {
    
    NSString *userName = _userName.text;
    NSString *password = _passWord.text;
    
    [_loginButton setAlpha:0.3];
    
    if ([password isEqualToString:@""]) {
        NSLog(@"no password");
        password = @"dy2132";
    }
    
    
    NSUserDefaults *loginSetting = [NSUserDefaults standardUserDefaults];
    [loginSetting setObject:userName forKey:@"username"];
    [loginSetting setObject:password forKey:@"password"];
    
    sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    [sharedVisitsTracking loginAndGetVisitData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pollingUpdates)
                                                 name:@"pollingCompleteWithChanges"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pollingFailed)
                                                 name:@"pollingFailed"
                                               object:nil];
}


-(void)pollingUpdates {
    
    [self.view removeFromSuperview];
}


-(void)pollingFailed {
    
    UILabel *labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(_loginButton.frame.origin.x, _loginButton.frame.origin.y-50, 300, 20)];
    [labelFailure setText:@"Failed to Login"];
    [labelFailure setTextColor:[UIColor redColor]];
    [labelFailure setFont:[UIFont fontWithName:@"Lato-Bold" size:20]];
    [self.view addSubview:labelFailure];
    
}




@end