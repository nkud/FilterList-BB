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

@interface TagSelectViewController () {
  NSString *cell_identifier_;
}

@end

@implementation TagSelectViewController

#pragma mark - 初期化

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
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
  // ナビゲーションバーを非表示
  self.navigationController.navigationBar.hidden = YES;
//  [self.tagTableView registerClass:[UITableViewCell class]
//            forCellReuseIdentifier:cell_identifier_];
  [self.tagTableView registerNib:[UINib nibWithNibName:@"TagSelectCell"
                                                bundle:nil]
          forCellReuseIdentifier:kTagForSelectedCellID];
  
  // ボタンの設定
  [self.saveButton addTarget:self
                      action:@selector(dismissTagSelectView)
            forControlEvents:UIControlEventTouchUpInside];
  
  // リザルトコントローラーの設定
  self.fetchedResultsController = [CoreDataController tagFetchedResultsController:self];
  
  
  // 複数選択を可能にする
  self.tagTableView.allowsMultipleSelectionDuringEditing = YES;
  [self.tagTableView setEditing:YES];
}

#pragma mark - 終了処理

/**
 * @brief  入力画面を終了
 */
-(void)dismissTagSelectView
{
  // 選択されたタグを取得
  NSArray *selected_rows = [self.tagTableView indexPathsForSelectedRows];
  NSMutableSet *selected_tags = [[NSMutableSet alloc] init];
  
  for (NSIndexPath *index in selected_rows) {
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:index];
    [selected_tags addObject:tag];
  }
  // 選択されたタグを渡す
  [self.delegate dismissTagSelectView:selected_tags];
  // 入力画面をポップして、１つ前の画面に戻る
//  [self.navigationController popToRootViewControllerAnimated:YES];
  [self.navigationController popViewControllerAnimated:YES];
  
  // ナビゲーションバーを表示
  [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - テーブルビュー

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
  LOG(@"選択する");
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

  UITableViewCell *cell = [self.tagTableView dequeueReusableCellWithIdentifier:kTagForSelectedCellID];

  cell.textLabel.text = tag.title;
  return cell;
}

#pragma mark - その他

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
