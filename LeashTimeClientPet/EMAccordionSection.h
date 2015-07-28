//
//  EMAccordionSection.h
//  UChat
//
//  Created by Ennio Masi on 10/01/14.
//  Copyright (c) 2014 Hippocrates Sintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMAccordionSection : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, copy) NSString *wellnessName;
@property (nonatomic, copy) NSString *wellnessDescr;
@property (nonatomic, copy) NSString *wellnessIcon;
@property (nonatomic, copy) NSString *serviceStatus;
@property (nonatomic, copy) NSString *medBuyStatus;
@property (nonatomic, copy) NSString *frequency;
@property (nonatomic, copy) NSString *next;
@property (nonatomic, copy) NSString *last;
@property (nonatomic, copy) NSString *methodFor;



@property (nonatomic, strong) NSMutableArray *items;


@end
