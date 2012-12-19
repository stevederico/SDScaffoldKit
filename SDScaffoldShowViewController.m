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
    NSMutableArray *attributeTypes;
    NSMutableArray *values;
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
        attributeTypes = [[NSMutableArray alloc] init];
        
        self.title = [NSString stringWithFormat:@"%@",[[self.entity class] description]];
        NSEntityDescription *entityDescription = [e entity];
  
        for (NSPropertyDescription *property in entityDescription) {
            NSLog(@"Property %@",[[[property valueForKey:@"attributeType"] class] description]);
            [attributeTypes addObject:[property valueForKey:@"attributeType"]];
        }
        
        attributes = [[entityDescription attributesByName] allKeys];
        NSLog(@"Array %@",attributes);
        values = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<attributes.count; i++) {
            [values insertObject:@"" atIndex:0];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
        //Add Edit Button Here
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editTapped)];
    self.navigationItem.rightBarButtonItem = editButton;

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [attributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing == YES) {
        static NSString *textFieldID = @"CellText";
        ELCRightTextFieldCell *cell = (ELCRightTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:textFieldID];
        if (cell == nil) {
            cell = [[ELCRightTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:textFieldID];
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.textLabel.text = [[attributes objectAtIndex:indexPath.row] capitalizedString];
        cell.rightTextField.placeholder = [[entity valueForKey:[attributes objectAtIndex:indexPath.row]] description];
        
        return cell;
        
    }else{
    
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[attributes objectAtIndex:indexPath.row] capitalizedString];
        cell.detailTextLabel.text = [[entity valueForKey:[attributes objectAtIndex:indexPath.row]] description];
        return cell;
    }

    return nil;
}


 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
 return NO;
}


- (void)editTapped{
    
    if (self.tableView.editing == NO) {
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Save"];
        [self.navigationItem.rightBarButtonItem setTarget:self];
        [self.navigationItem.rightBarButtonItem setAction:@selector(saveObject)];
    }
    
    [self.tableView reloadData];

}


#pragma mark - Save Core Data

-(void)saveObject{
    
    [self.managedObjectContext save:nil];
    
    [self.tableView setEditing:NO animated:YES];
    [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(editTapped)];
    [self.tableView reloadData];
    
}

#pragma mark - ELCTextField Delegate

- (void)textFieldCell:(ELCTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue{

    int i = 0;

    NSString *stringValue = [inValue description];
    NSNumber *intValue = [NSNumber numberWithInt:[inValue integerValue]];
    NSNumber *floatValue = [NSNumber numberWithFloat:[inValue floatValue]];

    if ([stringValue length] == 0) {
        i++;
    }else{

        switch ([[attributeTypes objectAtIndex:i] integerValue]) {
            case 0:
                [entity setValue:intValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 100:
                [entity setValue:intValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 200:
                [entity setValue:intValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 300:
                [entity setValue:intValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 400:
                [entity setValue:floatValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 500:
                [entity setValue:floatValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 600:
                [entity setValue:floatValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 700:
                [entity setValue:stringValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 800:
                [entity setValue:intValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
            case 900:
                    //Add Date Picker
                    //                        [managedObject setValue:intValue forKey:attribute];
                
                break;
                
            default:
                [entity setValue:stringValue forKey:[[attributes objectAtIndex:inIndexPath.row] description]];
                break;
        }
        
        i++;
    }

}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (self.tableView.editing == NO) {
        return nil;
    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 10, footer.bounds.size.width - 10 - 10, 45);
    [button setTitle:@"Delete" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteTapped) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview: button];
    
    return footer;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 75.0;

}


- (void)deleteTapped{

    [self.managedObjectContext deleteObject:entity];
    [self.managedObjectContext save:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

@end
