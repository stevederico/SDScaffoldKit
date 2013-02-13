//
//  SDMapPoint.h
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/11/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface SDMapPoint : NSObject <MKAnnotation>

@property (nonatomic,strong) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString*)ttl andCoordinate:(CLLocationCoordinate2D)c2d;


@end