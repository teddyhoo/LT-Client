//
//  JTCalendarDayView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "JTCalendar.h"

@interface JTCalendarDayView : UIView

@property (weak, nonatomic) JTCalendar *calendarManager;

@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL isOtherMonth;
@property (strong,nonatomic) NSDate *startDate;
@property (strong,nonatomic) NSDate *endDate;

- (void)reloadData;
- (void)reloadAppearance;

@end
