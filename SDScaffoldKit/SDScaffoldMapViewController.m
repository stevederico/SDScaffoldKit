//
//  MapViewController.m
//  ParkPro
//
//  Created by Steve Derico on 12/11/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <NSFetchedResultsControllerDelegate>
@property NSFetchedResultsController *fetchedResultsController;
@end

@implementation MapViewController
@synthesize managedObjectContext;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
  
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Spot"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES]];
    
    [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    self.title = NSLocalizedString(@"Spots", nil);
    
//    UIImage *iconImage = [UIImage imageNamed:@"contact"];
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 61, 30)];
//    [button addTarget:self action:@selector(showAccount) forControlEvents:UIControlEventTouchUpInside];
//    [button setBackgroundImage:iconImage forState:UIControlStateNormal];
//    UIBarButtonItem *accountButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    

    UIBarButtonItem *accountButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showAccount)];
    self.navigationItem.leftBarButtonItem = accountButton;
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"LIST" style:UIBarButtonItemStyleBordered target:self action:@selector(showListView)];
    self.navigationItem.rightBarButtonItem = listButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    

    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
        [self getSpots];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showListView{
    
    SpotsViewController  *svc = [[SpotsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    svc.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
    
}


- (void)showAccount{
    
    AccountViewController  *accountViewController = [[AccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
    
}

- (void)getSpots{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Spot"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES]];
    
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

    [self plotSpots:objects];

}

- (void)plotSpots:(NSArray*)spots{

    for (Spot *spot in spots) {
        CLLocationCoordinate2D location;
        location.latitude = spot.latitude.doubleValue;
        location.longitude = spot.longitude.doubleValue;
        
        NSLog(@"Spot id %@: %@",[[[[spot objectID] URIRepresentation] lastPathComponent] stringByReplacingOccurrencesOfString:@"p__af_" withString:@""], spot.title.description);
        
        MapPoint *destination = [[MapPoint alloc] initWithTitle:spot.title andCoordinate:location];

        destination.spot = spot;
        [self.mapView addAnnotation:destination];
    }
}



- (IBAction)refreshTapped:(id)sender {
    
    [self getSpots];
    
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    
}


- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    if (annotation.class != [MapPoint class]) {
        return nil;
    }

    static NSString *reuseId = @"RightStandardPin";

    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView                                                        dequeueReusableAnnotationViewWithIdentifier:reuseId];
        
    if (aView == nil){
       aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
    }
        
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    aView.canShowCallout = YES;
    aView.annotation = annotation;
    
    return aView;
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
   
    MapPoint *myPoint = view.annotation;
    
    if (myPoint.class != [MapPoint class]) {
        return;
    }
    
    ListingViewController *lvc = [[ListingViewController alloc] initWithSpot:myPoint.spot];
    
     NSLog(@"The SPOT %@", myPoint.spot);
    [self.navigationController pushViewController:lvc animated:YES];
    
}

- (IBAction)pageCurlTapped:(id)sender {
    
    MapDetailsViewController *mdvc = [[MapDetailsViewController alloc] init];
    mdvc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    [self presentViewController:mdvc animated:YES completion:nil];


}

@end
