//
//  VisitDetails.m
//  LeashTimeSitter
//
//  Created by Ted Hooban on 7/11/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import "VisitDetails.h"
#import <UIKit/UIImage.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation VisitDetails


-(id)initWithVisits:(NSMutableDictionary*)visitDetails {
    
    self = [super init];
    if (self)
    {
        
        _routePoints = [[NSMutableArray alloc]init];
        _isComplete = NO;
        _hasArrived = NO;
        _cancelationPending = NO;
        _isCanceled = NO;
        _appointmentid = [visitDetails valueForKey:@"appointmentid"];
        _petName = [visitDetails valueForKey:@"petName"];
        _starttime = [visitDetails valueForKey:@"starttime"];
        _endtime = [visitDetails valueForKey:@"endtime"];
        _petImage = [visitDetails valueForKey:@"PetImage"];
        _clientname = [visitDetails valueForKey:@"clientname"];
        _service = [visitDetails valueForKey:@"service"];
        _clientPhone = [visitDetails valueForKey:@"ClientPhone"];
        _homeAddress = [visitDetails valueForKey:@"Street"];
        _clientNote = [visitDetails valueForKey:@"ClientNote"];
        _petNote1 = [visitDetails valueForKey:@"PetNote1"];
        _petNote2 = [visitDetails valueForKey:@"PetNote2"];
        _petNote3 = [visitDetails valueForKey:@"PetNote3"];
        _latitude = [visitDetails valueForKey:@"latitude"];
        _longitude = [visitDetails valueForKey:@"longitude"];
        _petAge = [visitDetails valueForKey:@"PetAge"];
        _petBreed = [visitDetails valueForKey:@"PetBreed"];
        _petNotes = [visitDetails valueForKey:@"PetNotes"];
        _alarmCompany = [visitDetails valueForKey:@"AlarmCompany"];
        _alarmCompanyPhone = [visitDetails valueForKey:@"AlarmCompanyPhone"];
        _alarmCodeOn = [visitDetails valueForKey:@"AlarmCodeOn"];
        _alarmCodeOff = [visitDetails valueForKey:@"AlarmCodeOff"];
        
        
        petPhotos = [[NSMutableArray alloc]init];
    
    }
    return self;
    
    
}


-(instancetype)init {
    
    self = [super init];
    if(self) {
        fileManager = [NSFileManager new];
        _currentPetImage = NULL;
    }
    
    return self;
    
}

-(void) addVisitNoteToVisit:(NSString*)visitNote {
    self.visitNoteBySitter = [NSString stringWithString:visitNote];
    [self writeVisitDataToFile];
    
}


-(void) markComplete:(NSString*)timeMarkComplete
            latitude:(NSString *)coordinateLatitudeMarkComplete
           longitude:(NSString *)coordinateLongitudeMarkComplete {
    
    _isComplete = YES;
    _hasArrived = FALSE;
    self.status = @"completed";
    _dateTimeMarkComplete = [NSString stringWithString:timeMarkComplete];
    _coordinateLatitudeMarkComplete = [NSString stringWithString:coordinateLatitudeMarkComplete];
    _coordinateLongitudeMarkComplete = [NSString stringWithString:coordinateLongitudeMarkComplete];
    [self writeVisitDataToFile];

    
}



-(void)markArrive:(NSString*)timeMarkArrive
         latitude:(NSString *)coordinateLatitudeMarkArrive
         longitude:(NSString *)coordinateLongitudeMarkArrive   {
    
    _inProcess = YES;
    _hasArrived = YES;
    self.status = @"arrived";
    _dateTimeMarkArrive = [NSString stringWithString:timeMarkArrive];
    _coordinateLatitudeMarkArrive = [NSString stringWithString:coordinateLatitudeMarkArrive];
    _coordinateLongitudeMarkArrive = [NSString stringWithString:coordinateLongitudeMarkArrive];
    [self writeVisitDataToFile];

}

