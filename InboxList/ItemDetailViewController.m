//
//  DetailViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ItemDetailTitleCell.h"
#import "Header.h"
#import "Tag.h"

#define kPickerAnimationDuration 0.4

static NSString *kTitleCellID = @"titleCell";

#pragma mark -

@interface ItemDetailViewController ()

- (void)initItem;

@end

@implementation ItemDetailViewController

#pragma mark - 初期化

/**
 *  @brief Nibファイルで初期化
 *
 *  @param nibNameOrNil   Nibファイル名
 *  @param nibBundleOrNil バンドル
 *
 *  @return インスタンス
 */
-(id)initWithNibName:(NSString *)nibNameOrNil
              bundle:(NSBundle *)nibBundleOrNil
{
  LOG(@"詳細ビューを初期化");
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];

  return self;
}

/**
 * @brief  ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // アイテムを更新
  [self initItem];
  
  // セル登録
  [self.tableView registerNib:[UINib nibWithNibName:@"ItemDetailTitleCell"
                                             bundle:nil]
       forCellReuseIdentifier:kTitleCellID];
  
  // セーブボタン
  UIBarButtonItem *saveButton
  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                  target:self
                                                  action:@selector(save)];
  self.navigationItem.rightBarButtonItem = saveButton;
}

/**
 *  @brief アイテムを更新する
 */
- (void)initItem
{
  if (self.detailItem) {
    NSString *title = self.detailItem.title;
    NSSet *tags     = self.detailItem.tags;

    NSMutableString *field = [[NSMutableString alloc] init];
    [self.titleField setText:title]; //< タイトル設置
    for( Tag *tag in tags )
    { //< すべてのタグに対して
      [field appendString:tag.title]; //< フィールドに足していく
      [field appendString:@" "];
    }
    self.tagField.text = field; //< タグを設置
  }
}

/**
 *  @brief アイテムを設定する
 *
 *  @param newDetailItem アイテム
 */
- (void)setDetailItem:(id)newDetailItem
{
  if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;

    // Update the view.
    [self initItem];
  }
}

/**
 *  @brief テキストフィールドを作成する
 *
 *  @param x x座標
 *  @param y y座標
 *
 *  @return インスタンス
 */
//- (UITextField *)createTextField:(int)x y:(int)y
//{
//  UITextField *_newTextField;
//  _newTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, 100, 40)];
//  [_newTextField setBorderStyle:UITextBorderStyleRoundedRect];
//  [_newTextField setReturnKeyType:UIReturnKeyDone];
//  [_newTextField setText:nil];
//  return _newTextField;
//}

#pragma mark - 保存・終了処理

/**
 *  @brief 保存して戻る
 */
- (void)save
{
  //    [self dismissViewControllerAnimated:YES completion:nil];

  NSArray *tag_titles = [self.tagField.text componentsSeparatedByString:@" "]; //< タグの配列を生成

  /// デリゲートに変更後を渡す
  [self.delegate dismissDetailView:self
                             index:self.index
                         itemTitle:self.titleField.text
                         tagTitles:tag_titles];
  /// ビューを削除する
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - テーブルビュー

/**
 * @brief  セクション数を返す
 *
 * @param tableView テーブルビュー
 *
 * @return セクション数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (section == 0) {
    return @"TITLE";
  } else {
    return @"OPTION";
  }
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) {
    return  1;
  } else {
    return 2;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ItemDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleCellID];
  cell.titleField.text = self.detailItem.title;
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
