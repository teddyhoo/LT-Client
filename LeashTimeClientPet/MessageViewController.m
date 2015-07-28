//
//  MessageViewController.m
//  LeashTimeSitter
//
//  Created by Ted Hooban on 10/25/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import "MessageViewController.h"
#import "VisitDetails.h"
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h> 


#include <tgmath.h>


@interface MessageViewController () <UITextViewDelegate,MFMailComposeViewControllerDelegate> {
    
    NSMutableData *_responseData;
}


@property (nonatomic,strong) UILabel *petName;
@property (nonatomic,strong) UILabel *timeOfArrival;
@property (nonatomic,strong) UILabel *timeOfCompletion;
@property (nonatomic,strong) UILabel *serviceName;
@property (nonatomic,strong) UILabel *lastSentDate;

@property (nonatomic,strong) UIButton *pooButton;
@property (nonatomic,strong) UIButton *peeButton;
@property (nonatomic,strong) UIButton *happyButton;
@property (nonatomic,strong) UIButton *sadButton;
@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UIButton *angryButton;
@property (nonatomic,strong) UIButton *hungryButton;
@property (nonatomic,strong) UIButton *sickButton;
@property (nonatomic,strong) UIButton *shyButton;
@property (nonatomic,strong) UIButton *catButton;
@property (nonatomic,strong) UIButton *scoopLitter;

@property CGPoint button1point;
@property CGPoint button2point;
@property CGPoint button3point;
@property CGPoint button4point;
@property CGPoint button5point;
@property CGPoint button6point;
@property CGPoint button7point;
@property CGPoint button8point;
@property CGPoint button9point;
@property CGPoint button10point;
@property CGPoint button11point;
@property CGPoint button12point;

@property (nonatomic,strong) UIImageView *mapSnap;

@property (nonatomic,strong) UIImage *angryImage;
@property (nonatomic,strong) UIImage *catImage;
@property (nonatomic,strong) UIImage *happyImage;
@property (nonatomic,strong) UIImage *hungryImage;
@property (nonatomic,strong) UIImage *scoopLitterImage;
@property (nonatomic,strong) UIImage *playImage;
@property (nonatomic,strong) UIImage *peeButtonImage;
@property (nonatomic,strong) UIImage *pooButtonImage;
@property (nonatomic,strong) UIImage *sadImage;
@property (nonatomic,strong) UIImage *shyImage;
@property (nonatomic,strong) UIImage *sickImage;

@property (nonatomic,strong) UIButton *checkMarkNote;
@property (nonatomic,strong) UIView* buttonsView;
@property (nonatomic,strong) UIButton *sendMail;
@property (nonatomic,strong) UIImage *petImage;

@property BOOL keyboardVisible;
@property CGRect keyboardRect;

@property CGFloat height;
@property CGFloat width;

@property BOOL isIphone4;
@property BOOL isIphone5;
@property BOOL isIphone6;
@property BOOL isIphone6P;


@end


int imageIndex = 0;


@implementation MessageViewController

-(id)init
{
    self = [super init];
    if(self){
        
        

    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    NSString *theDeviceType = [_sharedVisitsTracking tellDeviceType];

    
    
    if ([theDeviceType isEqualToString:@"iPhone6P"]) {
        _isIphone6P = YES;
        _isIphone6 = NO;
        _isIphone5 = NO;
        _isIphone4 = NO;
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(12, 410, 390, 320)];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;
        self.mapView.userInteractionEnabled = YES;
        [self.view addSubview:_mapView];
        

    } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
        _isIphone6 = YES;
        _isIphone6P = NO;
        _isIphone5 = NO;
        _isIphone4 = NO;
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(10, 375, 355, 320)];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;
        self.mapView.userInteractionEnabled = YES;
        [self.view addSubview:_mapView];
        
        
    } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
        _isIphone5 = YES;
        _isIphone6P = NO;
        _isIphone6 = NO;
        _isIphone4 = NO;
    }
    
    _isIphone6P = YES;
    _height = self.view.bounds.size.height;
    _sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    
    myVisitData = [[NSMutableArray alloc]init];
    NSLog(@"got visit data");
    myVisitData = [_sharedVisitsTracking getTodayVisits];
    NSLog(@"finished get visit data");
    
    for (VisitDetails *visit in myVisitData) {
        if ([visit.appointmentid isEqualToString:_sharedVisitsTracking.onWhichVisitID]) {
            
            _currentVisit = visit;
        }
    }
    if (_isIphone6P) {
        
        
        
        
    } else if (_isIphone6) {
        
        
        
    } else if (_isIphone5) {
        
        
        
    } else if (_isIphone4) {
        
        
        
    }
    
    
    
    float spanX = 0.00125;
    float spanY = 0.00125;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
    
    [self layoutElements];
    [self addButtons];
    
}


