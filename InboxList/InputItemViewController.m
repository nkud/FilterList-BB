//
//  InputItemViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "InputItemViewController.h"
#import "Header.h"
#import "TagSelectViewController.h"
#import "Tag.h"

static NSString *default_cell_identifier = @"OptionContainerCell";
static NSString *reminder_cell_identifier = @"ReminderCell";

@interface InputItemViewController () {

  int cell_height_;
  int reminder_cell_height_;
}

@end

@implementation InputItemViewController

#pragma mark - 初期化

/**
 *  初期化
 *
 *  @param nibNameOrNil   nibNameOrNil description
 *  @param nibBundleOrNil nibBundleOrNil description
 *
 *  @return instance
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self)
  {
    // Custom initialization
  }
  return self;
}

/**
 * ビュー読み込み後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.cellTitleForSelectedTags = @"Tags";
  
  // セルの高さを設定
  cell_height_ = 43;
  reminder_cell_height_ = 0;
  
  // 使用するセルを登録する, ２つ
  [self.optionContainerTableView registerClass:[UITableViewCell class]
                        forCellReuseIdentifier:default_cell_identifier];
  [self.optionContainerTableView registerNib:[UINib nibWithNibName:@"ReminderCell" bundle:nil]
                      forCellReuseIdentifier:reminder_cell_identifier];
  
  // アイテム入力フィールド
  [self.titleInputField becomeFirstResponder];
  self.titleInputField.delegate = self;
  
  // 入力完了ボタン
  [self.saveButton addTarget:self
                      action:@selector(dismissInput)
            forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - テーブルビュー

/**
 * @brief  セルを返す
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return セル
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  switch (indexPath.row) {
    case 0:
      cell = [self.optionContainerTableView dequeueReusableCellWithIdentifier:default_cell_identifier];
      cell.textLabel.text = self.cellTitleForSelectedTags;
      break;
    case 1:
      cell = [self.optionContainerTableView dequeueReusableCellWithIdentifier:default_cell_identifier];
      cell.textLabel.text = @"Reminder";
      break;
    case 2:
      cell = [self.optionContainerTableView dequeueReusableCellWithIdentifier:reminder_cell_identifier];
      break;
    default:
      break;
  }
  return cell;
}

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
  return 3;
}
/**
 * @brief  セルが選択された時の処理
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LOG(@"選択された");
  switch (indexPath.row) {
    case 0:
      LOG(@"タグを選択するセル");
      [self toTagSelectView];
      
      break;
      
    case 1:
      LOG(@"高さを変えて、リロード");
      reminder_cell_height_ = 162;
      [self.optionContainerTableView reloadData];
      break;
      
    case 2:
      break;
    default:
      break;
  }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}
-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  LOG(@"高さを設定");
  switch (indexPath.row) {
    case 2:
      return reminder_cell_height_;
      break;
      
    default:
      return cell_height_;
      break;
  }
}

#pragma mark - タグ選択画面

/**
 * @brief  タグ選択画面を表示する
 */
-(void)toTagSelectView
{
  LOG(@"タグ選択画面表示");
  TagSelectViewController *tagSelectViewController
  = [[TagSelectViewController alloc] initWithNibName:@"TagSelectViewController"
                                              bundle:nil];
  [self.navigationController pushViewController:tagSelectViewController
                                       animated:YES];
  [tagSelectViewController setDelegate:self];
  return;
}

/**
 * @brief  タグ入力画面を終了する
 *
 * @param tagsForSelectedRows tags
 */
-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows
{
  LOG(@"選択されたタグを更新する");
  NSMutableString *tags_title = [NSMutableString stringWithString:@""];
  for (Tag *tag in tagsForSelectedRows) {
    [tags_title appendFormat:@"%@ ", tag.title];
  }
  // 選択されたタグを更新
  self.selectedTags = tagsForSelectedRows;

  if ([tags_title isEqual:@""]) {
    [tags_title setString:@"no tags"];
  }
  
  // セルのタイトルを更新する
  self.cellTitleForSelectedTags = tags_title;
  
  // テーブルビューを更新する
  [self.optionContainerTableView reloadData];
}

#pragma mark - 終了処理

/**
 * Returnが押された時の処理
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.titleInputField) { // アイテム名入力欄なら、
    [self dismissInput];
  }
  return YES;
}

/**
 * データを渡して入力画面を削除する
 */
- (void)dismissInput
{
  LOG(@"データを渡して入力画面を閉じる");
//  NSArray *_data = @[self.titleInputField.text, self.tagInputField.text];
//  [[self delegate] dismissInputModalView:self data:_data
//                                reminder:self.remindPicker.date];
  [[self delegate] dismissInputItemView:self.titleInputField.text
                    tagsForSelectedRows:self.selectedTags
                               reminder:self.remindPicker.date];
}

#pragma mark - その他

/**
 * メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
