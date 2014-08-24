//
//  TagSelectViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/24.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TagSelectViewController.h"
#import "CoreDataController.h"

@interface TagSelectViewController ()

@end

@implementation TagSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.saveButton addTarget:self
                      action:@selector(pop)
            forControlEvents:UIControlEventTouchUpInside];
//  [self.fetchedResultsController = [CoreDataController tagFetchedResultsController:self]];
  [self.tagTableView setDelegate:self];
}

-(void)pop
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//  return [[self.fetchedResultsController sections] count];
  return 5;
}

/**
 * @brief  セルを返す
 *
 * @param tableView <#tableView description#>
 * @param indexPath <#indexPath description#>
 */
-(UITableViewCell *)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:@"tagselectcell"];
  cell.textLabel.text = @"tag";
  return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