- (void)didMoveToParentViewController:(UIViewController *)parent {
    
    NSLog(@"did move to parent view controller");
    
    imageIndex = 0;
    
    [_timeOfArrival removeFromSuperview];
    [_petName removeFromSuperview];
    [_serviceName removeFromSuperview];
    [_timeOfCompletion removeFromSuperview];
    [_playButton removeFromSuperview];
    [_angryButton removeFromSuperview];
    [_pooButton removeFromSuperview];
    [_peeButton removeFromSuperview];
    [_happyButton removeFromSuperview];
    [_sadButton removeFromSuperview];
    [_sickButton removeFromSuperview];
    [_hungryButton removeFromSuperview];
    [_catButton removeFromSuperview];
    [_scoopLitter removeFromSuperview];
    [_shyButton removeFromSuperview];
    [_lastSentDate removeFromSuperview];
    [_mapSnap removeFromSuperview];
    
    NSLog(@"on which visit: %@",_sharedVisitsTracking.onWhichVisitID);
    
    for (VisitDetails *visit in myVisitData) {
        if ([visit.appointmentid isEqualToString:_sharedVisitsTracking.onWhichVisitID]) {
            
            _currentVisit = visit;
        }
    }

    UIImageView *currentPicView;
    NSString *theDeviceType = [_sharedVisitsTracking tellDeviceType];
    
    if ([theDeviceType isEqualToString:@"iPhone6P"]) {
        NSLog(@"iphone6p");

        _isIphone6P = YES;
        
    } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
        NSLog(@"iphone6");

        _isIphone6 = YES;
        
    } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
        NSLog(@"iphone5");

        _isIphone5 = YES;
        
    } else {
        _isIphone4 = YES;
    }
    
    
    if(_isIphone5) {
        currentPicView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13,100,100)];
        [currentPicView setImage:_currentVisit.currentPetImage];
        
        CAShapeLayer *circle = [CAShapeLayer layer];
        // Make a circular shape
        UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, currentPicView.frame.size.width, currentPicView.frame.size.height) cornerRadius:MAX(currentPicView.frame.size.width, currentPicView.frame.size.height)];
        
        circle.path = circularPath.CGPath;
        
        // Configure the apperence of the circle
        circle.fillColor = [UIColor blackColor].CGColor;
        circle.strokeColor = [UIColor blackColor].CGColor;
        circle.lineWidth = 0;
        
        currentPicView.layer.mask=circle;
        
        _sendMail.frame = CGRectMake(280, 100, 32, 32);
        
        _lastSentDate = [[UILabel alloc]initWithFrame:CGRectMake(280, 65, 120, 20)];
        [_lastSentDate setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
        if(![_currentVisit.dateTimeVisitReportSubmit isEqual:[NSNull null]] && [_currentVisit.dateTimeVisitReportSubmit length] != 0) {
            
            [_lastSentDate setText:_currentVisit.dateTimeVisitReportSubmit];
            
        } else {
            
            [_lastSentDate setText:@" "];
        }
    } else if (_isIphone4) {
        
        currentPicView =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 140, 180)];
        [currentPicView setImage:_currentVisit.currentPetImage];

        [self.view addSubview:currentPicView];
        
        _sendMail.frame = CGRectMake(260, 10, 32, 32);
        
        
        _lastSentDate = [[UILabel alloc]initWithFrame:CGRectMake(260, 65, 120, 20)];
        [_lastSentDate setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
        if(![_currentVisit.dateTimeVisitReportSubmit isEqual:[NSNull null]] && [_currentVisit.dateTimeVisitReportSubmit length] != 0) {
            
            [_lastSentDate setText:_currentVisit.dateTimeVisitReportSubmit];
            
        } else {
            
            [_lastSentDate setText:@" "];
        }
        
        
    } else if (_isIphone6P){
        
        NSLog(@"iphone6p");

        currentPicView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18,124,124)];
        [currentPicView setImage:_currentVisit.currentPetImage];
        
        CAShapeLayer *circle = [CAShapeLayer layer];
        // Make a circular shape
        UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, currentPicView.frame.size.width, currentPicView.frame.size.height) cornerRadius:MAX(currentPicView.frame.size.width, currentPicView.frame.size.height)];
        
        circle.path = circularPath.CGPath;
        
        // Configure the apperence of the circle
        circle.fillColor = [UIColor blackColor].CGColor;
        circle.strokeColor = [UIColor blackColor].CGColor;
        circle.lineWidth = 0;
        
        currentPicView.layer.mask=circle;
        
        _sendMail.frame = CGRectMake(370, 125, 30, 30);
        
        _lastSentDate = [[UILabel alloc]initWithFrame:CGRectMake(300, 145, 120, 20)];
        [_lastSentDate setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
        if(![_currentVisit.dateTimeVisitReportSubmit isEqual:[NSNull null]] && [_currentVisit.dateTimeVisitReportSubmit length] != 0) {
            NSLog(@"last sent date: %@",_currentVisit.dateTimeVisitReportSubmit);
            NSString *lastSent = [NSString stringWithFormat:@"%@",_currentVisit.dateTimeVisitReportSubmit];
            [_lastSentDate setText:lastSent];

        } else {
            NSLog(@"last sent date: %@",_currentVisit.dateTimeVisitReportSubmit);
            [_lastSentDate setText:@" "];
        }
        
        
    } else if (_isIphone6) {
 
        
        currentPicView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 124, 124)];
        [currentPicView setImage:_currentVisit.currentPetImage];
        
        CAShapeLayer *circle = [CAShapeLayer layer];
        // Make a circular shape
        UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, currentPicView.frame.size.width, currentPicView.frame.size.height) cornerRadius:MAX(currentPicView.frame.size.width, currentPicView.frame.size.height)];
        
        circle.path = circularPath.CGPath;
        
        // Configure the apperence of the circle
        circle.fillColor = [UIColor blackColor].CGColor;
        circle.strokeColor = [UIColor blackColor].CGColor;
        circle.lineWidth = 0;
        
        currentPicView.layer.mask=circle;
        
        _sendMail.frame = CGRectMake(300,300, 32, 32);
        
        _lastSentDate = [[UILabel alloc]initWithFrame:CGRectMake(340, 145, 120, 20)];
        [_lastSentDate setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
        if(![_currentVisit.dateTimeVisitReportSubmit isEqual:[NSNull null]] && [_currentVisit.dateTimeVisitReportSubmit length] != 0) {
            
            [_lastSentDate setText:_currentVisit.dateTimeVisitReportSubmit];
            
        } else {
            
            [_lastSentDate setText:@" "];
        }
        
    }
    
    [self.view addSubview:_mapView];
    [self.view addSubview:currentPicView];
    [self.view addSubview:_checkMarkNote];
    [self.view addSubview:_lastSentDate];
    [self addVisitInfoToView];
    [self addButtons];
}

