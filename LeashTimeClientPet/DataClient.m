//
//  DataClient.m
//  LeashTimeSitterV1
//
//  Created by Ted Hooban on 11/17/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import "DataClient.h"

@implementation DataClient

-(instancetype) init {
    if(self=[super init]){
        _customClientFields = [[NSMutableArray alloc]init];
        _petInfo = [[NSMutableArray alloc]init];
        _groupPets = [[NSMutableDictionary alloc]init];
        _customPetInfo = [[NSMutableDictionary alloc]init];
        
        
    }
    return self;
}



-(void)createFlagData:(NSMutableArray*)flagInfo {
    
    
}



-(void)prettyPrint {
    NSLog(@"----------------------------------");
    NSLog(@"|CLIENT ID; %@                    |",self.clientID);
    NSLog(@"----------------------------------");
    NSLog(@"----------------------------------");
    NSLog(@"Basic Info");
    NSLog(@"----------------------------------");
    NSLog(@"name: %@",self.sortName);
    NSLog(@"Client name: %@",self.clientName);
    NSLog(@"first name; %@",self.firstName);
    NSLog(@"last name; %@",self.lastName);
    NSLog(@"first name2; %@",self.firstName2);
    NSLog(@"last name2; %@",self.lastName2);
    NSLog(@"email; %@",self.email);
    NSLog(@"email2; %@",self.email2);
    NSLog(@"Home Phone: %@",self.homePhone);
    NSLog(@"workphone; %@",self.workphone);
    NSLog(@"cellphone; %@",self.cellphone);
    NSLog(@"cellphone2; %@",self.cellphone2);
    NSLog(@"----------------------------------");
    NSLog(@"Address");
    NSLog(@"----------------------------------");
    NSLog(@"street; %@",self.street1);
    NSLog(@"street2; %@",self.street2);
    NSLog(@"city; %@",self.city);
    NSLog(@"state; %@",self.state);
    NSLog(@"zip; %@",self.zip);
    NSLog(@"----------------------------------");
    NSLog(@"Security");
    NSLog(@"----------------------------------");
    NSLog(@"Garage/Gate Code; %@",self.garageGateCode);
    NSLog(@"Alarm Info: %@",self.alarmInfo);
    NSLog(@"Alarm Company: %@",self.alarmCompany);
    NSLog(@"Alarm Company Phone: %@",self.alarmCompanyPhone);
    NSLog(@"key ID; %@",self.keyID);
    NSLog(@"Has Key: %@",self.hasKey);
    NSLog(@"----------------------------------");
    NSLog(@"Veterinary Clinic");
    NSLog(@"----------------------------------");
    NSLog(@"Clinic Name: %@",self.clinicName);
    NSLog(@"Clinic Street: %@",self.clinicStreet1);
    NSLog(@"Clinic Street2: %@",self.clinicStreet2);
    NSLog(@"Clinic Phone: %@",self.clinicPhone);
    NSLog(@"Clinic City: %@",self.clinicCity);
    NSLog(@"Clinic Lat: %@",self.clinicLat);
    NSLog(@"Clinic Lon: %@",self.clinicLon);
    NSLog(@"Vet: %@",self.vetPtr);
    NSLog(@"----------------------------------");
    NSLog(@"Pet Info");
    NSLog(@"----------------------------------");
    
    for (NSDictionary *petDicTmp in _petInfo) {
    
        NSLog(@"--------------------------");
        NSLog(@"%@",[petDicTmp valueForKey:@"name"]);
        NSLog(@"----------------------------------");
        for(NSString *petKey in petDicTmp) {
            
            NSLog(@"[C]%@: %@",petKey,[petDicTmp valueForKey:petKey]);
            
        }
    }
    
    NSLog(@"----------------------------------");
    NSLog(@"Custom Client Fields");
    NSLog(@"----------------------------------");
    
    for (NSDictionary *dicTemp in _customClientFields) {

        NSString *label = [dicTemp objectForKey:@"label"];
        NSString *value = [dicTemp objectForKey:@"value"];
    }
    
}

