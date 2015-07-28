//
//  VisitsAndTracking.m
//  LeashTimeSitter
//
//  Created by Ted Hooban on 8/13/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import "VisitsAndTracking.h"
#import "DateTools.h"
#import "DataClient.h"
#import "VisitDetails.h"

@implementation VisitsAndTracking {
    

    
}

NSString *const pollingCompleteWithChanges = @"pollingCompleteWithChanges";
NSString *const pollingFailed = @"pollingFailed";
int totalCoordinatesInSession;

+(VisitsAndTracking *)sharedInstance {
    
    static VisitsAndTracking *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance =[[VisitsAndTracking alloc]init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        coordinatesForVisits = [[NSMutableDictionary alloc]init];
        arrayCoordForVisits = [[NSMutableArray alloc]init];
        _clientData = [[NSMutableArray alloc]init];
        _visitData = [[NSMutableArray alloc]init];
        _globalFlagData = [[NSMutableArray alloc]init];
        
        _beginTimes = [[NSMutableDictionary alloc]init];
        _endTimes = [[NSMutableDictionary alloc]init];
        
        _onSequence = @"000";
        _onWhichVisitID = NULL;
        
        self.isReachable = NO;
        self.isUnreachable = NO;
        self.isReachableViaWiFi = NO;
        self.isReachableViaWWAN = NO;

        [self setupDefaults];
        //[self setUpReachability];
    
        
    }
    return self;
}

-(void)setupDefaults {
    
    NSDictionary *userDefaultDic = [[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];

    if([userDefaultDic objectForKey:@"weatherOff"] != NULL) {
        _weatherOff = [userDefaultDic objectForKey:@"weatherOff"];
    } else  {
        _weatherOff = NO;
    }
    
    if([userDefaultDic objectForKey:@"gpsON"] != NULL) {
        _userTracking = [userDefaultDic objectForKey:@"gpsON"];
    } else {
        _userTracking = YES;
        [standardDefaults setObject:@"YES" forKey:@"gpsON"];
    }
    
    if([userDefaultDic objectForKey:@"distanceSettingForGPS"] != NULL) {
        NSNumber *distanceSettingForGPSNum = [userDefaultDic objectForKey:@"distanceSettingForGPS"];
        _distanceSettingForGPS = [distanceSettingForGPSNum floatValue];
    } else {
        [standardDefaults setObject:[NSNumber numberWithFloat:100.0] forKey:@"distanceSettingForGPS"];
        _distanceSettingForGPS = 100;
    }
    
    if ([userDefaultDic objectForKey:@"frequencyOfPolling"] != NULL) {
        NSNumber *pollNum = [userDefaultDic objectForKey:@"frequencyOfPolling"];
        _pollingFrequency = [pollNum floatValue];
        
    } else {
        [standardDefaults setObject:[NSNumber numberWithFloat:600.0f] forKey:@"frequencyOfPolling"];
        _pollingFrequency = 600.0f;
    }
    
    if([userDefaultDic objectForKey:@"transmitCoordFrequency"] != NULL) {
        
        NSNumber *transmitCoordinateFrequency = [userDefaultDic objectForKey:@"transmitCoordFrequency"];
        _frequencyCoordinateTransmit = [transmitCoordinateFrequency floatValue];
    } else {
        [standardDefaults setObject:[NSNumber numberWithFloat:60] forKey:@"transmitCoordFrequency"];
        _frequencyCoordinateTransmit = 60;
    }
    
    //if ([[userDefaultDic objectForKey:@"diagnosticsON"]isEqualToString:@"ON"]) {
        _diagnosticsON = YES;
    //}
}

-(void)addLocationCoordinate:(CLLocation*)point {
    
    NSMutableDictionary *locationDic = [[NSMutableDictionary alloc]init];

    if(_onWhichVisitID != NULL &&
       ![_onSequence isEqualToString:@"000"] &&
       point != NULL) {
        
        for (VisitDetails *visitDetails in _visitData) {
            if ([visitDetails.sequenceID isEqualToString:_onSequence]) {
                [locationDic setObject:visitDetails.appointmentid forKey:point];
                [arrayCoordForVisits addObject:locationDic];
                [visitDetails addPointForRouteUsingCLLocation:point];

            }
        }
        
        [locationDic setObject:_onWhichVisitID forKey:point];
        
        
        for (VisitDetails *visitInfo in _visitData) {
            if ([_onWhichVisitID isEqualToString:visitInfo.appointmentid] &&
                [visitInfo.status isEqualToString:@"arrived"] &&
                ![visitInfo.status isEqualToString:@"completed"]) {
                
                //[visitInfo addPointForRouteUsingCLLocation:point];
            }
        }
        
        
    }
}

-(void)addLocationNoVisit:(CLLocation*)point {
    
    NSMutableDictionary *locationDic = [[NSMutableDictionary alloc]init];
    
    if(_onWhichVisitID != NULL &&
       ![_onSequence isEqualToString:@"000"] &&
       point != NULL) {
        
        for (VisitDetails *visitDetails in _visitData) {
            if ([visitDetails.sequenceID isEqualToString:_onSequence]) {
            
                [locationDic setObject:visitDetails.appointmentid forKey:point];
            
            }
        }

        for (VisitDetails *visitInfo in _visitData) {
            if ([_onWhichVisitID isEqualToString:visitInfo.appointmentid] &&
                [visitInfo.status isEqualToString:@"arrived"] &&
                ![visitInfo.status isEqualToString:@"completed"]) {
                
                [locationDic setObject:visitInfo.appointmentid forKey:point];
                [arrayCoordForVisits addObject:locationDic];
                [visitInfo addPointForRouteUsingCLLocation:point];

            }
        }
    }
}



-(NSArray*)getCoordinatesForVisit:(NSString*)visitID {
    
    NSMutableArray *rebuildVisitPoints = [[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *pointsDic in arrayCoordForVisits) {
        
        for (CLLocation *location in pointsDic) {
            if ([[pointsDic objectForKey:location] isEqualToString:visitID]) {
                [rebuildVisitPoints addObject:location];
            }
        }
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"timestamp" ascending:YES];
    [rebuildVisitPoints sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    return rebuildVisitPoints;
}



-(void)loggedInBeginPolling {
    _timerRequest = [NSTimer scheduledTimerWithTimeInterval:_pollingFrequency
                                                     target:self
                                                   selector:@selector(getUpdatedVisitData)
                                                   userInfo:nil
                                                    repeats:NO];
}


-(BOOL)recreateNetworkRequest:(NSMutableDictionary *)param {
    
    if ([[param objectForKey:@"type"]isEqualToString:@"markArrive"]) {
        
        _makeAnotherRequest = [NSTimer scheduledTimerWithTimeInterval:30
                                                               target:self
                                                             selector:@selector(resendArrivalCompleteToServer)
                                                             userInfo:nil
                                                              repeats:NO];
        
        _resendRequestDic = [[NSMutableDictionary alloc]initWithDictionary:param];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"FailedArrive"
             object:self];
        });
        
        
        
        
    } else if ([[param objectForKey:@"type"]isEqualToString:@"markComplete"]) {
        
        _makeAnotherRequest = [NSTimer scheduledTimerWithTimeInterval:30
                                                               target:self
                                                             selector:@selector(resendArrivalCompleteToServer)
                                                             userInfo:nil
                                                              repeats:NO];
        
        _resendRequestDic = [[NSMutableDictionary alloc]initWithDictionary:param];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"FailedComplete"
             object:self];
        });
        
        
        
    } else if ([[param objectForKey:@"type"]isEqualToString:@"sendNotes"]) {
        
    } else if ([[param objectForKey:@"type"]isEqualToString:@"sendPicture"]) {
        
    }
    
    
    return YES;
}