-(void)layoutElements {

    NSLog(@"called layout elements");
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backgroundView2;

    UIImageView *headerBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 90)];
    UIImage *headBackFile = [UIImage imageNamed:@"header-white"];
    [headerBack setImage:headBackFile];
    [headerBack setAlpha:0.5];
    
    UIImageView *arrivalButton = [[UIImageView alloc]initWithFrame:CGRectMake(5, 320, 20, 20)];
    [arrivalButton setImage:[UIImage imageNamed:@"arrive-blue-100x100"]];
    
    UIImageView *completedButton = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-20, 320, 20, 20)];
    [completedButton setImage:[UIImage imageNamed:@"check-mark-circle"]];
    
    _sendMail = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkMarkNote = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(_isIphone6P) {
        _sendMail.frame = CGRectMake(300, 300, 32, 32);
        backgroundView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,60, self.view.bounds.size.width, self.view.bounds.size.height)];
        [backgroundView2 setImage:[UIImage imageNamed:@"messageVC"]];

    } else if (_isIphone6) {
        _sendMail.frame = CGRectMake(300, 100, 32, 32);
        backgroundView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [backgroundView2 setImage:[UIImage imageNamed:@"messageBG-iphone6"]];
    } else if (_isIphone5) {
        _sendMail.frame = CGRectMake(280, 100, 32, 32);
        backgroundView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [backgroundView2 setImage:[UIImage imageNamed:@"messageBG-iphone5"]];
    } else if (_isIphone4) {
        _sendMail.frame = CGRectMake(280, 10, 32, 32);
    }
    
    [_sendMail setBackgroundImage:[UIImage imageNamed:@"envelope-128x128"] forState:UIControlStateNormal];
    [_sendMail addTarget:self action:@selector(sendMessageToClient) forControlEvents:UIControlEventTouchUpInside];
    
    [_checkMarkNote addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [_checkMarkNote setBackgroundImage:[UIImage imageNamed:@"add-note-button-1"] forState:UIControlStateNormal];

    [self.view addSubview:backgroundView2];
    //[backgroundView addSubview:backgroundView2];

    [backgroundView2 addSubview:arrivalButton];
    [backgroundView2 addSubview:completedButton];
    [self.view addSubview:_sendMail];
    [self.view addSubview:_checkMarkNote];
    
    
}


-(void)addVisitInfoToView {
    
    
    for (VisitDetails *visit in _sharedVisitsTracking.visitData) {
        if ([visit.appointmentid isEqualToString:_sharedVisitsTracking.onWhichVisitID]) {
            
            _petName = [[UILabel alloc]initWithFrame:CGRectMake(25, 145, 200, 26)];
            [_petName setText:visit.petName];
            [_petName setFont:[UIFont fontWithName:@"Lato-Bold" size:20]];
            [_petName setTextColor:[UIColor blackColor]];
            //petName.alpha = 0.9;
            
            [self.view addSubview:_petName];
            
            _timeOfArrival = [[UILabel alloc]initWithFrame:CGRectMake(25, 320, 100, 18)];
            [_timeOfArrival setText:visit.dateTimeMarkArrive];
            [_timeOfArrival setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
            [self.view addSubview:_timeOfArrival];
            
            _timeOfCompletion = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 320, 100, 18)];
            NSLog(@"visit id: %@, mark complete: %@",visit.appointmentid,visit.dateTimeMarkComplete);
            [_timeOfCompletion setText:visit.dateTimeMarkComplete];
            [_timeOfCompletion setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
            [self.view addSubview:_timeOfCompletion];
            
            _serviceName = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-90, 320, 280, 22)];
            [_serviceName setText:visit.service];
            [_serviceName setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
            [self.view addSubview:_serviceName];
            
        }
    }
}

