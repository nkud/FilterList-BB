//
//  ListViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

static NSString *kEditBarItemImageName = @"EditBarItem.png";

// ナビゲーションバータイトル文字サイズ
#define kTitleFontSize 18
#define kSubTitleFontSize 15

#pragma mark -

#import "ListViewController.h"
#import "Header.h"
#import "Configure.h"

#import "CoreDataController.h"

#import "TagSelectViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

#pragma mark - 初期化 -

/**
 * @brief  ビュー表示前処理
 *
 * @param animated アニメーション
 */
-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  // 選択状態を解除する
  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                animated:YES];
  [self.tableView reloadData];
}

/**
 * @brief  ビュー非表示前
 *
 * @param animated アニメーション
 */
-(void)viewWillDisappear:(BOOL)animated
{
  // 編集状態でないなら、
  // 編集バーを隠す
  if (self.tableView.editing == NO) {
    [self hideEditTabBar:YES];
  }
}

/**
 * @brief  ビュー表示後処理
 *
 * @param animated アニメーション
 */
- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // スクロールバーを点滅させる
  [self.tableView flashScrollIndicators];
}

/**
 * @brief  ビューロード後処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //////////////////////////////////////////////////////////////////////////////
  // テーブルビュー初期化
  CGRect tableFrame = SCREEN_BOUNDS;
  tableFrame.size.height -= TABBAR_H + NAVBAR_H + STATUSBAR_H;
  self.tableView = [[UITableView alloc] initWithFrame:tableFrame];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  // 編集時マルチ選択を許可
  self.tableView.allowsMultipleSelectionDuringEditing = YES;
  
  [self.view addSubview:self.tableView];

  //////////////////////////////////////////////////////////////////////////////
  // 編集タブ初期化
  CGRect tabFrame = CGRectMake(0,
                            SCREEN_BOUNDS.size.height - TABBAR_H - NAVBAR_H - STATUSBAR_H,
                            SCREEN_BOUNDS.size.width,
                            TABBAR_H);
  
  self.tabBar = [[UITabBar alloc] initWithFrame:tabFrame];
  self.tabBar.delegate = self;
  [self.view addSubview:self.tabBar];
  self.editTabBar = [[UIView alloc] initWithFrame:self.tabBar.frame];
  self.editTabBar.backgroundColor = [UIColor whiteColor];
  
  [self.view addSubview:self.editTabBar];
  // 全削除ボタン作成
  self.deleteAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.deleteAllButton addTarget:self
                           action:@selector(deleteRows:)
                 forControlEvents:UIControlEventTouchUpInside];
  [self updateDeleteButton];
  [self.deleteAllButton setTintColor:RED_COLOR];
  CGFloat height = TABBAR_H;
  CGFloat width = SCREEN_BOUNDS.size.width/2;
  CGFloat margin = 0;
  [self.deleteAllButton setTitle:@"Delete"
                        forState:UIControlStateDisabled];
  self.deleteAllButton.frame = CGRectMake(margin,
                                          (self.editTabBar.frame.size.height-height)/2,
                                          width,
                                          height);
  [self.editTabBar addSubview:self.deleteAllButton];
  
  // 移動ボタン
  self.moveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.moveButton addTarget:self
                      action:@selector(moveTag:)
            forControlEvents:UIControlEventTouchUpInside];
  [self.moveButton setTintColor:BLUE_COLOR];
  [self updateMoveButton];
  [self.moveButton setTitle:@"Move"
                   forState:UIControlStateDisabled];
  self.moveButton.frame = CGRectMake(self.editTabBar.frame.size.width-margin-width,
                                     (self.editTabBar.frame.size.height-height)/2,
                                     width,
                                     height);
  [self.moveButton setTitle:@"Move"
                   forState:UIControlStateNormal];
  [self.editTabBar addSubview:self.moveButton];
  // 編集タブは隠す
  [self hideEditTabBar:YES];
}

#pragma mark - 編集タブ -

/**
 * @brief  選択したセルのタグを移動する
 *
 * @param sender センダー
 */
-(void)moveTag:(id)sender
{
  LOG(@"タグを移動");
  TagSelectViewController *controller = [[TagSelectViewController alloc] initWithNibName:nil bundle:nil];
  
  controller.delegate = self;
  controller.tagsForAlreadySelected = nil;
  controller.maxCapacityRowsForSelected = 1;
  
  UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:controller];
  [self presentViewController:navcontroller
                     animated:YES
                   completion:nil];
}

