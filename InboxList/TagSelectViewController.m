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
#import "Header.h"

static NSString *kTagForSelectedCellID = @"TagSelectCell";

#pragma mark -

@interface TagSelectViewController ()

@property NSMutableArray *kIndexPathsForSelectedRows;

@end

@implementation TagSelectViewController

#pragma mark - 初期化

/**
 * @brief  ビュー読込後処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  // ナビゲーションバーを非表示
  [self.navigationController.navigationBar setHidden:YES];

  // セルを登録
  [self.tagTableView registerNib:[UINib nibWithNibName:@"TagSelectCell"
                                                bundle:nil]
          forCellReuseIdentifier:kTagForSelectedCellID];
  
  // ボタンの設定
  [self.saveButton addTarget:self
                      action:@selector(dismissTagSelectView)
            forControlEvents:UIControlEventTouchUpInside];
  
  // リザルトコントローラーの設定
  self.fetchedResultsController = [CoreDataController tagFetchedResultsController:self];
  
  // 選択されたセル
  self.kIndexPathsForSelectedRows = [[NSMutableArray alloc] init];
  
  // 既存のタグを選択セットに追加する
  [self initializeForAlreadySavedTags];
}

/**
 * @brief  既存のタグを選択セットに追加
 */
-(void)initializeForAlreadySavedTags
{
  if (self.tagsForAlreadySaved)
  {
    for (Tag *tag in self.tagsForAlreadySaved) {
      NSIndexPath *index = [self.fetchedResultsController indexPathForObject:tag];
      [self addIndexPathForSelectedRows:index];
    }
  }
}

#pragma mark - ユーティリティ

/**
 * @brief  選択されたタグのセットを返す
 *
 * @return タグのセット
 */
-(NSSet *)tagsForSelectedRows
{
  NSMutableSet *setForTags = [[NSMutableSet alloc] init];
  for (NSIndexPath *index in self.kIndexPathsForSelectedRows) {
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:index];
    [setForTags addObject:tag];
  }
  return setForTags;
}

-(void)addIndexPathForSelectedRows:(NSIndexPath *)index
{
  [self.kIndexPathsForSelectedRows addObject:index];
}
-(void)removeIndexPathForSelectedRows:(NSIndexPath *)index
{
  [self.kIndexPathsForSelectedRows removeObject:index];
}
-(BOOL)cellHasCheckmark:(UITableViewCell *)cell
{
  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    return YES;
  } else {
    return NO;
  }
}
-(void)toggleCheckmark:(UITableViewCell *)cell
{
  if ([self cellHasCheckmark:cell]) {
    cell.accessoryType = UITableViewCellAccessoryNone;
  } else {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }
}
#pragma mark - 終了処理

/**
 * @brief  入力画面を終了
 */
-(void)dismissTagSelectView
{
  // 選択されたタグを渡す
  [self.delegate dismissTagSelectView:[self tagsForSelectedRows]];
  // 入力画面をポップして、１つ前の画面に戻る
  [self.navigationController popViewControllerAnimated:YES];
  // ナビゲーションバーを表示
  [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - テーブルビュー

/**
 * @brief  セクション内のセル数
 *
 * @param tableView テーブルビュー
 * @param section   セクション
 *
 * @return セル数
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
 * @param tableView テーブルビュー
 *
 * @return セクション数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
}

-(BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

/**
 * @brief  セルを選択した時の処理
 *
 * @param tableView テーブルビュー
 * @param indexPath 選択した位置
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // セルを取得
  UITableViewCell *cell = [self.tagTableView cellForRowAtIndexPath:indexPath];

  if ([self cellHasCheckmark:cell]) {
    // 選択セル配列から削除
    [self removeIndexPathForSelectedRows:indexPath];
  } else {
    // 選択セル配列に追加
    [self addIndexPathForSelectedRows:indexPath];
  }
  [self toggleCheckmark:cell];
}


/**
 * @brief  セルを返す
 *
 * @param tableView テーブルビュー
 * @param indexPath セルの位置
 */
-(UITableViewCell *)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];

  UITableViewCell *cell = [self.tagTableView dequeueReusableCellWithIdentifier:kTagForSelectedCellID];

  cell.textLabel.text = tag.title;
  
  // 既存のタグなら、チェックマークをつける
  if ([self.kIndexPathsForSelectedRows containsObject:indexPath]) {
    [self toggleCheckmark:cell];
  }
  return cell;
}

#pragma mark - その他

/**
 * @brief  メモリー警告
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
