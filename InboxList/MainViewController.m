//
//  MainViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "Header.h"

@interface MainViewController () {
  AppDelegate *app;
}

@end

@implementation MainViewController

/**
 * パラメータを初期化
 */
- (void)initParameter
{
  swipe_distance = 200;
  app = [[UIApplication sharedApplication] delegate];
}

/**
 * 初期化
 */
-(id)init
{
  self = [super init];
  return self;
}

/**
 * マスタービューを中心に持ってくる
 */
- (void)moveMasterViewToCenter
{
  CGPoint next_center = self.navigationController.view.center;
  CGFloat center_x = self.navigationController.view.center.x; // 現在の中心 x

  CGFloat screen_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x
  next_center.x = MAX(center_x-swipe_distance, screen_x);

  /// アニメーション
  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}

/**
 * @brief マスタービュー上でスワイプ時の処理
 */
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;
{
  int distance = 200;
  CGPoint next_center = self.navigationController.view.center;
  CGFloat center_x = self.navigationController.view.center.x; // 現在の中心 x

  CGFloat screen_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  switch (recognizer.direction) {
    case UISwipeGestureRecognizerDirectionRight: /// 右スワイプ時
      next_center.x = center_x + distance;
      self.menuViewController.tag_list = [self.masterViewController getTagList]; ///< メニューの内容を更新して
      [self.menuViewController updateTableView]; ///< ビューを更新
      break;

    case UISwipeGestureRecognizerDirectionLeft: /// 左スワイプ時
      next_center.x = MAX(center_x-distance, screen_x);
      break;

    default:
      break;
  }

  /// アニメーション
  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}
/**
 * ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];

  /// パラメータを初期化
  [self initParameter];

  /// マスタービュー初期化
  self.masterViewController = [[MasterViewController alloc] initWithStyle:UITableViewStylePlain];

  /// ナビゲーションコントローラー初期化
  self.navigationController = [[NavigationController alloc] initWithRootViewController:self.masterViewController];

  /// ジェスチャーを設定
  UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleSwipeFrom:)];
  UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleSwipeFrom:)];
  [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
  [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.navigationController.view addGestureRecognizer:recognizerRight];
  [self.navigationController.view addGestureRecognizer:recognizerLeft];


  self.navigationController.title = @"FilterList";
//  [self addChildViewController:self.navigationController];

  /// メニューバー初期化
  self.menuViewController = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
  self.menuViewController.delegate = self;

  /// コントローラーのビューを配置
  [self.view addSubview:self.menuViewController.view];
  [self.view addSubview:self.navigationController.view];
}

/**
 *  タグが選択された時の処理
 *
 *  @param tagString 選択されたタグの文字列
 */
-(void)selectedTag:(NSString *)tagString
{
  if ([tagString isEqualToString:@"all"]) {
    [self loadMasterViewForTag:@"all" fetcheResultController:[self fetchedResultsController]];
    return;
  }
  [self loadMasterViewForTag:tagString
      fetcheResultController:[self fetchedResultsControllerForTag:tagString]];
}

/**
 *  通常のリザルトコントローラー
 *
 *  @return return value description
 */
- (NSFetchedResultsController *)fetchedResultsController
{
  NSLog(@"%s", __FUNCTION__);
//  if (_fetchedResultsController != nil) {
//    return _fetchedResultsController;
//  }
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:app.managedObjectContext];
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
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:app.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil]; //< 元は@"Master"

  aFetchedResultsController.delegate = self.masterViewController; //< デリゲートを設定

//  self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController;
}

/**
 *  タグを指定したリザルトコントローラー
 *
 *  @param tagString 抽出するタグ
 *
 *  @return リザルトコントローラー
 */
- (NSFetchedResultsController *)fetchedResultsControllerForTag:(NSString *)tagString
{
  NSLog(@"%s", __FUNCTION__);
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:app.managedObjectContext];
  [fetchRequest setEntity:entity];

  /// Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];

  /// ソート条件
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];                 /// ソートを設定

  /// 検索条件
  /// @details 選択されたタグを持つアイテムを列挙
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY SELF.tags.title == %@", tagString];
  [fetchRequest setPredicate:predicate];

  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:app.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];   //< タグをキャッシュネームにする
  aFetchedResultsController.delegate = self.masterViewController; //< デリゲートを設定

//  _fetchedResultsControllerForTag = aFetchedResultsController;

  /// フェッチを実行
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController;
}

/**
 * メニューでタグが選択された時の処理
 */
- (void)loadMasterViewForTag:(NSString *)tag
      fetcheResultController:(NSFetchedResultsController *)fetchedResultController
{
  NSLog(@"%s", __FUNCTION__);
  self.masterViewController.selectedTagString = tag;//< 選択されたタグを渡して
  self.masterViewController.fetchedResultsController = fetchedResultController;
  [self.masterViewController updateTableView]; //< テーブルを更新
  [self.masterViewController setTitle:tag]; //< タグの名前に変える
  [self moveMasterViewToCenter]; //< マスタービューを中心に移動させる
}

/**
 * メモリー警告
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