/**
 * @brief  タグ選択画面を終了する
 *
 * @param tagsForSelectedRows 選択されたタグ
 */
-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows
{
  Tag *selectedTag;
  
  // タグの先頭だけ取得する
  for (Tag *tag in tagsForSelectedRows) {
    selectedTag = tag;
    break;
  }
  
  // 取得したタグを選択したアイテムに設定する
  NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
  if (self.tableView.editing) {
    for (NSIndexPath *indexPathInTable in selectedRows) {
      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPathInTable];
      [item setTag:selectedTag];
    }
  }
  
  // 保存する
  [CoreDataController saveContext];
}

/**
 * @brief  移動ボタンを更新する
 */
-(void)updateMoveButton
{
  NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
  BOOL noItemsInTable = [[self.fetchedResultsController fetchedObjects] count] == 0;
  BOOL allItemsAreSelected = selectedRows.count == [[self.fetchedResultsController fetchedObjects] count];
  BOOL noItemsAreSelected = selectedRows.count == 0;
  NSString *title;
  
  // テーブルにアイテムがない場合、アイテムが選択されてない場合、
  // 移動ボタンを選択不可にする。
  // それ以外の場合、選択可能にする。
  if (noItemsInTable || noItemsAreSelected) {
    self.moveButton.enabled = NO;
    return;
  } else {
    self.moveButton.enabled = YES;
  }
  
  // 全てのアイテムが選択されている場合、
  // タイトルを変更する。
  // それ以外の場合、選択数を隣に表示する。
  if (allItemsAreSelected) {
    title = @"Move All";
  } else {
    title = [NSString stringWithFormat:@"Move(%lu)", (unsigned long)selectedRows.count];
  }
  
  // タイトルを実装する。
  [self.moveButton setTitle:title
                   forState:UIControlStateNormal];
}

/**
 * @brief  削除ボタンを更新する
 */
-(void)updateDeleteButton
{
  NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
  BOOL noItemsInTable = [[self.fetchedResultsController fetchedObjects] count] == 0;
  BOOL allItemsAreSelected = selectedRows.count == [[self.fetchedResultsController fetchedObjects] count];
  BOOL noItemsAreSelected = selectedRows.count == 0;
  NSString *title;
  
  if (noItemsInTable || noItemsAreSelected) {
    self.deleteAllButton.enabled = NO;
    return;
  } else {
    self.deleteAllButton.enabled = YES;
  }
  
  if (allItemsAreSelected) {
    title = @"Delete All";
  } else {
      title = [NSString stringWithFormat:@"Delete(%lu)", (unsigned long)selectedRows.count];
  }
  
  [self.deleteAllButton setTitle:title
                        forState:UIControlStateNormal];
}
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // 削除・移動ボタンの状態を更新する。
  [self updateDeleteButton];
  [self updateMoveButton];
}
-(void)tableView:(UITableView *)tableView
didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // 削除・移動ボタンの状態を更新する。
  [self updateDeleteButton];
  [self updateMoveButton];
}

-(void)deleteRows:(id)sender
{
  NSString *title;
  NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
  BOOL allItemsAreSelected = selectedRows.count == [[self.fetchedResultsController fetchedObjects] count];
  BOOL noItemsAreSelected = selectedRows.count == 0;
  BOOL oneItemAreSelected = selectedRows.count == 1;
  
  // 全て選択されている場合、何も選択されていない場合、
  // タイトルを調整する。
  // @TODO: 使用していない。
  if (allItemsAreSelected || noItemsAreSelected) {
    title = NSLocalizedString(@"Are you sure you want to remove all items?", @"");
  } else {
    if (oneItemAreSelected) {
      title = NSLocalizedString(@"Are you sure you want to remove this item?", @"");
    } else {
      title = NSLocalizedString(@"Are you sure you want to remove these items?", @"");
    }
  }
  [self showConfirmActionSheetWithTitle:title];
}

/**
 * @brief  選択セルを削除
 *
 * @param sender センダー
 */
-(void)deleteAllSelectedRows:(id)sender
{
  // 選択セルのみ削除する
  for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
    NSManagedObject *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[self.fetchedResultsController managedObjectContext] deleteObject:item];
  }
}