-(void)resendArrivalCompleteToServer {
    
    
    if (_isReachable) {
        NSLog(@"------------------------------");
        NSLog(@"is reachable for resend");
        NSLog(@"------------------------------");

        NSString *postString = [_resendRequestDic valueForKey:@"postData"];
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:@"https://leashtime.com/native-visit-action.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setTimeoutInterval:20.0];
        [request setHTTPBody:postData];
        [NSURLConnection connectionWithRequest:request delegate:self];
        
    } else  {
        NSLog(@"------------------------------");
        NSLog(@"no internet, scheduling new request");
        NSLog(@"------------------------------");

        _makeAnotherRequest = [NSTimer scheduledTimerWithTimeInterval:30
                                                               target:self
                                                             selector:@selector(resendArrivalCompleteToServer)
                                                             userInfo:nil
                                                              repeats:NO];
    }
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _responseData = [[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    
    
    [_responseData appendData:data];
    
    
    NSString *receivedDataString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];

    if ([receivedDataString isEqualToString:@"OK"]) {
        
        if ([[_resendRequestDic objectForKey:@"type"]isEqualToString:@"arrived"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"ResendArriveSuccessful"
                 object:self];
            });
        } else if ([[_resendRequestDic objectForKey:@"type"]isEqualToString:@"completed"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"ResendCompleteSuccessful"
                 object:self];
            });
        }
        
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSUserDefaults *networkLogging = [NSUserDefaults standardUserDefaults];
    NSDate *rightNow2 = [NSDate date];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc]init];
    [dateFormat2 setDateFormat:@"HH:mm:ss MMM dd yyyy"];
    NSString *dateString2 = [dateFormat2 stringFromDate:rightNow2];
    NSString *failURLString = [NSString stringWithFormat:@"%@",error];
    NSString *errorDetails = error.localizedDescription;
    

    _makeAnotherRequest = [NSTimer scheduledTimerWithTimeInterval:30
                                                           target:self
                                                         selector:@selector(resendArrivalCompleteToServer)
                                                         userInfo:nil
                                                          repeats:NO];
    NSLog(@"received error: %@",error);
    
    NSMutableDictionary *logServerError = [[NSMutableDictionary alloc]init];
    [logServerError setObject:dateString2 forKey:@"date"];
    [logServerError setObject:failURLString forKey:@"error1"];
    [logServerError setObject:errorDetails forKey:@"errorDetails"];
    [logServerError setObject:@"RESEND OF PREVIOUS" forKey:@"location"];
    [logServerError setObject:@"network" forKey:@"type"];
    [networkLogging setObject:logServerError forKey:dateString2];
    
}


- (void) parseResponse:(NSData *) data {
    
    NSString *myData = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    
}

-(BOOL)loginAndGetVisitData {
        
    
    NSString *userName;
    NSString *password;
    
    NSUserDefaults *loginSettings = [NSUserDefaults standardUserDefaults];
    
    if ([loginSettings objectForKey:@"username"] != NULL) {
        userName = [loginSettings objectForKey:@"username"];
        NSLog(@"username: %@",userName);
    }
    if ([loginSettings objectForKey:@"password"]) {
        password = [loginSettings objectForKey:@"password"];
        NSLog(@"password: %@",password);
    }
    
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"YYYY/MM/dd"];
    NSString *date_String=[dateformat stringFromDate:[NSDate date]];
    NSDateFormatter *dateformat2=[[NSDateFormatter alloc]init];
    [dateformat2 setDateFormat:@"YYYY/MM/dd MM:ss"];
    
    
    NSURL *leashTimeServer = [NSURL
                              URLWithString:
                              [NSString stringWithFormat:@"https://leashtime.com/native-prov-day-list.php?loginid=%@&password=%@&date=%@",
                               userName,password,
                               date_String]];
    
   //NSLog(@"LeashTime request: %@",leashTimeServer);
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL * url = leashTimeServer;
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data,
                                                                        NSURLResponse *response,
                                                                        NSError *error) {
                                                        
                                                        
                                                        NSUserDefaults *networkLogging = [NSUserDefaults standardUserDefaults];
                                                        NSDate *rightNow2 = [NSDate date];
                                                        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc]init];
                                                        [dateFormat2 setDateFormat:@"HH:mm:ss MMM dd yyyy"];
                                                        NSString *dateString2 = [dateFormat2 stringFromDate:rightNow2];
                                                        NSDictionary *errorDic = [error userInfo];
                                                        
                                                        if(error == nil) {
                                                            
                                                            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                        options:
                                                                                         NSJSONReadingMutableContainers|
                                                                                         NSJSONReadingAllowFragments|
                                                                                         NSJSONWritingPrettyPrinted|
                                                                                         NSJSONReadingMutableLeaves
                                                                                                                          error:&error];
                                                            
                                                            [self parseDataResponse:responseDic];
                                                            [self updateCoordinateData];
                                                            
                                                            if(responseDic == NULL) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [[NSNotificationCenter defaultCenter]
                                                                     postNotificationName:pollingFailed
                                                                     object:self];
                                                                });
                                                                
                                                                
                                                                
                                                            } else {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [[NSNotificationCenter defaultCenter]
                                                                     postNotificationName:pollingCompleteWithChanges
                                                                     object:self];
                                                                });
                                                                
                                                                _rollingSecondRequest = [NSTimer scheduledTimerWithTimeInterval:_pollingFrequency
                                                                                                                         target:self
                                                                                                                       selector:@selector(getUpdatedVisitData)
                                                                                                                       userInfo:nil
                                                                                                                        repeats:NO];
                                                                
                                                            }
                                                                            
                                                        } else {
                                                            
                                                            NSString *failURLString = [errorDic valueForKey:@"NSErrorFailingURLStringKey"];
                                                            NSString *errorDetails = error.localizedDescription;
                                                            NSMutableDictionary *logServerError = [[NSMutableDictionary alloc]init];
                                                            [logServerError setObject:rightNow2 forKey:@"date"];
                                                            [logServerError setObject:failURLString forKey:@"error1"];
                                                            [logServerError setObject:errorDetails forKey:@"errorDetails"];
                                                            [logServerError setObject:@"initial login" forKey:@"location"];
                                                            [logServerError setObject:@"network" forKey:@"type"];
                                                            [networkLogging setObject:logServerError forKey:dateString2];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [[NSNotificationCenter defaultCenter]
                                                                 postNotificationName:pollingFailed
                                                                 object:self];
                                                            });
                                                            
                                                            
                                                            
                                                        }
                                                        
                                                    }];
    
    [dataTask resume];
    
    return TRUE;
    
}

