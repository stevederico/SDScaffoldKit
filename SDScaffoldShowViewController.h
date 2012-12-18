//
//  SDScaffoldShowViewController.h
//  ParkPro
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDScaffoldShowViewController : UITableViewController
@property(nonatomic,strong) id entity;
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
- (id)initWithEntity:(id)e context:(NSManagedObjectContext*)moc;
@end