-(void)deleteAllRows:(id)sender
{
  // 全てのセルを削除する
  NSArray *allObjects = [self.fetchedResultsController fetchedObjects];
  for (NSManagedObject *obj in allObjects) {
    [[self.fetchedResultsController managedObjectContext] deleteObject:obj];
  }
}

-(void)showConfirmActionSheetWithTitle:(NSString *)title
{
  NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel title for item removal action");
  NSString *okTitle = NSLocalizedString(@"Delete", @"OK title for item removal action");
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                             destructiveButtonTitle:okTitle
                                                  otherButtonTitles:nil];
  [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
  {
    LOG(@"selected: OK");
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    BOOL allItemsAreSelected = selectedRows.count == [[self.fetchedResultsController fetchedObjects] count];
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    // 全て選択されている場合、アイテムが選択されていない場合、
    // 全てのセルを削除する。
    // そうでない場合、選択されたセルを削除する。
    if (allItemsAreSelected || noItemsAreSelected) {
      [self deleteAllRows:self];
    } else {
      [self deleteAllSelectedRows:self];
    }
    
    // 何か選択されていた場合、
    // メッセージを表示する
    if ( ! noItemsAreSelected) {
      [self instantMessage:@"Delete"
                     color:nil];
    }
    
    [CoreDataController saveContext];
    [self updateEditTabBar];
  }
  
  // テーブルを更新する
  [self.tableView reloadData];
  
  // デリゲートにデータの更新を通達する。
  [self.delegateForList didUpdateCoreData];
}

#pragma mark - ユーティリティ -

-(void)scrollToTopCell
{
  // セルが存在すれば、トップのセルまでスクロールする。
  // セルがなければ、何故か落ちる。
  BOOL hasAnyCell = ([self.tableView numberOfRowsInSection:0]>0) ? YES : NO;
  if (hasAnyCell) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
  }
}

#pragma mark ナビゲーションバー

/**
 * @brief  新規挿入ボタンを作成する
 *
 * @return インスタンス
 */
-(UIBarButtonItem *)newInsertObjectButton
{
  UIBarButtonItem *insertObjectButton
  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                  target:self
                                                  action:@selector(didTappedInsertObjectButton)];
  return insertObjectButton;
}

/**
 * @brief  全選択ボタンを作成する
 *
 * @return インスタンス
 */
-(UIBarButtonItem *)newSelectAllButton
{
  UIBarButtonItem *selectAllButton
  = [[UIBarButtonItem alloc] initWithTitle:@"ALL"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(selectAllRows:)];
  return selectAllButton;
}

/**
 * @brief  全選択する
 *
 * @param sender センダー
 */
-(void)selectAllRows:(id)sender
{
  LOG(@"全選択");
  NSInteger section =  [self.tableView numberOfSections];
  
  for (; section > 0; section--) {
    NSInteger row = [self.tableView numberOfRowsInSection:section];
    NSIndexPath *indexPathInController = [NSIndexPath indexPathForRow:row-1
                                                            inSection:section-1];
    [self.tableView selectRowAtIndexPath:indexPathInController
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
  }
}

-(void)updateEditTabBar
{
  // 編集タブの状態を更新する
  [self updateMoveButton];
  [self updateDeleteButton];
}

/**
 * @brief  編集ボタンを作成
 *
 * @return インスタンス
 */
-(UIBarButtonItem *)newEditTableButton
{
  UIBarButtonItem *editTableButton
  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kEditBarItemImageName]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(didTappedEditTableButton)];
  editTableButton.tintColor = RGB(212, 212, 212);
  return editTableButton;
}

/**
 * @brief  編集ボタンをタップ時
 */
-(void)didTappedEditTableButton
{
  [self updateDeleteButton];
  [self updateMoveButton];
  
  if (self.tableView.isEditing)
  {
    // 編集中なら、
    // タブバーを開く。
    // 編集タブバーをアニメーションで閉じる。
    [self.delegateForList openTabBar];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.2];
    [self hideEditTabBar:YES];
    [UIView commitAnimations];
  } else {
    // 編集中でなければ、
    // タブバーを閉じる
    // 編集タブバーを開く。
    [self hideEditTabBar:NO];
    [self.delegateForList closeTabBar];
  }
}

