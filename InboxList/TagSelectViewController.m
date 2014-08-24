//
//  TagSelectViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/24.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TagSelectViewController.h"
#import "CoreDataController.h"
#import "Tag.h"

@interface TagSelectViewController () {
  NSString *cell_identifier_;
}

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
  
  cell_identifier_ = @"TagSelectCell";
  [self.tagTableView registerClass:[UITableViewCell class]
            forCellReuseIdentifier:cell_identifier_];
  
  // ボタンの設定
  [self.saveButton addTarget:self
                      action:@selector(pop)
            forControlEvents:UIControlEventTouchUpInside];
  
  // リザルトコントローラーの設定
  self.fetchedResultsController = [CoreDataController tagFetchedResultsController:self];
  }

/**
 * @brief  入力画面を終了
 */
-(void)pop
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 * @brief  セクション内のセル数
 *
 * @param tableView <#tableView description#>
 * @param section   <#section description#>
 *
 * @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects];
}

/**
 * @brief  セクション数
 *
 * @param tableView <#tableView description#>
 *
 * @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
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
  Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];

  UITableViewCell *cell = [self.tagTableView dequeueReusableCellWithIdentifier:cell_identifier_];

  cell.textLabel.text = tag.title;
  return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