-(void)updateCoordinateData {
    
    for (VisitDetails *visit in _visitData) {

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setLocale:[NSLocale currentLocale]];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormat setDateFormat:@"HH:mm"];

        
        NSArray *coordinatesForVisitArray = [visit getPointForRoutes];
        
        if(coordinatesForVisitArray != NULL) {
            for (NSData *coordinateData in coordinatesForVisitArray) {
                CLLocation *coordinateForVisit = [NSKeyedUnarchiver unarchiveObjectWithData:coordinateData];
                NSMutableDictionary *locationDic = [[NSMutableDictionary alloc]init];
                [locationDic setObject:visit.appointmentid forKey:coordinateForVisit];
                [arrayCoordForVisits addObject:locationDic];
            }
        } else {
            //NSLog(@"no coordinate values for this visit: %@, %@",visit.appointmentid,visit.petName);
        }
        
    }
}

-(void) getUpdatedVisitData {

    NSString *userName;
    NSString *password;
    
    if (_lastRequest != NULL) {
        [_lastRequest removeAllObjects];
    }
    _lastRequest = [[NSMutableArray alloc]init];
    
    NSUserDefaults *loginSettings = [NSUserDefaults standardUserDefaults];
    
    if ([loginSettings objectForKey:@"username"] != NULL) {
        userName = [loginSettings objectForKey:@"username"];
    }
    if ([loginSettings objectForKey:@"password"]) {
        password = [loginSettings objectForKey:@"password"];
    }
    
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"YYYY/MM/dd"];
    NSString *date_String=[dateformat stringFromDate:[NSDate date]];
    
    NSDateFormatter *dateformat2=[[NSDateFormatter alloc]init];
    [dateformat2 setDateFormat:@"YYYY/MM/dd MM:ss"];
    
    NSURL *leashTimeServer = [NSURL
                              URLWithString:
                              [NSString stringWithFormat:@"https://leashtime.com/native-prov-day-list.php?loginid=%@&password=%@&date=%@",
                               userName,password,
                               date_String]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL * url = leashTimeServer;
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data,
                                                                        NSURLResponse *response,
                                                                        NSError *error) {
                                                        
                                                        
                                                        NSUserDefaults *networkLogging = [NSUserDefaults standardUserDefaults];
                                                        NSDate *rightNow2 = [NSDate date];
                                                        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc]init];
                                                        [dateFormat2 setDateFormat:@"HH:mm:ss"];
                                                        NSString *dateString2 = [dateFormat2 stringFromDate:rightNow2];
                                                        NSDictionary *errorDic = [error userInfo];
                                                        [_lastRequest addObject:dateString2];
                                                        
                                                        if(error == nil) {
                                                            
                                                            [_lastRequest addObject:@"OK"];
                                                            
                                                            
                                                            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                        options:
                                                                                         NSJSONReadingMutableContainers|
                                                                                         NSJSONReadingAllowFragments|
                                                                                         NSJSONWritingPrettyPrinted|
                                                                                         NSJSONReadingMutableLeaves
                                                                                                                          error:&error];
                                                            
                                                            [self parseDataResponse:responseDic];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [[NSNotificationCenter defaultCenter]
                                                                 postNotificationName:pollingCompleteWithChanges
                                                                 object:self];
                                                            });
                                                            
                                                            
                                                        } else {
                                                            
                                                            [_lastRequest addObject:@"FAIL"];
                                                            
                                                            NSString *failURLString = [errorDic valueForKey:@"NSErrorFailingURLStringKey"];
                                                            NSString *errorDetails = error.localizedDescription;
                                                            NSMutableDictionary *logServerError = [[NSMutableDictionary alloc]init];
                                                            [logServerError setObject:rightNow2 forKey:@"date"];
                                                            [logServerError setObject:failURLString forKey:@"error1"];
                                                            [logServerError setObject:errorDetails forKey:@"errorDetails"];
                                                            [logServerError setObject:@"polling request" forKey:@"location"];
                                                            [logServerError setObject:@"network" forKey:@"type"];
                                                            [networkLogging setObject:logServerError forKey:dateString2];
                                                            
                                                            
                                                        }
                                                        
                                                    }];
    
    [dataTask resume];
        
    _rollingSecondRequest = [NSTimer scheduledTimerWithTimeInterval:_pollingFrequency
                                                   target:self
                                                 selector:@selector(getUpdatedVisitData)
                                                 userInfo:nil
                                                  repeats:NO];
}

