//
//  SDScaffoldViewController.h
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDScaffoldViewController : UITableViewController
@property(nonatomic,strong) NSString *entityName;
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
- (id)initWithEntityName:(NSString*)entityName context:(NSManagedObjectContext*)moc andStyle:(UITableViewStyle)style;
@end
