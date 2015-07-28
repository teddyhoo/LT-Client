//
//  CalendarViewController.m
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/8/15.
//
//

#import "CalendarViewController.h"

@interface CalendarViewController () {
    
    NSMutableDictionary *eventsByDate;
    NSMutableArray *theVisitData;
    NSMutableArray *displayVisitData;
}

@end

BOOL startDateTouch;
BOOL endDateTouch;

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    startDateTouch = NO;
    endDateTouch = NO;
    _selectedDates = [[NSMutableArray alloc]init];
    displayVisitData = [[NSMutableArray alloc]init];
    
    eventsByDate = [NSMutableDictionary new];

    NSString *pListData = [[NSBundle mainBundle]
                           pathForResource:@"Visits"
                           ofType:@"plist"];
    
   
    
    theVisitData = [[NSMutableArray alloc] initWithContentsOfFile:pListData];

    
    for (NSDictionary *eventInfo in theVisitData) {
        
        NSString *theDate = [eventInfo objectForKey:@"StartTime"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        NSDate *date = [dateFormat dateFromString:theDate];
        
        
        NSString *service = [eventInfo objectForKey:@"Service"];
        NSString *notes = [eventInfo objectForKey:@"Notes"];
        NSString *status = [eventInfo objectForKey:@"Status"];
        NSString *timeWindow = [eventInfo objectForKey:@"EndTime"];

        
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
        NSInteger day = [weekdayComponents day];
        NSString *dayNum = [NSString stringWithFormat:@"-%ld",day];
        NSString *weekdayStr;
        
        NSInteger weekday = [weekdayComponents weekday];
        if(weekday == 1) {
            weekdayStr = @"SUN";
            
        } else if (weekday == 2) {
            weekdayStr = @"MON";
            
        } else if (weekday == 3) {
            weekdayStr = @"TUE";
            
        } else if (weekday == 4) {
            weekdayStr = @"WED";
            
        } else if (weekday == 5) {
            weekdayStr = @"THU";
            
        } else if (weekday == 6) {
            weekdayStr = @"FRI";
            
        } else if (weekday == 7) {
            weekdayStr = @"SAT";
            
        }
        
        weekdayStr = [weekdayStr stringByAppendingString:dayNum];
        NSLog(@"day: %@",weekdayStr);
        
        NSMutableArray *dateData = [[NSMutableArray alloc]initWithObjects:weekdayStr,service,notes,timeWindow,status, nil];
        if(date != NULL) [eventsByDate setObject:dateData forKey:theDate];
        
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.calendar = [JTCalendar new];
    
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 8. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 0.75;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld %@", comps.year, monthText];
        };
    }
    
    
    self.calendarMenuView = [[JTCalendarMenuView alloc]initWithFrame:CGRectMake(0,60,320, 30)];
    self.calendarContentView = [[JTCalendarContentView alloc]initWithFrame:CGRectMake(0, 90, 320, 290)];
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    
    [self.view addSubview:self.calendarMenuView];
    [self.view addSubview:self.calendarContentView];
    
    [self.calendar setDataSource:self];
    [self.calendar reloadData];
}


-(void) createEventDetailsView:(NSString*)dateFor
                   serviceName:(NSString*)service
                      notesFor:(NSString *)notes
                       timeFor:(NSString*)time
                     statusFor:(NSString*)status  {

    
    UIImageView *eventView;
    
    float indexForView = [displayVisitData count] * 110;
    if (indexForView > 400) {
        indexForView = 100;
        
    }
    
    if ([status isEqualToString:@"Canceled"]) {
        eventView = [[UIImageView alloc]initWithFrame:CGRectMake(indexForView, 420, 100, 100)];
        [eventView setImage:[UIImage imageNamed:@"canceled-visit-details"]];
        
        
    } else {
        eventView = [[UIImageView alloc]initWithFrame:CGRectMake(indexForView, 420, 100, 100)];
        [eventView setImage:[UIImage imageNamed:@"visit-details"]];
    }
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, eventView.frame.size.width, 20)];
    [dateLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:12]];
    //[dateLabel setText:@"10 MON"];
    [dateLabel setText:dateFor];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, eventView.frame.size.width-10, 20)];
    [labelTitle setFont:[UIFont fontWithName:@"Lato-Regular" size:12]];
    //[labelTitle setText:@"Dog Walk 30 min"];
    [labelTitle setText:service];
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(20,50, 100, 20)];
    [labelTime setFont:[UIFont fontWithName:@"Lato-Regular" size:12]];
    //[labelTime setText:@"11a-1p"];
    [labelTime setText:time];
    
    UIImageView *timeWindowView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 15, 15)];
    [timeWindowView setImage:[UIImage imageNamed:@"clock-icon"]];
    

    UIImageView *noteView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 70, 15, 15)];
    [noteView setImage:[UIImage imageNamed:@"note-icon"]];
    
    UILabel *labelNote = [[UILabel alloc]initWithFrame:CGRectMake(25, 70, eventView.frame.size.width-10, 20)];
    [labelNote setFont:[UIFont fontWithName:@"Lato-Regular" size:12]];
    [labelNote setText:@"Feed dog"];

    UIImageView *cancelVisit = [[UIImageView alloc]initWithFrame:CGRectMake(eventView.frame.size.width - 20,0, 15, 15)];
    [cancelVisit setImage:[UIImage imageNamed:@"red-remove-button"]];

    [eventView addSubview:timeWindowView];
    [eventView addSubview:labelTime];
    [eventView addSubview:labelTitle];
    [eventView addSubview:dateLabel];
    [eventView addSubview:noteView];
    [eventView addSubview:cancelVisit];
    [eventView addSubview:labelNote];
    [self.view addSubview:eventView];
    
    [displayVisitData addObject:eventView];
    
    
}
- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    NSArray *events = eventsByDate[key];
    
    /*for (NSString *eventInfo in events) {
        NSLog(@"event info: %@",eventInfo);
    }
    */
    /*[self createEventDetailsView:[events objectAtIndex:0]
                     serviceName:[events objectAtIndex:1]
                        notesFor:[events objectAtIndex:2]
                         timeFor:[events objectAtIndex:3]
                       statusFor:[events objectAtIndex:4]];*/
    
    
    
    
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}


- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
