//
//  SDScaffoldMapViewController.h
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/11/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SDScaffoldMapViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property(nonatomic,strong) NSString *entityName;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
- (IBAction)refreshTapped:(id)sender;
- (IBAction)pageCurlTapped:(id)sender;

@end
