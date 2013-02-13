//
//  SDScaffoldMapViewController.h
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/11/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SDScaffoldMapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;



@end