-(void)toggleRightNavigationItemWithEditingState:(BOOL)isEditing
{
  UIBarButtonItem *rightItem;
  
  // 編集中なら、
  // 全選択ボタンを表示する。
  // そうでないなら、
  // 新規挿入ボタンを表示する。
  if (isEditing) {
    rightItem = [self newSelectAllButton];
  } else {
    rightItem = [self newInsertObjectButton];
  }
  
  // テーマカラーに設定する
  if (self.navbarThemeColor) {
    rightItem.tintColor = self.navbarThemeColor;
  }
  self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)didTappedInsertObjectButton
{
  [self.delegateForList closeTabBar];
  LOG(@"挿入ボタン");
}

/**
 * @brief  タイトルを設定
 *
 * @param title     メインタイトル
 * @param miniTitle サブタイトル
 */
-(void)configureTitleWithString:(NSString *)title
                       subTitle:(NSString *)subTitle
                       subColor:(UIColor *)subColor
{
  LOG(@"ナビゲーションバーのタイトル・サブタイトルを設定");
  
  //////////////////////////////////////////////////////////////////////////////
  // タイトルのみの時
  if (subTitle == nil) {
    self.navigationItem.title = title;
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.opaque = NO;
    self.navigationItem.titleView = self.titleView;
    
    // メインタイトルを作成・設定
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.titleView addSubview:self.titleLabel];
    
    return;
  }
  
  //////////////////////////////////////////////////////////////////////////////
  // タイトル・サブタイトルの時
  // タイトルビューを再設定
  self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
  self.titleView.backgroundColor = [UIColor clearColor];
  self.titleView.opaque = NO;
  self.navigationItem.titleView = self.titleView;
  
  // メインタイトルを作成・設定
  self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 20)];
  self.titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
  self.titleLabel.text = title;
  self.titleLabel.textColor = [UIColor blackColor];
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.backgroundColor = [UIColor clearColor];
  self.titleLabel.adjustsFontSizeToFitWidth = YES;
  [self.titleView addSubview:self.titleLabel];
  
  // サブタイトルを作成・設定
  self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 195, 20)];
  self.subTitleLabel.font = [UIFont boldSystemFontOfSize:kSubTitleFontSize];
  self.subTitleLabel.textColor = subColor;
  self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
  self.subTitleLabel.backgroundColor = [UIColor clearColor];
  self.subTitleLabel.adjustsFontSizeToFitWidth = YES;
  self.subTitleLabel.text = subTitle;
  [self.titleView addSubview:self.subTitleLabel];
}

/**
 * @brief  メッセージを表示する
 *
 * @param message メッセージ
 */
-(void)aleartMessage:(NSString *)message {
  CGFloat duration = 0.3f;
  CGFloat presentDistance = 50;
  CGFloat delay = 0.8f;
  
  UILabel *label = self.subTitleLabel;
  
  CGRect originFrame = label.frame;
  CGRect startFrame = label.frame;
  startFrame.origin.x -= presentDistance;
  CGRect destinationFrame = label.frame;
  destinationFrame.origin.x += presentDistance;
//  NSString *originString = label.text;
  
  // メッセージを作成する
  UILabel *mesLabel = [[UILabel alloc] initWithFrame:startFrame];
  mesLabel.font = [UIFont boldSystemFontOfSize:kSubTitleFontSize];
  mesLabel.textColor = [UIColor blackColor];
  mesLabel.textAlignment = NSTextAlignmentCenter;
  mesLabel.backgroundColor = [UIColor clearColor];
  mesLabel.adjustsFontSizeToFitWidth = YES;
  mesLabel.text = message;
  mesLabel.alpha = 0;
  
  [self.titleView addSubview:mesLabel];
  
  // アニメーションを開始する
  // 表示して、消滅させる
  [UIView animateWithDuration:duration
                   animations:^{
                     label.alpha = 0;
                     label.frame = destinationFrame;
                     
                     mesLabel.alpha = 1;
                     mesLabel.frame = originFrame;
                   }
                   completion:^(BOOL finished) {
                     label.frame = startFrame;
                     
                     // 出現
                     [UIView animateWithDuration:0.2
                                           delay:delay
                                         options:UIViewAnimationOptionCurveLinear
                                      animations:^{
                                        label.alpha = 1;
                                        label.frame = originFrame;
                                        
                                        mesLabel.alpha = 0;
                                        mesLabel.frame = destinationFrame;
                                      }
                                      completion:^(BOOL finished) {
                                        ;
                                      }];
                     
                   }];
}

