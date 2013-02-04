//
//  MapViewController.h
//  ParkPro
//
//  Created by Steve Derico on 12/11/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "MapDetailsViewController.h"
#import "AccountViewController.h"
#import "SpotsViewController.h"
#import "MapPoint.h"
#import "ListingViewController.h"
#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
- (IBAction)refreshTapped:(id)sender;
- (IBAction)pageCurlTapped:(id)sender;

@end