-(void) parseDataResponse:(NSDictionary *)responseDic {

    NSDictionary *clientDicCheck = [responseDic objectForKey:@"clients"];
    NSDictionary *visitsDicCheck = [responseDic objectForKey:@"visits"];
    
    NSInteger payloadCount = [visitsDicCheck count];
    NSInteger clientListCount = [_clientData count];
    NSInteger visitListCount = [_visitData count];
    NSLog(@"response dic: %@",responseDic);
    NSLog(@"payload: %ld, clientList: %ld, visitList: %ld",(long)payloadCount,(long)clientListCount,(long)visitListCount);
    
    
    if (payloadCount <= 0) {
    
        [self syncData:responseDic];

    } else if (payloadCount > 0 && visitListCount <= 0) {
        
        [self setUpNewData:responseDic];
        
    } else if (payloadCount > 0 && visitListCount > 0) {
        
        [self syncData:responseDic];

    } else {

    
    }
}

-(void)setupFlagImages:(NSMutableArray *)listOfFlagIDs {
    
    _flagImagesDic = [[NSMutableDictionary alloc]init];
    
    for (NSMutableDictionary *dic in _globalFlagData) {
        
        if([[dic valueForKey:@"src"]isEqualToString:@"flag-yellow-star"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"star-icon-cartoon"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-redcross"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"red-cross-32x32"];
            
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-dollar"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"money-icon"];
            
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-female"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"female32x32"];
            
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-syringe"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"needle32x32"];
            
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-clock-simple"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"clock-flag"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-globe-1"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"globe-flag"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-valentine"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"heart-icon"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-house-1"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"home-icon"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-male"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"male-flag"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-water-can"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"wateringcan-flag"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-0"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number0-circle"];
            
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-1"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number1-circle"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-2"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number2-circle"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-3"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number3-circle"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-4"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number4-circle"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-5"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number5-circle"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-6"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number6-circle"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-7"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number7-circle"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-8"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number8-circle"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        } else if ([[dic valueForKey:@"src"]isEqualToString:@"flag-zblue-9"]) {
            
            UIImage *theImage = [UIImage imageNamed:@"number9-circle"];
            [_flagImagesDic setObject:theImage forKey:[dic valueForKey:@"flagid"]];
            
        }
    }
}