#pragma mark アクセサリー
//-(UIButton *)newDisclosureIndicatorAccessory
//{
//  UIButton *disclosureIndicator = [UIButton buttonWithType:UIButtonTypeCustom];
//  disclosureIndicator.frame = CGRectMake(0, 0, 30, 30);
//  disclosureIndicator.backgroundColor = [UIColor blackColor];
//  [disclosureIndicator addTarget:self
//                          action:@selector(didTappedAccessoryButton)
//                forControlEvents:UIControlEventTouchUpInside];
//  return disclosureIndicator;
//}

/**
 * @brief  アクセサリーがタップされた時の処理
 */
-(void)didTappedAccessoryButton
{
  LOG(@"アクセサリーをタップ");
}

#pragma mark タブバー

/**
 * @brief  編集タブバーの表示・非表示
 *
 * @param hide 真偽値
 */
-(void)hideEditTabBar:(BOOL)hide {
//  CGFloat duration = 0.2;
  CGRect frame = self.editTabBar.frame;
  if (hide) {
    // 編集タブを隠す
    frame.origin.y = SCREEN_BOUNDS.size.height - NAVBAR_H - STATUSBAR_H;
  } else {
    // 編集タブを表示する
    frame.origin.y = SCREEN_BOUNDS.size.height - TABBAR_H - NAVBAR_H - STATUSBAR_H;
  }
//  [UIView beginAnimations:nil context:nil];
//  [UIView setAnimationDuration:duration];
  self.editTabBar.frame = frame;
//  [UIView commitAnimations];
}

#pragma mark インスタントメッセージ

/**
 * @brief  インスタントメッセージを表示する
 *
 * @param message メッセージ
 */
-(void)instantMessage:(NSString *)message color:(UIColor *)color {
  CGFloat width = 80;
  CGFloat height = 50;
  UILabel *instant = [UILabel new];
  instant.frame = CGRectMake((SCREEN_BOUNDS.size.width - width)/2,
                             (SCREEN_BOUNDS.size.height - height - NAVBAR_H - TABBAR_H)/2 - 50,
                             width,
                             height);
  
  // 背景色
  if (color) {
    instant.backgroundColor = color;
  } else {
    instant.backgroundColor = [UIColor blackColor];
  }

  instant.textColor = [UIColor whiteColor];
  NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  style.alignment = NSTextAlignmentCenter;
  NSDictionary *attributes = @{NSParagraphStyleAttributeName:style};
  instant.attributedText = [[NSAttributedString alloc] initWithString:message
                                                           attributes:attributes];
  
  // レイヤー
  instant.layer.masksToBounds = YES;
  instant.layer.opacity = 0.0f;
  instant.layer.cornerRadius = 10;
  
  [self.view addSubview:instant];
  
  CGFloat maxOpacity = 0.8f;
  CGFloat animationDelay = 0.4f;
  
  // アニメーションを実行
  // TODO: 途中でストップできるようにする
  [UIView animateWithDuration:0.1f
                        delay:0.0
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     instant.layer.opacity = maxOpacity;
                     instant.transform = CGAffineTransformMakeScale(1.1, 1.1);
                   }
                   completion:^(BOOL finished) {
                     [UIView animateKeyframesWithDuration:0.1f
                                                    delay:animationDelay
                                                  options:UIViewKeyframeAnimationOptionOverrideInheritedOptions
                                               animations:^{
                                                 instant.layer.opacity = 0.0f;
                                                 instant.transform = CGAffineTransformMakeScale(0.7, 0.7);
                                               }
                                               completion:^(BOOL finished) {
                                                 ;
                                               }];
                     
                   }];
  
}

#pragma mark - その他 -
#pragma mark メモリー
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - テーブルビュー -

#pragma mark - スクロールビュー
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  LOG(@"スクロール開始");
}

#pragma mark デリゲート

#pragma mark データソース

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  LOG(@"このメソッドはオーバライドする必要がある");
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  LOG(@"このメソッドはオーバライドする必要がある");
  return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LOG(@"このメソッドはオーバライドする必要がある");
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                          forIndexPath:indexPath];
  
  // Configure the cell...
  
  return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
