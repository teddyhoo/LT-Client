//
//  RequestViewController.h
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/8/15.
//
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "JTCalendarDayView.h"
#import "AKPickerView.h"
#import "VisitsAndTracking.h"

@interface RequestViewController : UIViewController <JTCalendarDataSource>

@property(nonatomic,strong) JTCalendarMenuView *calendarMenuView;
@property(nonatomic,strong) JTCalendarContentView *calendarContentView;
@property(nonatomic,strong) JTCalendarDayView *dayView;

@property (strong, nonatomic) JTCalendar *calendar;
@property (nonatomic,strong) UIView *visitDetails;

@property (nonatomic,strong) NSString *startDatePicked;
@property (nonatomic,strong) NSString *endDatePicked;
@property (nonatomic,strong) NSMutableArray *selectedDates;

@property (nonatomic,strong) AKPickerView *pickerView;
@property (nonatomic,strong) AKPickerView *patternPickerView;
@property (nonatomic,strong) AKPickerView *timePickerView;

@property (nonatomic,strong) VisitsAndTracking *sharedVisitsTracking;

@property BOOL isIphone6P;
@property BOOL isIphone6;
@property BOOL isIphone5;
@property BOOL isIphone4;

@end