-(void) setUpNewData:(NSDictionary *)responseDic {
    self.onSequence = @"000";
    
    NSDictionary *clientDic = [responseDic objectForKey:@"clients"];
    NSDictionary *visitsDic = [responseDic objectForKey:@"visits"];
    
    _globalFlagData = [responseDic objectForKey:@"flags"];
    
    [self setupFlagImages:_globalFlagData];
    
    for (NSString *clientIDNum in clientDic) {
        DataClient *clientProfile = [[DataClient alloc]init];
        NSMutableDictionary *clientInformation = [clientDic objectForKey:clientIDNum];
        clientProfile.clientID = [clientInformation objectForKey:@"clientid"];
        clientProfile.clientName = [clientInformation objectForKey:@"clientname"];
        clientProfile.email = [clientInformation objectForKey:@"email"];
        clientProfile.email2 = [clientInformation objectForKey:@"email2"];
        clientProfile.cellphone = [clientInformation objectForKey:@"cellphone"];
        clientProfile.cellphone2 = [clientInformation objectForKey:@"cellphone2"];
        clientProfile.street1 = [clientInformation objectForKey:@"street1"];
        clientProfile.street2 = [clientInformation objectForKey:@"street2"];
        clientProfile.city = [clientInformation objectForKey:@"city"];
        clientProfile.zip = [clientInformation objectForKey:@"zip"];
        clientProfile.garageGateCode = [clientInformation objectForKey:@"garagegatecode"];
        clientProfile.alarmCompany = [clientInformation objectForKey:@"alarmcompany"];
        clientProfile.alarmCompanyPhone = [clientInformation objectForKey:@"alarmcophone"];
        clientProfile.hasKey = [clientInformation objectForKey:@"hasKey"];
        clientProfile.keyID = [clientInformation objectForKey:@"keyid"];
        clientProfile.sortName = [clientInformation objectForKey:@"sortname"];
        clientProfile.firstName = [clientInformation objectForKey:@"fname"];
        clientProfile.firstName2 = [clientInformation objectForKey:@"fname2"];
        clientProfile.lastName = [clientInformation objectForKey:@"lname"];
        clientProfile.lastName2 = [clientInformation objectForKey:@"lname2"];
        clientProfile.workphone = [clientInformation objectForKey:@"workphone"];
        clientProfile.alarmInfo = [clientInformation objectForKey:@"alarminfo"];
        clientProfile.homePhone = [clientInformation objectForKey:@"homePhone"];
        clientProfile.clinicPtr = [clientInformation objectForKey:@"clinicptr"];
        clientProfile.vetPtr = [clientInformation objectForKey:@"vetptr"];
        clientProfile.clinicZip = [clientInformation objectForKey:@"cliniczip"];
        
        
        if((![[clientInformation objectForKey:@"clinicname"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"clinicname"] length] != 0 )) {
            
            clientProfile.clinicName = [clientInformation objectForKey:@"clinicname"];
            
        }
        
        if((![[clientInformation objectForKey:@"cliniccity"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"cliniccity"] length] != 0 )) {
            
            clientProfile.clinicCity = [clientInformation objectForKey:@"cliniccity"];
            
        }
        
        if((![[clientInformation objectForKey:@"clinicphone"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"clinicphone"] length] != 0 )) {
            
            clientProfile.clinicPhone = [clientInformation objectForKey:@"clinicphone"];
            
        }
        
        if((![[clientInformation objectForKey:@"clinicstreet1"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"clinicstreet1"] length] != 0 )) {
            
            clientProfile.clinicStreet1 = [clientInformation objectForKey:@"clinicstreet1"];
            
        }
        
        
        if((![[clientInformation objectForKey:@"clinicstreet2"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"clinicstreet2"] length] != 0 )) {
            
            clientProfile.clinicStreet2 = [clientInformation objectForKey:@"clinicstreet2"];
            
        }
        
        if((![[clientInformation objectForKey:@"vetname"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"vetname"] length] != 0 )) {
            
            clientProfile.vetName = [clientInformation objectForKey:@"vetname"];
            
        }
        
        if((![[clientInformation objectForKey:@"vetphone"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"vetphone"] length] != 0 )) {
            
            clientProfile.vetName = [clientInformation objectForKey:@"vetphone"];
            
        }
        
        
        if((![[clientInformation objectForKey:@"vetstreet1"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"vetstreet1"] length] != 0 )) {
            
            clientProfile.vetName = [clientInformation objectForKey:@"vetnstreet1"];
            
        }
        
        if((![[clientInformation objectForKey:@"vetstreet2"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"vetstreet2"] length] != 0 )) {
            
            clientProfile.vetName = [clientInformation objectForKey:@"vetstreet2"];
            
        }
        
        
        if((![[clientInformation objectForKey:@"vetzip"]isEqual:[NSNull null]] )
           && ( [[clientInformation objectForKey:@"vetzip"] length] != 0 )) {
            
            clientProfile.vetName = [clientInformation objectForKey:@"vetzip"];
            
        }
        
        
        NSArray *petsData = [clientInformation objectForKey:@"pets"];
        int petCount = [petsData count];
        
        for (int i = 0; i < petCount; i++) {
            NSDictionary *petDataDic = [petsData objectAtIndex:i];
            [clientProfile handlePetInformation:petDataDic];
        }
        
        
        NSMutableArray *flagData = [[NSMutableArray alloc]init];
        flagData = [clientInformation objectForKey:@"flags"];
        clientProfile.flagIDsWithNotes = [NSMutableArray arrayWithArray:flagData];
        
        [_clientData addObject:clientProfile];
    }
    
    int i = 100; // Sequence ID incrementer
    
    for (NSDictionary *key in visitsDic) {
        
        VisitDetails *detailsVisit = [[VisitDetails alloc]init];
        
        NSDictionary *visitInfo = key;
        detailsVisit.appointmentid = [visitInfo objectForKey:@"appointmentid"];
        NSString *clientIntVal = [visitInfo valueForKey:@"clientptr"];
        detailsVisit.sequenceID = [NSString stringWithFormat:@"%i",i];
        detailsVisit.clientptr = [NSString stringWithFormat:@"%@",clientIntVal];
        detailsVisit.service = [visitInfo objectForKey:@"service"];
        detailsVisit.starttime = [visitInfo objectForKey:@"starttime"];
        detailsVisit.endtime = [visitInfo objectForKey:@"endtime"];
        detailsVisit.timeofday = [visitInfo objectForKey:@"timeofday"];
        detailsVisit.petName = [visitInfo objectForKey:@"petNames"];
        detailsVisit.latitude = [visitInfo objectForKey:@"lat"];
        detailsVisit.longitude = [visitInfo objectForKey:@"lon"];
        detailsVisit.date = [visitInfo objectForKey:@"date"];
        detailsVisit.status = [visitInfo objectForKey:@"status"];


        // First, add sequence ID to track the points for visit (cannot use visit ID)
        [self addPawPrintForVisits:(int)i forVisit:detailsVisit];
        
        if ([detailsVisit.status isEqualToString:@"arrived"]) {
            self.onWhichVisitID = detailsVisit.appointmentid;
            self.onSequence = detailsVisit.sequenceID;
            detailsVisit.hasArrived = YES;
        }
        
        if((![[visitInfo objectForKey:@"arrived"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"arrived"] length] != 0 )) {
            
            detailsVisit.arrived = [visitInfo objectForKey:@"arrived"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSDate *date = [dateFormat dateFromString:detailsVisit.arrived];
            
            NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
            [dateFormat2 setDateFormat:@"HH:mm a"];
            [dateFormat2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *dateString = [dateFormat2 stringFromDate:date];
            detailsVisit.dateTimeMarkArrive = dateString;
            
        }
        
        if((![[visitInfo objectForKey:@"completed"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"completed"] length] != 0 )) {
            
            detailsVisit.completed = [visitInfo objectForKey:@"completed"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSDate *date = [dateFormat dateFromString:detailsVisit.completed];
            // back to string
            NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
            [dateFormat2 setDateFormat:@"HH:mm a"];
            [dateFormat2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *dateString = [dateFormat2 stringFromDate:date];
            detailsVisit.dateTimeMarkComplete = dateString;
        }
        
        if((![[visitInfo objectForKey:@"canceled"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"canceled"] length] != 0 )) {
            
            detailsVisit.canceled = [visitInfo objectForKey:@"canceled"];
            detailsVisit.isCanceled = YES;
            
        }
        
        if((![[visitInfo objectForKey:@"note"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"note"] length] != 0 )) {
            
            detailsVisit.visitNote = [visitInfo objectForKey:@"note"];
            
        }
        
        if((![[visitInfo objectForKey:@"highpriority"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"highpriority"] length] != 0 )) {
            
            detailsVisit.highpriority = YES;
            
        }
        
        if((![[visitInfo objectForKey:@"clientname"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"clientname"] length] != 0 )) {
            
            detailsVisit.clientname = [visitInfo objectForKey:@"clientname"];
            
        }
        
        if((![[visitInfo objectForKey:@"clientemail"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"clientemail"] length] != 0 )) {
            
            detailsVisit.clientEmail = [visitInfo objectForKey:@"clientemail"];
            
        }
        
        
        [_visitData addObject:detailsVisit];
        i++;
    }
    
    for(VisitDetails *clientPoint in _visitData) {
        
        for(DataClient *clientData in _clientData) {
            
            if ([clientPoint.clientptr isEqualToString:clientData.clientID]) {
                
                clientPoint.alarmCompany = clientData.alarmCompany;
                clientPoint.alarmCompanyPhone = clientData.alarmCompanyPhone;
                clientPoint.clientPhone = clientData.cellphone;
                clientPoint.clientPhone2 = clientData.cellphone2;
                clientPoint.clientEmail = clientData.email;
                clientPoint.clientEmail2 = clientData.email2;
                clientPoint.street1 = clientData.street1;
                clientPoint.street2 = clientData.street2;
                clientPoint.city = clientData.city;
                clientPoint.zip = clientData.zip;
                clientPoint.garageGateCode = clientData.garageGateCode;
                
                
                if ([clientData.hasKey isEqualToString:@"Yes"]) {
                    clientPoint.hasKey = YES;
                    clientPoint.keyID = clientData.keyID;
                }
                
                
            }
        }
        
        [clientPoint syncVisitDetailFromFile];
    }
}

-(void)syncData:(NSDictionary *)responseDic {
    //NSLog(@"SYNC DATA");
    //NSLog(@"%@",responseDic);
    NSMutableArray *compareClientDetails = [[NSMutableArray alloc]init];
    NSMutableArray *compareVisitDetails = [[NSMutableArray alloc]init];
    
    NSDictionary *clientDic = [responseDic objectForKey:@"clients"];
    NSDictionary *visitsDic = [responseDic objectForKey:@"visits"];
    
    for (NSString *clientIDNum in clientDic) {
        
        DataClient *clientProfile = [[DataClient alloc]init];
        
        NSMutableDictionary *clientInformation = [clientDic objectForKey:clientIDNum];
        
        clientProfile.clientID = [clientInformation objectForKey:@"clientid"];
        clientProfile.clientName = [clientInformation objectForKey:@"clientName"];
        clientProfile.email = [clientInformation objectForKey:@"email"];
        clientProfile.email2 = [clientInformation objectForKey:@"email2"];
        clientProfile.cellphone = [clientInformation objectForKey:@"cellphone"];
        clientProfile.cellphone2 = [clientInformation objectForKey:@"cellphone2"];
        clientProfile.street1 = [clientInformation objectForKey:@"street1"];
        clientProfile.street2 = [clientInformation objectForKey:@"street2"];
        clientProfile.city = [clientInformation objectForKey:@"city"];
        clientProfile.zip = [clientInformation objectForKey:@"zip"];
        clientProfile.garageGateCode = [clientInformation objectForKey:@"garagegatecode"];
        clientProfile.alarmCompany = [clientInformation objectForKey:@"alarmcompany"];
        clientProfile.alarmCompanyPhone = [clientInformation objectForKey:@"alarmcophone"];
        clientProfile.hasKey = [clientInformation objectForKey:@"hasKey"];
        clientProfile.keyID = [clientInformation objectForKey:@"keyid"];
        clientProfile.sortName = [clientInformation objectForKey:@"sortname"];
        clientProfile.firstName = [clientInformation objectForKey:@"fname"];
        clientProfile.firstName2 = [clientInformation objectForKey:@"fname2"];
        clientProfile.lastName = [clientInformation objectForKey:@"lname"];
        clientProfile.lastName2 = [clientInformation objectForKey:@"lname2"];
        clientProfile.workphone = [clientInformation objectForKey:@"workphone"];
        clientProfile.alarmInfo = [clientInformation objectForKey:@"alarminfo"];
        clientProfile.homePhone = [clientInformation objectForKey:@"homePhone"];
        clientProfile.clinicPtr = [clientInformation objectForKey:@"clinicptr"];
        clientProfile.vetPtr = [clientInformation objectForKey:@"vetptr"];
        clientProfile.clinicZip = [clientInformation objectForKey:@"cliniczip"];
        
        NSArray *petsData = [clientInformation objectForKey:@"pets"];
        int petCount = [petsData count];
        
        for (int i = 0; i < petCount; i++) {
            NSDictionary *petDataDic = [petsData objectAtIndex:i];
            [clientProfile handlePetInformation:petDataDic];
        }
        [compareClientDetails addObject:clientProfile];
        
    }
    

    for (NSDictionary *key in visitsDic) {
        
        VisitDetails *detailsVisit = [[VisitDetails alloc]init];
        NSDictionary *visitInfo = key;
        
        detailsVisit.appointmentid = [visitInfo objectForKey:@"appointmentid"];
        NSString *clientIntVal = [visitInfo valueForKey:@"clientptr"];
        detailsVisit.clientptr = [NSString stringWithFormat:@"%@",clientIntVal];
        detailsVisit.service = [visitInfo objectForKey:@"service"];
        detailsVisit.starttime = [visitInfo objectForKey:@"starttime"];
        detailsVisit.endtime = [visitInfo objectForKey:@"endtime"];
        detailsVisit.timeofday = [visitInfo objectForKey:@"timeofday"];
        detailsVisit.petName = [visitInfo objectForKey:@"petNames"];
        detailsVisit.latitude = [visitInfo objectForKey:@"latitude"];
        detailsVisit.longitude = [visitInfo objectForKey:@"longitude"];
        detailsVisit.date = [visitInfo objectForKey:@"date"];
        detailsVisit.status = [visitInfo objectForKey:@"status"];
        
        //NSLog(@"visit id: %@, status: %@",detailsVisit.appointmentid, detailsVisit.status);
        
        if ([detailsVisit.status isEqualToString:@"arrived"]) {
            self.onWhichVisitID = detailsVisit.appointmentid;
            //self.onSequence = detailsVisit.sequenceID;
            //NSLog(@"set global sequence id: %@, self val: %@",detailsVisit.sequenceID,self.onSequence);
            detailsVisit.hasArrived = YES;
        }
        
        if((![[visitInfo objectForKey:@"arrived"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"arrived"] length] != 0 )) {
            
            detailsVisit.arrived = [visitInfo objectForKey:@"arrived"];

            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSDate *date = [dateFormat dateFromString:detailsVisit.arrived];
            
            // back to string
            NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
            [dateFormat2 setDateFormat:@"HH:mm a"];
            [dateFormat2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *dateString = [dateFormat2 stringFromDate:date];
            detailsVisit.dateTimeMarkArrive = dateString;
        }

        
        if((![[visitInfo objectForKey:@"completed"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"completed"] length] != 0 )) {
            
            detailsVisit.completed = [visitInfo objectForKey:@"completed"];
            //NSLog(@"completed: %@", [visitInfo objectForKey:@"completed"]);
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSDate *date = [dateFormat dateFromString:detailsVisit.completed];
            
            NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
            [dateFormat2 setDateFormat:@"HH:mm a"];
            [dateFormat2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *dateString = [dateFormat2 stringFromDate:date];
            
            detailsVisit.dateTimeMarkComplete = dateString;
            
        }
        
        if((![[visitInfo objectForKey:@"canceled"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"canceled"] length] != 0 )) {
            
            detailsVisit.canceled = [visitInfo objectForKey:@"canceled"];
            
        }
        
        if((![[visitInfo objectForKey:@"note"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"note"] length] != 0 )) {
            
            detailsVisit.visitNote = [visitInfo objectForKey:@"note"];
            
        }
        
        if((![[visitInfo objectForKey:@"highpriority"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"highpriority"] length] != 0 )) {
            
            detailsVisit.highpriority = YES;
            
        }
        
        if((![[visitInfo objectForKey:@"clientname"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"clientname"] length] != 0 )) {
            
            detailsVisit.clientname = [visitInfo objectForKey:@"clientname"];
            
        }
        
        if((![[visitInfo objectForKey:@"clientemail"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"clientemail"] length] != 0 )) {
            
            detailsVisit.clientEmail = [visitInfo objectForKey:@"clientemail"];
            
        }
        if((![[visitInfo objectForKey:@"highpriority"]isEqual:[NSNull null]] )
           && ( [[visitInfo objectForKey:@"highpriority"] length] != 0 )) {
            
            detailsVisit.highpriority = YES;
            
        }
        
        [compareVisitDetails addObject:detailsVisit];
        
    }

    
    for(VisitDetails *clientPoint in compareVisitDetails) {
        for(DataClient *clientData in compareClientDetails) {
            if ([clientPoint.clientptr isEqualToString:clientData.clientID]) {
                clientPoint.alarmCompany = clientData.alarmCompany;
                clientPoint.alarmCompanyPhone = clientData.alarmCompanyPhone;
                clientPoint.clientPhone = clientData.cellphone;
                clientPoint.clientPhone2 = clientData.cellphone2;
                clientPoint.clientEmail = clientData.email;
                clientPoint.clientEmail2 = clientData.email2;
                clientPoint.street1 = clientData.street1;
                clientPoint.street2 = clientData.street2;
                clientPoint.city = clientData.city;
                clientPoint.zip = clientData.zip;
                clientPoint.garageGateCode = clientData.garageGateCode;
                
                if ([clientData.hasKey isEqualToString:@"Yes"]) {
                    clientPoint.hasKey = YES;
                    clientPoint.keyID = clientData.keyID;
                }
            }
        }
    }
    int p = [_visitData count];
    int i = 100 + p;

    for (VisitDetails *visit in compareVisitDetails) {
        
        BOOL matchVisit = NO;
        if(_visitData != NULL) {
            
            //NSLog(@"VISIT DATA IS NOT NULL");
            for (VisitDetails *currentVisit in _visitData) {
                if ([visit.appointmentid isEqualToString:currentVisit.appointmentid]) {
                    ///NSLog(@"FOUND MATCH VISIT APPOINTMENT");
                    //NSLog(@"visit seq id: %@, current visit: %@",visit.sequenceID,currentVisit.sequenceID);
                    visit.sequenceID = currentVisit.sequenceID;
                    matchVisit = YES;
                }
            }
            
            if(!matchVisit) {
                [_visitData addObject:visit];
                visit.sequenceID = [NSString stringWithFormat:@"%i",i];
                [self addPawPrintForVisits:(int)i forVisit:visit];
                i++;
                //NSLog(@"Adding visit: %@, Pet: %@, Client: %@",visit.appointmentid, visit.petName, visit.clientname);
            }
            
        } else {
            
            visit.sequenceID = [NSString stringWithFormat:@"%i",i];
            [self addPawPrintForVisits:(int)i forVisit:visit];
            [_visitData addObject:visit];

            i++;
            
            
        }
        
        
        if ([visit.status isEqualToString:@"arrived"]) {
            
            //NSLog(@"visit seq ID: %@",visit.sequenceID);
            self.onSequence = visit.sequenceID;

            //NSLog(@"visit status is arrived: %@, sequence id now assigned: %@",visit.appointmentid,self.onSequence);
        }
        
    }
    
    if ([compareVisitDetails count] < [_visitData count]) {

        //NSLog(@"compare visits <");
        
        NSMutableArray *keepVisits = [[NSMutableArray alloc]init];
        
        for (int p = 0; p < [_visitData count]; p++) {
            VisitDetails *visit = [_visitData objectAtIndex:p];
            BOOL matchVisit = NO;
            
            for (int i = 0; i < [compareVisitDetails count]; i++) {
                VisitDetails *newVisit= [compareVisitDetails objectAtIndex:i];
                if ([newVisit.appointmentid isEqualToString:visit.appointmentid]) {
                    matchVisit = YES;
                }
            }
            
            if (matchVisit) {
                //NSLog(@"Adding visit: %@, Pet: %@, Client: %@",visit.appointmentid, visit.petName, visit.clientname);
                [keepVisits addObject:visit];
            }
        }
        
        [_visitData removeAllObjects];
        
        int i = 100;
        
        for (VisitDetails *keepVisitDetails in keepVisits) {
           // NSLog(@"going through keep visits");
        
            keepVisitDetails.sequenceID = [NSString stringWithFormat:@"%i",i];
            [self addPawPrintForVisits:(int)i forVisit:keepVisitDetails];
            [_visitData addObject:keepVisitDetails];
            i++;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:pollingCompleteWithChanges
         object:self];
    });
    
}


-(BOOL)compareVisitIds:(NSMutableArray *)compareVisitArray withCurrentVisits:(NSMutableArray *)currentVisitArray {
    
    BOOL matchForAllID = YES;
    NSMutableArray *extraVisitDataCompare = [[NSMutableArray alloc]init];
    NSMutableArray *extraVisitDataCurrent = [[NSMutableArray alloc]init];
    
    
    // If the new data has an extra visit
    for(NSDictionary *newVisit in compareVisitArray) {
        NSString *visitIDNew = [newVisit objectForKey:@"appointmentid"];
        
        BOOL checkAnID = NO;
        for (NSDictionary *currentVisit in currentVisitArray) {
            NSString *currentID = [currentVisit objectForKey:@"appointmentid"];
            if ([visitIDNew isEqualToString:currentID]) {
                checkAnID = YES;
            }
        }
        if (!checkAnID) {
            
            matchForAllID = NO;
            [extraVisitDataCompare addObject:newVisit];
        }
    }
    
    
    // If the current data has an extra visit
    
    for(NSDictionary *oldVisit in currentVisitArray) {
        
        NSString *currentID = [oldVisit objectForKey:@"apppointmentid"];
        
        BOOL checkAnID = NO;
        for (NSDictionary *newVisit in compareVisitArray) {
            NSString *visitIDNew = [newVisit objectForKey:@"appointmentid"];
            if([currentID isEqualToString:visitIDNew]) {
                checkAnID = YES;
            }
        }
        if(!checkAnID) {
            
            matchForAllID = NO;
            [extraVisitDataCurrent addObject:oldVisit];
        }
    }
    return YES;
}
-(void)addPawPrintForVisits:(int)pawprintID forVisit:(VisitDetails*)visitInfo {
    
    if (pawprintID == 100) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-red-100"];
        visitInfo.sequenceID = @"100";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
        
    } else if (pawprintID == 101) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-lime-100"];
        visitInfo.sequenceID = @"101";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 102) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-purple-100"];
        visitInfo.sequenceID = @"102";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 103) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-dark-blue"];
        visitInfo.sequenceID = @"103";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 104) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-pine-100"];
        visitInfo.sequenceID = @"104";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
        
    } else if (pawprintID == 105) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-orange-100"];
        visitInfo.sequenceID = @"105";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
        
    } else if (pawprintID == 106) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-teal-100"];
        visitInfo.sequenceID = @"106";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 107) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-pink-100"];
        visitInfo.sequenceID = @"107";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 108) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-powder-blue-100"];
        visitInfo.sequenceID = @"108";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 109) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"paw-black-100"];
        visitInfo.sequenceID = @"109";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 110) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"dog-footprint-green"];
        visitInfo.sequenceID = @"110";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 111) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"dog-footprint-green"];
        visitInfo.sequenceID = @"111";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 112) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"dog-footprint-green"];
        visitInfo.sequenceID = @"112";
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
        
    } else if (pawprintID == 113) {
        
        visitInfo.pawPrintForSession = [UIImage imageNamed:@"dog-footprint-green"];
        NSMutableArray *visitPoints = [[NSMutableArray alloc]init];
        [coordinatesForVisits setObject:visitPoints forKey:visitInfo.appointmentid];
    }
}


