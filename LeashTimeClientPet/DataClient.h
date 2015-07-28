//
//  DataClient.h
//  LeashTimeSitterV1
//
//  Created by Ted Hooban on 11/17/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClient : NSObject
@property (nonatomic,retain)NSString *clientID;

@property (nonatomic,retain)NSString *sortName;
@property (nonatomic,retain)NSString *clientName;
@property (nonatomic,retain)NSString *homePhone;
@property (nonatomic,retain)NSString *firstName;
@property (nonatomic,retain)NSString *firstName2;
@property (nonatomic,retain)NSString *lastName;
@property (nonatomic,retain)NSString *lastName2;
@property (nonatomic,retain)NSString *email;
@property (nonatomic,retain)NSString *email2;
@property (nonatomic,retain)NSString *workphone;
@property (nonatomic,retain)NSString *cellphone;
@property (nonatomic,retain)NSString *cellphone2;
@property (nonatomic,retain)NSString *street1;
@property (nonatomic,retain)NSString *street2;
@property (nonatomic,retain)NSString *city;
@property (nonatomic,retain)NSString *state;
@property (nonatomic,retain)NSString *zip;

@property (nonatomic,retain)NSString *garageGateCode;
@property (nonatomic,retain)NSString *alarmCompany;
@property (nonatomic,retain)NSString *alarmCompanyPhone;
@property (nonatomic,retain)NSString *alarmInfo;

@property (nonatomic,retain)NSString *keyID;
@property (nonatomic,retain)NSString *hasKey;

@property (nonatomic,retain)NSString *clinicName;
@property (nonatomic,retain)NSString *clinicStreet1;
@property (nonatomic,retain)NSString *clinicStreet2;
@property (nonatomic,retain)NSString *clinicPhone;
@property (nonatomic,retain)NSString *clinicCity;
@property (nonatomic,retain)NSString *clinicLat;
@property (nonatomic,retain)NSString *clinicLon;
@property (nonatomic,retain)NSString *clinicZip;

@property (nonatomic,retain)NSString *clinicPtr;
@property (nonatomic,retain)NSString *vetPtr;

@property (nonatomic,retain)NSString *vetName;
@property (nonatomic,retain)NSString *vetPhone;
@property (nonatomic,retain)NSString *vetStreet1;
@property (nonatomic,retain)NSString *vetStreet2;
@property (nonatomic,retain)NSString *vetCity;
@property (nonatomic,retain)NSString *vetState;
@property (nonatomic,retain)NSString *vetZip;
@property (nonatomic,retain)NSString *vetLat;
@property (nonatomic,retain)NSString *vetLon;

@property (nonatomic,strong)NSString *petName;
@property (nonatomic,strong)NSString *petAge;
@property (nonatomic,strong)NSString *petBreed;
@property (nonatomic,strong)NSString *petColor;
@property (nonatomic,strong)NSString *petFixed;
@property (nonatomic,strong)NSString *petNotes;
@property (nonatomic,strong)NSString *petDescription;

@property (nonatomic,strong)NSString *customPet1;
@property (nonatomic,strong)NSString *customPet2;
@property (nonatomic,strong)NSString *customPet3;
@property (nonatomic,strong)NSString *customPet4;
@property (nonatomic,strong)NSString *customPet5;
@property (nonatomic,strong)NSString *customPet6;
@property (nonatomic,strong)NSString *customPet7;
@property (nonatomic,strong)NSString *customPet8;
@property (nonatomic,strong)NSString *customPet9;
@property (nonatomic,strong)NSString *customPet10;
@property (nonatomic,strong)NSString *customPet11;
@property (nonatomic,strong)NSString *customPet12;
@property (nonatomic,strong)NSString *customPet13;
@property (nonatomic,strong)NSString *customPet14;
@property (nonatomic,strong)NSString *customPet15;
@property (nonatomic,strong)NSString *customPet16;
@property (nonatomic,strong)NSString *customPet17;
@property (nonatomic,strong)NSString *customPet18;
@property (nonatomic,strong)NSString *customPet19;
@property (nonatomic,strong)NSString *customPet20;
@property (nonatomic,strong)NSString *customPet21;
@property (nonatomic,strong)NSString *customPet22;
@property (nonatomic,strong)NSString *customPet23;
@property (nonatomic,strong)NSString *customPet24;
@property (nonatomic,strong)NSString *customPet25;
@property (nonatomic,strong)NSString *customPet26;
@property (nonatomic,strong)NSString *customPet27;
@property (nonatomic,strong)NSString *customPet28;
@property (nonatomic,strong)NSString *customPet29;
@property (nonatomic,strong)NSString *customPet30;


@property (nonatomic,strong)NSString *customClient1;
@property (nonatomic,strong)NSString *customClient2;
@property (nonatomic,strong)NSString *customClient3;
@property (nonatomic,strong)NSString *customClient4;
@property (nonatomic,strong)NSString *customClient5;
@property (nonatomic,strong)NSString *customClient6;
@property (nonatomic,strong)NSString *customClient7;
@property (nonatomic,strong)NSString *customClient8;
@property (nonatomic,strong)NSString *customClient9;
@property (nonatomic,strong)NSString *customClient10;
@property (nonatomic,strong)NSString *customClient11;
@property (nonatomic,strong)NSString *customClient12;
@property (nonatomic,strong)NSString *customClient13;
@property (nonatomic,strong)NSString *customClient14;
@property (nonatomic,strong)NSString *customClient15;
@property (nonatomic,strong)NSString *customClient16;
@property (nonatomic,strong)NSString *customClient17;
@property (nonatomic,strong)NSString *customClient18;
@property (nonatomic,strong)NSString *customClient19;
@property (nonatomic,strong)NSString *customClient20;
@property (nonatomic,strong)NSString *customClient21;
@property (nonatomic,strong)NSString *customClient22;
@property (nonatomic,strong)NSString *customClient23;
@property (nonatomic,strong)NSString *customClient24;
@property (nonatomic,strong)NSString *customClient25;
@property (nonatomic,strong)NSString *customClient26;
@property (nonatomic,strong)NSString *customClient27;
@property (nonatomic,strong)NSString *customClient28;
@property (nonatomic,strong)NSString *customClient29;
@property (nonatomic,strong)NSString *customClient30;


@property (nonatomic,strong)NSMutableArray *customClientFields;
@property (nonatomic,strong)NSMutableArray *petInfo;
@property (nonatomic,strong)NSMutableDictionary *customPetInfo;
@property (nonatomic,strong)NSMutableDictionary *groupPets;

@property BOOL read;
@property BOOL flag;

@property (nonatomic,strong)NSNumber *howManyPets;

@property (nonatomic,strong)NSMutableArray *flagIDsWithNotes;


-(void)handleCustomClientFields:(NSDictionary*)customClientFields;
-(void)handlePetInformation:(NSDictionary *)customPetFields;
-(void)prettyPrint;
-(void)createFlagData:(NSMutableArray*)flagInfo;



@end
