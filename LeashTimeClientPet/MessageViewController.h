//
//  MessageViewController.h
//  LeashTimeSitter
//
//  Created by Ted Hooban on 10/25/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitsAndTracking.h"
#import "VisitDetails.h"
#import <MapKit/MapKit.h>

@interface MessageViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,NSURLConnectionDelegate> {
    
    NSMutableArray *myVisitData;
    
    
}
@property (nonatomic,retain) MKMapView *mapView;
@property (nonatomic,strong) VisitsAndTracking *sharedVisitsTracking;
@property (nonatomic,strong) VisitDetails *currentVisit;
@property (nonatomic,strong) UIImageView *petPicFrame;
@property (nonatomic,strong) UIImageView *sidebar;

@end
