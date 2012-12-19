//
//  SDScaffoldShowViewController.h
//  ParkPro
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "ELCRightTextFieldCell.h"
#import <UIKit/UIKit.h>

@interface SDScaffoldShowViewController : UITableViewController <ELCTextFieldDelegate>
@property(nonatomic,strong) id entity;
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic) BOOL isDeletable;
@property(nonatomic) BOOL isEditable;
- (id)initWithEntity:(id)e context:(NSManagedObjectContext*)moc;
@end