-(void)addButtons {
    
    _buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-40)];
    [_buttonsView setBackgroundColor:[UIColor clearColor]];
    
    _angryImage = [UIImage imageNamed:@"angry-border2"];
    _catImage = [UIImage imageNamed:@"catsit-border2"];
    _happyImage = [UIImage imageNamed:@"happy-border2"];
    _hungryImage = [UIImage imageNamed:@"hungry-border2"];
    _scoopLitterImage = [UIImage imageNamed:@"litter-border2"];
    _playImage = [UIImage imageNamed:@"play-border2"];
    _peeButtonImage = [UIImage imageNamed:@"number-1-border2"];
    _pooButtonImage = [UIImage imageNamed:@"number-2-border2"];
    _sadImage = [UIImage imageNamed:@"sad-border2"];
    _shyImage = [UIImage imageNamed:@"shy-button-10"];
    _sickImage = [UIImage imageNamed:@"sick-border2"];

    _peeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _peeButton.tag = 2;
    [_peeButton addTarget:self action:@selector(peeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_peeButton setBackgroundImage:_peeButtonImage forState:UIControlStateNormal];

    _pooButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pooButton.tag = 1;
    [_pooButton addTarget:self action:@selector(pooButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_pooButton setBackgroundImage:_pooButtonImage forState:UIControlStateNormal];

    _shyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shyButton.tag = 9;
    [_shyButton addTarget:self action:@selector(shyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_shyButton setBackgroundImage:_shyImage forState:UIControlStateNormal];
    [_shyButton setTitle:@"SHY" forState:UIControlStateNormal];
    _shyButton.titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:16];
    
    
    _happyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _happyButton.tag = 3;
    [_happyButton addTarget:self action:@selector(happyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_happyButton setBackgroundImage:_happyImage forState:UIControlStateNormal];

    _hungryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hungryButton.tag = 7;
    [_hungryButton addTarget:self action:@selector(hungryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_hungryButton setBackgroundImage:_hungryImage forState:UIControlStateNormal];
    
    
    _sadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sadButton.tag = 4;
    [_sadButton addTarget:self action:@selector(sadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_sadButton setBackgroundImage:_sadImage forState:UIControlStateNormal];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.tag = 5;
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundImage:_playImage forState:UIControlStateNormal];
    
    _angryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _angryButton.tag = 6;
    [_angryButton addTarget:self action:@selector(angryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_angryButton setBackgroundImage:_angryImage forState:UIControlStateNormal];
    
    _sickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sickButton.tag = 8;
    [_sickButton addTarget:self action:@selector(sickButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_sickButton setBackgroundImage:_sickImage forState:UIControlStateNormal];

    _catButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _catButton.tag = 10;
    [_catButton addTarget:self action:@selector(catSitClick) forControlEvents:UIControlEventTouchUpInside];
    [_catButton setBackgroundImage:_catImage forState:UIControlStateNormal];
    
    _scoopLitter = [UIButton buttonWithType:UIButtonTypeCustom];
    _scoopLitter.tag = 11;
    [_scoopLitter addTarget:self action:@selector(scoopLitterClick) forControlEvents:UIControlEventTouchUpInside];
    [_scoopLitter setBackgroundImage:_scoopLitterImage forState:UIControlStateNormal];

    if (_isIphone4) { // iPhone4/4s
        
        _pooButton.frame = CGRectMake(10, _height-100, 50, 50);
        _peeButton.frame = CGRectMake(70, _height-100, 50, 50);
        _happyButton.frame = CGRectMake(130, _height-100, 50, 50);
        _playButton.frame = CGRectMake(190,_height-100,50,50);
        _hungryButton.frame = CGRectMake(250,_height-100,50,50);
        _shyButton.frame = CGRectMake(190,_height-280,50,50);
        _scoopLitter.frame = CGRectMake(250, _height-280, 50, 50);
        _catButton.frame = CGRectMake(250, _height-160, 50, 50);
        _angryButton.frame = CGRectMake(190,_height-220,50,50);
        _sickButton.frame = CGRectMake(250,_height-220,50,50);
        _sadButton.frame = CGRectMake(190, _height-160, 50, 50);


    } else if (_isIphone5) { // iPhone5c/s
        
        _happyButton.frame = CGRectMake(100, 10, 40,40);
        _pooButton.frame = CGRectMake(160, 10, 40, 40);
        _peeButton.frame = CGRectMake(200, 10, 40, 40);
        _hungryButton.frame = CGRectMake(240,10,40,40);
        _playButton.frame = CGRectMake(280,10,40,40);
        _catButton.frame = CGRectMake(120,50, 40, 40);
        _scoopLitter.frame = CGRectMake(160,50, 40, 40);
        _shyButton.frame = CGRectMake(200,50,40,40);
        _angryButton.frame = CGRectMake(240,50,40,40);
        _sadButton.frame = CGRectMake(280, 50, 40, 40);
        _sickButton.frame = CGRectMake(120,90,40,40);
        
    } else if (_isIphone6) {
        
        _peeButton.frame = CGRectMake(130, 10, 40, 40);
        _happyButton.frame = CGRectMake(170, 10, 40, 40);
        _playButton.frame = CGRectMake(210, 10,40,40);
        _hungryButton.frame = CGRectMake(250, 10, 40,40);
        _scoopLitter.frame = CGRectMake(290, 10, 40, 40);
        _catButton.frame = CGRectMake(330, 10, 40, 40);
        _angryButton.frame = CGRectMake(150, 55,40,40);
        _sickButton.frame = CGRectMake(230,55,40,40);
        _sadButton.frame = CGRectMake(270, 55, 40, 40);
        _shyButton.frame = CGRectMake(310, 55, 40, 40);
        _pooButton.frame = CGRectMake(190, 55, 40, 40);

    } else if (_isIphone6P) {
        
        NSLog(@"is Iphone 6 mood button print");

        _happyButton.frame = CGRectMake(145, 80, 40, 40);
        _sadButton.frame = CGRectMake(188, 80, 40, 40);
        _shyButton.frame = CGRectMake(231, 80, 40, 40);
        _angryButton.frame = CGRectMake(274, 80,40,40);
        _pooButton.frame = CGRectMake(317, 80, 40, 40);
        _playButton.frame = CGRectMake(360, 80,40,40);

        _hungryButton.frame = CGRectMake(360, 125, 40,40);
        _catButton.frame = CGRectMake(188, 125, 40, 40);
        _sickButton.frame = CGRectMake(231, 125,40,40);
        _scoopLitter.frame = CGRectMake(274, 125, 40, 40);
        _peeButton.frame = CGRectMake(317, 125, 40, 40);

    }

    [self.view addSubview:_peeButton];
    [self.view addSubview:_pooButton];
    [self.view addSubview:_catButton];
    [self.view addSubview:_sadButton];
    [self.view addSubview:_happyButton];
    [self.view addSubview:_hungryButton];
    [self.view addSubview:_playButton];
    [self.view addSubview:_angryButton];
    [self.view addSubview:_sickButton];
    [self.view addSubview:_shyButton];
    [self.view addSubview:_scoopLitter];

    _button1point = _pooButton.frame.origin;
    _button2point = _peeButton.frame.origin;
    _button9point = _shyButton.frame.origin;
    _button11point = _scoopLitter.frame.origin;
    _button5point = _playButton.frame.origin;
    _button3point = _happyButton.frame.origin;
    _button6point = _angryButton.frame.origin;
    _button4point = _sadButton.frame.origin;
    _button10point = _catButton.frame.origin;
    _button8point = _sickButton.frame.origin;
    _button7point =_hungryButton.frame.origin;
    
    if (_currentVisit.didPoo) {
        [_pooButton setAlpha:1.0];
        [self animateStatusButtonOn:_pooButton];

    } else {
        [_pooButton setAlpha:0.9];
    }
    
    if (_currentVisit.didPee) {
        [_peeButton setAlpha:1.0];
        [self animateStatusButtonOn:_peeButton];
    } else {
        [_peeButton setAlpha:0.9];
    }
    
    if (_currentVisit.wasHappy) {
        [_happyButton setAlpha:1.0];
        [self animateStatusButtonOn:_happyButton];
    } else {
        [_happyButton setAlpha:0.9];
    }
    if (_currentVisit.wasSad) {
        [_sadButton setAlpha:1.0];
        [self animateStatusButtonOn:_sadButton];
    } else {
        [_sadButton setAlpha:0.9];
    }
    if(_currentVisit.didPlay) {
        [_playButton setAlpha:1.0];
        [self animateStatusButtonOn:_playButton];
    } else {
        [_playButton setAlpha:0.9];
    }
    if (_currentVisit.wasHungry) {
        [_hungryButton setAlpha:1.0];
        [self animateStatusButtonOn:_hungryButton];
    } else {
        [_hungryButton setAlpha:0.9];
    }
    if (_currentVisit.wasSick) {
        [_sickButton setAlpha:1.0];
        [self animateStatusButtonOn:_sickButton];
    } else {
        [_sickButton setAlpha:0.9];
    }
    if (_currentVisit.wasAngry) {
        [_angryButton setAlpha:1.0];
        [self animateStatusButtonOn:_angryButton];
    } else {
        [_angryButton setAlpha:0.9];
    }
    if (_currentVisit.wasShy) {
        [_shyButton setAlpha:1.0];
        [self animateStatusButtonOn:_shyButton];
    } else {
        [_shyButton setAlpha:0.9];
    }
    if (_currentVisit.didScoopLitter) {
        [_scoopLitter setAlpha:1.0];
        [self animateStatusButtonOn:_scoopLitter];
    } else {
        [_scoopLitter setAlpha:0.9];
    }
    if (_currentVisit.wasCat) {
        [_catButton setAlpha:1.0];
        [self animateStatusButtonOn:_catButton];
    } else {
        [_catButton setAlpha:0.9];
    }
}

-(void)animateStatusButtonOn:(UIView*)buttonView {
    if (_isIphone4) {
        CGRect newFrame = CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y, buttonView.frame.size.width/2, buttonView.frame.size.height/1.8);
        newFrame.origin.x = imageIndex * 30 - 20;
        [UIView animateWithDuration:1.0 animations:^{
            buttonView.frame = newFrame;
        }];
    } else if (_isIphone5) {
        
        CGRect newFrame = CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y, buttonView.frame.size.width, buttonView.frame.size.height);
        newFrame.origin.x = imageIndex * 40 + 20;
        newFrame.origin.y = _petPicFrame.frame.size.height + 140;
        [UIView animateWithDuration:1.0 animations:^{
            buttonView.frame = newFrame;
        }];
        
    } else if (_isIphone6) {
        
        CGRect newFrame = CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y, buttonView.frame.size.width, buttonView.frame.size.height);
        newFrame.origin.x = imageIndex * 40 + 20;
        newFrame.origin.y = _petPicFrame.frame.size.height + 140;
        [UIView animateWithDuration:1.0 animations:^{
            buttonView.frame = newFrame;
        }];
    } else if (_isIphone6P) {
        
        CGRect newFrame = CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y, buttonView.frame.size.width, buttonView.frame.size.height);
        newFrame.origin.x = imageIndex * 40 + 20;
        newFrame.origin.y = _petPicFrame.frame.size.height + 140;
        [UIView animateWithDuration:1.0 animations:^{
            buttonView.frame = newFrame;
        }];
    }
    imageIndex++;
    
}

-(void)animateStatusButtonOff:(UIView*)buttonView {
    
    imageIndex--;
    
    CGRect newFrame = buttonView.frame;
    newFrame.size.width = newFrame.size.width;
    newFrame.size.height = newFrame.size.height;
    
    if(buttonView.tag == 1) {
        newFrame.origin = _button1point;
    } else if (buttonView.tag == 2) {
        newFrame.origin = _button2point;
    } else if (buttonView.tag == 3) {
        newFrame.origin = _button3point;
    } else if (buttonView.tag == 4) {
        newFrame.origin = _button4point;
    } else if (buttonView.tag == 5) {
        newFrame.origin = _button5point;
    } else if (buttonView.tag == 6) {
        newFrame.origin = _button6point;
    } else if (buttonView.tag == 7) {
        newFrame.origin = _button7point;
    } else if (buttonView.tag == 8) {
        newFrame.origin = _button8point;
    } else if (buttonView.tag == 9) {
        newFrame.origin = _button9point;
    } else if (buttonView.tag == 10) {
        newFrame.origin = _button10point;
    } else if (buttonView.tag == 11) {
        newFrame.origin = _button11point;
    } else if (buttonView.tag == 12) {
        newFrame.origin = _button12point;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        buttonView.frame = newFrame;
    }];
    
}

