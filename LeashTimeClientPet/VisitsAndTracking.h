//
//  VisitsAndTracking.h
//  LeashTimeSitter
//
//  Created by Ted Hooban on 8/13/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VisitDetails.h"

#define kCLIENTID @"FYS4IBCXJT3DYB2S4YJIYYLQRB0AECG0TAQQVMCYH2XK4MIO"
#define kCLIENTSECRET @"TZUQXDODQEH20NTJSALNDXGL4OQBTC5V4B4LZW4NSTRTMZ4T"
#define kHOSTNAME @"leashtime.com"
#define kHOSTNAMEALT @"https://leashtime.com"
#define kHOSTWEATHER @"http://api.openweathermanp.org"


@interface VisitsAndTracking : NSObject <CLLocationManagerDelegate, NSURLSessionDelegate> {
    
    NSMutableData *_responseData;
    NSString *deviceType;
    NSMutableDictionary *coordinatesForVisits;
    NSMutableArray *arrayCoordForVisits;
    
    
}

+(VisitsAndTracking *)sharedInstance;

extern NSString *const pollingCompleteWithChanges;
extern NSString *const pollingFailed;

@property(nonatomic)NSTimer *timerRequest;              // Initial login, because UI loaded before data received
@property(nonatomic)NSTimer *rollingSecondRequest;      // Background request to get latest visit data and sync with local copy
@property(nonatomic)NSTimer *makeAnotherRequest;        // If request fails, redo

@property(nonatomic,strong)NSNumber* totalCoordinatesForSession;
@property(nonatomic)NSTimer *locationUpdateTimer;
@property(nonatomic)NSTimer *weatherRequest;
@property(nonatomic)NSTimer *rollingWeatherRequest;
@property(nonatomic)NSTimer* beginTrackingForDay;
@property(nonatomic)NSTimer* endTrackingForDay;
@property(nonatomic,strong)NSString *onWhichVisitID;
@property(nonatomic,strong)NSString *onSequence;
@property(nonatomic,strong)NSMutableArray *clientData;
@property(nonatomic,strong)NSMutableArray *visitData;

@property(nonatomic,strong)NSMutableArray *lastRequest;
@property(nonatomic,strong)NSMutableArray *lastLocationUpdate;
@property(nonatomic,strong)NSMutableDictionary *resendRequestDic;
@property(nonatomic,strong)NSMutableArray *globalFlagData;
@property(nonatomic,strong)NSMutableDictionary *flagImagesDic;

@property(nonatomic,strong)NSMutableArray *startTimes;
@property(nonatomic,strong)NSMutableDictionary *endTimes;
@property(nonatomic,strong)NSMutableDictionary *beginTimes;


-(NSMutableArray *)getTodayVisits;
-(NSMutableArray *)getClientData;
-(NSMutableArray *)getVisitData;
-(BOOL)loginAndGetVisitData;
-(void)getUpdatedVisitData;
-(void)loggedInBeginPolling;
-(NSMutableArray *)visitDataFromServer;
-(BOOL)recreateNetworkRequest:(NSMutableDictionary*)param;

@property BOOL isReachable;
@property BOOL isUnreachable;
@property BOOL isReachableViaWWAN;
@property BOOL isReachableViaWiFi;
@property BOOL diagnosticsON;
@property BOOL userTracking;
@property BOOL weatherOff;
@property BOOL currentlyPolling;


// OPTION SETTINGS
-(void)setDeviceType:(NSString*)typeDev;
-(NSString*)tellDeviceType;
@property float pollingFrequency;
@property float distanceSettingForGPS;
@property float frequencyCoordinateTransmit;
@property float checkWeatherFrequency;
@property BOOL showFlagsListView;
@property BOOL showFlagsDetailView;
@property BOOL showClientName;
@property BOOL showClientPhone;
@property BOOL showClientEmail;


-(void)changePollingFrequency:(NSNumber*)changePollingFrequencyTo;
-(void)turnOffGPSTracking;
-(void)changeDistanceFilter:(NSNumber*)changeDistanceFilterTo;

-(void)addLocationCoordinate:(CLLocation*)point;
-(void)addLocationNoVisit:(CLLocation*)point;

-(NSArray*)getCoordinatesForVisit:(NSString*)visitID;
-(void)addPictureForPet:(UIImage*)petPicture;



@end
