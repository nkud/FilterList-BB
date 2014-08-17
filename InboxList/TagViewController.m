//
//  MenuView.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TagViewController.h"
#import "Header.h"
#import "TagCell.h"
#import "Tag.h"
#import "CoreDataController.h"
#import "InputTagViewController.h"

@interface TagViewController ()

@end

@implementation TagViewController

/**
 * @brief この初期化方法は変えたほうがいいかも
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    ;
  }
  return self;
}

/**
 *  タグが選択された時の処理
 *
 *  @param tableView tableView description
 *  @param indexPath 選択された場所
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LOG(@"タグが選択された時の処理");
  Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [self.delegate selectedTag:tag.title]; // 選択されたタグを渡す
}

/**
 *  セクションのタイトルを設定
 *
 *  @param tableView テーブルビュー
 *  @param section   セクション
 *
 *  @return タイトルの文字列
 */
//-(NSString *)tableView:(UITableView *)tableView
//titleForHeaderInSection:(NSInteger)section
//{
//  LOG(@"セクションのタイトルを設定");
//  switch (section) {
//    case 0:
//      return @"Default";
//      break;
//    case 1:
//      return @"Tag";
//      break;
//  }
//  return nil;
//}

/**
 * ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  LOG(@"タグビューがロードされた後の処理");
  [super viewDidLoad];

//  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TagCell class])
                                             bundle:nil]
       forCellReuseIdentifier:TagModeCellIdentifier];

  LOG(@"編集ボタンを追加");
  UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"タグ編集"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(toEdit:)];
  self.navigationItem.leftBarButtonItem = editButton;

  LOG(@"新規入力ボタンを追加");
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"新規"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(toAdd:)];
  self.navigationItem.rightBarButtonItem = addButton;
}

/**
 *  新規入力を開始する
 *
 *  @param sender センダー
 */
-(void)toAdd:(id)sender
{
  LOG(@"新規入力画面をプッシュ");
  NSString *inputTagNibName = @"InputTagViewController";
  InputTagViewController *inputTagViewController = [[InputTagViewController alloc] initWithNibName:inputTagNibName
                                                                                            bundle:nil];
  inputTagViewController.delegate = self;
  [self.navigationController pushViewController:inputTagViewController
                                       animated:YES];
}

-(void)saveTags:(NSSet *)tagStrings
{
  LOG(@"新規タグを保存");
  Tag *newTag;
  for (NSString *title in tagStrings) {
    newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                           inManagedObjectContext:[CoreDataController managedObjectContext]];
    newTag.title = title;
  }
  [CoreDataController saveContext];
}

/**
 *  編集モード切り替え
 *
 *  @param sender センダー
 */
-(void)toEdit:(id)sender
{
  if (self.tableView.isEditing) {
    [self setEditing:false animated:YES];
  } else {
    [self setEditing:true animated:YES];
  }
}

/**
 * セクション数を返す
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[NSNumber numberWithInt:1] integerValue];
}

/**
 * アイテム数を返す
 */
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
//  if (section == 0) {
//    return 1;
//  }
  NSInteger num = [[self.fetchedResultsController fetchedObjects] count];
  return num;
}

/**
 * テーブルのセルを表示する
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TagCell *cell = [tableView dequeueReusableCellWithIdentifier:TagModeCellIdentifier];

//  LOG(@"セクションによる分岐");
//  switch (indexPath.section) {
//    case 0:
//      cell.textLabel.text = @"all";
//      break;
//
//    case 1:
//    {
//      NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row
//                                              inSection:0];
//      Tag *tag = [self.fetchedResultsController objectAtIndexPath:index];
//      cell.textLabel.text = tag.title;
//    }
//      break;
//      
//    default:
//      break;
//  }
  Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
  if ([tag.title isEqualToString:@""]) {
    cell.textLabel.text = @"NO TAGS";
  } else {
    cell.textLabel.text = tag.title;
  }

  cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", [tag.items count]];
  return cell;
}

/**
 * テーブルを更新する
 *
 * @note 非効率かも
 */
- (void)updateTableView
{
  [self.tableView reloadData];
}

/**
 *  テーブル編集の可否
 *
 *  @param tableView テーブルビュー
 *  @param indexPath インデックス
 *
 *  @return 可否
 */
-(BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//  if (indexPath.section == 0) { // セクション０なら
//    return NO;                  // 編集不可
//  }                             // タグセクションなら
  return YES;                   // 編集可
}

-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (editingStyle) {
    case UITableViewCellEditingStyleDelete: // 削除
    {
      LOG(@"タグを削除");
//      [[CoreDataController managedObjectContext] deleteObject:self.tagArray_[indexPath.row]];
//      NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row
//                                              inSection:0];
      Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
      LOG(@"関連アイテム：%@", tag.items);
      LOG(@"アイテムを削除");
      for (Item *item in tag.items) {
        [[CoreDataController managedObjectContext] deleteObject:item];
      }

      LOG(@"タグを削除");
      [[CoreDataController managedObjectContext] deleteObject:tag];

      LOG(@"削除されるオブジェクト数：%lu", [[[CoreDataController managedObjectContext] deletedObjects] count]);

      [CoreDataController saveContext];
      break;
    }
    default:
      break;
  }
}

/**
 *  コンテンツを更新する前処理
 *
 *  @param controller リザルトコントローラー
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  LOG(@"コンテキストを更新する前処理");
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
  LOG(@"コンテキストを更新");
  switch(type) {
    case NSFetchedResultsChangeInsert:
      LOG(@"挿入");
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      LOG(@"削除");
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
  LOG(@"コンテキストを更新");
  UITableView *tableView = self.tableView;

  switch(type) {
    case NSFetchedResultsChangeInsert:
      LOG(@"挿入");
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationLeft];
      break;

    case NSFetchedResultsChangeDelete:
    {
      LOG(@"削除");
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationLeft];
      //      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
      //      NSSet *tags = item.tags; // アイテムに設定されているタグのセットを取得して
      //      for (Tag *tag in tags) { // そのセットそれぞれに対して
      //        if ([tag.items count] == 0) { // タグの関連付けがそのアイテムのみだった場合
      //          [app.managedObjectContext deleteObject:tag]; // そのタグも削除する
      //        }
      //      }
      break;
    }

    case NSFetchedResultsChangeUpdate:
      LOG(@"更新");
//      [self configureCell:(ItemCell *)[tableView cellForRowAtIndexPath:indexPath]
//              atIndexPath:indexPath];                                // これであってる？？

      break;

    case NSFetchedResultsChangeMove:
      LOG(@"移動");
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 */

/**
 *  コンテンツが更新された後処理
 *
 *  @param controller リザルトコントローラー
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  LOG(@"コンテキストを更新した後の処理");
  // In the simplest, most efficient, case, reload the table view.
  [self.tableView endUpdates];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