-(void)shyButtonClick {
    if (_shyButton.alpha == 1.0) {
        [_shyButton setAlpha:0.9];
        _currentVisit.wasShy = NO;
        [self animateStatusButtonOff:_shyButton];
    } else {
        [_shyButton setAlpha:1.0];
        _currentVisit.wasShy = YES;
        [self animateStatusButtonOn:_shyButton];
    }
    
}

-(void)catSitClick {
    if (_catButton.alpha == 1.0) {
        [_catButton setAlpha:0.9];
        _currentVisit.wasCat = NO;
        [self animateStatusButtonOff:_catButton];
    } else {
        [_catButton setAlpha:1.0];
        _currentVisit.wasCat = YES;
        [self animateStatusButtonOn:_catButton];
        
    }
    
}

-(void)scoopLitterClick {
    if (_scoopLitter.alpha == 1.0) {
        [_scoopLitter setAlpha:0.9];
        _currentVisit.didScoopLitter = NO;
        [self animateStatusButtonOff:_scoopLitter];
    } else {
        [_scoopLitter setAlpha:1.0];
        _currentVisit.didScoopLitter = YES;
        [self animateStatusButtonOn:_scoopLitter];
    }
    
}


-(void)sickButtonClick {
    
    if (_sickButton.alpha == 1.0) {
        [_sickButton setAlpha:0.9];
        _currentVisit.wasSick = NO;
        [self animateStatusButtonOff:_sickButton];

    } else {
        [_sickButton setAlpha:1.0];
        _currentVisit.wasSick = YES;
        [self animateStatusButtonOn:_sickButton];

    }
    
}
-(void)hungryButtonClick {
    
    if(_hungryButton.alpha == 1.0) {
        [_hungryButton setAlpha:0.9];
        _currentVisit.wasHungry = NO;
        [self animateStatusButtonOff:_hungryButton];

    } else {
        [_hungryButton setAlpha:1.0];
        _currentVisit.wasHungry = YES;
        [self animateStatusButtonOn:_hungryButton];
    }
}