-(void)handleCustomClientFields:(NSDictionary*)customClientFields {
    

    NSString *label = [customClientFields objectForKey:@"label"];
    NSString *value = [customClientFields objectForKey:@"value"];
    
    if (label != NULL) {
        [_customClientFields addObject:customClientFields];
    }
    
    
}

-(void)handlePetInformation:(NSDictionary *)customPetFields {
    
    NSMutableDictionary *flatPetDic = [[NSMutableDictionary alloc]init];
    
    _petName = [customPetFields valueForKey:@"name"];
    [flatPetDic setObject:_petName forKey:@"name"];
    
    
    if((![[customPetFields objectForKey:@"breed"]isEqual:[NSNull null]] && [[customPetFields objectForKey:@"breed"]length] != 0)) {
        _petBreed = [customPetFields valueForKey:@"breed"];
        [flatPetDic setObject:_petBreed forKey:@"breed"];
    }
    if((![[customPetFields objectForKey:@"color"]isEqual:[NSNull null]] && [[customPetFields objectForKey:@"color"]length] != 0)) {
        _petColor = [customPetFields valueForKey:@"color"];
        [flatPetDic setObject:_petColor forKey:@"color"];
    }
    if((![[customPetFields objectForKey:@"fixed"]isEqual:[NSNull null]] && [[customPetFields objectForKey:@"fixed"]length] != 0)) {
        _petFixed = [customPetFields valueForKey:@"fixed"];
        [flatPetDic setObject:_petFixed forKey:@"fixed"];
    }
    if((![[customPetFields objectForKey:@"notes"]isEqual:[NSNull null]] && [[customPetFields objectForKey:@"notes"]length] != 0)) {
        _petNotes = [customPetFields valueForKey:@"notes"];
        [flatPetDic setObject:_petNotes forKey:@"notes"];
    }
    if((![[customPetFields objectForKey:@"age"]isEqual:[NSNull null]] && [[customPetFields objectForKey:@"age"]length] != 0)) {
        _petAge = [customPetFields valueForKey:@"age"];
        [flatPetDic setObject:_petAge forKey:@"age"];
    }
    if((![[customPetFields objectForKey:@"description"]isEqual:[NSNull null]] && [[customPetFields objectForKey:@"description"]length] != 0)) {
        _petDescription = [customPetFields valueForKey:@"description"];
        [flatPetDic setObject:_petDescription forKey:@"description"];
    }
    if(![[customPetFields objectForKey:@"petcustom1"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom1"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];
        
        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    if(![[customPetFields objectForKey:@"petcustom2"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom2"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    if(![[customPetFields objectForKey:@"petcustom3"]isEqual:[NSNull null]]) {
        
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom3"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    if(![[customPetFields objectForKey:@"petcustom4"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom4"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    if(![[customPetFields objectForKey:@"petcustom5"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom5"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    if(![[customPetFields objectForKey:@"petcustom6"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom6"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom7"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom7"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom8"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom8"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom9"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom9"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];
        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom10"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom10"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];
        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom11"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom11"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom12"]isEqual:[NSNull null]]) {
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom12"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    if(![[customPetFields objectForKey:@"petcustom13"]isEqual:[NSNull null]]) {
        
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom13"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom14"]isEqual:[NSNull null]]) {
        
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom14"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom15"]isEqual:[NSNull null]]) {
        
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom15"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom16"]isEqual:[NSNull null]]) {
        
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom16"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    if(![[customPetFields objectForKey:@"petcustom17"]isEqual:[NSNull null]]) {
        
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom17"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];

        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    if(![[customPetFields objectForKey:@"petcustom18"]isEqual:[NSNull null]]) {
        
        NSDictionary *customFieldPet = [customPetFields valueForKey:@"petcustom18"];
        NSString *label = [customFieldPet objectForKey:@"label"];
        NSString *value = [customFieldPet objectForKey:@"value"];
        if (![value isEqual:[NSNull null]] && [value length] != 0) {
            [flatPetDic setObject:value forKey:label];
        }
    }
    
    [_petInfo addObject:flatPetDic];

}

@end