-(void)addImageForRoute:(UIImage *)routeImage {
    
    _mapImage = routeImage;
    NSData *imageData = UIImagePNGRepresentation(_mapImage);
    
    
}


-(void)addImageForPet:(UIImage*)petImage {
    
    NSLog(@"Sending to server...");
    _currentPetImage = petImage;
    NSData *imageData = UIImagePNGRepresentation(_currentPetImage);
    
    [petPhotos addObject:petImage];

    NSString *dateForImageFilename = [self stringForCurrentDateAndTime];
    NSString *nameOfImageFile = [NSString stringWithFormat:@"image-%@.png",dateForImageFilename];
    _petImageFile = [NSString stringWithString:nameOfImageFile];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    NSString *imagePath = [documentsPath stringByAppendingPathComponent:
                           [NSString stringWithFormat:@"image-%@.png",
                            dateForImageFilename]];
    
    [imageData writeToFile:imagePath atomically:YES];
    NSLog(@"image path: %@",imagePath);

    NSURL *filePathURL = [[NSURL alloc]initFileURLWithPath:imagePath];
    
    [self sendPhotoViaAFNetwork:filePathURL imageData:imageData imageFileNameString:nameOfImageFile];
    
}

-(void)sendPhotoViaAFNetwork:(NSURL*)filePathURL
                   imageData:(NSData*)imageData
         imageFileNameString:(NSString*)imageFileNameString {
    
    /*NSString *scriptName = @"https://leashtime.com/appointment-photo-upload.php";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    serializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain",@"text/html",@"application/json"]];

    manager.responseSerializer = serializer;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    NSDictionary *creds = [[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
    
    NSString *username = [creds objectForKey:@"username"];
    NSString *pass = [creds objectForKey:@"password"];
    NSLog(@"%@, %@",username,pass);
    
    NSDictionary *parameters = @{@"loginid":  username,
                                 @"password": pass,
                                 @"appointmentid": self.appointmentid};
    
    [manager POST:scriptName
       parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
        [formData appendPartWithFileData:imageData
                                    name:@"image"
                                fileName:imageFileNameString
                                mimeType:@"image/png"];
    
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@", responseObject);


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];*/
}
    


-(void)writeVisitDataToFile {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    NSString *filename = [NSString stringWithFormat:@"%@-visitdetails",self.appointmentid];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:filename];

    NSMutableDictionary *fileDictionary = [self getMyVisitDetails:self.appointmentid];
    BOOL wroteVisitDetails = [fileDictionary writeToFile:plistPath atomically:YES];
    if (wroteVisitDetails) {
        NSLog(@"wrote out visit details successfully");
        for (NSString *key in fileDictionary) {
            NSLog(@"%@: %@",key,[fileDictionary valueForKey:key]);
        }
    }
}