-(void)angryButtonClick {
    
    if(_angryButton.alpha == 1.0) {
        
        [_angryButton setAlpha:0.9];
        _currentVisit.wasAngry = NO;
        [self animateStatusButtonOff:_angryButton];

        
    } else {
        
        [_angryButton setAlpha:1.0];
        _currentVisit.wasAngry = YES;
        [self animateStatusButtonOn:_angryButton];
        
        
    }
}

-(void)playButtonClick {
    
    if(_playButton.alpha == 1.0) {
    
        [_playButton setAlpha:0.9];
        _currentVisit.didPlay = NO;
        [self animateStatusButtonOff:_playButton];

    
    } else {
        
        [_playButton setAlpha:1.0];
        _currentVisit.didPlay = YES;
        [self animateStatusButtonOn:_playButton];
    }
}

-(void)happyButtonClick {
    
    if (_happyButton.alpha == 1.0) {
        [_happyButton setAlpha:0.9];
        _currentVisit.wasHappy = NO;
        [self animateStatusButtonOff:_happyButton];

    } else {
        [_happyButton setAlpha:1.0];
        _currentVisit.wasHappy = YES;
        [self animateStatusButtonOn:_happyButton];
    }
    
}

-(void)sadButtonClick {
    
    if(_sadButton.alpha == 1.0) {
        
        [_sadButton setAlpha:0.9];
        _currentVisit.wasSad = NO;
        [self animateStatusButtonOff:_sadButton];

    } else {
        [_sadButton setAlpha:1.0];
        _currentVisit.wasSad = YES;
        [self animateStatusButtonOn:_sadButton];
    }
    
}


