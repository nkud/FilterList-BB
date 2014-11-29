//
//  TagDetailViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/19.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TagDetailViewController.h"
#import "Header.h"

#import "TitleCell.h"

#pragma mark -

@interface TagDetailViewController () {
  NSArray *dataArray_;
}

@end

@implementation TagDetailViewController

#pragma mark - 初期化 -

/**
 * @brief  初期化
 *
 * @param title     タイトル
 * @param indexPath 位置
 * @param delegate  デリゲート
 *
 * @return インスタンス
 */
-(instancetype)initWithTitle:(NSString *)title
                   indexPath:(NSIndexPath *)indexPath
                    delegate:(id<TagDetailViewControllerDelegte>)delegate
{
  self = [super initWithNibName:nil
                         bundle:nil];
  if (self) {
    if (title) {
      self.tagTitle = title;
      self.tagIndexPath = indexPath;
      self.isNewTag = NO;
    } else {
      self.tagTitle = nil;
      self.tagIndexPath = nil;
      self.isNewTag = YES;
    }
  }
  self.delegate = delegate;
  
  return self;
}

-(void)viewDidAppear:(BOOL)animated
{
  if (self.isNewTag) {
    [[self titleCell].titleField becomeFirstResponder];
  }
}

/**
 * @brief  変数初期化
 */
- (void)initParam {

}

-(NSArray *)dataArray
{
  NSArray *itemOne = @[[self titleCellID]];
  dataArray_ = @[itemOne];
  return dataArray_;
}

/**
 * @brief  ビューロード後の処理
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // 変数初期化
  [self initParam];
  // Do any additional setup after loading the view.
  
  // ナビバーアイテム
  UIBarButtonItem *saveButton
  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                  target:self
                                                  action:@selector(saveAndDismiss)];
  self.navigationItem.rightBarButtonItem = saveButton;
}

/**
 * @brief  保存して終了
 */
- (void)saveAndDismiss
{
  LOG(@"タグを保存");
  
  self.tagTitle = [self titleCell].titleField.text;
  
  [self.delegate dismissDetailView:self.tagTitle
                         indexPath:self.tagIndexPath
                          isNewTag:self.isNewTag];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (TitleCell *)titleCell
{
  TitleCell *cell
  = (TitleCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0
                                                                           inSection:0]];
  return cell;
}

#pragma mark - ユーティリティ -
- (BOOL)isTitleCellAtIndexPath:(NSIndexPath *)atIndexPath
{
  if (atIndexPath == [NSIndexPath indexPathForRow:0 inSection:0]) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - テーブルビュー -
#pragma mark デリゲート

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
  if (section == 0) {
    return @"TITLE";
  }
  return @"";
}

#pragma mark データソース

/**
 * @brief  セルを作成する
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return インスタンス
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isTitleCellAtIndexPath:indexPath])
  {
    TitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[self titleCellID]];
    if (self.tagTitle) {
      cell.titleField.text = self.tagTitle;
    }
    cell.titleField.delegate = self;
    return cell;
  } else {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"cell"];
    return cell;
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  [self saveAndDismiss];
  return YES;
}

#pragma mark - その他 -
#pragma mark メモリー

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