-(void)syncVisitDetailFromFile {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    NSString *filename = [NSString stringWithFormat:@"%@-visitdetails",self.appointmentid];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:filename];
    
    
    if([fileManager fileExistsAtPath:plistPath]) {
        
        NSLog(@"file exists");
        NSDictionary *visitDetail = [[NSDictionary alloc]initWithContentsOfFile:plistPath];

        self.visitNoteBySitter = [visitDetail valueForKey:@"visitNoteBySitter"];
        
        if(self.dateTimeMarkArrive == NULL)
            self.dateTimeMarkArrive = [visitDetail valueForKey:@"dateTimeMarkArrive"];
        if(self.dateTimeMarkComplete == NULL)
            self.dateTimeMarkComplete = [visitDetail valueForKey:@"dateTimeMarkComplete"];
        
        self.coordinateLatitudeMarkArrive =[visitDetail valueForKey:@"coordinateLatitudeMarkArrive"];
        self.coordinateLongitudeMarkArrive = [visitDetail valueForKey:@"coordinateLongitudeMarkArrive"];
        self.coordinateLongitudeMarkComplete = [visitDetail valueForKey:@"coordinateLongitudeMarkComplete"];
        self.coordinateLatitudeMarkComplete = [visitDetail valueForKey:@"coordinateLatitudeMarkComplete"];
        self.dateTimeVisitReportSubmit = [visitDetail valueForKey:@"dateTimeVisitReportSubmit"];
        self.petImageFile = [visitDetail valueForKey:@"petImageFile"];
        NSString *petImagePath = [documentsPath stringByAppendingPathComponent:_petImageFile];

        _currentPetImage = [[UIImage alloc]initWithContentsOfFile:petImagePath];
        
        if([[visitDetail valueForKey:@"didPoo"]isEqualToString:@"YES"]) {
            _didPoo = YES;
        } else {
            _didPoo = NO;
        }
        if([[visitDetail valueForKey:@"didPee"]isEqualToString:@"YES"]) {
            _didPee = YES;
        } else {
            _didPee = NO;
        }
        if([[visitDetail valueForKey:@"wasHappy"]isEqualToString:@"YES"]) {
            _wasHappy = YES;
        } else {
            _wasHappy = NO;
        }
        if([[visitDetail valueForKey:@"wasSad"]isEqualToString:@"YES"]) {
            _wasSad = YES;
        } else {
            _wasSad = NO;
        }
        if ([[visitDetail valueForKey:@"wasAngry"]isEqualToString:@"YES"]) {
            _wasAngry = YES;
            
        } else {
            _wasAngry = NO;
        }
        if([[visitDetail valueForKey:@"wasShy"]isEqualToString:@"YES"]) {
            _wasShy = YES;
            
        } else  {
            _wasShy = NO;
        }
        if([[visitDetail valueForKey:@"wasHungry"]isEqualToString:@"YES"]) {
            _wasHungry = YES;
            
        } else  {
            _wasHungry = NO;
        }
        if ([[visitDetail valueForKey:@"wasSick"]isEqualToString:@"YES"]) {
            _wasSick = YES;
        } else {
            _wasSick = NO;

        }
        if([[visitDetail valueForKey:@"didPlay"]isEqualToString:@"YES"]) {
            _didPlay = YES;
        } else {
            _didPlay = NO;
        }
        if ([[visitDetail valueForKey:@"wasCat"]isEqualToString:@"YES"]) {
            _wasCat = YES;
        } else {
            _wasCat = NO;
        }
        if ([[visitDetail valueForKey:@"didScoopLitter"]isEqualToString:@"YES"]) {
            
            _didScoopLitter = YES;
        } else {
            _didScoopLitter = NO;
        }
    }
}


-(void)addPointForRouteUsingCLLocation:(CLLocation*)location {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormat setDateFormat:@"hhMMss"];
    
    NSData *pointData = [NSKeyedArchiver archivedDataWithRootObject:location];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    NSString *filename = [NSString stringWithFormat:@"%@-coordinates",self.appointmentid];
    NSString *coordinateFilePath = [documentsPath stringByAppendingPathComponent:filename];
    
    //NSLog(@"coordinate file path: %@",coordinateFilePath);
    
    if([fileManager fileExistsAtPath:coordinateFilePath]) {
        
        NSArray *coordinateArray = [[NSArray alloc]initWithContentsOfFile:coordinateFilePath];
        _routePoints = [[NSMutableArray alloc]initWithArray:coordinateArray];
        [_routePoints addObject:pointData];
        NSArray *coordinateArrayFile = [[NSArray alloc]initWithArray:_routePoints];
        BOOL wroteCoordArr = [coordinateArrayFile writeToFile:coordinateFilePath atomically:YES];
        
        if(wroteCoordArr) {
            
            //NSLog(@"coordinate count: %lu",(unsigned long)[coordinateArrayFile count]);
        } else {
            
            //NSLog(@"coord arr file not written");

        }
    } else {
        
        NSArray *coordinateArray = [[NSArray alloc]initWithObjects:pointData, nil];
        BOOL wroteCoordArr = [coordinateArray writeToFile:coordinateFilePath atomically:YES];
        if(wroteCoordArr) {
            
            //NSLog(@"coord arr file written");
            
        } else {
            
            //NSLog(@"coord arr file not written");
        }

    }
    
}


