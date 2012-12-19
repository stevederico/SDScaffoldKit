//
//  SDScaffoldAddViewController.m
//  ParkPro
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import "SDScaffoldAddViewController.h"

@interface SDScaffoldAddViewController  (){

    NSArray *attributes;
    NSMutableArray *values;
    
    NSManagedObject *object;
    
}

@end

@implementation SDScaffoldAddViewController 
@synthesize entityName = _entityName;
@synthesize managedObjectContext = _managedObjectContext;
- (id)initWithEntityName:(NSString*)entityName context:(NSManagedObjectContext*)moc{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.allowsSelection = NO;
        self.entityName = entityName;
        self.managedObjectContext = moc;
        self.title = [NSString stringWithFormat:@"Add %@",self.entityName.capitalizedString];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
        for (NSPropertyDescription *property in entityDescription) {
            NSLog(@"Property %@",property.description);
        }
        attributes = [[entityDescription attributesByName] allKeys];
         NSLog(@"Array %@",attributes);
        values = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<attributes.count; i++) {
            [values insertObject:[NSNull null] atIndex:0];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObject)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    
    
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
    ELCTextFieldCell *cell = (ELCTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ELCTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    

    // Configure the cell...
    cell.indexPath = indexPath;
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{

    ELCTextFieldCell *c = (ELCTextFieldCell*)cell;
    c.rightTextField.text = @"";
    if ([values objectAtIndex:indexPath.row] == [NSNull null]) {
        c.rightTextField.placeholder = [[attributes objectAtIndex:indexPath.row] description];
    }else{
        c.rightTextField.text = [[values objectAtIndex:indexPath.row] description];
    }
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
  
    
       NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    switch ([[[entityDescription attributesByName] valueForKey:[attributes objectAtIndex:indexPath.row]] attributeType]) {
        case 0:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;   
            break;
        case 100:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 200:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 300:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 400:
            c.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 500:
            c.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 600:
            c.rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 700:
            c.rightTextField.keyboardType = UIKeyboardTypeDefault;
            break;
        case 800:
            c.rightTextField.inputView = [[UISwitch alloc] initWithFrame:CGRectZero];
            break;
        case 900:
                //Add Date Picker
            datePicker.tag = indexPath.row;
            c.rightTextField.inputView = datePicker;

            break;
            
        default:
            c.rightTextField.keyboardType = UIKeyboardTypeNumberPad; 
            break;
    } 
   
    
 
    

    
}

- (void)textFieldCell:(ELCTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue{

    NSLog(@"Row %d",inIndexPath.row );
    if ([values count] > 0) {
        [values removeObjectAtIndex:inIndexPath.row];
        [values insertObject:inValue atIndex:inIndexPath.row];
    }else{
           [values insertObject:inValue atIndex:inIndexPath.row];
    
    }
    
     NSLog(@"Values %@",[values description]);

    

}



#pragma mark - Table view delegate

- (void)datePickerValueChanged:(UIDatePicker*)sender{
    
    UIDatePicker *s = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:s.tag inSection:0];
    ELCTextFieldCell *cell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [self textFieldCell:cell updateTextLabelAtIndexPath:indexPath string:s.date.description];
    
    
    NSLog(@"DATE Picker %d: %@",s.tag, s.date);
    
    [self.tableView reloadData];
    
}




#pragma mark - Save Core Data

-(void)saveObject{



}

@end
