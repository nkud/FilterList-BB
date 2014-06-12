//
//  MasterViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "InputModalViewController.h"
#import "Tag.h"
#import "Item.h"
#import "Cell.h"

@interface MasterViewController ()

- (void)configureCell:(Cell *)cell
          atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

/* ===  FUNCTION  ==============================================================
 *        Name: swipeView
 * Description: スライドさせる
 * ========================================================================== */
-(void)swipeView:(UISwipeGestureRecognizer *)sender
{
  //    CGRect _main_frame = self.view.frame;
  CGPoint location = self.view.center;
  //    CGFloat _height = CGRectGetHeight(_main_frame);
  CGFloat center_x = self.view.center.x;
  if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
    location.x = center_x + 50;
  }
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.view.center = location;
                   }];
}

/* ===  FUNCTION  ==============================================================
 *        Name: initWithStyle:
 * Description: 初期化する
 * ========================================================================== */
- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];

  if (self) {
    // pass
  }

  return self;
}

/* ===  FUNCTION  ==============================================================
 *        Name: viewDidLoad
 * Description: ビューをロードする
 * ========================================================================== */
- (void)viewDidLoad
{
  [super viewDidLoad];

  // セルとして使うクラスを登録する
  [self.tableView registerClass:[Cell class] forCellReuseIdentifier:@"Cell"];
  [self.tableView setRowHeight:40];
  //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
  //    view.backgroundColor = [UIColor redColor];

  // スワイプしてスライドさせる
  UISwipeGestureRecognizer *slideFrontView = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(swipeView:)];
  [self.view addGestureRecognizer:slideFrontView];

  // Do any additional setup after loading the view, typically from a nib.

  // 編集ボタン
  UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"編集"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self action:@selector(toEdit:)];
  //    self.navigationItem.leftBarButtonItem = self.editButtonItem;
  self.navigationItem.leftBarButtonItem = editButton;

  // 新規ボタン
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(inputAndInsertNewObjectFromModalView)];
  self.navigationItem.rightBarButtonItem = addButton;
}

/* ===  FUNCTION  ==============================================================
 *        Name: toEdit
 * Description: 編集モードの切り替え
 * ========================================================================== */
- (void)toEdit:(id)sender
{
  if (self.tableView.isEditing) {
    [self setEditing:false animated:YES];
  } else {
    [self setEditing:true animated:YES];
  }
}

/* ===  FUNCTION  ==============================================================
 *        Name: didReceiveMemoryWarning
 * Description:
 * ========================================================================== */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/* ===  FUNCTION  ==============================================================
 *        Name: dismissInputModalView:title:
 * Description: 入力画面を終了させる。フィールドの値を受け取る
 * ========================================================================== */
- (void)dismissInputModalView:(id)sender
                         data:(NSArray *)data
{
  NSString *title = data[0]; // タイトルを取得して
  if (title.length > 0) { // 空欄でなければ
    [self insertNewObject:sender data:data]; // リストを挿入する
  }

  [self dismissViewControllerAnimated:YES completion:nil]; // ビューを削除
}

// 詳細ビューを削除する前の処理
-(void)dismissDetailView:(id)sender index:(NSIndexPath *)index
{
  ;
}
/* ===  FUNCTION  ==============================================================
 *        Name: inputAndInsertNewObjectFromModalView
 * Description: 入力画面を出す。
 * ========================================================================== */
- (void)inputAndInsertNewObjectFromModalView
{
  InputModalViewController *inputView = [[InputModalViewController alloc] init];

  [inputView setDelegate:self];
  [inputView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

  [self presentViewController:inputView
                     animated:YES
                   completion:nil];
}

/* ===  FUNCTION  ==============================================================
 *        Name: insertNewObject
 * Description: 新しい項目を追加する。
 * ========================================================================== */
- (void)insertNewObject:(id)sender
                   data:(NSArray *)data
{
  // ここはよくわからない
  // 特になくても、直接指定すればいいのでは？
  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
  NSLog(@"%@", [entity name]);

  // -----------------
  // 新しい項目を初期化・追加する
  Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                inManagedObjectContext:context];

  // If appropriate, configure the new managed object.
  // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
  //    [newManagedObject setValuesForKeysWithDictionary:nsdictionary];

  // -----------------
  // 項目を設定する
  [newItem setValue:data[0] forKey:@"title"];
  Tag *newTags = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                               inManagedObjectContext:context];
  [newTags setTitle:data[1]]; // タグにタイトルを設定する
  [newItem addTagsObject:newTags]; // アイテムにタグを設定する

  NSLog(@"%@", newItem);
  NSLog(@"%@", [[[newItem tags] allObjects][0] title]);

  // -----------------
  // エラー処理
  // Save the context.
  NSError *error = nil;
  if (![context save:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
}

#pragma mark - Table View

// セルが選択された時の処理
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  DetailViewController *detailViewController = [[DetailViewController alloc] init];
  Item *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];

  [detailViewController setDetailItem:object];
  [detailViewController setIndex:indexPath];

  [self.navigationController pushViewController:detailViewController
                                       animated:NO];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo
  = [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects];
}

// indexPath 列目のセルを返す
- (Cell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  //    if (cell == nil) {
  //        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault
  //                                      reuseIdentifier:CellIdentifier];
  //    }

  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

    NSError *error = nil;
    if (![context save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The table view should not be re-orderable.
  return YES;
}

-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath
{
  NSLog(@"%s", "Moved");
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }

  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate.
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];

  // Edit the sort key as appropriate.
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];

  [fetchRequest setSortDescriptors:sortDescriptors];

  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                              managedObjectContext:self.managedObjectContext
                                                                                                sectionNameKeyPath:nil cacheName:@"Master"];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}

  return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.tableView;

  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
              atIndexPath:indexPath];
      break;

    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(Cell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
  Item *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = [[object valueForKey:@"title"] description];
}

@end