-(BOOL)checkStatusComparison:(NSString *)forStatus
                 withCurrent:(NSString*)withCurrent
                andNewStatus:(NSString *)newStatus {
    
    

    return YES;
}



-(NSMutableArray *)getClientData {
    return _clientData;
}


-(NSMutableArray *)getVisitData {
    return _visitData;
}

-(NSMutableArray *)visitDataFromServer {
    return _visitData;
}


#pragma mark - Notifications

-(void)setupLocalNotifications {
    UILocalNotification* local = [[UILocalNotification alloc]init];
    if (local)
    {
        local.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        local.alertBody = @"Turn on GPS tracking";
        local.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:local];
    }

    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)turnOffGPSTracking {
    
    if (_userTracking) {
        
        _userTracking = NO;
        NSUserDefaults *settingsGPS = [NSUserDefaults standardUserDefaults];
        [settingsGPS setObject:@"NO" forKey:@"gpsON"];
        
    } else {
        
        _userTracking = YES;
        NSUserDefaults *settingsGPS = [NSUserDefaults standardUserDefaults];
        [settingsGPS setObject:@"YES" forKey:@"gpsON"];
        
    }
}


-(void)changePollingFrequency:(NSNumber*)changePollingFrequencyTo {
    
    _pollingFrequency = (float)[changePollingFrequencyTo floatValue];
    
    NSUserDefaults *settingsPollFrequency = [NSUserDefaults standardUserDefaults];
    [settingsPollFrequency setObject:changePollingFrequencyTo forKey:@"frequencyOfPolling"];


    NSDictionary *mySetting = [settingsPollFrequency dictionaryRepresentation];
    
    NSNumber *frequencyPollingNumberFrom = [mySetting objectForKey:@"frequencyOfPolling"];
    //NSLog(@"frequency of polling: %@",frequencyPollingNumberFrom);

}

