//
//  ProfileFormViewController.m
//  LeashTimeClientPet
//
//  Created by Ted Hooban on 5/11/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "ProfileFormViewController.h"

@interface ProfileFormViewController () {
    
    
}

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *lastNameLabel;
@property (nonatomic,strong) UILabel *altFirstLabel;
@property (nonatomic,strong) UILabel *altLastLabel;
@property (nonatomic,strong) UILabel *emailLabel;
@property (nonatomic,strong) UILabel *altEmailLabel;
@property (nonatomic,strong) UITextField *name;
@property (nonatomic,strong) UITextField *lastNameField;

@end

@implementation ProfileFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"white-blue-bg-1136x640"]];
    background.alpha = 0.5;
    [self.view addSubview:background];
    
    
    _name = [[UITextField alloc]initWithFrame:CGRectMake(120, 100, 200, 40)];
    _name.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    _name.textColor = [UIColor blackColor];
    _name.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_name];
    
    _lastNameField = [[UITextField alloc]initWithFrame:CGRectMake(120, 160, 200, 40)];
    _lastNameField.font = [UIFont fontWithName:@"Lato-Light" size:20];
    _lastNameField.textColor = [UIColor blackColor];
    _lastNameField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_lastNameField];

    [self initializeForm];
    
}


-(void)initializeForm {
    
    


    
    
    
    
}

/*- (void)form:(EZForm *)form didUpdateValueForField:(EZFormField *)formField modelIsValid:(BOOL)isValid
{


}

- (void)formInputFinishedOnLastField:(EZForm *)form
{
    BOOL isValid = [form isFormValid];


}*/


@end
