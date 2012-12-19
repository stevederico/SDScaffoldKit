//
//  SDScaffoldShowViewController.m
//  ParkPro
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "ELCTextFieldCell.h"
#import "SDScaffoldShowViewController.h"

@interface SDScaffoldShowViewController (){
    
    NSArray *attributes;

}

@end

@implementation SDScaffoldShowViewController
@synthesize entity;
@synthesize managedObjectContext = _managedObjectContext;
- (id)initWithEntity:(id)e context:(NSManagedObjectContext*)moc{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.allowsSelection = NO;
        self.entity = e;
        self.managedObjectContext = moc;
        

        
        self.title = [NSString stringWithFormat:@"%@",[[self.entity class] description]];
        NSEntityDescription *entityDescription = [e entity];
        
        for (NSPropertyDescription *property in entityDescription) {
            NSLog(@"Property %@",property.description);
        }
        attributes = [[entityDescription attributesByName] allKeys];
        NSLog(@"Array %@",attributes);

        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
        //Add Edit Button Here
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
        // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        // Return the number of rows in the section.
    return [attributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
        // Configure the cell...
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    
    cell.textLabel.text = [[attributes objectAtIndex:indexPath.row] capitalizedString];
    
    cell.detailTextLabel.text = [[entity valueForKey:[attributes objectAtIndex:indexPath.row]] description];
    
}


 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 // Return NO if you do not want the specified item to be editable.
 return YES;
}





#pragma mark - Save Core Data

-(void)saveObject{
    
    
    
}

@end
