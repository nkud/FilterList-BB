//
//  InputFilterViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/26.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "InputFilterViewController.h"
#import "FilterCell.h"
#import "Tag.h"
#import "CoreDataController.h"

static NSString *InputFilterCellIdentifier = @"InputTagCell";

@interface InputFilterViewController ()

@end

@implementation InputFilterViewController

#pragma mark - 初期化

/**
 * @brief  初期化
 *
 * @param nibNameOrNil   nibNameOrNil description
 * @param nibBundleOrNil nibBundleOrNil description
 *
 * @return インスタンス
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 * @brief  ロード後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // セルを登録
  [self.tagTableView registerClass:[FilterCell class]
            forCellReuseIdentifier:InputFilterCellIdentifier];
  self.tagFetchedResultsController = [CoreDataController userTagFetchedResultsController:self];
  
  // テーブルの設定
  self.tagTableView.allowsMultipleSelectionDuringEditing = YES;
  [self.tagTableView setEditing:YES];
  
  // ボタンを設定
  [self.saveButton addTarget:self
                      action:@selector(dismissView)
            forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - テーブルビュー

/**
 * @brief  セルを表示
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return セル
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:InputFilterCellIdentifier];
  
  Tag *tag = [self.tagFetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = tag.title;
  
  return cell;
}

/**
 * @brief  セル数
 *
 * @param tableView テーブルビュー
 * @param section   セクション数
 *
 * @return セル数
 */
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  NSInteger num = [[self.tagFetchedResultsController fetchedObjects] count];
  return num;
}

/**
 * @brief  入力画面を終了する
 */
-(void)dismissView
{
  NSArray *selected_rows =  [self.tagTableView indexPathsForSelectedRows];
  NSMutableSet *tags_for_selected = [[NSMutableSet alloc] init];
  for (NSIndexPath *index in selected_rows) {
    Tag *tag = [self.tagFetchedResultsController objectAtIndexPath:index];
    [tags_for_selected addObject:tag];
  }

  [self.delegate dismissInputFilterView:self.inputTitleField.text
                        tagsForSelected:tags_for_selected];
}

#pragma mark - その他

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