-(void)changeDistanceFilter:(NSNumber*)changeDistanceFilterTo {
    
    _distanceSettingForGPS = (float)[changeDistanceFilterTo floatValue];
    
    NSUserDefaults *settingsPollFrequency = [NSUserDefaults standardUserDefaults];
    [settingsPollFrequency setObject:changeDistanceFilterTo forKey:@"distanceSettingForGPS"];
    
    NSDictionary *mySetting = [settingsPollFrequency dictionaryRepresentation];
    NSNumber *distFilter = [mySetting objectForKey:@"distanceSettingForGPS"];
    //NSLog(@"distance filter: %@",distFilter);


}



-(void)setUserDefault:(NSString*)preferenceSetting {
    
    
}

-(void)addPictureForPet:(UIImage*)petPicture {
    
    for (VisitDetails *visitInfo in _visitData) {
        
        if ([_onWhichVisitID isEqualToString:visitInfo.appointmentid]) {
            [visitInfo addImageForPet:petPicture];
        }
        
    }
    
}

-(NSMutableArray *)getTodayVisits {
    //NSLog(@"get today's visits");
    return _visitData;
}


-(void)setUpReachability {
    
    /*[[AFNetworkReachabilityManager sharedManager]startMonitoring];

    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        //NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if (status == -1) {
            //NSLog(@"VISITSANDTRACKING: unknown");
            _isReachable = NO;
            _isUnreachable = YES;
            _isReachableViaWiFi = NO;
            _isReachableViaWWAN = NO;
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"unreachable" object:nil];

        } else if (status == 0) {
            //NSLog(@"VISITSANDTRACKING: not reachable");
            _isReachable = NO;
            _isUnreachable = YES;
            _isReachableViaWiFi = NO;
            _isReachableViaWWAN = NO;
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"unreachable" object:nil];

        } else if (status == 1) {
            //NSLog(@"VISITSANDTRACKING: reachable via wwan");
            _isReachable = YES;
            _isUnreachable = NO;
            _isReachableViaWiFi = NO;
            self.isReachableViaWWAN = YES;
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"reachableWAN" object:nil];

        } else if (status == 2) {
            //NSLog(@"VISITSANDTRACKING: reachable via wifi");
            _isReachable = YES;
            _isUnreachable = NO;
            self.isReachableViaWiFi = YES;
            _isReachableViaWWAN = NO;
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"reachableWIFI" object:nil];

        }
    }];*/
}





-(void) setDeviceType:(NSString*)typeDev {
    
    deviceType = typeDev;
    
}

-(NSString *) tellDeviceType {
    
    return deviceType;
    
}
-(NSString *)getCurrentSystemVersion {
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *systemVersion = [currentDevice systemVersion];
    return systemVersion;
    
}


-(NSString *)stringForYesterday:(int)numDays {
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMdd"];
    NSDate *now = [NSDate date];
    NSDate *yesterday = [now dateByAddingDays:numDays];
    NSString *dateString = [format stringFromDate:yesterday];
    return dateString;
}


-(NSString *)stringForCurrentDateAndTime {
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *now = [NSDate date];
    NSString *dateString = [format stringFromDate:now];
    return dateString;
    
}

-(NSString *)stringForCurrentDay {
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMdd"];
    NSDate *now = [NSDate date];
    NSString *dateString = [format stringFromDate:now];
    return dateString;
}


@end
