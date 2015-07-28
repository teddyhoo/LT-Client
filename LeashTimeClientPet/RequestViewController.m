//
//  RequestViewController.m
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/8/15.
//
//

#import "RequestViewController.h"
#import "AKPickerView.h"

@interface RequestViewController () {

    NSMutableDictionary *eventsByDate;
    NSMutableArray *theVisitData;
    NSMutableArray *displayVisitData;

}

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *timeWindows;
@property (nonatomic,strong) NSArray *pets;

@end



@implementation RequestViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    NSString *theDeviceType = [_sharedVisitsTracking tellDeviceType];
    NSLog(@"the device type: %@",theDeviceType);
    
    if ([theDeviceType isEqualToString:@"iPhone6P"]) {
        _isIphone6P = YES;
        _isIphone6 = NO;
        _isIphone5 = NO;
        _isIphone4 = NO;
        
    } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
        _isIphone6 = YES;
        _isIphone6P = NO;
        _isIphone5 = NO;
        _isIphone4 = NO;
        
    } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
        _isIphone5 = YES;
        _isIphone6P = NO;
        _isIphone6 = NO;
        _isIphone4 = NO;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"white-blue-bg-1136x640"]];
    background.alpha = 0.5;
    [self.view addSubview:background];
    
    [self loadDataForCal];
    [self setupCalendarView];
    [self setupSchedulerView];
    
    
}

-(void)loadDataForCal {
    
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
}


-(void)setupCalendarView {
    
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
    
    if (_isIphone6P) {
        
        self.calendarContentView = [[JTCalendarContentView alloc]initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 290)];
    } else if (_isIphone6) {
        
        self.calendarContentView = [[JTCalendarContentView alloc]initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 290)];
        
    } else if (_isIphone5) {
        self.calendarContentView = [[JTCalendarContentView alloc]initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 290)];
        
    } else if (_isIphone4) {
        
        self.calendarContentView = [[JTCalendarContentView alloc]initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 290)];
    }
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    
    [self.view addSubview:self.calendarMenuView];
    [self.view addSubview:self.calendarContentView];
    
    [self.calendar setDataSource:self];
    [self.calendar reloadData];
    
}

-(void)setupSchedulerView {
    UILabel *requestVisit = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 200,30)];
    [requestVisit setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [requestVisit setText:@"Request Visits"];
    [self.view addSubview:requestVisit];
    
    
    UIImageView *backDialIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-310, 30, 30)];
    [backDialIcon setImage:[UIImage imageNamed:@"dog-icon-outline"]];
    [self.view addSubview:backDialIcon];
    
    
    UIImageView *backDialIcon2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 245, 30, 30)];
    [backDialIcon2 setImage:[UIImage imageNamed:@"clock-icon"]];
    [self.view addSubview:backDialIcon2];
    
    
    
    UIImageView *backDial = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-310, 600, 60)];
    [backDial setImage:[UIImage imageNamed:@"green-bg-new"]];
    [self.view addSubview:backDial];
    
    
    UIImageView *backDial3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 245, 500, 60)];
    [backDial3 setImage:[UIImage imageNamed:@"light-blue-box"]];
    [self.view addSubview:backDial3];

    
    UIImageView *backDial2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-165, 500, 60)];
    [backDial2 setImage:[UIImage imageNamed:@"pink-bg-800x100"]];
    [self.view addSubview:backDial2];
    
    
    self.pickerView = [[AKPickerView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 310, 400, 50)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.tag = 1;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pickerView.font = [UIFont fontWithName:@"CompassRoseCPC-Regular" size:20];
    self.pickerView.highlightedFont = [UIFont fontWithName:@"CompassRoseCPC-Bold" size:24];
    self.pickerView.interitemSpacing = 20.0;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyle3D;
    [self.view addSubview:self.pickerView];
    
    self.timePickerView = [[AKPickerView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 235 ,360, 50)];
    self.timePickerView.delegate = self;
    self.timePickerView.dataSource = self;
    self.timePickerView.tag  = 2;
    self.timePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.timePickerView.font = [UIFont fontWithName:@"CompassRoseCPC-Regular" size:20];
    self.timePickerView.highlightedFont = [UIFont fontWithName:@"CompassRoseCPC-Bold" size:24];
    self.timePickerView.interitemSpacing = 24.0;
    self.timePickerView.fisheyeFactor = 0.0001;
    self.timePickerView.pickerViewStyle = AKPickerViewStyle3D;
    [self.view addSubview:self.timePickerView];
    
    self.patternPickerView = [[AKPickerView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 165,360, 50)];
    self.patternPickerView.delegate = self;
    self.patternPickerView.dataSource = self;
    self.patternPickerView.tag  = 3;
    self.patternPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.patternPickerView.font = [UIFont fontWithName:@"CompassRoseCPC-Regular" size:20];
    self.patternPickerView.highlightedFont = [UIFont fontWithName:@"CompassRoseCPC-Bold" size:24];
    self.patternPickerView.interitemSpacing = 44.0;
    self.patternPickerView.fisheyeFactor = 0.0001;
    self.patternPickerView.pickerViewStyle = AKPickerViewStyle3D;
    [self.view addSubview:self.patternPickerView];

    
    self.titles =  @[@"Dog Walk - 30 min",
                     @"Dog Walk - 20 min",
                     @"Pet Sit - AM",
                     @"Pet Sit - PM",
                     @"Pet Sit - Mid",
                     @"Overnight",
                     @"Vet Visit",
                     @"Wellness",
                     @"Adventure Run",
                     @"Day Care - Boarding"];
    
    
    self.timeWindows =  @[@"9a - 11a",
                          @"11a - 1p",
                          @"12p - 2p",
                          @"1p - 3p",
                          @"3p - 5p",
                          @"5p - 7p",
                          @"8p - 6a (Overnight)"];
    
    self.pets =  @[@"Only Today",@"Everyday",@"Everyday except Last",@"Everyday except First"];
    
    [self.pickerView reloadData];
    
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    
    if (pickerView.tag == 1) {
        return [self.titles count];
        
    } else if (pickerView.tag == 2) {
        return [self.timeWindows count];
        
    } else if (pickerView.tag == 3) {
        return [self.pets count];
    } else {
        return 0;
    }
    
}


- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    
    if (pickerView.tag == 1) {
        return self.titles[item];
    } else if (pickerView.tag == 2) {
        return self.timeWindows[item];
    } else if (pickerView.tag == 3) {
        return self.pets[item];
    }
    return self.titles[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    NSLog(@"%@", self.titles[item]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Too noisy...
    // NSLog(@"%f", scrollView.contentOffset.x);
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


@end