-(void)pooButtonClick {
    
    if (_pooButton.alpha == 1.0) {
        [_pooButton setAlpha:0.9];
        _currentVisit.didPoo = NO;
        [self animateStatusButtonOff:_pooButton];

        
    } else {
        [_pooButton setAlpha:1.0];
        _currentVisit.didPoo = YES;
        [self animateStatusButtonOn:_pooButton];

    }
}

-(void)peeButtonClick {
    
    if (_peeButton.alpha == 1.0) {
        [_peeButton setAlpha:0.9];
        _currentVisit.didPee = NO;
        [self animateStatusButtonOff:_peeButton];

    } else {
        [_peeButton setAlpha:1.0];
        _currentVisit.didPee = YES;
        [self animateStatusButtonOn:_peeButton];
    }
}


-(void)sendMessageToClient {
    
    NSLog(@"connecting to server....");
    NSDate *rightNow = [NSDate date];
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"HH:mm a"];
    NSString *dateTimeString = [dateFormat stringFromDate:rightNow];
    
    _currentVisit.dateTimeVisitReportSubmit = dateTimeString;
    
    [_currentVisit writeVisitDataToFile];
    
    NSString *arriveTime = _timeOfArrival.text;
    NSString *completionTime = _timeOfCompletion.text;
    
    NSString *moodButton = @"buttons={";

    
    if(_currentVisit.didPee) {
        NSString *peeMood = @"\"pee\":\"yes\"";
        moodButton = [moodButton stringByAppendingString:peeMood];
    } else if (!_currentVisit.didPee) {
        NSString *peeMood = @"\"pee\":\"no\"";
        moodButton = [moodButton stringByAppendingString:peeMood];
    }
    if(_currentVisit.didPoo) {
        moodButton = [moodButton stringByAppendingString:@",\"poo\":\"yes\""];
    } else if (!_currentVisit.didPoo) {
        moodButton = [moodButton stringByAppendingString:@",\"poo\":\"no\""];
    }
    if(_currentVisit.didPlay) {
        moodButton = [moodButton stringByAppendingString:@",\"play\":\"yes\""];
    } else if (!_currentVisit.didPlay) {
        moodButton = [moodButton stringByAppendingString:@",\"play\":\"no\""];
    }
    if(_currentVisit.wasHappy) {
        moodButton = [moodButton stringByAppendingString:@",\"happy\":\"yes\""];
    } else if (!_currentVisit.wasHappy) {
        moodButton = [moodButton stringByAppendingString:@",\"happy\":\"no\""];
    }
    if(_currentVisit.wasHungry) {
        moodButton = [moodButton stringByAppendingString:@",\"hungry\":\"yes\""];
    } else if (!_currentVisit.wasHungry) {
        moodButton = [moodButton stringByAppendingString:@",\"hungry\":\"no\""];
    }
    if(_currentVisit.wasAngry) {
        moodButton = [moodButton stringByAppendingString:@",\"angry\":\"yes\""];
    } else if (!_currentVisit.didPee) {
        moodButton = [moodButton stringByAppendingString:@",\"angry\":\"no\""];
    }
    if(_currentVisit.wasShy) {
        moodButton = [moodButton stringByAppendingString:@",\"shy\":\"yes\""];
    } else if (!_currentVisit.wasShy) {
        moodButton = [moodButton stringByAppendingString:@",\"shy\":\"no\""];
    }
    if(_currentVisit.wasSad) {
        moodButton = [moodButton stringByAppendingString:@",\"sad\":\"yes\""];
    } else if (!_currentVisit.wasSad) {
        moodButton = [moodButton stringByAppendingString:@",\"sad\":\"no\""];
    }
    if(_currentVisit.wasSick) {
        moodButton = [moodButton stringByAppendingString:@",\"sick\":\"yes\""];
    } else if (!_currentVisit.wasSick) {
        moodButton = [moodButton stringByAppendingString:@",\"sick\":\"no\""];
    }
    if(_currentVisit.wasCat) {
        moodButton = [moodButton stringByAppendingString:@",\"cat\":\"yes\""];
    } else if (!_currentVisit.wasShy) {
        moodButton = [moodButton stringByAppendingString:@",\"cat\":\"no\""];
    }
    if(_currentVisit.didScoopLitter) {
        moodButton = [moodButton stringByAppendingString:@",\"litter\":\"yes\""];
    } else if (!_currentVisit.didScoopLitter) {
        moodButton = [moodButton stringByAppendingString:@",\"litter\":\"no\""];
    }
    
    NSString *closeMood = @"}";
    
    moodButton = [moodButton stringByAppendingString:closeMood];
    
}

