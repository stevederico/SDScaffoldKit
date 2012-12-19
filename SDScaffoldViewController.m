//
//  SDScaffoldViewController.m
//  SDScaffoldKit
//
//  Created by Steve Derico on 12/18/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "SDScaffoldShowViewController.h"
#import "SDScaffoldAddViewController.h"
#import "SDScaffoldViewController.h"

@interface SDScaffoldViewController () <NSFetchedResultsControllerDelegate>{
    NSString *_sortPropertyName;
}
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
- (void)showAddViewController;
@end

@implementation SDScaffoldViewController
@synthesize entityName = _entityName;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithEntityName:(NSString*)entityName sortBy:(NSString*)propertyName context:(NSManagedObjectContext*)moc andStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
            // Custom initialization
        self.isDeletable = YES;
        self.isEditable = YES;
        self.isViewable = YES;
        self.isCreatable = YES;
        self.entityName = entityName;
        self.managedObjectContext = moc;
        _sortPropertyName = propertyName;

       [self refreshData];
    }
    return self;
}

- (id)initWithEntityName:(NSString*)entityName sortBy:(NSString*)propertyName context:(NSManagedObjectContext*)moc{
    self = [self initWithEntityName:entityName sortBy:propertyName context:moc andStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@s",self.entityName];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddViewController)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    if (self.isCreatable == NO) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [self refreshData];
    
    [self.tableView reloadData];
    
  
    

}

- (void)refreshData{
    
//    [self.pullToRefreshView startLoading];
    NSString *entityName = [NSString stringWithFormat:@"%@",self.entityName];
     NSLog(@"EntityName %@", entityName);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Spot"];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:_sortPropertyName ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
//    [self.pullToRefreshView finishLoading];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
        
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [managedObject description];
    
    if (self.isViewable == NO) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isViewable == NO) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    SDScaffoldShowViewController *showVC = [[SDScaffoldShowViewController alloc] initWithEntity:[_fetchedResultsController objectAtIndexPath:indexPath] context:self.managedObjectContext];
    showVC.isDeletable = self.isDeletable;
    showVC.isEditable = self.isEditable;
    [self.navigationController pushViewController:showVC animated:YES];

}


#pragma showAddViewController

- (void)showAddViewController{


    SDScaffoldAddViewController *addVC = [[SDScaffoldAddViewController alloc]initWithEntityName:self.entityName context:self.managedObjectContext];

    [self.navigationController pushViewController:addVC animated:YES];
}

@end