-(NSArray*)getPointForRoutes {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    NSString *filename = [NSString stringWithFormat:@"%@-coordinates",self.appointmentid];
    NSString *coordinateFilePath = [documentsPath stringByAppendingPathComponent:filename];
    
    if([fileManager fileExistsAtPath:coordinateFilePath]) {
        
        NSArray *coordinateArray = [[NSArray alloc]initWithContentsOfFile:coordinateFilePath];
        return coordinateArray;

    } else {
        
        return NULL;
        
    }
}



-(void)printDirectoryFiles:(NSURL*)docsurl {
    
    NSDirectoryEnumerator *dir = [fileManager enumeratorAtURL:docsurl
                                   includingPropertiesForKeys:nil
                                                      options:0
                                                 errorHandler:nil];
    
    
    for (NSURL* files in dir) NSLog(@"%@", [files lastPathComponent]);
    
    
}
// store coordinates
// store images - transmit images
// store mood button status
// store

-(NSMutableArray *)getImagesFromFileSystem {
    
    return petPhotos;
    
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


-(NSMutableDictionary *)getMyVisitDetails:(NSString *)visitID {
    
    NSMutableDictionary *visitDetails = [[NSMutableDictionary alloc]init];
    [visitDetails setValue:self.appointmentid forKey:@"appointmentid"];
    [visitDetails setValue:self.visitNoteBySitter forKey:@"visitNoteBySitter"];
    [visitDetails setValue:self.dateTimeMarkArrive forKey:@"dateTimeMarkArrive"];
    [visitDetails setValue:self.dateTimeMarkComplete forKey:@"dateTimeMarkComplete"];
    [visitDetails setValue:self.coordinateLatitudeMarkArrive forKey:@"coordinateLatitudeMarkArrive"];
    [visitDetails setValue:self.coordinateLongitudeMarkArrive forKey:@"coordinateLongitudeMarkArrive"];
    [visitDetails setValue:self.coordinateLongitudeMarkComplete forKey:@"coordinateLongitudeMarkComplete"];
    [visitDetails setValue:self.coordinateLatitudeMarkComplete forKey:@"coordinateLatitudeMarkComplete"];
    [visitDetails setValue:self.dateTimeVisitReportSubmit forKey:@"dateTimeVisitReportSubmit"];
    [visitDetails setValue:self.petImageFile forKey:@"petImageFile"];
    
    if (_didPoo) {
        [visitDetails setValue:@"YES" forKey:@"didPoo"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"didPoo"];
    }
    
    if (_didPee) {
        [visitDetails setValue:@"YES" forKey:@"didPee"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"didPee"];
    }
    
    if (_wasHappy) {
        [visitDetails setValue:@"YES" forKey:@"wasHappy"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"wasHappy"];
    }
    
    if (_wasSad) {
        [visitDetails setValue:@"YES" forKey:@"wasSad"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"wasSad"];
    }
    
    if (_wasAngry) {
        [visitDetails setValue:@"YES" forKey:@"wasAngry"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"wasAngry"];
    }
    
    if (_wasShy) {
        [visitDetails setValue:@"YES" forKey:@"wasShy"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"wasShy"];
    }
    
    if (_wasHungry) {
        [visitDetails setValue:@"YES" forKey:@"wasHungry"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"wasHungry"];
    }
    
    if (_wasSick) {
        [visitDetails setValue:@"YES" forKey:@"wasSick"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"wasSick"];
    }
    
    if (_didPlay) {
        [visitDetails setValue:@"YES" forKey:@"didPlay"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"didPlay"];
    }
    
    if (_wasCat) {
        [visitDetails setValue:@"YES" forKey:@"wasCat"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"wasCat"];
    }
    
    if (_didScoopLitter) {
        [visitDetails setValue:@"YES" forKey:@"didScoopLitter"];
    } else {
        [visitDetails setValue:@"NO" forKey:@"didScoopLitter"];
    }
    
    return visitDetails;
    
}

@end
