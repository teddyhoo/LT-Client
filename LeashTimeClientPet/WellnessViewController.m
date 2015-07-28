//
//  WellnessViewController.m
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/7/15.
//
//

#import "WellnessViewController.h"


#define kTableHeaderHeight 70.0f
#define kTableRowHeight 40.0f

@interface WellnessViewController () {

    EMAccordionTableViewController *emTV;
    EMAccordionTableParallaxHeaderView *emParallaxHeaderView;

    
}
@end

@implementation WellnessViewController {
    
    NSMutableArray *theWellnessData;
    NSMutableArray *sections;
    CGFloat origin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 80.0f, self.view.bounds.size.width, self.view.bounds.size.height-100) style:UITableViewStylePlain];
    [tableView setSectionHeaderHeight:kTableHeaderHeight];
    
    emTV = [[EMAccordionTableViewController alloc] initWithTable:tableView withAnimationType:EMAnimationTypeBounce];
    [emTV setDelegate:self];
    
    emParallaxHeaderView = [[EMAccordionTableParallaxHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 60.0f)];
    emParallaxHeaderView.headerImage = [UIImage imageNamed:@"wellness-bg-sponsor"];
    emTV.parallaxHeaderView = emParallaxHeaderView;
    [emTV setClosedSectionIcon:[UIImage imageNamed:@"green-add-button"]];
    [emTV setOpenedSectionIcon:[UIImage imageNamed:@"red-remove-button"]];
    
    
    NSString *pListData = [[NSBundle mainBundle]
                           pathForResource:@"Wellness-Data"
                           ofType:@"plist"];
    
    theWellnessData = [[NSMutableArray alloc] initWithContentsOfFile:pListData];
    sections = [[NSMutableArray alloc] init];
    

    UIColor *sectionsColor = [UIColor colorWithRed:62.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
    UIColor *sectionTitleColor = [UIColor clearColor];
    UIFont *sectionTitleFont = [UIFont fontWithName:@"Lato-Regular" size:10.0f];
    
    for (NSMutableDictionary *dicFor in theWellnessData) {
        
        EMAccordionSection *section = [[EMAccordionSection alloc]init];
        NSMutableArray *items  =[[NSMutableArray alloc]init];

        [section setBackgroundColor:sectionsColor];
        [section setTitleColor:sectionTitleColor];
        [section setTitleFont:sectionTitleFont];
        
        NSString *type = [dicFor objectForKey:@"Type"];
        NSString *name = [dicFor objectForKey:@"Name"];
        NSString *description = [dicFor objectForKey:@"Description"];
        NSString *frequency = [dicFor objectForKey:@"Frequency"];
        NSString *last = [dicFor objectForKey:@"Last"];
        NSString *next = [dicFor objectForKey:@"Next"];
        NSString *scheduleStatus = [dicFor objectForKey:@"ScheduleStatus"];
        NSString *icon = [dicFor objectForKey:@"IconFor"];
        NSString *methodFor = [dicFor objectForKey:@"methodFor"];
        
        [items addObject:type];
        [items addObject:name];
        [items addObject:description];
        [items addObject:frequency];
        [items addObject:last];
        [items addObject:next];
        
        section.title = name;
        section.wellnessName = description;
        section.wellnessDescr = description;
        section.wellnessIcon = icon;
        section.frequency = frequency;
        section.next = next;
        section.last = last;
        section.serviceStatus = scheduleStatus;
        section.methodFor = methodFor;
        
        [section setTitle:name];
        [section setItems:items];

        [emTV addAccordionSection:section];
        [sections addObject:section];
    }
    [self.view addSubview:emTV.tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emCell"];
    
    NSMutableArray *items = [self dataFromIndexPath:indexPath];
    
    for (NSString *item in items) {
        NSLog(@"item: %@",item);
    }
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 5.0f, 320, 12)];
    [titleLbl setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0f]];
    [titleLbl setText:[items objectAtIndex:indexPath.row]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [[cell contentView] addSubview:titleLbl];
    cell.layer.borderWidth = 0.1;
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableRowHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    EMAccordionSection *section = [sections objectAtIndex:indexPath.section];
    NSMutableArray *items = [self dataFromIndexPath:indexPath];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oh my!" message:[[NSString alloc] initWithFormat:@"%@ : %@", section.title, [items objectAtIndex:indexPath.row]] delegate:NULL cancelButtonTitle:NULL otherButtonTitles:@"OK", nil];
    [av show];
}

- (NSMutableArray *) dataFromIndexPath: (NSIndexPath *)indexPath {

    EMAccordionSection *sectionItems = [sections objectAtIndex:indexPath.section];
    return sectionItems.items;
    

}

/*-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.borderWidth = 3;
    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    
    UIImageView *headerBack = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,headerView.frame.size.width, headerView.frame.size.height)];
    [headerBack setImage:[UIImage imageNamed:@"yellow-bg-800x100"]];
    [headerView addSubview:headerBack];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0;
}
*/

@end