-(void)sendNote:(NSString*)note
          moods:(NSString*)moodButtons
       latitude:(NSString*)currentLatitude
      longitude:(NSString*)currentLongitude
     markArrive:(NSString*)arriveTime
   markComplete:(NSString*)completionTime {
    
    
    NSDate *rightNow = [NSDate date];
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateTimeString = [dateFormat stringFromDate:rightNow];

    NSUserDefaults *loginSetting = [NSUserDefaults standardUserDefaults];
    NSString *username = [loginSetting objectForKey:@"username"];
    NSString *pass = [loginSetting objectForKey:@"password"];

    NSString *appointmentID = _currentVisit.appointmentid;
    
    NSString *parameterData = [NSString stringWithFormat:@"loginid=%@&password=%@&datetime=%@&appointmentptr=%@&note=%@&%@&appointmentid=%@",username,pass,dateTimeString,appointmentID,note,moodButtons,appointmentID];
       
    NSLog(@"[VISIT REPORT]: %@",parameterData);
       
    NSData *requestBodyData = [parameterData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBodyData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
                                    
    [request setURL:[NSURL URLWithString:@"https://leashtime.com/native-visit-update.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0];
    [request setHTTPBody:requestBodyData];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                delegate:self];
    
    CGRect newFrame = CGRectMake(_sendMail.frame.origin.x, _sendMail.frame.origin.y, _sendMail.frame.size.width*2, _sendMail.frame.size.height*1.5);
    newFrame.origin.x = _sendMail.frame.origin.x - 30;
    newFrame.origin.y = _sendMail.frame.origin.y + 30;
    [UIView animateWithDuration:0.1 animations:^{
        _sendMail.frame = newFrame;
    }];
}

-(void)scaledownMailIcon {
    
    
    CGRect newFrame = CGRectMake(_sendMail.frame.origin.x, _sendMail.frame.origin.y, _sendMail.frame.size.width/2, _sendMail.frame.size.height/1.5);
    newFrame.origin.x = _sendMail.frame.origin.x + 30;
    newFrame.origin.y = _sendMail.frame.origin.y - 30;
    [UIView animateWithDuration:0.5 animations:^{
        _sendMail.frame = newFrame;
        _sendMail.alpha = 1.0;
    }];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _responseData = [[NSMutableData alloc]init];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_responseData appendData:data];
    [self scaledownMailIcon];
    NSString *receivedDataString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];

    if(![receivedDataString isEqualToString:@"OK"]) {
        
        
        
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSDate *rightNow = [NSDate date];
    NSDateFormatter *dateFormat2 = [NSDateFormatter new];
    [dateFormat2 setDateFormat:@"HH:mm a"];
    NSString *dateTimeString2 = [dateFormat2 stringFromDate:rightNow];
    
    [_lastSentDate setText:dateTimeString2];
    
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"received error: %@",error);
    NSUserDefaults *networkLogging = [NSUserDefaults standardUserDefaults];
    NSDate *rightNow2 = [NSDate date];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc]init];
    [dateFormat2 setDateFormat:@"HH:mm:ss MMM dd yyyy"];
    NSString *dateString2 = [dateFormat2 stringFromDate:rightNow2];
    
    NSString *failURLString = [NSString stringWithFormat:@"%@",error];
    NSString *errorDetails = error.localizedDescription;
    NSMutableDictionary *logServerError = [[NSMutableDictionary alloc]init];
    [logServerError setObject:dateString2 forKey:@"date"];
    [logServerError setObject:failURLString forKey:@"error1"];
    [logServerError setObject:errorDetails forKey:@"errorDetails"];
    [logServerError setObject:@"SEND NOTES" forKey:@"location"];
    [logServerError setObject:@"network" forKey:@"type"];
    [networkLogging setObject:logServerError forKey:dateString2];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}




- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
