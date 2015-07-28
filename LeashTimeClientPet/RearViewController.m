
/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
*/

#import "RearViewController.h"
#import "SWRevealViewController.h"
#import "FrontViewController.h"
#import "MapViewController.h"
#import "PhotoGallery.h"
#import "WellnessViewController.h"
#import "CalendarViewController.h"
#import "RequestViewController.h"
#import "MessageViewController.h"
#import "ProfileFormViewController.h"

@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //self.title = NSLocalizedString(@"Main Menu", nil);
    
    UIView *headerForTable = [[UIView alloc]initWithFrame:CGRectMake(-5, 0, self.view.frame.size.width-60, 80)];
    headerForTable.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+250, 100)];
    [backgroundView setImage:[UIImage imageNamed:@"two-milkbone"]];
    [headerForTable addSubview:backgroundView];
    
    
    self.rearTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    _rearTableView.delegate = self;
    _rearTableView.dataSource = self;
    [self.view addSubview:self.rearTableView];
    self.rearTableView.tableHeaderView = headerForTable;
    self.rearTableView.separatorColor = [UIColor grayColor];
    self.rearTableView.rowHeight = 80;
    
    
}


#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
	
    NSString *text = nil;
    UIImageView *cellBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300,80)];
    [cellBackground setImage:[UIImage imageNamed:@"light-blue-box"]];
    cellBackground.alpha = 0.5;
    [cell.contentView addSubview:cellBackground];
    
    if (row == 0)
    {
        text = @"Visit Report";
        
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 25, 20, 20)];
        [iconView setImage:[UIImage imageNamed:@"file-folder64x64"]];
        [cell.contentView addSubview:iconView];
    }
    else if (row == 1)
    {
        text = @"Request";
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 25, 20, 20)];
        [iconView setImage:[UIImage imageNamed:@"collar-leash"]];
        [cell.contentView addSubview:iconView];
        
    }
    else if (row == 2)
    {
        text = @"Scheduled";
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 25, 20, 20)];
        [iconView setImage:[UIImage imageNamed:@"day-cal"]];
        [cell.contentView addSubview:iconView];
    }
    else if (row == 3)
    {
        text = @"Gallery";
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 25, 20, 20)];
        [iconView setImage:[UIImage imageNamed:@"dog-icon-outline"]];
        [cell.contentView addSubview:iconView];
    }
    else if (row == 4)
    {
        text = @"Profile";
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 25, 20, 20)];
        [iconView setImage:[UIImage imageNamed:@"note-icon"]];
        [cell.contentView addSubview:iconView];
    }
    else if (row == 5)
    {
        
        text = @"Wellness";
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 25, 20, 20)];
        [iconView setImage:[UIImage imageNamed:@""]];
        [cell.contentView addSubview:iconView];
    }
    else if (row == 6)
    {
        text = @"Billing";
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 25, 20, 20)];
        [iconView setImage:[UIImage imageNamed:@"dollar-sign-circle"]];
        [cell.contentView addSubview:iconView];
    } else if (row == 7)
    {
        text = @"Account";
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 25, 20, 20)];
        [iconView setImage:[UIImage imageNamed:@"settings-icon"]];
        [cell.contentView addSubview:iconView];
    }

    cell.textLabel.font = [UIFont fontWithName:@"CompassRoseCPC-Bold" size:16];
    cell.textLabel.text = NSLocalizedString(text,nil );
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    UIView *cellForTable = [[UIView alloc]initWithFrame:CGRectMake(-5, 0, self.view.frame.size.width-60, 60)];
    cellForTable.backgroundColor = [UIColor whiteColor];
    [cellForTable addSubview:cell];
    
    
    return cell;
    //return cellForTable;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    
    if ( row == _presentedRow )
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }

    UIViewController *newFrontController = nil;

    if (row == 0)
    {
        newFrontController = [[MessageViewController alloc] init];
    }
    
    else if (row == 1)
    {
        
        newFrontController = [[RequestViewController alloc] init];
    }
    
    else if (row == 2)
    {
        
        newFrontController = [[CalendarViewController alloc]init];
    }
    else if (row == 3)
    {
        
        newFrontController = [[PhotoGallery alloc]init];
        
    }
    
    else if (row == 4)
    {
    
        newFrontController = [[ProfileFormViewController alloc]init]; //Profile
    
    }
    else if (row == 5)
    {
        newFrontController = [[WellnessViewController alloc]init];
    }
    else if (row == 6)
    {
        
        newFrontController = [[MessageViewController alloc]init];

    } else if (row == 7)
    {
        
        newFrontController = [[MessageViewController alloc]init];
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    [revealController pushFrontViewController:navigationController animated:YES];
    
    _presentedRow = row;  // <- store the presented row
}


@end