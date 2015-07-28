//
//  VisitDetails.h
//  LeashTimeSitter
//
//  Created by Ted Hooban on 7/11/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h> 


@interface VisitDetails : NSObject {

    NSMutableArray *petPhotos;
    NSMutableArray *petNames;
    NSMutableArray *flagsForClientPet;
    NSMutableArray *zoneAround;
    NSFileManager *fileManager;
}


// Visit Details
@property (nonatomic,copy) NSString *appointmentid;
@property (nonatomic,copy) NSString *clientptr;
@property (nonatomic,copy) NSString *providerptr;
@property (nonatomic,copy) NSString *service;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *starttime;
@property (nonatomic,copy) NSString *endtime;
@property (nonatomic,copy) NSString *timeofday;
@property (nonatomic,copy) NSString *note;
@property (nonatomic,copy) NSString *clientname;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *petName;
@property (nonatomic,copy) NSString *visitNote;


@property (nonatomic,copy) NSString *status;
@property NSString *arrived;
@property NSString *completed;
@property NSString *canceled;
@property BOOL highpriority;
@property BOOL pendingChange;
@property BOOL hasKey;
@property NSString *keyID;


// Client Details

@property (nonatomic,copy) NSString *sequenceID;
@property (nonatomic,copy) NSString *petImage;
@property (nonatomic,copy) NSString *petBreed;
@property (nonatomic,copy) NSString *petAge;
@property (nonatomic,copy) NSString *petNotes;
@property (nonatomic,copy) NSString *petGender;

@property (nonatomic,copy) NSString *alarmCompany;
@property (nonatomic,copy) NSString *alarmCompanyPhone;
@property (nonatomic,copy) NSString *alarmInfo;

@property (nonatomic,copy) NSString *alarmCodeOn;
@property (nonatomic,copy) NSString *alarmCodeOff;
@property (nonatomic,copy) NSString *clientPhone;
@property (nonatomic,copy) NSString *clientPhone2;

@property (nonatomic,copy) NSString *clientEmail;
@property (nonatomic,copy) NSString *clientEmail2;
@property (nonatomic,copy) NSString *homeAddress;
@property (nonatomic,copy) NSString *street1;
@property (nonatomic,copy) NSString *street2;
@property (nonatomic,copy) NSString *zip;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *garageGateCode;


@property (nonatomic,copy) NSString *clientNote;
@property (nonatomic,copy) NSString *petNote1;
@property (nonatomic,copy) NSString *petNote2;
@property (nonatomic,copy) NSString *petNote3;


@property BOOL hasArrived;
@property BOOL isCanceled;
@property BOOL isComplete;
@property BOOL inProcess;
@property BOOL isLate;
@property BOOL cancelationPending;


// Visit actions

@property (nonatomic,retain) UIImage *currentPetImage;
@property (nonatomic,copy) NSString *petImageFile;
@property (nonatomic,retain) UIImage *pawPrintForSession;
@property (nonatomic,retain) UIImage *mapImage;
@property (nonatomic,retain) UIImageView *petImageAvatar;

@property BOOL didPoo;
@property BOOL didPee;
@property BOOL wasHappy;
@property BOOL wasSad;
@property BOOL wasAngry;
@property BOOL wasShy;
@property BOOL wasHungry;
@property BOOL wasSick;
@property BOOL didPlay;
@property BOOL wasCat;
@property BOOL didScoopLitter;

@property (nonatomic,copy) NSDate *NSDateMarkArrive;
@property (nonatomic,copy) NSDate *NSDateMarkComplete;

@property (nonatomic,copy) NSString *visitNoteBySitter;
@property (nonatomic,copy) NSString *dateTimeMarkArrive;
@property (nonatomic,copy) NSString *coordinateLatitudeMarkArrive;
@property (nonatomic,copy) NSString *coordinateLongitudeMarkArrive;
@property (nonatomic,copy) NSString *dateTimeMarkComplete;
@property (nonatomic,copy) NSString *coordinateLatitudeMarkComplete;
@property (nonatomic,copy) NSString *coordinateLongitudeMarkComplete;

@property (nonatomic,copy) NSString *dateTimeRequestCancelation;
@property (nonatomic,copy) NSString *dateTimeVisitReportSubmit;

@property (nonatomic,copy) NSMutableArray *routePoints;
@property (nonatomic, strong) NSURLSession *session;

-(id)initWithVisits:(NSMutableDictionary*)visitDetails;

-(NSMutableDictionary*)getMyVisitDetails:(NSString *)visitID;

-(void)addVisitNoteToVisit:(NSString*)visitNote;

-(void)markArrive:(NSString *)timeMarkArrive
         latitude:(NSString *)coordinateLatitudeMarkArrive
        longitude:(NSString *)coordinateLongitudeMarkArrive;

-(void)markComplete:(NSString *)timeMarkComplete
           latitude:(NSString *)coordinateLatitudeMarkComplete
          longitude:(NSString*)coordinateLongitudeMarkComplete;

-(void)addImageForPet:(UIImage*)petImage;

-(void)addPointForRouteUsingCLLocation:(CLLocation*)location;
-(NSArray*)getPointForRoutes;

-(void)writeVisitDataToFile;
-(void)syncVisitDetailFromFile;

-(NSMutableArray*)getImagesFromFileSystem;


@end
