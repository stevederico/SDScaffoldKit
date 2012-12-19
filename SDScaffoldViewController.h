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
@property(nonatomic) BOOL isDeletable;
@property(nonatomic) BOOL isEditable;
@property(nonatomic) BOOL isViewable;
@property(nonatomic) BOOL isCreatable;
- (id)initWithEntityName:(NSString*)entityName sortBy:(NSString*)propertyName context:(NSManagedObjectContext*)moc;
- (id)initWithEntityName:(NSString*)entityName sortBy:(NSString*)propertyName context:(NSManagedObjectContext*)moc andStyle:(UITableViewStyle)style;
@end
