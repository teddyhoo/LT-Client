//
//  CalendarViewController.h
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/8/15.
//
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "JTCalendarDayView.h"

@interface CalendarViewController : UIViewController<JTCalendarDataSource>

@property(nonatomic,strong) JTCalendarMenuView *calendarMenuView;
@property(nonatomic,strong) JTCalendarContentView *calendarContentView;
@property(nonatomic,strong) JTCalendarDayView *dayView;

@property (strong, nonatomic) JTCalendar *calendar;
@property (nonatomic,strong) UIView *visitDetails;

@property (nonatomic,strong) NSString *startDatePicked;
@property (nonatomic,strong) NSString *endDatePicked;
@property (nonatomic,strong) NSMutableArray *selectedDates;


@end
