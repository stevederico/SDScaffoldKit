//
//  SDScaffoldMapViewController.m
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/11/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import "SDScaffoldMapViewController.h"


@protocol SDMapPointProtocol <NSObject>

@property (nonatomic, readonly) NSNumber *latitude;
@property (nonatomic, readonly) NSNumber *longitude;

@end

@interface SDScaffoldMapViewController () <NSFetchedResultsControllerDelegate>
@property NSFetchedResultsController *fetchedResultsController;

@end

@implementation SDScaffoldMapViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize entityName = _entityName, propertyName = _propertyName;

- (id)initWithEntityName:(NSString*)entityName sortBy:(NSString*)propertyName context:(NSManagedObjectContext*)managedObjectContext {
    
    self = [super init];
    if (self) {
        //Setup Properties
        self.propertyName = propertyName;
        self.entityName = entityName;
        self.managedObjectContext = managedObjectContext;
        self.title = [NSString stringWithFormat:@"%@s",self.entityName];
            
        [self refreshData];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:_entityName];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:_propertyName ascending:YES]];
    
    [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
 
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];

    [self.view addSubview:self.mapView];
    
    [self refreshData];

}


- (void)refreshData{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:self.propertyName ascending:YES]];
    
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

    [self plotPoints:objects];

}


- (void)plotPoints:(NSArray*)points{

    for (NSManagedObject *point in points) {
        CLLocationCoordinate2D location;
        location.latitude = [[point valueForKey:@"latitude"] doubleValue];
        location.longitude = [[point valueForKey:@"longitude"] doubleValue];
        
        NSString *locationTitle = [NSString stringWithFormat:@"%f,%f",location.latitude, location.longitude];
        
        SDMapPoint *destination = [[SDMapPoint alloc] initWithTitle:locationTitle andCoordinate:location];
        
        destination.object = point;
        
        [self.mapView addAnnotation:destination];
    }
}


- (IBAction)refreshTapped:(id)sender {
    [self refreshData];
    
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;    
}


- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if (annotation.class != [SDMapPoint class]) {
        return nil;
    }

    static NSString *reuseId = @"RightStandardPin";

    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        
    if (aView == nil){
       aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
    }
        
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    aView.canShowCallout = YES;
    aView.annotation = annotation;

    return aView;
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
   
    SDMapPoint *myPoint = view.annotation;
    
    if (myPoint.class != [SDMapPoint class]) {
        return;
    }
    
    SDScaffoldShowViewController *lvc = [[SDScaffoldShowViewController alloc] initWithEntity:myPoint.object context:self.managedObjectContext];
    

    [self.navigationController pushViewController:lvc animated:YES];
    
}

@end
