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
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
        
//        NSLog(@"Spot id %@: %@",[[[[spot objectID] URIRepresentation] lastPathComponent] stringByReplacingOccurrencesOfString:@"p__af_" withString:@""], spot.title.description);
        
        SDMapPoint *destination = [[SDMapPoint alloc] initWithTitle:point.description andCoordinate:location];
        
        [self.mapView addAnnotation:destination];
    }
}


- (IBAction)refreshTapped:(id)sender {
    [self refreshData];
    
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;    
}


//- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//
////    if (annotation.class != [SDMapPoint class]) {
////        return nil;
////    }
////
////    static NSString *reuseId = @"RightStandardPin";
////
////    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView                                                        dequeueReusableAnnotationViewWithIdentifier:reuseId];
////        
////    if (aView == nil){
////       aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
////    }
////        
////    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////
////    aView.canShowCallout = YES;
////    aView.annotation = annotation;
////    
//    return aView;
//    
//}

//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//   
////    SDMapPoint *myPoint = view.annotation;
////    
////    if (myPoint.class != [SDMapPoint class]) {
////        return;
////    }
//    
////    SDScaffoldShowViewController *lvc = [[SDScaffoldShowViewController alloc] initWithEntity:<#(id)#> context:<#(NSManagedObjectContext *)#>];
////    
////
////    [self.navigationController pushViewController:lvc animated:YES];
//    
//}

@end
