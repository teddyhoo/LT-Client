//
//  WellnessEvent.h
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/7/15.
//
//

#import <Foundation/Foundation.h>

@interface WellnessEvent : NSObject

@property (nonatomic,copy) NSString *eventName;
@property (nonatomic,copy) NSString *frequencyEvent;
@property (nonatomic,strong) NSData *nextSchedule;
@property (nonatomic,strong) NSData *prevSchedule;
@property (nonatomic,copy) NSString *purposeForEvent;
@property (nonatomic,copy) NSString *explanationEvent;

@property (nonatomic,strong) NSMutableArray *medicationOptions;


@end
